import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon/controllers/TeamController.dart';
import 'package:pokemon/models/pokemon.dart';

class TeamSelectionPage extends StatelessWidget {
  const TeamSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TeamController>();
    final teamNameController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        elevation: 0,
        title: Row(
          children: [
            Image.network(
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png',
              width: 36,
              height: 36,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.catching_pokemon, color: Colors.white),
            ),
            const SizedBox(width: 8),
            const Text(
              'Pokemon Team Builder',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Reload Pokémon',
            onPressed: () => c.loadPokemons(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            // --- Saved Teams List ---
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "ทีมที่สร้างแล้ว",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 3),
                  Divider(thickness: 2, color: Colors.redAccent),
                ],
              ),
            ),
            SizedBox(
              height: 150,
              child: Obx(() {
                if (c.savedTeams.isEmpty) {
                  return const Center(
                    child: Text(
                      'ยังไม่มีทีม',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: c.savedTeams.length,
                  itemBuilder: (context, index) {
                    final team = c.savedTeams[index];
                    final pokes = (team['pokemons'] as List)
                        .map((e) => PokemonItem.fromJson(Map<String, dynamic>.from(e)))
                        .toList();

                    return GestureDetector(
                      onTap: () => c.editTeam(index),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        color: Colors.white,
                        child: Container(
                          width: 200,
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.catching_pokemon, color: Colors.amber[800], size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    team['name'].toString().toUpperCase(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                alignment: WrapAlignment.center,
                                children: pokes
                                    .map(
                                      (p) => CircleAvatar(
                                        backgroundColor: Colors.yellow[100],
                                        radius: 20,
                                        child: ClipOval(
                                          child: Image.network(
                                            p.imageUrl,
                                            width: 36,
                                            height: 36,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(Icons.catching_pokemon, color: Colors.red),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade400,
                                  minimumSize: const Size(80, 30),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                icon: const Icon(Icons.delete, size: 16),
                                label: const Text('Delete', style: TextStyle(fontSize: 12)),
                                onPressed: () => c.deleteTeam(index),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 8),

            // --- Selected Pokémon Preview ---
            Obx(() {
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.yellow[700],
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
                  boxShadow: [
                    BoxShadow(color: Colors.yellow.shade200, blurRadius: 8, offset: const Offset(0, 2)),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'สมาชิกทีม (${c.selected.length}/${TeamController.maxSelect})',
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        TextButton(
                          onPressed: () => c.selected.clear(),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red.shade300,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('รีเซ็ต', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    c.selected.isEmpty
                        ? const Center(
                            child: Text(
                              'ยังไม่เลือกโปเกมอน',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          )
                        : Center(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 18,
                              runSpacing: 10,
                              children: c.selected
                                  .map(
                                    (p) => Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.red, width: 2),
                                            boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
                                          ),
                                          child: ClipOval(
                                            child: Image.network(
                                              p.imageUrl,
                                              width: 56,
                                              height: 56,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  const Icon(Icons.catching_pokemon, size: 32, color: Colors.red),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          p.name,
                                          style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                  ],
                ),
              );
            }),

            // --- TextField + Save Button ---
            Obx(() {
              if (c.selected.length < TeamController.maxSelect) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: teamNameController,
                        decoration: InputDecoration(
                          labelText: 'สร้างชื่อทีม',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.yellow[100],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => c.saveTeam(teamNameController.text.trim()),
                      icon: const Icon(Icons.save),
                      label: const Text('สร้างทีม'),
                    ),
                  ],
                ),
              );
            }),

            // --- Search Field ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'ค้นหา Pokémon...',
                  prefixIcon: const Icon(Icons.search, color: Colors.red),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.yellow[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onChanged: (value) {
                  final query = value.toLowerCase();
                  c.filteredPokemons.value =
                      c.pokemons.where((p) => p.name.toLowerCase().contains(query)).toList();
                },
              ),
            ),

            // --- Pokémon Grid ---
            Obx(() {
              if (c.filteredPokemons.isEmpty) return const Center(child: CircularProgressIndicator());

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(3),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: c.filteredPokemons.length,
                itemBuilder: (context, index) {
                  final p = c.filteredPokemons[index];

                  return Obx(() {
                    final isSelected = c.selected.contains(p);

                    return GestureDetector(
                      onTap: () => c.toggle(p),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.yellow[200] : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected ? Colors.red : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.red.withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  color: Colors.yellow[50],
                                  child: Center(
                                    child: Image.network(
                                      p.imageUrl,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.broken_image,
                                        size: 40,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              p.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? Colors.red : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
