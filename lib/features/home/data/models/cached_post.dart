import 'package:isar/isar.dart';

part 'cached_post.g.dart';

@collection
class CachedPost {
  Id id = Isar.autoIncrement;

  late String title;
  late String body;
  late int postId;
}
