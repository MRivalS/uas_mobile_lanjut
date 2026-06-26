import 'package:dio/dio.dart';
import 'package:uas_mobile_lanjut/core/database/isar_service.dart';
import '../models/api_entry_model.dart';
import '../models/cached_post.dart';

class ApiRepository {
  final Dio _dio;
  final IsarService _isarService;

  ApiRepository(this._dio, this._isarService);

  Future<List<ApiEntryModel>> fetchEntries() async {
    try {
      final response = await _dio.get('/posts');
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> entriesJson = response.data;
        List<ApiEntryModel> listData = entriesJson
            .map((json) => ApiEntryModel.fromJson(json))
            .toList();
        listData.sort(
          (a, b) => a.api.toLowerCase().compareTo(b.api.toLowerCase()),
        );
        List<CachedPost> postsToCache = listData
            .map(
              (e) => CachedPost()
                ..title = e.api
                ..body = e.description
                ..postId =
                    int.tryParse(
                      e.category.replaceAll(RegExp(r'[^0-9]'), ''),
                    ) ??
                    6,
            )
            .toList();

        await _isarService.savePosts(postsToCache);

        return listData;
      } else {
        throw Exception('Gagal memuat data dari server');
      }
    } on DioException catch (_) {
      final localPosts = await _isarService.getCachedPosts();

      if (localPosts.isNotEmpty) {
        return localPosts
            .map(
              (local) => ApiEntryModel(
                api: local.title,
                description: local.body,
                auth: '',
                https: true,
                cors: '',
                link: '',
                category: 'Post ID: ${local.postId} (Offline Cache)',
              ),
            )
            .toList();
      } else {
        throw Exception('Koneksi internet terputus & tidak ada cache lokal.');
      }
    }
  }
}
