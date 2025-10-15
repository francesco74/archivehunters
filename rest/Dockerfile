# Usa un'immagine Python ufficiale come base
FROM python:3.11-slim

# Imposta la working directory dentro al container
WORKDIR /app

# Copia i file di requirements e installa le dipendenze
COPY src/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Copia il codice sorgente dentro il container
COPY src/ .

# Espone la porta (adatta se usi FastAPI, Flask, ecc.)
EXPOSE 8000

# Comando di default per avviare l'applicazione
CMD ["python", "app.py"]

