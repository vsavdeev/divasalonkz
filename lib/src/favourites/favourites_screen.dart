import 'package:diva_salon_kz/src/services/services_screen.dart';
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
      backgroundColor: Colors.black,
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
                Expanded(child: FavoriteServicesList()),
                TotalPriceSection(totalPrice: totalPrice),
              ],
            ),
    );
  }
}

class FavoriteServicesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavouritesProvider>(context);
    return ListView.builder(
      itemCount: favoritesProvider.favorites.length,
      itemBuilder: (context, index) {
        final service = favoritesProvider.favorites[index];
        return FavoriteServiceCard(option: service);
      },
    );
  }
}

class FavoriteServiceCard extends StatelessWidget {
  final ServiceOption option;

  const FavoriteServiceCard({required this.option, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoritesProvider =
        Provider.of<FavouritesProvider>(context, listen: false);
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(option.name,
            style: const TextStyle(color: Colors.white, fontSize: 18)),
        subtitle: Text('${option.price} ₸',
            style: const TextStyle(color: Colors.grey, fontSize: 16)),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.pink),
          onPressed: () => favoritesProvider.toggleFavorite(option),
        ),
      ),
    );
  }
}

class TotalPriceSection extends StatelessWidget {
  final double totalPrice;

  const TotalPriceSection({required this.totalPrice, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Итого:',
              style: TextStyle(color: Colors.white, fontSize: 20)),
          Text(
            '${totalPrice.toStringAsFixed(2)} ₸',
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
