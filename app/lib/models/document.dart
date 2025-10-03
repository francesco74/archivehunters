// lib/models/document.dart

class Document {
  final int id;
  final String description;
  final String url;

  Document({
    required this.id,
    required this.description,
    required this.url,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'], // Provide a default value if null
      description: json['description'], // Provide a default value if null
      url: json['url'], // Provide a default value if null
    );
  }
}
