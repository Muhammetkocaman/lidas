import 'package:flutter/material.dart';
import 'package:lidas/ekranlar/ayarlar_ekrani.dart';

class ProfilEkrani extends StatelessWidget {
  const ProfilEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: ListView(
          children: [
            // Üst kısım - Profil başlığı
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.purple[200],
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Merhaba Sherman',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications_outlined),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            
            // Menü öğeleri
            _menuOgesi('Gönder & Al', Icons.swap_horiz, Colors.blue[200]),
            _menuOgesi('Portföyüm', Icons.grid_view, Colors.blue[200]),
            _menuOgesi('Piyasa görünümü', Icons.insights, Colors.grey[400]),
            _menuOgesi('Ayarlar', Icons.settings, Colors.grey[400],
                onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AyarlarEkrani(),
                ),
              );
            }),
            _menuOgesi('Yedekleme & Güvenlik', Icons.security, Colors.grey[400]),
            _menuOgesi('Bize ulaşın', Icons.message, Colors.grey[400]),
            
            // Alt bilgi
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Şartlar & Gizlilik',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'v0.0.1 beta',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _menuOgesi(String baslik, IconData ikon, Color? renk, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        elevation: 0,
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: renk,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(ikon, color: Colors.white),
          ),
          title: Text(baslik),
          trailing: Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
} 