import os
import logging
from functools import wraps
from flask import Flask, jsonify, request
from flask_cors import CORS
import mysql.connector
from dotenv import load_dotenv

# --- (Setup, CORS, Logging, DB Connection, and Decorator code remains the same) ---
load_dotenv()
app = Flask(__name__)
app.config['DEBUG'] = os.getenv('FLASK_DEBUG', 'False').lower() in ['true', '1']

CORS(app)

if app.config['DEBUG']:
    logging.basicConfig(level=logging.DEBUG, 
                        format='%(asctime)s - %(levelname)s - %(message)s')

def get_db_connection():
    try:
        conn = mysql.connector.connect(
            host=os.getenv('DB_HOST'),
            user=os.getenv('DB_USER'),
            password=os.getenv('DB_PASSWORD'),
            database=os.getenv('DB_NAME')
        )
        return conn
    
        
    except mysql.connector.Error as err:
        app.logger.error(f"Database connection failed: {err}")
        return None

def db_handler(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        conn = None
        cursor = None
        try:
            conn = get_db_connection()
            if conn is None:
                return jsonify({"status": "error", "error": "Database connection could not be established."}), 200
            cursor = conn.cursor(dictionary=True)
            return f(cursor, *args, **kwargs)
        except mysql.connector.Error as err:
            app.logger.error(f"Error executing query: {err}")
            return jsonify({"status": "error", "error": err}), 200
        finally:
            if cursor: cursor.close()
            if conn and conn.is_connected(): conn.close()
    return decorated_function

# --- API Endpoints ---

# Get State
############## 
@app.route('/getState', methods=['POST'])
@db_handler
def get_status(cursor):
    app.logger.debug("--- /getState DEBUG LOG START ---")
    app.logger.debug(f"Received request: {request}")
    try:
        # 1. Parameter Validation
        if request.is_json:
            raw_params = request.get_json() or {}
        else:
            raw_params = request.form.to_dict()

        params = {k: v for k, v in raw_params.items()}
        app.logger.debug(f"Received raw parameters: {params}")

        if 'id_app' not in params or params['id_app'] is None or 'id_status' not in params or params['id_status'] is None or 'lang' not in params or params['lang'] is None:
            app.logger.debug(f"Missing required parameters: id_app ({params.get('id_app')}) id_status ({params.get('id_status')}).")
            return jsonify({"status": "error", "error": "Missing required parameters: id_app and id_status."}), 200

        # 2. Prioritized Query Logic
        result = None
        
        # Priority 1: Check id_image
        app.logger.debug("Checking for rule with 'id_image'...")
        query = "SELECT next_status, hint FROM controller WHERE id_app = %s AND id_status = %s AND id_image = %s AND lang = %s"
        cursor.execute(query, (int(params['id_app']), int(params['id_status']), int(params['id_image']), params['lang']))
        result = cursor.fetchone()
        app.logger.debug(f"  > Query result: {result if result else 'No match'}")

        # Priority 2: Check id_location
        if not result and 'id_location' in params:
            app.logger.debug("Checking for rule with 'id_location'...")
            query = "SELECT next_status, hint FROM controller WHERE id_app = %s AND id_status = %s AND id_location = %s AND lang = %s"
            cursor.execute(query, (int(params['id_app']), int(params['id_status']), int(params['id_location']), params['lang']))
            result = cursor.fetchone()
            app.logger.debug(f"  > Query result: {result if result else 'No match'}")

        # Priority 3: Check id_answer
        if not result and 'id_answer' in params:
            app.logger.debug("Checking for rule with 'id_answer'...")
            query = "SELECT next_status, hint FROM controller WHERE id_app = %s AND id_status = %s AND id_answer = %s AND lang = %s"
            cursor.execute(query, (int(params['id_app']), int(params['id_status']), int(params['id_answer']), params['lang']))
            result = cursor.fetchone()
            app.logger.debug(f"  > Query result: {result if result else 'No match'}")
            
        # Priority 4: Fallback
        if not result:
            app.logger.debug("No specific rule matched. Checking for fallback rule...")
            query = "SELECT next_status, hint FROM controller WHERE id_app = %s AND id_status = %s AND lang = %s AND id_image IS NULL AND id_location IS NULL AND id_answer IS NULL"
            cursor.execute(query, (int(params['id_app']), int(params['id_status']), params['lang']))
            result = cursor.fetchone()
            app.logger.debug(f"  > Query result: {result if result else 'No match'}")
                
        # 3. Response Generation (JSON is now always clean)
        if result:
            app.logger.debug(f"Final result found. Returning {result}")
            return jsonify({"status": "ok", "result" : result}), 200
        else:
            app.logger.debug("No transition rule found, even after fallback.")
            return jsonify({"status": "error", "error": "No transition rule found for the given state."}), 200

    except Exception as err:
        app.logger.debug(f"Error {err}")
        return jsonify({"status": "error", "error": err}), 200
    finally:
        app.logger.debug("--- /getState DEBUG LOG END ---")


# --- (get_locations and health_check endpoints remain the same) ---

# Get Location
############## 
@app.route('/getLocations', methods=['GET'])
@db_handler
def get_locations(cursor):
    try:
        app.logger.debug("--- /getLocations DEBUG LOG START ---")
        app.logger.debug(f"Received request: {request}")
        query = "SELECT id, name, description, latitude, longitude, model_url, labels_url FROM locations ORDER BY id"
        cursor.execute(query)
        locations = cursor.fetchall()
        app.logger.debug(f"Locations: {locations}")
        return jsonify({"status": "ok", "result": locations}), 200
    except Exception as err:
        app.logger.debug(f"Error {err}")
        return jsonify({"status": "error", "error": err}), 200
    

#   
# Get Documents
##################
@app.route('/getDocuments', methods=['POST'])
@db_handler
def get_documents(cursor):
    """
    Fetches a list of documents (url, description) for a given id_app and id_status.
    """
    try:
        app.logger.debug("--- /getDocuments DEBUG LOG START ---")
        app.logger.debug(f"Received request: {request}")
        
        if request.is_json:
            raw_params = request.get_json() or {}
        else:
            raw_params = request.form.to_dict()

        params = {k: v for k, v in raw_params.items()}
        app.logger.debug(f"Received raw parameters: {params}")

        if 'id_app' not in params or params['id_app'] is None or 'id_status' not in params or params['id_status'] is None:
            app.logger.debug(f"Missing required parameters: id_app ({params.get('id_app')}) id_status ({params.get('id_status')}).")
            return jsonify({"status": "error", "error": "Missing required parameters: id_app and id_status."}), 200

        try:
            int_params = {k: int(v) for k, v in params.items()}
            app.logger.debug(f"Validated integer parameters: {int_params}")
        except ValueError:
            app.logger.debug(f"All provided parameters must be integers.")
            return jsonify({"status": "error", "error": "All provided parameters must be integers."}), 200
        
        # 2. Fetch documents from the database
        query = "SELECT id, url, description FROM documents WHERE id_app = %s AND id_status <= %s"
        cursor.execute(query, (int_params['id_app'], int_params['id_status']))
        documents = cursor.fetchall()
        
        app.logger.debug(f"Found {len(documents)} document(s).")
        app.logger.debug("--- /getDocuments DEBUG LOG END ---")

        # 3. Return the result
        app.logger.debug(f"Final result found. Returning {documents}")
        return jsonify({
            "status": "ok",
            "result": documents
        }), 200
    except Exception as err:
        app.logger.debug(f"Error {err}")
        return jsonify({"status": "error", "error": err}), 200
    
@app.route('/getGeofenceList', methods=['POST'])
@db_handler
def get_geofence_list(cursor):
    """
    Fetches the list of fence (url, description) for a given id_app 
    """
    try:
        app.logger.debug("--- /getGeofenceList DEBUG LOG START ---")
        app.logger.debug(f"Received request: {request}")
        
        if request.is_json:
            raw_params = request.get_json() or {}
        else:
            raw_params = request.form.to_dict()

        params = {k: v for k, v in raw_params.items()}
        app.logger.debug(f"Received raw parameters: {params}")

        if 'id_app' not in params or params['id_app'] is None:
            app.logger.debug(f"Missing required parameter id_app ({params.get('id_app')}).")
            return jsonify({"status": "error", "error": "Missing required parameter id_app."}), 200

        try:
            int_params = {k: int(v) for k, v in params.items()}
            app.logger.debug(f"Validated integer parameters: {int_params}")
        except ValueError:
            app.logger.debug(f"All provided parameters must be integers.")
            return jsonify({"status": "error", "error": "All provided parameters must be integers."}), 200
        
        # 2. Fetch documents from the database
        query = "SELECT id, id_app, latitude, longitude, radius, description FROM poi WHERE id_app = %s"
        cursor.execute(query, (int_params['id_app'],))
        poi = cursor.fetchall()
        
        app.logger.debug(f"Found {len(poi)} document(s).")
        app.logger.debug("--- /getGeofenceList DEBUG LOG END ---")

        # 3. Return the result
        app.logger.debug(f"Final result found. Returning {poi}")
        return jsonify({
            "status": "ok",
            "result": poi
        }), 200
    except Exception as err:
        app.logger.debug(f"Error {err}")
        return jsonify({"status": "error", "error": err}), 200
    
@app.route('/checkAnswer', methods=['POST'])
@db_handler
def get_answer_id(cursor):
    app.logger.debug("--- /getAnswerId DEBUG LOG START ---")
    app.logger.debug(f"Received request: {request}")
    try:
        # 1. Parameter Validation
        if request.is_json:
            raw_params = request.get_json() or {}
        else:
            raw_params = request.form.to_dict()

        params = {k: v for k, v in raw_params.items()}
        app.logger.debug(f"Received raw parameters: {params}")

        # 1. Parameter Validation
        if 'id_app' not in params or params['id_app'] is None \
            or 'id_status' not in params or params['id_status'] is None \
            or 'answer' not in params or params['answer'] is None   :
            app.logger.debug(f"Missing required parameters: id_app ({params.get('id_app')}), id_status ({params.get('id_status')}), answer ({params.get('answer')}).")
            return jsonify({"status": "error", "error": "Missing required parameters."}), 200
        
        try:
            id_app = int(params['id_app'])
            id_status = int(params['id_status'])
        except ValueError:
            return jsonify({"status": "error", "description": "Parameters id_app and id_status must be integers."}), 400

        # 2. Fetch the correct answer from the database
        query = "SELECT answer, id_answer FROM answers WHERE id_app = %s AND id_status = %s"
        cursor.execute(query, (id_app, id_status))
        correct_answer_record = cursor.fetchone()

        if not correct_answer_record:
            app.logger.debug("No answer found")
            id_answer = 0
        else:
            db_answer = correct_answer_record['answer'].strip().lower()
            user_answer_normalized = params['answer'].strip().lower()

            is_match = (db_answer == user_answer_normalized)
            id_answer = correct_answer_record['id_answer'] if is_match else 0

        app.logger.debug(f"id_answer: {id_answer}")
        return jsonify({
            "status": "ok", "result" : { "id_answer": id_answer }
        }), 200
    
        
    except Exception as err:
        app.logger.debug(f"Error {err}")
        return jsonify({"status": "error", "error": err}), 200
    finally:
        app.logger.debug("--- /getAnswerId DEBUG LOG END ---")

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "healthy"}), 200

# --- Main Execution ---
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)