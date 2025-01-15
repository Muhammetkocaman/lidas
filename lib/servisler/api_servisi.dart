import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServisi {
  // API endpoint ve key tanımlamaları
  static const String _baseUrl = 'https://rest.coinapi.io/v1';
  static const String _apiKey = '64402a73-abb2-4943-9c97-bea832956b48';

  // Tüm kurları getir
  Future<List<dynamic>> getKurlar() async {
    // Desteklenen kur çiftleri
    final List<Map<String, String>> kurCiftleri = [
      {'base': 'USDT', 'quote': 'TRY'},
      {'base': 'BTC', 'quote': 'USDT'},
      {'base': 'ETH', 'quote': 'USDT'},
      {'base': 'BTC', 'quote': 'TRY'},
      {'base': 'ETH', 'quote': 'TRY'},
    ];
    
    List<dynamic> sonuclar = [];

    try {
      // Her kur çifti için API çağrısı
      for (var kurCifti in kurCiftleri) {
        final response = await http.get(
          Uri.parse('$_baseUrl/exchangerate/${kurCifti['base']}/${kurCifti['quote']}'),
          headers: {'X-CoinAPI-Key': _apiKey},
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          sonuclar.add({
            'asset_id_base': kurCifti['base'],
            'asset_id_quote': kurCifti['quote'],
            'rate': data['rate'] ?? 0,
            'time': data['time'],
          });
        }
      }
      return sonuclar;
    } catch (e) {
      // Hata yönetimi
      throw Exception('Kurlar yüklenirken hata oluştu: $e');
    }
  }

  // Belirli bir kur çifti için detay
  Future<Map<String, dynamic>> getKurDetay(String baseKur, String hedefKur) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/exchangerate/$baseKur/$hedefKur'),
      headers: {'X-CoinAPI-Key': _apiKey},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Kur detayı yüklenirken hata oluştu: ${response.statusCode}');
    }
  }

  // Geçmiş kur verileri
  Future<List<dynamic>> getKurGecmis(String baseKur, String hedefKur) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/exchangerate/$baseKur/$hedefKur/history?period_id=1DAY&limit=30'),
      headers: {'X-CoinAPI-Key': _apiKey},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Geçmiş veriler yüklenirken hata oluştu: ${response.statusCode}');
    }
  }
} 