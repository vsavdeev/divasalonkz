import 'package:flutter/material.dart';
import 'dart:ui';

import 'service_details_screen.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _buildServiceList(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildServiceList(BuildContext context) {
    List<Widget> widgets = [];
    for (int i = 0; i < servicesData.length; i += 2) {
      if (i + 1 < servicesData.length) {
        widgets.add(_buildRow(context, servicesData[i], servicesData[i + 1]));
      } else {
        widgets.add(ServiceCard(item: servicesData[i]));
      }
      widgets.add(const SizedBox(height: 10));
    }
    return widgets;
  }

  Widget _buildRow(BuildContext context, ServiceItem left, ServiceItem right) {
    return Row(
      children: [
        Expanded(child: ServiceCard(item: left)),
        const SizedBox(width: 10),
        Expanded(child: ServiceCard(item: right)),
      ],
    );
  }
}

class ServiceCard extends StatelessWidget {
  final ServiceItem item;

  const ServiceCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetailPage(item: item),
          ),
        );
      },
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(item.image),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                item.text,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ServiceItem {
  final String image;
  final String text;
  final List<String> images;
  final List<ServiceOption> options;

  ServiceItem({
    required this.image,
    required this.text,
    required this.images,
    required this.options,
  });
}

class ServiceOption {
  final String name;
  final double price;
  final String pricePrefix; // Новое поле для префикса

  ServiceOption({
    required this.name,
    required this.price,
    this.pricePrefix = '', // Значение по умолчанию
  });
}

// Список данных
final List<ServiceItem> servicesData = [
  ServiceItem(
    image: 'assets/images/man.png',
    text: "Мужской зал",
    images: [
      'assets/images/man1.png',
      'assets/images/man2.png',
      'assets/images/man3.png',
    ],
    options: [
      ServiceOption(name: "Стрижка \"Наголо\"", price: 1000),
      ServiceOption(name: "Стрижка", price: 3200),
      ServiceOption(name: "Укладка", price: 1300),
      ServiceOption(name: "Коррекция бороды, усов, бровей", price: 1000),
      ServiceOption(name: "Коррекция бороды под насадку", price: 300),
      ServiceOption(name: "Коррекция бороды с контуром", price: 800),
      ServiceOption(name: "Оконтовка", price: 2500),
      ServiceOption(name: "Окрашивание волос", price: 3400),
      ServiceOption(name: "Мытье головы/Сушка волос", price: 700),
      ServiceOption(name: "Стрижка под одну насадку", price: 2200),
      ServiceOption(name: "Стрижка \"Детская\" до 9 лет", price: 1800),
      ServiceOption(name: "Стрижка \"Детская\" с 10 до 15 лет", price: 2000),
      ServiceOption(
          name: "Стрижка \"Детская\" с 16 лет, взрослая", price: 3200),
    ],
  ),
  ServiceItem(
    image: 'assets/images/woman.png',
    text: "Женский зал",
    images: [
      'assets/images/woman1.png',
      'assets/images/woman2.png',
      'assets/images/woman3.png',
    ],
    options: [
      ServiceOption(name: "Стрижка", pricePrefix: "от", price: 4000),
      ServiceOption(name: "Стрижка челки", price: 1000),
    ],
  ),
  ServiceItem(
    image: 'assets/images/cosmetology.png',
    text: "Косметология",
    images: [
      'assets/images/cosmetology1.png',
      'assets/images/cosmetology2.png',
    ],
    options: [
      ServiceOption(name: "Чистка лица", price: 2500),
      ServiceOption(name: "Массаж лица", price: 1800),
    ],
  ),
  ServiceItem(
    image: 'assets/images/manicure.png',
    text: "Маникюр/Педикюр",
    images: [
      'assets/images/manicure1.png',
      'assets/images/manicure2.png',
    ],
    options: [
      ServiceOption(name: "Маникюр с покрытием", price: 1800),
      ServiceOption(name: "Педикюр классический", price: 2300),
    ],
  ),
  ServiceItem(
    image: 'assets/images/epilation.png',
    text: "Шугаринг",
    images: [
      'assets/images/epilation1.png',
      'assets/images/epilation2.png',
    ],
    options: [
      ServiceOption(name: "Шугаринг ног", price: 2000),
      ServiceOption(name: "Шугаринг зоны бикини", price: 2500),
    ],
  ),
];
