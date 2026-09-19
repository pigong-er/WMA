void main() {
  Map<String, String?> mahasiswa = {
    'nama': 'Figor S Ramadani',
    'nim': 'E41251279',
    'email': null,
  };

  print('=== BIODATA MAHASISWA ===');
  print('Nama  : ${mahasiswa['nama']}');
  print('NIM   : ${mahasiswa['nim']}');
  print('Email : ${mahasiswa['email'] ?? 'Email belum tersedia'}');
}