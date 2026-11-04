import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/Const/colors.dart';
import '../../../core/widgets/Widget/auth_widgets.dart';

/// Register 4 langkah dalam satu halaman:
/// 0 = email / nomor HP, 1 = kode verifikasi, 2 = username, 3 = password
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _step = 0;
  bool _usePhone = false; // false = daftar pakai email
  String? _error; // null = tidak ada error

  final _contactController = TextEditingController();
  final _codeController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Data dummy untuk demo. Nanti ganti dengan cek ke server.
  final _takenEmails = ['nasywa@gmail.com'];
  final _takenUsernames = ['admin', 'telused'];
  static const _dummyCode = '4444';

  // Controller yang dipakai sesuai langkah sekarang
  TextEditingController get _controller {
    return [
      _contactController,
      _codeController,
      _usernameController,
      _passwordController,
    ][_step];
  }

  @override
  void dispose() {
    _contactController.dispose();
    _codeController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ---------- Teks tiap langkah ----------
  String get _title {
    if (_step == 0) {
      if (_usePhone) return 'What’s your phone number?';
      return 'What’s your email?';
    }
    if (_step == 1) return 'Enter verification code';
    if (_step == 2) return 'Create a username';
    return 'Create your password';
  }

  String get _subtitle {
    if (_step == 0) {
      if (_usePhone) {
        return 'Enter your number and join the reading adventure.\n'
            'No one will see this on your profile.';
      }
      return 'Enter your email and join the reading adventure.\n'
          'No one will see this on your profile.';
    }
    if (_step == 1) {
      return 'A verification code has been sent to\n'
          '${_contactController.text.trim()}';
    }
    if (_step == 2) {
      return 'Create a username that resonates with you!\n'
          'You can change this anytime, don’t worry.';
    }
    return 'Create a password with:\n'
        '•  At least 8 characters,\n'
        '•  Using a combination of letters, numbers, and symbols';
  }

  String get _hint {
    if (_step == 0) {
      if (_usePhone) return 'Mobile number';
      return 'Email';
    }
    if (_step == 2) return 'Username';
    return 'Password';
  }

  TextInputType get _keyboardType {
    if (_step == 0 && _usePhone) return TextInputType.phone;
    if (_step == 0) return TextInputType.emailAddress;
    return TextInputType.text;
  }

  // ---------- Status field (centang hijau / error) ----------
  bool _isValid(String text) {
    if (_step == 0) {
      if (_usePhone) return text.length >= 9 && int.tryParse(text) != null;
      return text.contains('@') && text.contains('.');
    }
    if (_step == 2) return text.length >= 3;
    return false; // kode & password tidak pakai centang hijau
  }

  FieldStatus get _status {
    if (_error != null) return FieldStatus.error;
    if (_isValid(_controller.text.trim())) return FieldStatus.valid;
    return FieldStatus.normal;
  }

  // ---------- Aksi ----------
  void _next() {
    final text = _controller.text.trim();
    String? error;

    if (_step == 0) {
      if (!_isValid(text)) {
        if (_usePhone) {
          error = 'Please enter a valid phone number.';
        } else {
          error = 'Please enter a valid email.';
        }
      } else if (!_usePhone && _takenEmails.contains(text)) {
        error = 'Oops, it seems like this email is already taken!';
      }
    } else if (_step == 1) {
      if (text != _dummyCode) {
        error = 'Incorrect verification code.';
      }
    } else if (_step == 2) {
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

    if (_step < 3) {
      setState(() => _step++); // lanjut ke langkah berikutnya
    } else {
      // TODO: kirim data ke server, lalu lanjut atur profil
      context.go('/setup-profile');
    }
  }

  void _togglePhone() {
    setState(() {
      _usePhone = !_usePhone;
      _contactController.clear();
      _error = null;
    });
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      // Di halaman kode verifikasi, link "Log In" tidak ditampilkan (sesuai desain)
      bottom: _step == 1
          ? const SizedBox.shrink()
          : AuthBottomLink(
              text: 'Already have an account?',
              linkText: 'Log In',
              onTap: () => context.go('/login'),
            ),
      children: [
        AuthHeader(title: _title, subtitle: _subtitle),

        if (_step == 1)
          _CodeField(
            controller: _codeController,
            errorText: _error,
            onChanged: (_) => setState(() => _error = null),
          )
        else
          AuthTextField(
            key: ValueKey('$_step-$_usePhone'), // field dibuat ulang tiap ganti langkah
            controller: _controller,
            hint: _hint,
            isPassword: _step == 3,
            keyboardType: _keyboardType,
            status: _status,
            errorText: _error,
            onChanged: (_) => setState(() => _error = null),
          ),
        const SizedBox(height: 24),

        AuthButton(
          text: _step == 1 ? 'Redeem code' : 'Sign Up',
          onPressed: _next,
        ),

        // Tombol ganti email <-> nomor HP hanya di langkah pertama
        if (_step == 0) ...[
          const SizedBox(height: 12),
          AuthOutlineButton(
            onPressed: _togglePhone,
            child: Text(
              _usePhone ? 'Sign up with email' : 'Sign up with phone number',
              style: const TextStyle(color: Color(0xFFB5B5B5)),
            ),
          ),
        ],
      ],
    );
  }
}

// ------------------------------------------------------------
// Field kode verifikasi 4 angka (garis bawah, angka besar di tengah)
// ------------------------------------------------------------
class _CodeField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String> onChanged;

  const _CodeField({
    required this.controller,
    required this.errorText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          onChanged: onChanged,
          autofocus: true,
          maxLength: 4,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 28, letterSpacing: 28),
          decoration: InputDecoration(
            counterText: '', // sembunyikan tulisan "0/4"
            hintText: '0000',
            hintStyle: const TextStyle(
              fontSize: 28,
              letterSpacing: 28,
              color: Color(0xFFD0D0D0),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: errorText == null ? const Color(0xFFD0D0D0) : kPrimaryColor,
                width: 2,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: errorText == null ? Colors.black54 : kPrimaryColor,
                width: 2,
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              errorText!,
              style: const TextStyle(fontSize: 12, color: kPrimaryColor),
            ),
          ),
      ],
    );
  }
}