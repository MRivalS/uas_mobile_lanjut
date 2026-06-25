class ApiEntryModel {
  final String api;
  final String description;
  final String auth;
  final bool https;
  final String cors;
  final String link;
  final String category;

  ApiEntryModel({
    required this.api,
    required this.description,
    required this.auth,
    required this.https,
    required this.cors,
    required this.link,
    required this.category,
  });

  factory ApiEntryModel.fromJson(Map<String, dynamic> json) {
    return ApiEntryModel(
      // Memetakan properti dari json milik jsonplaceholder/posts
      api: json['title'] ?? '', // 'title' dipetakan ke nama API
      description: json['body'] ?? '', // 'body' dipetakan ke deskripsi
      auth: '',
      https: true,
      cors: '',
      link: '',
      category:
          'Post ID: ${json['id']}', // 'id' dipetakan ke kategori sebagai pembeda
    );
  }
}
