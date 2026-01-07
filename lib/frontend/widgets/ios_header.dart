import 'package:flutter/material.dart';

class IOSHeader extends StatelessWidget {
  final String nombre;
  final String avatar;
  final VoidCallback onMenuTap;
  final VoidCallback onAvatarTap;

  const IOSHeader({
    super.key,
    required this.nombre,
    required this.avatar,
    required this.onMenuTap,
    required this.onAvatarTap,
  });

  static const List<String> _frasesDiarias = [
    "Organizá tu día y ganale al caos",
    "Un paso hoy, progreso mañana",
    "Constancia > motivación",
    "Hacé foco, lo demás espera",
    "Hoy también cuenta",
    "Menos excusas, más acción",
    "Avanzá aunque sea lento",
    "Disciplina primero, resultados después",
    "Lo simple bien hecho gana",
    "Un día ordenado = mente clara",
    "Construí tu mejor versión",
    "El progreso es acumulativo",
    "Hoy entrenás el hábito",
    "Hacé que valga",
    "No pares ahora",
    "Pequeñas victorias suman",
    "Elegí avanzar",
    "Enfocada > ocupada",
    "Paso firme, cabeza clara",
    "Un día más fuerte",
    "Que el día te siga a vos",
    "Rutina que libera",
    "Hoy también se construye",
    "Todo suma",
    "Constancia silenciosa",
    "Modo foco activado",
    "Menos ruido, más intención",
    "Seguimos",
    "Hoy se progresa",
    "No aflojes",
    "Día productivo desbloqueado",
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final saludo = nombre.trim().isEmpty ? "Hola! 👋" : "Hola $nombre! 👋";

    final dia = DateTime.now().day;
    final frase = _frasesDiarias[(dia - 1) % _frasesDiarias.length];

    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F0F0F) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.45)
                  : Colors.black.withOpacity(0.06),
              blurRadius: isDark ? 22 : 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // MENU
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: onMenuTap,
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
                  Icons.menu_open_rounded,
                  size: 24,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),

            const SizedBox(width: 14),

            // TEXTOS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    saludo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    frase,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? Colors.white.withOpacity(0.6)
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 14),

            InkWell(
              onTap: onAvatarTap,
              borderRadius: BorderRadius.circular(30),
              child: _AvatarCircle(avatar: avatar, isDark: isDark),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  final String avatar;
  final bool isDark;

  const _AvatarCircle({required this.avatar, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.22) : Colors.grey.shade200,
          width: 2,
        ),
      ),
      child: ClipOval(child: _buildAvatar()),
    );
  }

  Widget _buildAvatar() {
    if (avatar.trim().isEmpty) {
      return _fallback();
    }

    if (avatar.startsWith('http')) {
      return Image.network(
        avatar,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }

    return Image.asset(
      'assets/avatars/$avatar',
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallback(),
    );
  }

  Widget _fallback() {
    return Container(
      color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
      child: Icon(
        Icons.person_rounded,
        size: 26,
        color: isDark ? Colors.white70 : Colors.white,
      ),
    );
  }
}
