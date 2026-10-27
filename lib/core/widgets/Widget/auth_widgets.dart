import 'package:flutter/material.dart';

import '../Const/colors.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

// Widget kecil yang dipakai bareng oleh Splash, Login, dan Register.

enum FieldStatus { normal, valid, error }

const Color _kGrey = Color(0xFF8E8E8E);
const Color _kValidBorder = Color(0xFFFFD666);
const Color _kGreen = Color(0xFF52C41A);

// Kerangka halaman auth: konten di atas, link di paling bawah
class AuthScaffold extends StatelessWidget {
  final List<Widget> children;
  final Widget bottom;

  const AuthScaffold({super.key, required this.children, required this.bottom});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                ),
              ),
            ),
            bottom,
          ],
        ),
      ),
    );
  }
}

// Judul + subjudul
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Color(0xFF222222),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            height: 1.4,
            color: Color(0xFF6B6B6B),
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }
}

// Text field: normal / valid (centang hijau) / error (merah)
class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final FieldStatus status;
  final String? errorText;
  final bool isPassword;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.status = FieldStatus.normal,
    this.errorText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscure = true;

  Color get _borderColor {
    switch (widget.status) {
      case FieldStatus.valid:
        return _kValidBorder;
      case FieldStatus.error:
        return kPrimaryColor;
      case FieldStatus.normal:
        return _kGrey;
    }
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(
      color: color,
      width: widget.status == FieldStatus.normal ? 1 : 1.5,
    ),
  );

  Widget? _suffix() {
    if (widget.isPassword) {
      return IconButton(
        icon: Icon(
          _obscure ? LucideIcons.eyeOff : LucideIcons.eye,
          size: 20,
          color: _kGrey,
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
      );
    }
    if (widget.status == FieldStatus.valid) {
      return const Icon(Icons.check_circle, size: 20, color: _kGreen);
    }
    if (widget.status == FieldStatus.error) {
      return IconButton(
        icon: const Icon(Icons.cancel_outlined, size: 20, color: _kGrey),
        onPressed: () {
          widget.controller.clear();
          widget.onChanged?.call('');
        },
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final showError =
        widget.status == FieldStatus.error && widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword && _obscure,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(fontSize: 14, color: _kGrey),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            suffixIcon: _suffix(),
            enabledBorder: _border(_borderColor),
            focusedBorder: _border(
              widget.status == FieldStatus.normal
                  ? Colors.black54
                  : _borderColor,
            ),
          ),
        ),
        if (showError)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              widget.errorText!,
              style: const TextStyle(fontSize: 12, color: kPrimaryColor),
            ),
          ),
      ],
    );
  }
}

// Tombol merah utama
class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const AuthButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(text, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}

// Tombol outline abu-abu (Google, Apple, Sign up with phone)
class AuthOutlineButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const AuthOutlineButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFB5B5B5), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: child,
      ),
    );
  }
}

// Teks di paling bawah: "Don’t have an account? Sign up"
class AuthBottomLink extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onTap;

  const AuthBottomLink({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$text ',
            style: const TextStyle(fontSize: 13, color: Color(0xFF8E8E8E)),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              linkText,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: kPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
