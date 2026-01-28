import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screens/main_screen.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // تهيئة Firebase باستخدام الإعدادات المولّدة من FlutterFire CLI
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // في حال فشل التهيئة، نطبع الخطأ لكن لا نمنع تشغيل التطبيق
    // حتى لا ينكسر التطبيق الحالي إذا كانت إعدادات Firebase غير مكتملة بعد.
    debugPrint('❌ Firebase initialization failed: $e');
  }
  runApp(const SahmApp());
}

class SahmApp extends StatelessWidget {
  const SahmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'DIN Next Arabic', // خط DIN Next Arabic لجميع النصوص
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(AppConstants.primaryColorValue),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          shadowColor: Colors.black.withOpacity(0.1),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadowColor: Colors.black.withOpacity(0.1),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: const Color(AppConstants.primaryColorValue),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            shadowColor: Colors.black.withOpacity(0.2),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _logoPulseAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    // أنيميشن دوران سلس للشعار
    _logoRotationAnimation = Tween<double>(begin: -0.2, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    // أنيميشن نبض متقدم للشعار
    _logoPulseAnimation =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 1.0,
              end: 1.2,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 0.25,
          ),
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 1.2,
              end: 0.95,
            ).chain(CurveTween(curve: Curves.easeIn)),
            weight: 0.15,
          ),
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 0.95,
              end: 1.0,
            ).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 0.2,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: 1.0, end: 1.0),
            weight: 0.4,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
          ),
        );

    // أنيميشن توهج متحرك
    _glowAnimation =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 0.3,
              end: 0.8,
            ).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 0.5,
          ),
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 0.8,
              end: 0.4,
            ).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 0.5,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
          ),
        );

    // أنيميشن بريق (shimmer)
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.9, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    // بعد انتهاء أنيميشن الـ Splash نذهب دائماً إلى شاشة تسجيل الدخول حالياً.
    // لاحقاً يمكننا إعادة تفعيل التحقق من AuthService.isLoggedIn.
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(AppConstants.primaryColorValue),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(AppConstants.primaryColorValue),
              const Color(AppConstants.primaryColorValue).withOpacity(0.8),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // الشعار مع أنيميشن احترافي متقدم
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // تأثير التوهج الخارجي المتحرك
                      Transform.scale(
                        scale: _scaleAnimation.value * 1.3,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(
                                  _glowAnimation.value * 0.6,
                                ),
                                blurRadius: 40,
                                spreadRadius: 15,
                              ),
                              BoxShadow(
                                color: const Color(
                                  AppConstants.primaryColorValue,
                                ).withOpacity(_glowAnimation.value * 0.4),
                                blurRadius: 60,
                                spreadRadius: 10,
                              ),
                              BoxShadow(
                                color: Colors.cyan.withOpacity(
                                  _glowAnimation.value * 0.3,
                                ),
                                blurRadius: 80,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // الشعار الرئيسي
                      Transform.scale(
                        scale:
                            _scaleAnimation.value * _logoPulseAnimation.value,
                        child: Transform.rotate(
                          angle: _logoRotationAnimation.value,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.1),
                                    Colors.transparent,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(
                                      _glowAnimation.value * 0.4,
                                    ),
                                    blurRadius: 25,
                                    spreadRadius: 8,
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  // الشعار
                                  Image.asset(
                                    'assets/icon/logo.png',
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.build_circle,
                                        size: 100,
                                        color: Colors.white,
                                      );
                                    },
                                  ),
                                  // تأثير البريق (Shimmer)
                                  if (_shimmerAnimation.value > -0.5 &&
                                      _shimmerAnimation.value < 1.5)
                                    Positioned.fill(
                                      child: ClipOval(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment(
                                                _shimmerAnimation.value - 1,
                                                0,
                                              ),
                                              end: Alignment(
                                                _shimmerAnimation.value,
                                                0,
                                              ),
                                              colors: [
                                                Colors.transparent,
                                                Colors.white.withOpacity(0.3),
                                                Colors.transparent,
                                              ],
                                              stops: const [0.0, 0.5, 1.0],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),
              FadeTransition(
                opacity: _fadeAnimation,
                child: const Text(
                  AppConstants.appName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  AppConstants.appTagline,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              FadeTransition(
                opacity: _fadeAnimation,
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
