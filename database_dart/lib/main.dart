import 'package:flutter/material.dart';

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

class ListUserPage extends StatefulWidget {
  const ListUserPage({super.key});

  @override
  State<ListUserPage> createState() => _ListUserPageState();
}

class _ListUserPageState extends State<ListUserPage> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _umurCtrl = TextEditingController();

  List<Map<String, dynamic>> userList = [
    {"id": 1, "nama": "Satu", "Umur": 10},
    {"id": 2, "nama": "Dua", "Umur": 20},
    {"id": 3, "nama": "Tiga", "Umur": 30},
    {"id": 4, "nama": "Empat", "Umur": 40},
  ];

  void _form(int? id) {
    if (id != null) {
      var user = userList.firstWhere(
        (user) => user['id'] == id,
        orElse: () => {},
      );

      _nameCtrl.text = user['nama'] ?? '';
      _umurCtrl.text = user['Umur']?.toString() ?? '';
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

  void _save(int? id, String nama, int umur) {
    if (id != null) {
      var user = userList.firstWhere((user) => user['id'] == id);

      setState(() {
        user['nama'] = nama;
        user['Umur'] = umur;
      });
    } else {
      var nextId = userList.length + 1;
      var newUser = {"id": nextId, "nama": nama, "Umur": umur};

      setState(() {
        userList.add(newUser);
      });
    }

    Navigator.pop(context);
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
            onPressed: () {
              setState(() {
                userList.removeWhere((data) => data['id'] == id);
              });
              Navigator.pop(context);
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
            title: Text(user['nama'] ?? ''),
            subtitle: Text("Umur: ${user['Umur']} Tahun"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _form(user['id']),
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () => _delete(user['id']),
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
