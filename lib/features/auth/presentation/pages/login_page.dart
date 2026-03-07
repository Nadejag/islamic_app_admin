import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _email = TextEditingController();
  final _password = TextEditingController();

  late final AnimationController _shakeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  @override
  void initState() {
    super.initState();
    _email.addListener(_clearError);
    _password.addListener(_clearError);
  }

  void _clearError() {
    context.read<AuthBloc>().add(const AuthErrorCleared());
  }

  @override
  void dispose() {
    _email.removeListener(_clearError);
    _password.removeListener(_clearError);
    _email.dispose();
    _password.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<AuthBloc>().add(
      AuthSignInRequested(email: _email.text, password: _password.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          _shakeController.forward(from: 0);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.9),
                  radius: 1.8,
                  colors: [Color(0xFF06352A), Color(0xFF021B14)],
                ),
              ),
            ),
            CustomPaint(size: Size.infinite, painter: _DotPatternPainter()),
            Center(
              child: AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) {
                  final dx =
                      math.sin(_shakeController.value * math.pi * 6) *
                      (1 - _shakeController.value) *
                      14;
                  return Transform.translate(
                    offset: Offset(dx, 0),
                    child: child,
                  );
                },
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return Container(
                      width: 480,
                      padding: const EdgeInsets.fromLTRB(48, 36, 48, 34),
                      decoration: BoxDecoration(
                        color: const Color(0xCC03261D),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFF6B7430),
                          width: 1,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x66000000),
                            blurRadius: 42,
                            offset: Offset(0, 20),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Container(
                              width: 78,
                              height: 78,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1EF08F),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.mosque_rounded,
                                size: 34,
                                color: Color(0xFF052A20),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Center(
                            child: Text(
                              'ASK Islam',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 44,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Container(
                              width: 58,
                              height: 2,
                              color: const Color(0xFFD1B53C),
                            ),
                          ),
                          const SizedBox(height: 28),
                          const Center(
                            child: Text(
                              'Welcome Back',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Center(
                            child: Text(
                              'Authorized access only',
                              style: TextStyle(
                                color: Color(0xFF92A79F),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          if (state.errorMessage != null)
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0x33D14343),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0x99D14343),
                                ),
                              ),
                              child: Text(
                                state.errorMessage!,
                                style: const TextStyle(
                                  color: Color(0xFFFFBABA),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          const Text(
                            'EMAIL ADDRESS',
                            style: TextStyle(
                              color: Color(0xFF9AB0A6),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _AuthField(
                            controller: _email,
                            hint: 'admin@askislam.org',
                            icon: Icons.email_outlined,
                            enabled: !state.isLoading,
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'PASSWORD',
                            style: TextStyle(
                              color: Color(0xFF9AB0A6),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _AuthField(
                            controller: _password,
                            hint: '••••••••',
                            icon: Icons.lock_outline,
                            obscure: true,
                            enabled: !state.isLoading,
                            onSubmitted: (_) => _submit(),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 56,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF1DE587),
                                foregroundColor: const Color(0xFF052D22),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              onPressed: state.isLoading ? null : _submit,
                              child: state.isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.2,
                                        color: Color(0xFF052D22),
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [Text('SIGN IN')],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const Positioned(
              bottom: 34,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'SECURE ENVIRONMENT © 2024 ASK ISLAM EDUCATIONAL ECOSYSTEM',
                  style: TextStyle(
                    color: Color(0xFF6E877D),
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.enabled = true,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final bool enabled;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      enabled: enabled,
      onSubmitted: onSubmitted,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF6D847A), fontSize: 14),
        prefixIcon: Icon(icon, size: 18, color: const Color(0xFFD2B83C)),
        filled: true,
        fillColor: const Color(0x4C082A20),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF1E4C3D)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF1DE587)),
        ),
      ),
    );
  }
}

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 64.0;
    const radius = 16.0;

    final dotPaint = Paint()
      ..color = const Color(0xFF0D4A37).withValues(alpha: 0.36);

    for (double y = -spacing; y < size.height + spacing; y += spacing) {
      for (double x = -spacing; x < size.width + spacing; x += spacing) {
        canvas.drawCircle(
          Offset(x + spacing * 0.5, y + spacing * 0.5),
          radius,
          dotPaint,
        );
      }
    }

    final vignette = Paint()
      ..shader = const RadialGradient(
        center: Alignment.center,
        radius: 0.95,
        colors: [Colors.transparent, Color(0xAA021611)],
        stops: [0.58, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), vignette);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
