
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHandler{
  Database? _database;
  Future<Database> get database async{

if(_database!=null){
   return _database!;
}

  Directory directory=await getApplicationDocumentsDirectory();
  String path= join(directory.path,'mydatabase.db');
  _database=await openDatabase(path,version:1,onCreate: (db, version) {
    db.execute(
      '''
      CREATE TABLE notes(
      id TEXT PRIMARY KEY,
      title TEXT,
      note TEXT,
      tag TEXT,
      date TEXT,
      isPinned INTEGER,
      isFavorite INTEGER,
      userId TEXT
      )
      '''
    );
  },);
  return _database!;
}
  Future<void> insertdata(Map<String, dynamic> note)async{
    Database? db=await database;
    await db.insert('notes',note,conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> readData()async{
    Database? db=await database;
    List<Map<String, dynamic>> notes=await db.query('notes');
    return notes;
  }

  Future<void> deleteData(String id)async{
    Database? db=await database;
    await db.delete('notes',where: 'id=?',whereArgs: [id]);
  }

  Future<void> updateData(
    Map<String, dynamic> note,
    String id,
  )async{
    Database? db=await database;
    await db.update('notes', note, where: 'id=?', whereArgs: [id]);
  }

  Future<void> updateFavorite(String id, int newvalue)async{
    Database? db=await database;
    await db.update('notes',{'isFavorite':newvalue},where: 'id=?',whereArgs: [id]);
  }

}