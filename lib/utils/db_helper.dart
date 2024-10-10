import 'package:note_keeper/models/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; //import these

class DBHelper {
  //this is to initialize the SQLite database
  //Database is from sqflite package
  //as well as getDatabasesPath()
  static Future<Database> initDB() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'note.db');
    //this is to create database
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  //build _onCreate function
  static Future _onCreate(Database db, int version) async {
    //this is to create table into database
    //and the command is same as SQL statement
    //you must use ''' and ''', for open and close
    const sql = '''CREATE TABLE notes(
      id INTEGER PRIMARY KEY,
      title TEXT,
      description TEXT
    )''';
    //sqflite is only support num, string, and unit8List format
    //please refer to package doc for more details
    await db.execute(sql);
  }

  //build create function (insert)
  static Future<int> createNote(NoteModel note) async {
    Database db = await initDB();
    //create contact using insert()
    return await db.insert('notes', note.toJson());
  }

  //build read function
  static Future<List<NoteModel>> readNote() async {
    Database db = await initDB();
    var note = await db.query('notes', orderBy: 'id');
    //this is to list out the contact list from database
    //if empty, then return empty []
    List<NoteModel> noteList = note.isNotEmpty
        ? note.map((details) => NoteModel.fromJson(details)).toList()
        : [];
    return noteList;
  }

  //build update function
  static Future<int> updateNote(NoteModel note) async {
    Database db = await DBHelper.initDB();
    //update the existing contact
    //according to its id
    return await db
        .update('notes', note.toJson(), where: 'id = ?', whereArgs: [note.id]);
  }

  //build delete function
  static Future<int> deleteNote(int id) async {
    Database db = await DBHelper.initDB();
    //delete existing contact
    //according to its id
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
