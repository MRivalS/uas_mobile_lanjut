import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/home/data/models/cached_post.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open([CachedPostSchema], directory: dir.path);
    }
    return Isar.getInstance()!;
  }

  // Menyimpan semua post baru dan membersihkan cache lama
  Future<void> savePosts(List<CachedPost> posts) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.cachedPosts.clear(); // Bersihkan cache lama
      await isar.cachedPosts.putAll(posts);
    });
  }

  // Mengambil data yang tersimpan di lokal jika offline
  Future<List<CachedPost>> getCachedPosts() async {
    final isar = await db;
    return await isar.cachedPosts.where().findAll();
  }
}
