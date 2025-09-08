
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:poster/db_poster/poster_entity.dart';
import 'package:sqflite/sqflite.dart';


class DBPoster extends GetxService {
  late Database dbBase;

  Future<DBPoster> init() async {
    await createPosterDB();
    return this;
  }

  createPosterDB() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'poster.db');

    dbBase = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await createPosterTable(db);
        });
  }

  createPosterTable(Database db) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS poster (id INTEGER PRIMARY KEY, createdTime TEXT, image BLOB)');
  }

  insertPoster(PosterEntity entity) async {
    final id = await dbBase.insert('poster', {
      'createdTime': entity.createdTime.toIso8601String(),
      'image': entity.image,
    });
    return id;
  }

  deletePosters(List<int> ids) async {
    await dbBase.delete('poster', where: 'id IN (${ids.join(',')})');
  }

  cleanPosterData() async {
    await dbBase.delete('poster');
  }

  Future<List<PosterEntity>> getPosterAllData() async {
    var result = await dbBase.query('poster', orderBy: 'createdTime DESC');
    return result.map((e) => PosterEntity.fromJson(e)).toList();
  }
}
