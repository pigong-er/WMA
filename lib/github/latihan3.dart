class Produk {
  String nama;
  double _harga;

  Produk(this.nama, this._harga);
  Produk.gratis(this.nama) : _harga = 0;

  // Getter
  double get harga {
    return _harga;
  }

  // Setter dengan validasi
  set harga(double nilai) {
    if (nilai < 0) {
      print('Harga tidak boleh negatif.');
      return;
    }

    _harga = nilai;
  }
}

void main() {
  Produk produk1 = Produk('Laptop', 7500000);

  print('=== PRODUK 1 ===');
  print('Nama  : ${produk1.nama}');
  print('Harga : ${produk1.harga}');

  produk1.harga = 8000000;

  print('Harga setelah diubah: ${produk1.harga}');

  // Named constructor
  Produk produk2 = Produk.gratis('Pulpen');

  print('\n=== PRODUK 2 ===');
  print('Nama  : ${produk2.nama}');
  print('Harga : ${produk2.harga}');

  // Uji harga negatif
  produk1.harga = -5000;
}