import 'package:dio/dio.dart';
import '../models/api_entry_model.dart';

class ApiRepository {
  final Dio _dio;

  ApiRepository(this._dio);

  Future<List<ApiEntryModel>> fetchEntries() async {
    try {
      final response = await _dio.get('/posts');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> entriesJson = response.data;

        // 1. Ubah JSON ke bentuk objek Model List
        List<ApiEntryModel> listData = entriesJson
            .map((json) => ApiEntryModel.fromJson(json))
            .toList();

        // 2. TANTANGAN ANTI-AI: Karena digit terakhir NIM Genap (6), urutkan dari A ke Z (Ascending)
        listData.sort(
          (a, b) => a.api.toLowerCase().compareTo(b.api.toLowerCase()),
        );

        return listData;
      } else {
        throw Exception('Gagal memuat data dari server');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Terjadi kesalahan jaringan');
    }
  }
}
