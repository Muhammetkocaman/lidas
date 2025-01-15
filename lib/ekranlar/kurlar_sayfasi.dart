import 'package:flutter/material.dart';

class KurlarSayfasi extends StatefulWidget {
  const KurlarSayfasi({super.key});

  @override
  State<KurlarSayfasi> createState() => _KurlarSayfasiState();
}

class _KurlarSayfasiState extends State<KurlarSayfasi> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Kurlar Sayfası'),
      ),
    );
  }
} 