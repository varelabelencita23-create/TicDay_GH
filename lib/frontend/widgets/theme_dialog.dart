import 'package:flutter/material.dart';
import '../../backend/estado/tema_estado.dart';

void showThemeDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Elegir tema",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text("Modo claro"),
              onTap: () {
                temaNotifier.value = ThemeMode.light;
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text("Modo oscuro"),
              onTap: () {
                temaNotifier.value = ThemeMode.dark;
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings_suggest),
              title: const Text("Según sistema"),
              onTap: () {
                temaNotifier.value = ThemeMode.system;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
