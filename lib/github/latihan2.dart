void main() {
  List<int> nilai = [80, 90, 65, 70, 95];

  // 1. Menampilkan nilai yang lulus
  final nilaiLulus = nilai.where((n) => n >= 75).toList();

  print('=== NILAI LULUS ===');
  print(nilaiLulus);

  // 2. Mengubah nilai menjadi predikat
  final predikat = nilai.map((n) {
    return switch (n) {
      >= 85 => 'A',
      >= 75 => 'B',
      _ => 'C',
    };
  }).toList();

  print('=== PREDIKAT ===');
  print(predikat);
}   