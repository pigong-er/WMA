abstract class Kendaraan {
  void bunyiklakson();
}

class Motor extends Kendaraan with BisaNgebut{
  @override
  void bunyiklakson() {
    print('Motor: TIN TIN!');
  }
}

mixin BisaNgebut {
  void ngebut() {
    print('Kendaraan sedang melaju dengan cepat!');
  }
}

class Mobil extends Kendaraan with BisaNgebut {
  @override
  void bunyiklakson() {
    print('Mobil: HORN HORN!');
  }
}

void main() {
  Motor motor = Motor();
  Mobil mobil = Mobil();

  print('=== MOTOR ===');
  motor.bunyiklakson();

  print('\n=== MOBIL ===');
  mobil.bunyiklakson();
  mobil.ngebut();
}