import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ronce_tuban_app/providers/auth_provider.dart';
import 'package:ronce_tuban_app/services/local_auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isRegistering = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      final auth = context.read<AuthProvider>();
      if (_isRegistering) {
        await auth.register(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );
      } else {
        await auth.signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
      }
    } on LocalAuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    } on DatabaseException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Penyimpanan akun gagal diakses. Coba lagi.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _toggleRegistration() {
    _formKey.currentState?.reset();
    setState(() {
      _isRegistering = !_isRegistering;
      _nameController.clear();
      _confirmPasswordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5F8FB),
              Color(0xFFF7F2EB),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xB3FFFFFF),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color(0xFFE5EEF5),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5F3FB),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(
                                Icons.auto_stories_rounded,
                                color: Color(0xFF247BA0),
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Ronce Tuban',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E3A4C),
                                fontFamily: 'Serif',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: const Color(0xE6FFFFFF),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: const Color(0xFFE3E8EE),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1A1E3A4C),
                              blurRadius: 20,
                              offset: Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF1E6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.waves_rounded,
                                color: Color(0xFFCE7850),
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 22),
                            const Text(
                              'Cerita Tuban,\ndekat di hatimu.',
                              style: TextStyle(
                                fontSize: 32,
                                height: 1.15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E3A4C),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Masuk atau buat akun untuk menyimpan perjalananmu mengenal budaya Tuban.',
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: Color(0xFF6B7A8D),
                              ),
                            ),
                            const SizedBox(height: 26),
                            if (_isRegistering) ...[
                              const Text(
                                'Nama',
                                style: TextStyle(
                                  color: Color(0xFF1E3A4C),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _nameController,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                decoration: _inputDecoration(
                                  hint: 'Nama kamu',
                                  icon: Icons.person_outline_rounded,
                                ),
                                validator: (value) {
                                  if (!_isRegistering) return null;
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Nama wajib diisi.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),
                            ],
                            const Text(
                              'Email',
                              style: TextStyle(
                                color: Color(0xFF1E3A4C),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.email],
                              decoration: _inputDecoration(
                                hint: 'nama@email.com',
                                icon: Icons.mail_outline_rounded,
                              ),
                              validator: (value) {
                                final email = value?.trim() ?? '';
                                if (email.isEmpty) return 'Email wajib diisi.';
                                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                    .hasMatch(email)) {
                                  return 'Masukkan alamat email yang valid.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'Kata sandi',
                              style: TextStyle(
                                color: Color(0xFF1E3A4C),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.password],
                              onFieldSubmitted: (_) => _submit(),
                              decoration: _inputDecoration(
                                hint: 'Masukkan kata sandi',
                                icon: Icons.lock_outline_rounded,
                              ).copyWith(
                                suffixIcon: IconButton(
                                  tooltip: _obscurePassword
                                      ? 'Tampilkan kata sandi'
                                      : 'Sembunyikan kata sandi',
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: const Color(0xFF6B7A8D),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Kata sandi wajib diisi.';
                                }
                                if (value.length < 6) {
                                  return 'Kata sandi minimal 6 karakter.';
                                }
                                return null;
                              },
                            ),
                            if (_isRegistering) ...[
                              const SizedBox(height: 18),
                              const Text(
                                'Konfirmasi kata sandi',
                                style: TextStyle(
                                  color: Color(0xFF1E3A4C),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.done,
                                decoration: _inputDecoration(
                                  hint: 'Ulangi kata sandi',
                                  icon: Icons.lock_outline_rounded,
                                ),
                                validator: (value) {
                                  if (!_isRegistering) return null;
                                  if (value != _passwordController.text) {
                                    return 'Konfirmasi kata sandi belum cocok.';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (_) => _submit(),
                              ),
                            ],
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isSubmitting ? null : _submit,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(_isRegistering
                                        ? 'Buat akun'
                                        : 'Masuk ke aplikasi'),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_forward_rounded,
                                        size: 18),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Center(
                              child: TextButton(
                                onPressed:
                                    _isSubmitting ? null : _toggleRegistration,
                                child: Text(
                                  _isRegistering
                                      ? 'Sudah punya akun? Masuk'
                                      : 'Belum punya akun? Daftar',
                                  style: const TextStyle(
                                    color: Color(0xFF247BA0),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Center(
                              child: TextButton(
                                onPressed: () => context
                                    .read<AuthProvider>()
                                    .continueAsGuest(),
                                child: const Text(
                                  'Jelajahi sebagai tamu',
                                  style: TextStyle(
                                    color: Color(0xFF247BA0),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Center(
                              child: Text(
                                'Akun tersimpan di perangkat ini dan tidak disinkronkan ke perangkat lain.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF8A9AAC),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF6B8798)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD8E5EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD8E5EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF247BA0), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEF6B5B)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEF6B5B), width: 1.5),
      ),
    );
  }
}
