import 'package:flutter/material.dart';

class InicioVista extends StatelessWidget {
  const InicioVista({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'InicioVista funcionando',
          style: TextStyle(
            fontSize: 28,
            color: Colors.deepPurpleAccent,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
