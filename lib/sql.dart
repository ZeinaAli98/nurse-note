import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  initialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'notesapp.db');
    Database mydb = await openDatabase(path,
        onCreate: _Oncreate, version: 11, onUpgrade: _OnUpgrade);
    return mydb;
  }

  _OnUpgrade(Database db, int oldVersion, int newVersion) {
    print("Update database successfully");
  }

  _Oncreate(Database db, int version) async {
    Batch batch = db.batch();

    batch.execute(
        'CREATE TABLE caringType (id INTEGER PRIMARY KEY NOT NULL AUTOINCREMENT, caringname TEXT NOT NULL, Description TEXT)');

    batch.execute('''
  CREATE TABLE Patient (
    id INTEGER PRIMARY KEY NOT NULL AUTOINCREMENT,
    patientname TEXT NOT NULL,
    roomnumber TEXT NOT NULL,
    isStopped INTEGER NOT NULL DEFAULT 0
   )
''');

    batch.execute('CREATE TABLE Caring ('
        'id INTEGER PRIMARY KEY NOT NULL AUTOINCREMENT, '
        'CaringType_ID INTEGER NOT NULL, '
        'Patient_Id INTEGER NOT NULL, '
        'Time TEXT NOT NULL, '
        'description TEXT, '
        'FOREIGN KEY (CaringType_ID) REFERENCES caringType(id), '
        'FOREIGN KEY (Patient_Id) REFERENCES Patient(id)'
        ')');
    await batch.commit();

    print('Create database successfully');
  }

  getLastInsertedId(String tableName) async {
    final db = await _db;
    final result =
        await db?.rawQuery('SELECT last_insert_rowid() FROM $tableName');
    final lastInsertedId = result != null && result.isNotEmpty
        ? result.first.values.first as int
        : null;
    return lastInsertedId;
  }

  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb?.rawQuery(sql) ?? [];
    return response;
  }

  insertData(String sql, List<String> list) async {
    Database? mydb = await db;
    int response = await mydb?.rawInsert(sql) ?? 0;
    return response;
  }

  updateData(
      String sql, Map<String, Object> map, String s, List<int> list) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  updateDataS(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  Future<bool> updateisStoppedData(
      String table, int id, String column, int values) async {
    try {
      Database? mydb = await db;
      await mydb!
          .update(table, {column: values}, where: 'id = ?', whereArgs: [id]);
      return true;
    } catch (e) {
      print('Error updating data: $e');
      return false;
    }
  }

  Future<bool> deleteData(String table, int id) async {
    try {
      Database? db = await this.db;
      int rowsAffected =
          await db!.delete(table, where: 'id = ?', whereArgs: [id]);
      return rowsAffected > 0;
    } catch (error) {
      print('Error deleting data: $error');
      return false;
    }
  }

  myDeletDatabase() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'myNote.db');
    await deleteDatabase(path);
  }

  Future<void> updateIsStopped(int id, bool newValue) async {
    Database? db = await this.db;
    await db!.update(
      'Patient',
      {'isStopped': newValue ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getAllPatients() async {
    Database? db = await this.db;
    return await db!.query('Patient');
  }
}
