import 'package:flutter/material.dart';
import '../temas/temas.dart';

class IOSHeader extends StatelessWidget {
  final String nombre;
  final String avatar;
  final VoidCallback onMenuTap;

  const IOSHeader({
    super.key,
    required this.nombre,
    required this.avatar,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
        decoration: BoxDecoration(
          color: isDark ? Temas.FondoOscuro : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.22 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // BOTÓN MENÚ PRO
            _MenuButton(isDark: isDark, onTap: onMenuTap),

            const SizedBox(width: 14),

            // TEXTO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _fraseMotivadora(),
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                      color: isDark
                          ? Temas.TextOscuro.withOpacity(0.7)
                          : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    nombre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Temas.TextOscuro : Temas.TextoClaro,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 14),

            // AVATAR
            _Avatar(avatar: avatar, isDark: isDark),
          ],
        ),
      ),
    );
  }

  String _fraseMotivadora() {
    final frases = [
      "Buen laburo, seguir apareciendo ya es ganar",
      "Otro día cumpliendo, así se construye",
      "Paso a paso, pero siempre para adelante",
      "Lo estás haciendo mejor de lo que creés",
      "Esto no es suerte, es constancia",
      "Sumaste otro día, eso cuenta",
      "No cualquiera sostiene este ritmo",
      "Estás en modo progreso, seguí así",
      "Cada check suma, no aflojes",
      "Hoy también elegiste avanzar",
      "Disciplina silenciosa, resultados reales",
      "Esto se está armando bien",
      "No perfecto, pero constante",
      "Seguís firme, eso habla de vos",
      "Lo difícil ya lo estás haciendo",
      "Otro ladrillo más al futuro",
      "Estás cumpliendo, disfrutalo",
      "No cualquiera llega hasta acá",
      "Modo enfoque activado",
      "Hoy también sumaste",
      "Esto es compromiso real",
      "Constancia > motivación",
      "Estás jugando a largo plazo",
      "Buen ritmo, buena cabeza",
      "El progreso se nota",
      "Seguí así, vas bien",
      "No pares ahora",
      "Otro día ganado",
      "Esto es construir hábitos",
      "Lo estás logrando",
      "Seguir es la clave",
    ];

    final dia = DateTime.now().day;
    return frases[(dia - 1) % frases.length];
  }
}

class _Avatar extends StatelessWidget {
  final String avatar;
  final bool isDark;

  const _Avatar({required this.avatar, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.25) : Colors.grey.shade200,
          width: 2,
        ),
      ),
      child: ClipOval(
        child: avatar.isNotEmpty
            ? Image.asset('assets/avatars/$avatar', fit: BoxFit.cover)
            : _fallback(),
      ),
    );
  }

  Widget _fallback() {
    return Container(
      color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
      child: Icon(
        Icons.person_rounded,
        color: isDark ? Colors.white70 : Colors.white,
        size: 26,
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;

  const _MenuButton({required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : Colors.black.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          Icons.dashboard_rounded,
          size: 22,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}
