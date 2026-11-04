import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/widgets/Widget/auth_widgets.dart';

/// Halaman terakhir setelah register: atur foto dan nama profil.
class SetupProfilePage extends StatefulWidget {
  const SetupProfilePage({super.key});

  @override
  State<SetupProfilePage> createState() => _SetupProfilePageState();
}

class _SetupProfilePageState extends State<SetupProfilePage> {
  final _nameController = TextEditingController();

  // Foto yang dipilih user (null = belum pilih)
  Uint8List? _imageBytes;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _goHome() => context.go('/home');

  // Buka galeri / folder, lalu simpan foto yang dipilih
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return; // user batal memilih

    final bytes = await picked.readAsBytes();
    setState(() => _imageBytes = bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tombol Skip di kanan atas
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _goHome,
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: Color(0xFF6B6B6B)),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const AuthHeader(
                title: 'Set up your profile',
                subtitle: 'Good job on reaching this far. Might as well to put'
                    'a profile to show the world your charm, darl.',
              ),

              // Foto profil + tombol plus
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: const Color(0xFFCCCAFF),
                      // Kalau sudah pilih foto, tampilkan fotonya
                      backgroundImage:
                          _imageBytes != null ? MemoryImage(_imageBytes!) : null,
                      // Kalau belum, tampilkan ikon orang
                      child: _imageBytes == null
                          ? const Icon(Icons.person, size: 80, color: Colors.white)
                          : null,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0xFF222222),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              AuthTextField(controller: _nameController, hint: 'Name'),

              const Spacer(),

              AuthButton(
                text: 'Continue',
                onPressed: () {
                  // TODO: simpan nama dan foto (_imageBytes) ke server
                  _goHome();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}