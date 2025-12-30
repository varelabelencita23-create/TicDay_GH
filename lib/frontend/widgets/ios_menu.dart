import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ticday/frontend/vistas/perfil_vista.dart';

class IOSDrawer extends StatelessWidget {
  const IOSDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1C1C1E),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Color(0xFF2C2C2E),
                    child: Icon(
                      CupertinoIcons.person_fill,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Hola 👋',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // PERFIL
            _DrawerItem(
              icon: CupertinoIcons.person,
              label: 'Perfil',
              onTap: () {
                Navigator.pop(context); // cerrar drawer

                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => const PerfilVista()),
                );
              },
            ),

            // TEMA
            _DrawerItem(
              icon: CupertinoIcons.paintbrush,
              label: 'Tema',
              onTap: () {
                Navigator.pop(context);
              },
            ),

            const Spacer(),

            // FOOTER
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'TicDay · v1.0',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ===========================================================
   ITEM
   =========================================================== */

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
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: const Icon(
        CupertinoIcons.chevron_right,
        color: Colors.white38,
        size: 18,
      ),
      onTap: onTap,
    );
  }
}
