// lib/screens/documents_screen.dart
import 'package:flutter/material.dart';
import '../models/document.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'webview_screen.dart';
import 'pdf_view_screen.dart';
import 'package:archive_hunters/l10n/app_localizations.dart'; 

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({Key? key}) : super(key: key);

  @override
  _DocumentsScreenState createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  late Future<List<Document>> _documentsFuture;
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _documentsFuture = _fetchDocuments();
  }

  Future<List<Document>> _fetchDocuments() {
    return _apiService.getDocumentList(
      idApp: _storageService.getIdApp(),
      idStatus: _storageService.getIdStatus(),
    );
  }

  void _retryFetch() {
    setState(() {
      _documentsFuture = _fetchDocuments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.collectedDocuments),
      ),
      body: FutureBuilder<List<Document>>(
        future: _documentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            final errorMessage = snapshot.error.toString().replaceFirst("Exception: ", "");
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text(
                      AppLocalizations.of(context)!.failedToLoadDocuments,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      errorMessage,
                      style: TextStyle(fontSize: 16, color: Colors.red[700]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _retryFetch,
                      child:  Text(AppLocalizations.of(context)!.reload),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return  Center(child: Text(AppLocalizations.of(context)!.noDocumentsCollected));
          } else {
            final documents = snapshot.data!;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final doc = documents[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.article_outlined, color: Colors.brown),
                    title: Text(doc.description),
                    trailing: ElevatedButton(
                      child:  Text(AppLocalizations.of(context)!.view),
                      onPressed: () {
                        if (doc.url.toLowerCase().endsWith('.pdf')) {
                          // Open PDF in the new PDF viewer
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PdfViewerScreen(url: doc.url),
                            ),
                          );
                        } else {
                          // Open images and other links in the webview
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => WebviewScreen(url: doc.url),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
