import 'package:get/get_connect/connect.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:pokemon/models/pokemon.dart';

class ApiService extends GetConnect {
  @override
  void onInit() {
    httpClient.timeout = const Duration(seconds: 15);
    super.onInit();
  }

  Future<List<PokemonItem>> fetchPokemons({int limit = 20}) async {
    final res = await get('https://pokeapi.co/api/v2/pokemon?limit=$limit');
    if (res.statusCode == HttpStatus.ok && res.body?['results'] is List) {
      final List results = res.body['results'];

      // สร้าง list ของ Pokémon โดยไม่เอา type
      final pokemons = results.map((p) {
        final name = p['name'].toString();
        final url = p['url'].toString();
        final id = _extractIdFromUrl(url);
        final imageUrl =
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

        return PokemonItem(
          id: id,
          name: name,
          imageUrl: imageUrl,
        );
      }).toList();

      return pokemons;
    }
    return [];
  }

  int _extractIdFromUrl(String url) {
    final parts = url.split('/')..removeWhere((e) => e.isEmpty);
    return int.parse(parts.last);
  }
}
