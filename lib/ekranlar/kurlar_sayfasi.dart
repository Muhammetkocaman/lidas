import 'package:flutter/material.dart';
import '../servisler/api_servisi.dart';
import '../servisler/firestore_servisi.dart';

// TODO: Arama özelliği eklenecek
// TODO: Sıralama özelliği eklenecek
// TODO: Detay sayfası eklenecek

class KurlarSayfasi extends StatefulWidget {
  const KurlarSayfasi({super.key});

  @override
  State<KurlarSayfasi> createState() => _KurlarSayfasiState();
}

class _KurlarSayfasiState extends State<KurlarSayfasi> {
  final ApiServisi _apiServisi = ApiServisi();
  final FirestoreServisi _firestoreServisi = FirestoreServisi();
  List<Map<String, dynamic>> _kurlar = [];
  final Set<String> _favoriler = {}; // Favori coinlerin ID'lerini tutacak set
  bool _yukleniyor = true;
  String? _hata;

  @override
  void initState() {
    super.initState();
    _kurlariYukle();
  }

  Future<void> _kurlariYukle() async {
    try {
      setState(() {
        _yukleniyor = true;
        _hata = null;
      });

      final kurlar = await _apiServisi.getKurlar();
      
      setState(() {
        _kurlar = List<Map<String, dynamic>>.from(kurlar);
        _yukleniyor = false;
      });
    } catch (e) {
      setState(() {
        _hata = e.toString();
        _yukleniyor = false;
      });
    }
  }

  // Sayı formatlama yardımcı fonksiyonu

  Widget _buildCoinIcon(String coinId) {
    final Map<String, String> coinIcons = {
      'USDT': 'assets/icons/usdt.png',
      'BTC': 'assets/icons/btc.png',
      'ETH': 'assets/icons/eth.png',
      'BNB': 'assets/icons/bnb.png',
      'XRP': 'assets/icons/xrp.png',
      'ADA': 'assets/icons/ada.png',
      'DOGE': 'assets/icons/doge.png',
      'SOL': 'assets/icons/sol.png',
      'DOT': 'assets/icons/dot.png',
      'MATIC': 'assets/icons/matic.png',
    };

    return Image.asset(
      coinIcons[coinId] ?? 'assets/icons/btc.png',
      width: 32,
      height: 32,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.currency_bitcoin, size: 32);
      },
    );
  }

  String _formatTRY(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(2)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(2)}K';
    }
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.grey[100],
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/logo.png', // Logo için
            fit: BoxFit.contain,
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lidas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              'Kripto Para Takip Uygulaması',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Bildirimler sayfasına yönlendirme
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _kurlariYukle,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Çıkış işlemi
            },
          ),
        ],
      ),
      body: _yukleniyor
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _hata != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _hata!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _kurlariYukle,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Tekrar Dene'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _kurlariYukle,
                  child: StreamBuilder<List<String>>(
                    stream: _firestoreServisi.favorileriDinle(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _favoriler.clear();
                        _favoriler.addAll(snapshot.data!);
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _kurlar.length,
                        itemBuilder: (context, index) {
                          final kur = _kurlar[index];
                          final coinId = kur['asset_id_base'];
                          final isFavorite = _favoriler.contains(coinId);

                          return Card(
                            color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                            child: ListTile(
                              leading: _buildCoinIcon(kur['asset_id_base']),
                              title: Text(
                                '${kur['asset_id_base']}/${kur['asset_id_quote']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                '≈ ${_formatTRY(kur['rate_try'])} TL',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    kur['rate'].toStringAsFixed(2),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: Icon(
                                      isFavorite ? Icons.star : Icons.star_border,
                                      color: isFavorite ? Colors.amber : null,
                                    ),
                                    onPressed: () async {
                                      try {
                                        await _firestoreServisi.favoriGuncelle(coinId, !isFavorite);
                                        setState(() {}); // UI'ı yenile
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Hata: $e')),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/detay',
                                  arguments: kur,
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
    );
    
  }



}
 
