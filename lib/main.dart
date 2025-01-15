import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'ekranlar/giris_ekrani.dart';
import 'ekranlar/kurlar_sayfasi.dart';
import 'ekranlar/detay_ekrani.dart';
import 'ekranlar/favoriler_ekrani.dart';
import 'ekranlar/profil_ekrani.dart';

void main() async {
  // Firebase'i başlat
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firebase'e default locale'i set edelim
  await FirebaseAuth.instance.setLanguageCode('tr');

  runApp(const LidasApp());
}

class LidasApp extends StatelessWidget {
  const LidasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Uygulama ayarları
      title: 'Lidas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      
      // Ana rotalar ve sayfa yönlendirmeleri
      initialRoute: '/anasayfa',
      routes: {
        '/giris': (context) => const GirisEkrani(),
        '/anasayfa': (context) => const AnaSayfa(),
        '/detay': (context) => const DetayEkrani(),
        '/favoriler': (context) => const FavorilerEkrani(),
      },
    );
  }
}

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int _secilenIndeks = 0;
  late final List<Widget> _sayfalar;

  @override
  void initState() {
    super.initState();
    _sayfalar = [
      const KurlarSayfasi(),
      const FavorilerEkrani(),
      ProfilEkrani(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _sayfalar[_secilenIndeks],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _secilenIndeks,
        onTap: (indeks) {
          if (indeks >= 0 && indeks < _sayfalar.length) {
            setState(() {
              _secilenIndeks = indeks;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange),
            label: 'Kurlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favoriler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
