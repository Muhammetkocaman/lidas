import 'package:flutter/material.dart';
import '../servisler/api_servisi.dart';

class KurlarSayfasi extends StatefulWidget {
  const KurlarSayfasi({super.key});

  @override
  State<KurlarSayfasi> createState() => _KurlarSayfasiState();
}

class _KurlarSayfasiState extends State<KurlarSayfasi> {
  final ApiServisi _apiServisi = ApiServisi();
  List<dynamic> _kurlar = [];
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
        _kurlar = kurlar;
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
  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(2)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(2)}K';
    } else {
      return number.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              'Kripto Takip',
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
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _kurlar.length,
                    itemBuilder: (context, index) {
                      final kur = _kurlar[index];
                      final double rate = kur['rate']?.toDouble() ?? 0.0;
                      
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/icons/${kur['asset_id_base'].toString().toLowerCase()}.png',
                                width: 32,
                                height: 32,
                              ),
                            ),
                          ),
                          title: Text(
                            '${kur['asset_id_base']} / ${kur['asset_id_quote']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Son Güncelleme: ${DateTime.tryParse(kur['time'] ?? '')?.toLocal() ?? 'Bilinmiyor'}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          trailing: Text(
                            rate > 0 ? _formatNumber(rate) : '0',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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
                  ),
                ),
    );
  }
} 