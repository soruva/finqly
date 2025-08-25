import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:finqly/screens/home_page.dart';
import 'package:finqly/screens/particle_background.dart';
import 'package:finqly/services/subscription_manager.dart';

class SplashScreen extends StatefulWidget {
  final SubscriptionManager subscriptionManager;
  final Locale currentLocale;
  final Function(Locale) onLocaleChanged;
  final Function(bool) onThemeChanged;

  const SplashScreen({
    super.key,
    required this.subscriptionManager,
    required this.currentLocale,
    required this.onLocaleChanged,
    required this.onThemeChanged,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final Animation<double> _rotationAnimation;
  late final Animation<Offset> _textAnimation;
  Timer? _navTimer;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    ));

    _textAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(const AssetImage('assets/images/finqly_logo.png'), context);
    });

    _logoController.forward().then((_) => _textController.forward());

    _navTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted || _navigated) return;
      _navigated = true;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => MyHomePage(
            subscriptionManager: widget.subscriptionManager,
            currentLocale: widget.currentLocale,
            onLocaleChanged: widget.onLocaleChanged,
            onThemeChanged: widget.onThemeChanged,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.black : const Color(0xFF4B0082);
    const textColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          const ParticleBackground(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RotationTransition(
                  turns: _rotationAnimation,
                  child: Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent.withValues(alpha: 0.6),
                        blurRadius: 25,
                        spreadRadius: 5,
                      ),
                    ]),
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          colors: [Colors.purpleAccent, Colors.cyan],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.srcIn,
                      child: Image.asset(
                        'assets/images/finqly_logo.png',
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.width * 0.3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SlideTransition(
                  position: _textAnimation,
                  child: const Text(
                    'Finqly',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      shadows: [
                        Shadow(
                          color: Color(0x6622FFFF),
                          blurRadius: 8,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
