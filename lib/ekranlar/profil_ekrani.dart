import 'package:flutter/material.dart';


  // TODO: Kullanıcı bilgileri yönetimi eklenecek
  // TODO: Portföy yönetimi eklenecek
  // TODO: Bildirim yönetimi eklenecek



class ProfilEkrani extends StatelessWidget {
  const ProfilEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.grey[100],
      body: SafeArea(
        child: ListView(
          children: [
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
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.notifications_outlined,
                      color: isDark ? Colors.white : Colors.black,
                    ),
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
              Navigator.pushNamed(
                context,
                '/ayarlar',
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
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey,
                    ),
                  ),
                  Text(
                    'v0.0.1',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey,
                    ),
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
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Card(
            elevation: 0,
            color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: renk,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(ikon, color: Colors.white),
              ),
              title: Text(
                baslik,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: isDark ? Colors.white : Colors.black,
              ),
              onTap: onTap,
            ),
          ),
        );
      },
    );
  }
} 

