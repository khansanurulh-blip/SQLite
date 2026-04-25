import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ListUserDataPage(),
    );
  }
}

class ListUserDataPage extends StatefulWidget {
  const ListUserDataPage({super.key});

  @override
  State<ListUserDataPage> createState() => _ListUserDataPageState();
}

class UserModel {
  int? id;
  String nama = "";
  int umur = 0;

  UserModel(this.id, {required this.nama, required this.umur});
}

class _ListUserDataPageState extends State<ListUserDataPage> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _umurCtrl = TextEditingController();

  final Color primaryBlue = Colors.lightBlue;
  final Color softBlue = Colors.lightBlueAccent.withOpacity(0.2);

  List<UserModel> userList = [
    UserModel(1, nama: "Khansa", umur: 20),
    UserModel(2, nama: "Hasbi", umur: 19),
    UserModel(3, nama: "Cahaya", umur: 17),
    UserModel(4, nama: "Ameera", umur: 13),
  ];

  void _form(int? id) {
    if (id != null) {
      var user = userList.firstWhere((data) => data.id == id);
      _nameCtrl.text = user.nama;
      _umurCtrl.text = user.umur.toString();
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
            // INPUT NAMA
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                hintText: "Nama",
                filled: true,
                fillColor: softBlue,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // INPUT UMUR
            TextField(
              controller: _umurCtrl,
              decoration: InputDecoration(
                hintText: "Umur",
                filled: true,
                fillColor: softBlue,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),

            // BUTTON SIMPAN
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue.withOpacity(0.7),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (_nameCtrl.text.isEmpty || _umurCtrl.text.isEmpty) return;

                _save(
                  id,
                  _nameCtrl.text,
                  int.parse(_umurCtrl.text),
                );
              },
              child: Text(id == null ? "Tambah" : "Perbaharui"),
            ),
          ],
        ),
      ),
    );
  }

  void _save(int? id, String nama, int umur) {
    if (id != null) {
      var user = userList.firstWhere((data) => data.id == id);
      setState(() {
        user.nama = nama;
        user.umur = umur;
      });
    } else {
      var nextId = userList.length + 1;
      var newUser = UserModel(nextId, nama: nama, umur: umur);
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text("Konfirmasi Hapus"),
        content:
            const Text("Apakah anda yakin ingin menghapus data ini?"),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: softBlue,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Batal",
              style: TextStyle(color: primaryBlue),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: primaryBlue.withOpacity(0.7),
            ),
            onPressed: () {
              setState(() =>
                  userList.removeWhere((data) => data.id == id));
              Navigator.pop(context);
            },
            child: const Text(
              "Hapus",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: softBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Icon(icon, color: primaryBlue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User List"),
        backgroundColor: primaryBlue.withOpacity(0.7),
      ),
      body: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, i) => ListTile(
          title: Text(userList[i].nama),
          subtitle: Text("umur: ${userList[i].umur} tahun"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _actionButton(
                Icons.edit,
                () => _form(userList[i].id),
              ),
              _actionButton(
                Icons.delete,
                () => _delete(userList[i].id!),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryBlue.withOpacity(0.7),
        onPressed: () => _form(null),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}