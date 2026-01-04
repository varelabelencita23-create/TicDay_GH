import 'package:flutter/material.dart';
import '../temas/temas.dart';

class IOSHeader extends StatelessWidget {
  final String? nombre;
  final String avatar;
  final VoidCallback onAvatarTap;

  const IOSHeader({
    super.key,
    required this.nombre,
    required this.avatar,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool tieneNombre = nombre != null && nombre!.trim().isNotEmpty;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color acento = isDark
        ? Temas.AcentoColorOscuro
        : Temas.AcentoColorClaro;

    final List<Color> gradientColors = isDark
        ? [acento, Colors.black]
        : [acento, Colors.white];

    final String avatarFinal = avatar.trim().isNotEmpty
        ? avatar
        : 'assets/avatars/avatar7.png';

    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(28),
            bottomRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.6 : 0.25),
              blurRadius: 26,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tieneNombre ? 'Hola 👋' : 'Bienvenida 👋',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (tieneNombre)
                    Text(
                      nombre!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.8,
                        shadows: [
                          Shadow(
                            blurRadius: 12,
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // AVATAR
            GestureDetector(
              onTap: onAvatarTap,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 14,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(avatarFinal, fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
