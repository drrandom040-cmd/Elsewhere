import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();

    // Check if already signed in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (AuthService().isSignedIn) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    setState(() { _isLoading = true; _error = null; });
    
    final user = await AuthService().signInWithGoogle();
    
    if (!mounted) return;
    
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _isLoading = false;
        _error = 'Sign in failed. Please try again.';
      });
    }
  }

  void _skipAuth() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1530), AppColors.homeBg, Color(0xFF48426D)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                FadeTransition(
                  opacity: _fadeIn,
                  child: SlideTransition(
                    position: _slideUp,
                    child: Column(children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: const LinearGradient(colors: [AppColors.homeAccent1, AppColors.homeAccent2]),
                          boxShadow: [BoxShadow(color: AppColors.homeAccent1.withOpacity(0.4), blurRadius: 24, offset: const Offset(0, 8))],
                        ),
                        child: const Icon(Icons.edit_note_rounded, size: 48, color: Colors.white),
                      ),
                      const SizedBox(height: 28),
                      const Text('Elsewhere',
                          style: TextStyle(fontSize: 44, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -1.5)),
                      const SizedBox(height: 10),
                      Text('Your stories live here.',
                          style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.55), fontWeight: FontWeight.w400)),
                    ]),
                  ),
                ),
                const Spacer(flex: 3),
                FadeTransition(
                  opacity: _fadeIn,
                  child: Column(children: [
                    if (_error != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.withOpacity(0.4)),
                        ),
                        child: Text(_error!, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // Google Sign In Button
                    GestureDetector(
                      onTap: _isLoading ? null : _signInWithGoogle,
                      child: Container(
                        width: double.infinity,
                        height: 58,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [BoxShadow(color: AppColors.homeAccent1.withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 8))],
                        ),
                        child: _isLoading
                            ? const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.homeBg)))
                            : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                _GoogleIcon(),
                                const SizedBox(width: 12),
                                const Text('Continue with Google',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
                              ]),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Skip button
                    GestureDetector(
                      onTap: _skipAuth,
                      child: Text('Continue without account',
                          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.4), decoration: TextDecoration.underline, decorationColor: Colors.white.withOpacity(0.4))),
                    ),

                    const SizedBox(height: 20),
                    Text('By continuing, you agree to our Terms & Privacy Policy',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.3))),
                  ]),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: Image.network(
        'https://www.google.com/favicon.ico',
        errorBuilder: (_, __, ___) => const Icon(Icons.g_mobiledata, color: Colors.blue, size: 22),
      ),
    );
  }
}
