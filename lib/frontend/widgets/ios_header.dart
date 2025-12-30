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

    final String avatarFinal = avatar.trim().isNotEmpty
        ? avatar
        : 'assets/avatars/avatar7.png';

    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 26),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Temas.AcentoColorOscuro, Colors.black],
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(28),
            bottomRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 24,
              offset: const Offset(0, 12),
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
                    style: const TextStyle(
                      color: Colors.white70,
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.8,
                      ),
                    ),
                ],
              ),
            ),
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
