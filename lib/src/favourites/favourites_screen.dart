import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'favourites_provider.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavouritesProvider>(context);
    final totalPrice = favoritesProvider.favorites
        .fold<double>(0, (sum, service) => sum + service.price);

    return Scaffold(
      backgroundColor: Colors.black, // Черный фон
      appBar: AppBar(
        title: const Text('Избранное', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: favoritesProvider.favorites.isEmpty
          ? const Center(
              child: Text(
                'Нет избранных услуг',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: favoritesProvider.favorites.length,
                    itemBuilder: (context, index) {
                      final service = favoritesProvider.favorites[index];

                      return Card(
                        color: Colors.grey[900], // Темно-серый фон карточек
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(
                            service.name,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                          subtitle: Text(
                            '${service.price} ₽',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 16),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.pink),
                            onPressed: () {
                              favoritesProvider.toggleFavorite(service);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Итого:',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Text(
                        '${totalPrice.toStringAsFixed(2)} ₽',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
