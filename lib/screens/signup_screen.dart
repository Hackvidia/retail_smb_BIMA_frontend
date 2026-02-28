import 'package:flutter/material.dart';
import 'package:retail_smb/services/auth_service.dart';
import 'package:retail_smb/theme/color_schema.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _authService.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() => _isSubmitting = true);
    try {
      final result = await _authService.register(
        email: email,
        password: password,
      );
      if (!mounted) return;

      if (!result.success) {
        _showSnack(result.message ?? 'Register failed.');
        return;
      }

      _showSnack(result.message ?? 'Account created successfully.');
      Navigator.pushReplacementNamed(context, '/login');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralWhiteBase,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const _SignupTopArt(),
              Transform.translate(
                offset: const Offset(0, -12),
                child: Container(
                  width: 360,
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 24),
                  decoration: BoxDecoration(
                    color: AppColors.neutralWhiteLighter,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0x4D79747E)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          'Create Your Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
                          "Let's start creating your first BIMA account",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _fieldLabel('Email', fontFamily: 'Inter'),
                        const SizedBox(height: 6),
                        _inputField(
                          controller: _emailController,
                          hintText: 'you@example.com',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.mail_outline,
                          suffixIcon: Icons.help_outline,
                          validator: (value) {
                            final text = (value ?? '').trim();
                            if (text.isEmpty) return 'Email is required';
                            final valid = RegExp(
                              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                            ).hasMatch(text);
                            if (!valid) return 'Invalid email format';
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        _fieldLabel('Password', fontFamily: 'Lato'),
                        const SizedBox(height: 6),
                        _inputField(
                          controller: _passwordController,
                          hintText: '************',
                          obscureText: true,
                          validator: (value) {
                            final text = value ?? '';
                            if (text.isEmpty) return 'Password is required';
                            if (text.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        _fieldLabel('Repeat Password', fontFamily: 'Inter'),
                        const SizedBox(height: 6),
                        _inputField(
                          controller: _repeatPasswordController,
                          hintText: '************',
                          obscureText: true,
                          validator: (value) {
                            final text = value ?? '';
                            if (text.isEmpty) {
                              return 'Repeat password is required';
                            }
                            if (text != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBimaBase,
                              foregroundColor: AppColors.neutralWhiteLighter,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              _isSubmitting ? 'Loading...' : 'Masuk',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushReplacementNamed(context, '/login'),
                          child: const Text.rich(
                            TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Log in',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text, {required String fontFamily}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 20 / 14,
          color: const Color(0xFF011829),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType? keyboardType,
    IconData? prefixIcon,
    IconData? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: Color(0xFF121926),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFFA1A1AA),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        prefixIcon: prefixIcon == null
            ? null
            : Icon(prefixIcon, size: 20, color: const Color(0xFF121926)),
        suffixIcon: suffixIcon == null
            ? null
            : Icon(suffixIcon, size: 16, color: const Color(0xFFA1A1AA)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD4D4D8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD4D4D8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryBimaBase),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.systemErrorRedBase),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.systemErrorRedBase),
        ),
      ),
    );
  }
}

class _SignupTopArt extends StatelessWidget {
  const _SignupTopArt();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      height: 200,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 108,
            top: 26,
            child: Transform.rotate(
              angle: -0.52,
              child: const _PuzzleShape(size: 136),
            ),
          ),
          Positioned(
            left: 174,
            top: 10,
            child: Image.asset(
              'assets/images/sm-icon.png',
              width: 175,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

class _PuzzleShape extends StatelessWidget {
  const _PuzzleShape({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final double nub = size * 0.24;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size * 0.78,
            height: size * 0.78,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFB9B9BD)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A7F9BF6),
                  offset: Offset(0, 2),
                  blurRadius: 0,
                ),
              ],
            ),
          ),
          Align(alignment: const Alignment(0, -1), child: _Nub(size: nub)),
          Align(alignment: const Alignment(1, 0), child: _Nub(size: nub)),
          Align(alignment: const Alignment(-1, 0.26), child: _Nub(size: nub)),
        ],
      ),
    );
  }
}

class _Nub extends StatelessWidget {
  const _Nub({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFB9B9BD)),
      ),
    );
  }
}
