import 'dart:convert'; // Untuk mengubah gambar ke teks Base64
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Package penyimpan data

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil Mahasiswa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk memuat data profil saat halaman pertama kali dibuka
    _loadProfile();
  }

  // --- FUNGSI UNTUK MEMBACA DATA YANG TERSIMPAN ---
  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Ambil teks. Jika kosong (belum pernah disave), gunakan nilai default
      _nameController.text = prefs.getString('name') ?? "Figor S Ramadani";
      _nimController.text = prefs.getString('nim') ?? "E41251279";
      _emailController.text = prefs.getString('email') ?? "e41251279@student.polije.ac.id";
      
      // Ambil gambar yang sudah diubah ke format teks Base64, lalu kembalikan ke format bytes
      String? imageString = prefs.getString('profile_image');
      if (imageString != null) {
        _imageBytes = base64Decode(imageString);
      }
    });
  }

  // --- FUNGSI UNTUK MENYIMPAN DATA SECARA PERMANEN ---
  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Simpan data teks
    await prefs.setString('name', _nameController.text);
    await prefs.setString('nim', _nimController.text);
    await prefs.setString('email', _emailController.text);
    
    // Jika ada gambar, ubah gambar ke bentuk teks Base64 lalu simpan
    if (_imageBytes != null) {
      String base64Image = base64Encode(_imageBytes!);
      await prefs.setString('profile_image', base64Image);
    }
  }

  // Fungsi mengambil gambar
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil gambar: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Keluar',
            onPressed: () {
              SystemNavigator.pop(); 
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 65,
                  backgroundImage: _imageBytes != null 
                      ? MemoryImage(_imageBytes!) as ImageProvider
                      : const NetworkImage('https://via.placeholder.com/150'), 
                ),
                if (_isEditing)
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white, size: 22),
                      onPressed: () {
                        _pickImage();
                      },
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 40),
            
            _buildTextField(label: "Nama Lengkap", controller: _nameController, icon: Icons.person),
            const SizedBox(height: 20),
            _buildTextField(label: "NIM", controller: _nimController, icon: Icons.badge, isNumber: true),
            const SizedBox(height: 20),
            _buildTextField(label: "Alamat Email", controller: _emailController, icon: Icons.email),
            const SizedBox(height: 40),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )
              ),
              onPressed: () async {
                setState(() {
                  _isEditing = !_isEditing;
                });
                
                // Ketika status berubah menjadi BUKAN mode edit (artinya baru saja di-klik Simpan)
                if (!_isEditing) {
                  await _saveProfile(); // Panggil fungsi simpan
                  
                  // Pastikan context masih aktif setelah await
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data profil berhasil disimpan secara permanen!')),
                    );
                  }
                }
              },
              child: Text(
                _isEditing ? 'Simpan Perubahan' : 'Edit Profil',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label, 
    required TextEditingController controller, 
    required IconData icon,
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      enabled: _isEditing,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}