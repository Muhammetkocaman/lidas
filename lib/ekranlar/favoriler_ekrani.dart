import 'package:flutter/material.dart';
import 'package:lidas/servisler/api_servisi.dart';
import 'package:lidas/servisler/firestore_servisi.dart';


class FavorilerEkrani extends StatefulWidget {
  const FavorilerEkrani({super.key});

  @override
  State<FavorilerEkrani> createState() => _FavorilerEkraniState();
}

class _FavorilerEkraniState extends State<FavorilerEkrani> {
  final FirestoreServisi _firestoreServisi = FirestoreServisi();
  final ApiServisi _apiServisi = ApiServisi();
  List<dynamic>? _tumKurlar;

  @override
  void initState() {
    super.initState();
    _kurlariYukle();
  }

  Future<void> _kurlariYukle() async {
    _tumKurlar = await _apiServisi.getKurlar();
    if (mounted) setState(() {});
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
      appBar: AppBar(
        title: const Text('Favoriler'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _kurlariYukle,
        child: StreamBuilder<List<String>>(
          stream: _firestoreServisi.favorileriDinle(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_tumKurlar == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final favoriKurlar = _tumKurlar!.where(
              (kur) => snapshot.data!.contains(kur['asset_id_base'])
            ).toList();

            if (favoriKurlar.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star_border,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Henüz favori coin eklemediniz',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: favoriKurlar.length,
              itemBuilder: (context, index) {
                final kur = favoriKurlar[index];
                return Card(
                  color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4),
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
                    trailing: Text(
                      kur['rate'].toStringAsFixed(2),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

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
}