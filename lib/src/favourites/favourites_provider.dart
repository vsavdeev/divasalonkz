import 'package:diva_salon_kz/src/services/services_screen.dart';
import 'package:flutter/material.dart';

class FavouritesProvider with ChangeNotifier {
  final List<ServiceOption> _favorites = [];

  List<ServiceOption> get favorites => _favorites;

  void toggleFavorite(ServiceOption option) {
    if (_favorites.contains(option)) {
      _favorites.remove(option);
    } else {
      _favorites.add(option);
    }
    notifyListeners();
  }

  bool isFavorite(ServiceOption option) {
    return _favorites.contains(option);
  }
}
