class Mahasiswa {
  int id;
  String nama;
  String jurusan;
  int angkatan;

  Mahasiswa({
    required this.id,
    required this.nama,
    required this.jurusan,
    required this.angkatan,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'jurusan': jurusan,
      'angkatan': angkatan,
    };
  }

  factory Mahasiswa.fromMap(Map<String, dynamic> map) {
    return Mahasiswa(
      id: map['id'],
      nama: map['nama'],
      jurusan: map['jurusan'],
      angkatan: map['angkatan'],
    );
  }
}

// 🔥 Pakai Map biar cepat & aman
Map<int, Mahasiswa> database = {};

void insertMahasiswa(Mahasiswa mhs) {
  if (database.containsKey(mhs.id)) {
    print("❌ ID ${mhs.id} sudah ada!");
    return;
  }
  database[mhs.id] = mhs;
}

List<Mahasiswa> getMahasiswa() {
  return database.values.toList();
}

void updateMahasiswa(int id, Mahasiswa newData) {
  if (!database.containsKey(id)) {
    print("ID $id tidak ditemukan!");
    return;
  }
  database[id] = newData;
}

void deleteMahasiswa(int id) {
  if (!database.containsKey(id)) {
    print("ID $id tidak ditemukan!");
    return;
  }
  database.remove(id);
}

void tampilkanData() {
  if (database.isEmpty) {
    print("Data kosong");
    return;
  }

  for (var mhs in database.values) {
    print(
        "ID: ${mhs.id}, Nama: ${mhs.nama}, Jurusan: ${mhs.jurusan}, Angkatan: ${mhs.angkatan}");
  }
}

void main() {
  insertMahasiswa(Mahasiswa(
    id: 1,
    nama: "Opang",
    jurusan: "TI",
    angkatan: 2046,
  ));

  insertMahasiswa(Mahasiswa(
    id: 2,
    nama: "Joo",
    jurusan: "SI",
    angkatan: 2044,
  ));

  print("=== DATA MAHASISWA ===");
  tampilkanData();

  updateMahasiswa(
    1,
    Mahasiswa(
      id: 1,
      nama: "Opang Update",
      jurusan: "TI",
      angkatan: 2044,
    ),
  );

  print("\n=== SETELAH UPDATE ===");
  tampilkanData();

  deleteMahasiswa(2);

  print("\n=== SETELAH DELETE ===");
  tampilkanData();
}