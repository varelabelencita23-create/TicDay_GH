import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ticday/frontend/vistas/main_layout.dart';
import 'package:ticday/frontend/temas/temas.dart';

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

  double _progress = 0.0;
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _opacity = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scale = Tween(
      begin: 0.88,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    // Barra de carga fake pero pro
    _progressTimer = Timer.periodic(const Duration(milliseconds: 60), (t) {
      setState(() {
        _progress += 0.02;
        if (_progress >= 1) {
          _progress = 1;
          t.cancel();
        }
      });
    });

    Timer(const Duration(milliseconds: 3000), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainLayout(uid: 'demo-user')),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final accent = isDark ? Temas.AcentoColorOscuro : Temas.AcentoColorClaro;

    final fondoBase = isDark ? Temas.FondoOscuro : Temas.FondoClaro;
    final textoColor = isDark ? Temas.TextOscuro : Temas.TextoClaro;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.3),
            radius: 1.2,
            colors: [accent.withOpacity(0.35), fondoBase, fondoBase],
            stops: const [0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),

              FadeTransition(
                opacity: _opacity,
                child: ScaleTransition(
                  scale: _scale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/icon/IconoTDay.png',
                        width: 110,
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'TicDay',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: textoColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LinearProgressIndicator(
                    value: _progress,
                    minHeight: 6,
                    backgroundColor: textoColor.withOpacity(
                      isDark ? 0.15 : 0.12,
                    ),
                    valueColor: AlwaysStoppedAnimation<Color>(accent),
                  ),
                ),
              ),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
