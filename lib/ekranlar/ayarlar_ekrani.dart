import 'package:flutter/material.dart';

class AyarlarEkrani extends StatelessWidget {
  const AyarlarEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // Uygulama Ayarları Grubu
          const _AyarBaslik(baslik: 'Uygulama Ayarları'),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Karanlık Mod'),
            trailing: Switch(
              value: false, // TODO: Tema durumuna göre değişecek
              onChanged: (value) {
                // TODO: Tema değiştirme işlemi
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Bildirimler'),
            trailing: Switch(
              value: true, // TODO: Bildirim durumuna göre değişecek
              onChanged: (value) {
                // TODO: Bildirim ayarları
              },
            ),
          ),

          // Hesap Ayarları Grubu
          const _AyarBaslik(baslik: 'Hesap Ayarları'),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Şifre Değiştir'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Şifre değiştirme sayfasına yönlendir
            },
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('E-posta Değiştir'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: E-posta değiştirme sayfasına yönlendir
            },
          ),

          // Güvenlik Ayarları
          const _AyarBaslik(baslik: 'Güvenlik'),
          ListTile(
            leading: const Icon(Icons.fingerprint),
            title: const Text('Biyometrik Kilit'),
            trailing: Switch(
              value: false, // TODO: Biyometrik durum kontrolü
              onChanged: (value) {
                // TODO: Biyometrik kilit ayarı
              },
            ),
          ),

          // Diğer Ayarlar
          const _AyarBaslik(baslik: 'Diğer'),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Uygulama Hakkında'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Hakkında sayfasına yönlendir
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Çıkış Yap',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              // TODO: Çıkış yapma işlemi
            },
          ),
        ],
      ),
    );
  }
}

// Ayar başlıkları için özel widget
class _AyarBaslik extends StatelessWidget {
  final String baslik;

  const _AyarBaslik({required this.baslik});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        baslik,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
} 