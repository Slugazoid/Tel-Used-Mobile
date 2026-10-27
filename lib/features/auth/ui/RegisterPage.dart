import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/Widget/auth_widgets.dart';

/// Register 3 langkah dalam satu halaman:
/// 0 = email, 1 = username, 2 = password
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _step = 0;
  String? _error; // null = tidak ada error

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Data dummy untuk demo "sudah dipakai". Nanti ganti dengan cek ke server.
  final _takenEmails = ['nasywa@gmail.com'];
  final _takenUsernames = ['admin', 'telused'];

  // Teks untuk tiap langkah (urutan: email, username, password)
  final _titles = [
    'What’s your email?',
    'Create a username',
    'Create your password',
  ];
  final _subtitles = [
    'Enter your email and join the reading adventure.\nNo one will see this on your profile.',
    'Create a username that resonates with you!\nYou can change this anytime, don’t worry.',
    'Create a password with:\n•  At least 8 characters,\n•  Using a combination of letters, numbers, and symbols',
  ];
  final _hints = ['Email', 'Username', 'Password'];

  TextEditingController get _controller {
    return [_emailController, _usernameController, _passwordController][_step];
  }

  // Apakah isi field sudah benar? (untuk menampilkan centang hijau)
  bool _isValid(String text) {
    if (_step == 0) return text.contains('@') && text.contains('.');
    if (_step == 1) return text.length >= 3;
    return false; // password pakai ikon mata, bukan centang
  }

  // Status field: error / valid / normal
  FieldStatus get _status {
    if (_error != null) return FieldStatus.error;
    if (_isValid(_controller.text.trim())) return FieldStatus.valid;
    return FieldStatus.normal;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _next() {
    final text = _controller.text.trim();
    String? error;

    if (_step == 0) {
      if (!text.contains('@') || !text.contains('.')) {
        error = 'Please enter a valid email.';
      } else if (_takenEmails.contains(text)) {
        error = 'Oops, it seems like this email is already taken!';
      }
    } else if (_step == 1) {
      if (text.length < 3) {
        error = 'Username must be at least 3 characters.';
      } else if (_takenUsernames.contains(text)) {
        error = 'Oops, it seems like this username is already taken!';
      }
    } else {
      if (text.length < 8) {
        error = 'Password must be at least 8 characters.';
      }
    }

    // Kalau ada error, tampilkan dan berhenti di sini
    if (error != null) {
      setState(() => _error = error);
      return;
    }

    if (_step < 2) {
      setState(() => _step++); // lanjut ke langkah berikutnya
    } else {
      // kirim data ke server
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      bottom: AuthBottomLink(
        text: 'Already have an account?',
        linkText: 'Log In',
        onTap: () => context.go('/login'),
      ),
      children: [
        AuthHeader(title: _titles[_step], subtitle: _subtitles[_step]),

        AuthTextField(
          key: ValueKey(_step), // supaya field dibuat ulang tiap ganti langkah
          controller: _controller,
          hint: _hints[_step],
          isPassword: _step == 2,
          keyboardType: _step == 0
              ? TextInputType.emailAddress
              : TextInputType.text,
          status: _status,
          errorText: _error,
          onChanged: (_) => setState(() => _error = null),
        ),
        const SizedBox(height: 24),

        AuthButton(text: 'Sign Up', onPressed: _next),
      ],
    );
  }
}
