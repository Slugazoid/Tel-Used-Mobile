import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/Widget/auth_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  String? _error; // null = tidak ada error

  // Password dummy untuk demo. Nanti ganti dengan panggilan API.
  static const _dummyPassword = '12345678';

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _login() {
    final user = _userController.text.trim();
    final pass = _passController.text;

    if (user.isEmpty || pass.isEmpty) {
      setState(() => _error = 'Please fill in all fields.');
      return;
    }

    // TODO: ganti dengan login ke server
    if (pass != _dummyPassword) {
      setState(() => _error = 'Incorrect password.');
      return;
    }

    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      bottom: AuthBottomLink(
        text: 'Don’t have an account?',
        linkText: 'Sign up',
        onTap: () => context.push('/register'),
      ),
      children: [
        const AuthHeader(
          title: 'It’s nice to see you again.',
          subtitle: 'Time to dive back into the literary wonderland.',
        ),

        AuthTextField(
          controller: _userController,
          hint: 'Username or Email',
          keyboardType: TextInputType.emailAddress,
          onChanged: (_) => setState(() => _error = null),
        ),
        const SizedBox(height: 12),
        AuthTextField(
          controller: _passController,
          hint: 'Password',
          isPassword: true,
          status: _error != null ? FieldStatus.error : FieldStatus.normal,
          errorText: _error,
          onChanged: (_) => setState(() => _error = null),
        ),
        const SizedBox(height: 24),

        AuthButton(text: 'Log In', onPressed: _login),
        const SizedBox(height: 48),

        // Divider "Or log in with"
        const Row(
          children: [
            Expanded(child: Divider(color: Color(0xFFB5B5B5))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Or log in with',
                style: TextStyle(fontSize: 13, color: Color(0xFF6B6B6B)),
              ),
            ),
            Expanded(child: Divider(color: Color(0xFFB5B5B5))),
          ],
        ),
        const SizedBox(height: 20),

        // Tombol Google & Apple
        Row(
          children: [
            Expanded(
              child: AuthOutlineButton(
                onPressed: () {
                  // TODO: login Google
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/google.png', width: 20, height: 20),
                    const SizedBox(width: 8),
                    const Text('Google', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AuthOutlineButton(
                onPressed: () {
                  // TODO: login Apple
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.apple, color: Colors.black, size: 22),
                    SizedBox(width: 8),
                    Text('Apple', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}