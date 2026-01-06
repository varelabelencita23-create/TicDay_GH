import 'dart:ui';
import 'package:flutter/material.dart';

class IOSHeader extends StatelessWidget {
  final String nombre;
  final String avatar;
  final double collapseFactor;

  const IOSHeader({
    super.key,
    required this.nombre,
    required this.avatar,
    required this.collapseFactor,
  });

  static const List<String> _frases = [
    "La constancia convierte días normales en resultados extraordinarios.",
    "No se trata de ganas, se trata de hábitos.",
    "Cada día suma identidad.",
    "El progreso silencioso siempre gana.",
    "Hoy también cuenta.",
  ];

  String _fraseDelDia() {
    final dia = DateTime.now().day;
    return _frases[(dia - 1) % _frases.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bool expandido = collapseFactor < 0.5;

    final double avatarSize = lerpDouble(56, 40, collapseFactor)!;
    final double titleSize = lerpDouble(34, 22, collapseFactor)!;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        lerpDouble(70, 14, collapseFactor)!,
        20,
        16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.textTheme.bodyLarge?.color,
                    fontSize: titleSize,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.6,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.textTheme.bodyLarge!.color!,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.4 : 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    avatar.isNotEmpty
                        ? 'assets/avatars/$avatar'
                        : 'assets/avatars/avatar7.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Icon(
                        Icons.person,
                        color: theme.textTheme.bodyLarge?.color?.withOpacity(
                          0.4,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),

          if (expandido)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                _fraseDelDia(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.9),
                  fontSize: 15,
                  height: 1.35,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
