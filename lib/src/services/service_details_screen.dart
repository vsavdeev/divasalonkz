import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../favourites/favourites_provider.dart';
import 'services_screen.dart';

class ServiceDetailPage extends StatefulWidget {
  final ServiceItem item;

  const ServiceDetailPage({super.key, required this.item});

  @override
  _ServiceDetailPageState createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavouritesProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:
            Text(widget.item.text, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildImageCarousel()),
          SliverToBoxAdapter(child: _buildCarouselIndicator()),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 600,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.item.options.map((option) {
                    return _buildServiceItem(context, favoritesProvider,
                        widget.item.options.indexOf(option));
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        viewportFraction: 1.0,
        autoPlay: true,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) => setState(() => _currentIndex = index),
      ),
      items: widget.item.images
          .map((image) => ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCarouselIndicator() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.item.images.length,
          (index) => Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentIndex == index ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceItem(
      BuildContext context, FavouritesProvider provider, int index) {
    final option = widget.item.options[index];
    final isFavorite = provider.isFavorite(option);

    final priceText = option.pricePrefix.isNotEmpty
        ? '${option.pricePrefix} ${option.price.toStringAsFixed(0)}₸'
        : '${option.price.toStringAsFixed(0)}₸';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          color: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            title: Text(option.name,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            subtitle: Text(priceText,
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
            trailing: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.pink : Colors.grey,
              ),
              onPressed: () => provider.toggleFavorite(option),
            ),
          ),
        ),
      ),
    );
  }
}
