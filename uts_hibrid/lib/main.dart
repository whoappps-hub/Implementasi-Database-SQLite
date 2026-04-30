import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ListUserPage());
  }
}

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database?> _initDB() async {
    String path = p.join(await getDatabasesPath(), "user-db.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, nama TEXT, umur INTEGER)",
        );
      },
    );
  }

  //create
  static Future<int> insertData(UserModel userModel) async {
    final db = await database;
    Map<String, dynamic> user = userModel.toJson();

    return await db.insert(
      "users",
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //read
  static Future<List<UserModel>> getData() async {
    final db = await database;
    List<Map<String, Object?>> result = await db.query("users");

    List<UserModel> users = result.map((userMap) {
      return UserModel.fromJson(userMap);
    }).toList();

    return users;
  }

  //update
  static Future<int> updateData(int id, UserModel userModel) async {
    final db = await database;
    var user = userModel.toJson();

    return await db.update("users", user, where: "id = ?", whereArgs: [id]);
  }

  //delete
  static Future<int> deleteData(int id) async {
    final db = await database;

    return await db.delete("users", where: "id = ?", whereArgs: [id]);
  }
}

class ListUserPage extends StatefulWidget {
  const ListUserPage({super.key});

  @override
  State<ListUserPage> createState() => _ListUserPageState();
}

class UserModel {
  int? id;
  String nama = '';
  int umur = 0;

  UserModel({this.id, required this.nama, required this.umur});

  //Convert dari map / hashmap ke model
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] as int?,
      nama: json["nama"] as String? ?? '',
      umur: json["umur"] as int? ?? 0,
    );
  }

  //Convert dari model ke map
  Map<String, dynamic> toJson() {
    return {"id": id, "nama": nama, "umur": umur};
  }
}

class _ListUserPageState extends State<ListUserPage> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _umurCtrl = TextEditingController();

  List<UserModel> userList = [];

  @override
  void initState() {
    super.initState();
    _reloadData();
  }

  void _reloadData() async {
    var users = await DatabaseHelper.getData();

    setState(() {
      userList = users;
    });
  }

  void _form(int? id) {
    if (id != null) {
      var user = userList.firstWhere((user) => user.id == id, orElse: () => UserModel(id: null, nama: '', umur: 0));

      _nameCtrl.text = user.nama;
      _umurCtrl.text = int.tryParse(user.umur.toString()) != null ? user.umur.toString() : '';
    } else {
      _nameCtrl.clear();
      _umurCtrl.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).viewInsets.bottom + 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(hintText: "Nama"),
            ),
            TextField(
              controller: _umurCtrl,
              decoration: const InputDecoration(hintText: "Umur"),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () =>
                  _save(id, _nameCtrl.text, int.tryParse(_umurCtrl.text) ?? 0),
              child: Text(id == null ? "Tambah" : "Perbaharui"),
            ),
          ],
        ),
      ),
    );
  }

  void _save(int? id, String nama, int umur) async {
    UserModel newUser = UserModel(id: id, nama: nama, umur: umur);
    if (id != null) {
      await DatabaseHelper.updateData(id, newUser);
    } else {
      await DatabaseHelper.insertData(newUser);
    }
    _reloadData();
  }

  void _delete(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: const Text("Apakah Anda yakin ingin menghapus user ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              await DatabaseHelper.deleteData(id);
              _reloadData();
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Data List")),
      body: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          final user = userList[index];

          return ListTile(
            title: Text(user.nama),
            subtitle: Text("Umur: ${user.umur} Tahun"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _form(user.id),
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () => _delete(user.id!),
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _form(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
