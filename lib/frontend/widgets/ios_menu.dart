import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticday/frontend/vistas/perfil_vista.dart';
import 'package:ticday/frontend/widgets/theme_dialog.dart';

class IOSDrawer extends StatelessWidget {
  final String uid;

  const IOSDrawer({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: theme.cardColor,
                    child: Icon(
                      CupertinoIcons.person_fill,
                      color: theme.textTheme.bodyLarge?.color,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hola!',
                        style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(
                            0.7,
                          ),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Bienvenido a TicDay',
                        style: TextStyle(
                          color: theme.textTheme.bodyLarge?.color,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// PERFIL
            _DrawerItem(
              icon: CupertinoIcons.person,
              label: 'Perfil',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => PerfilVista(uid: uid)),
                );
              },
            ),

            /// TEMA
            _DrawerItem(
              icon: CupertinoIcons.paintbrush,
              label: 'Tema',
              onTap: () {
                Navigator.pop(context);

                Future.delayed(Duration.zero, () {
                  showThemeDialog(
                    Navigator.of(context, rootNavigator: true).context,
                  );
                });
              },
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'TicDay · 2025',
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.4),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: theme.textTheme.bodyLarge?.color, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: theme.textTheme.bodyLarge?.color,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.4),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
