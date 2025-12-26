import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ticday/frontend/vistas/main_layout.dart';

class SplashVista extends StatefulWidget {
  const SplashVista({super.key});

  @override
  State<SplashVista> createState() => _SplashVistaState();
}

class _SplashVistaState extends State<SplashVista>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scale = Tween<double>(
      begin: 0.85,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    // ⏱ duración total del splash
    Timer(const Duration(milliseconds: 3000), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const MainLayout()));
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.0, -0.1),
            radius: 1.1,
            colors: [
              Color(0xFF4E02FF), // violeta acento (centro)
              Color(0xFF1A1A1A), // gris oscuro
              Color(0xFF0B0B0B), // negro profundo (bordes)
            ],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _opacity,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/icon/IconoTDay.png', width: 120),
                  const SizedBox(height: 24),
                  const Text(
                    'TicDay',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
