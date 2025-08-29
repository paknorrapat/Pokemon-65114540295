import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/services/api_service.dart';

class TeamController extends GetxController {
  final storage = GetStorage();
  static const _storageKey = 'teams';
  static const maxSelect = 3;

  var pokemons = <PokemonItem>[].obs;
  var filteredPokemons = <PokemonItem>[].obs;
  var selected = <PokemonItem>[].obs;
  var savedTeams = <Map<String, dynamic>>[].obs;
  var editingTeamIndex = RxnInt();

  @override
  void onInit() {
    super.onInit();
    loadTeamsFromStorage();
    loadPokemons();
  }

  Future<void> loadPokemons() async {
    final data = await ApiService().fetchPokemons();
    pokemons.assignAll(data);
    filteredPokemons.assignAll(data);
  }

  void toggle(PokemonItem p) {
    if (selected.contains(p)) {
      selected.remove(p);
    } else {
      if (selected.length < maxSelect) {
        selected.add(p);
      } else {
        Get.snackbar('Limit', 'เลือกได้สูงสุด $maxSelect ตัว');
      }
    }
  }

  void saveTeam(String teamName) {
    if (teamName.isEmpty || selected.isEmpty) {
      Get.snackbar('Error', 'กรอกชื่อทีมและเลือก Pokémon อย่างน้อย 1 ตัว');
      return;
    }

    final teamData = {
      'name': teamName,
      'pokemons': selected.map((p) => p.toJson()).toList(),
    };

    if (editingTeamIndex.value != null) {
      savedTeams[editingTeamIndex.value!] = teamData;
      editingTeamIndex.value = null;
    } else {
      savedTeams.add(teamData);
    }

    storage.write(_storageKey, savedTeams);
    Get.snackbar('Team Saved', 'ทีม "$teamName" ถูกบันทึกแล้ว');
    selected.clear();
  }

  void loadTeamsFromStorage() {
    final data = storage.read<List>(_storageKey);
    if (data != null) {
      savedTeams.assignAll(data.cast<Map<String, dynamic>>());
    }
  }

  void editTeam(int index) {
    final team = savedTeams[index];
    editingTeamIndex.value = index;
    selected.assignAll(
      (team['pokemons'] as List)
          .map((e) => PokemonItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  void deleteTeam(int index) {
    savedTeams.removeAt(index);
    storage.write(_storageKey, savedTeams);
    if (editingTeamIndex.value == index) {
      editingTeamIndex.value = null;
      selected.clear();
    }
    Get.snackbar('Deleted', 'ลบทีมเรียบร้อยแล้ว');
  }

 
}
