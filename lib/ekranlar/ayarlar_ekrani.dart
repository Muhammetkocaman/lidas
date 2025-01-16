import 'package:flutter/material.dart';


// TODO: Şifre değiştirme eklenecek
// TODO: E-posta değiştirme eklenecek
// TODO: Bildirim ayarları eklenecek
// TODO: Dil seçeneği eklenecek


class AyarlarEkrani extends StatefulWidget {
  final bool karanlikMod;
  final VoidCallback temaToggle;

  const AyarlarEkrani({
    super.key,
    required this.karanlikMod,
    required this.temaToggle,
  });

  @override
  State<AyarlarEkrani> createState() => _AyarlarEkraniState();
}

class _AyarlarEkraniState extends State<AyarlarEkrani> {
  bool _bildirimAktif = true;

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
          const _AyarBaslik(baslik: 'Uygulama Ayarları'),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Karanlık Mod'),
            trailing: Switch(
              value: widget.karanlikMod,
              onChanged: (value) {
                widget.temaToggle();
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Bildirimler'),
            trailing: Switch(
              value: _bildirimAktif,
              onChanged: (value) {
                setState(() {
                  _bildirimAktif = value;
                });
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
              // TODO: Şifre değiştirme sayfası yapılacak
            },
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('E-posta Değiştir'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: E-posta değiştirme sayfası yapılacak
            },
          ),

          // Diğer Ayarlar
          const _AyarBaslik(baslik: 'Diğer'),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Uygulama Hakkında'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Hakkında sayfası yapılacak
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Çıkış Yap',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Çıkış Yap'),
                  content: const Text('Çıkış yapmak istediğinize emin misiniz?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('İptal'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Çıkış işlemi 
                        Navigator.pushReplacementNamed(context, '/giris');
                      },
                      child: const Text('Çıkış Yap', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
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