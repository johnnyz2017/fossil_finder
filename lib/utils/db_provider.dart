import 'dart:io';
import 'package:fossils_finder/config/global_config.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbProvider {
  static Database db;

  /// 获取数据库中所有的表
  Future<List> getTables() async {
    if (db == null) {
      return Future.value([]);
    }
    List tables = await db
        .rawQuery('SELECT name FROM sqlite_master WHERE type = "table"');
    List<String> targetList = [];
    tables.forEach((item) {
      targetList.add(item['name']);
    });
    return targetList;
  }

  /// 检查数据库中, 表是否存在
  Future checkTableIsRight(String expectTables) async {
    List<String> tables = await getTables();
    return tables.contains(expectTables);
  }

  /// 初始化数据库
  Future init({bool isCreate = false}) async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'fossil.db');
    try {
      db = await openDatabase(
        path,
        version: 5,
        onCreate: (db, version) async {
          // 创建pb_setting表
          // _initPb(db);
          // 创建uploaded表
          await db.execute('''
          CREATE TABLE $TABLE_NAME_UPLOADED (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            path varchar(255) NOT NULL,
            type varchar(20) NOT NULL,
            info varchar(255) NOT NULL
          )''');
        },
        onUpgrade: (db, oldVersion, newVersion) {
          // _initPb(db);

          /// v1 to v2
          if (oldVersion == 1) {
            _upgradeDbV1ToV2(db);
          }
        },
      );
    } catch (e) {
      print('DataBase init Error >>>>>> $e');
      var file = File(path);
      file.deleteSync();
    }
  }

  /// 初始化图床设置表
  _initPb(Database db) async {
  }

  /// db版本升级
  _upgradeDbV1ToV2(Database db) async {
    await db.execute(
        'ALTER TABLE $TABLE_NAME_UPLOADED ADD COLUMN info varchar(255)');
  }
}
