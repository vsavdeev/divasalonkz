import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/indicator.dart';

const _icons = [
  "assets/images/logo_diva_white.png",
  "assets/images/barber.png",
  "assets/images/nails.png",
  "assets/images/cosmetics.png",
];

const _backgroundImages = [
  "assets/images/page0.png",
  "assets/images/page1.png",
  "assets/images/page2.png",
  "assets/images/page3.png",
];

const _whatsappUrl = 'https://wa.me/77015203600';
const _gisUrl = 'https://go.2gis.com/4bsfa';
const _instagramUrl = 'https://www.instagram.com/divasalonkz/';
const _phoneUrl = 'tel:+77015203600';

class HomePage extends StatelessWidget {
  final PageController _controller = PageController(initialPage: 0);
  final List<Widget> _pages = [
    for (int i = 0; i < _icons.length; i++)
      ServicePage(
        icon: _icons[i],
        title: _getTitle(i),
        subtitle: "Любые виды услуг",
        backgroundImage: _backgroundImages[i],
        buttonTitle: _getButtonTitle(i),
        url: _whatsappUrl,
      ),
    ContactsPage()
  ];

  static String _getTitle(int index) {
    return [
      "Салон красоты",
      "Женские, мужские и детские стрижки!",
      "Маникюр, педикюр и др.",
      "Ваша красота - ваше здоровье"
    ][index];
  }

  static String _getButtonTitle(int index) {
    return [
      "Записаться",
      "Записаться на стрижку",
      "Записаться на маникюр",
      "Записаться к косметологу"
    ][index];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _controller,
          scrollDirection: Axis.vertical,
          itemCount: _pages.length,
          itemBuilder: (context, index) => _pages[index],
        ),
        Positioned(
          right: 0.0,
          top: 0.0,
          bottom: 0.0,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: DotsIndicator(
                controller: _controller,
                itemCount: _pages.length,
                onPageSelected: (int page) {
                  _controller.animateToPage(
                    page,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ContactsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildPage(
      "assets/images/page4.png",
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/contacts.png", width: 150, height: 150),
          _buildText("Наши контакты", 30, FontWeight.bold),
          _buildText("г. Астана, проспект Женис, д. 49", 20, FontWeight.normal),
          _buildButton(
              "Показать на карте", Colors.pink, () => _launchURL(_gisUrl)),
          _buildButtonWithIcon("+77015203600", Icons.phone, Colors.green,
              () => _launchURL(_phoneUrl)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconButton(FontAwesomeIcons.instagram, _instagramUrl),
              _buildIconButton(FontAwesomeIcons.whatsapp, _whatsappUrl),
            ],
          ),
        ],
      ),
    );
  }
}

class ServicePage extends StatelessWidget {
  final String icon, title, subtitle, backgroundImage, buttonTitle, url;

  const ServicePage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.backgroundImage,
    required this.buttonTitle,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return _buildPage(
      backgroundImage,
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(icon, width: 150, height: 150, fit: BoxFit.contain),
          _buildText(title, 30, FontWeight.bold),
          _buildText(subtitle, 20, FontWeight.normal),
          _buildButton(buttonTitle, Colors.pink, () => _launchURL(url)),
        ],
      ),
    );
  }
}

Widget _buildPage(String backgroundImage, Widget child) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(backgroundImage),
        fit: BoxFit.cover,
      ),
    ),
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black, Colors.transparent],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    ),
  );
}

Widget _buildText(String text, double fontSize, FontWeight fontWeight) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.white, fontSize: fontSize, fontWeight: fontWeight),
    ),
  );
}

Widget _buildButton(String text, Color color, VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    child: Text(text, style: TextStyle(color: Colors.white)),
  );
}

Widget _buildButtonWithIcon(
    String text, IconData icon, Color color, VoidCallback onPressed) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(backgroundColor: color),
    icon: Icon(icon, color: Colors.white, size: 24),
    label: Text(text, style: TextStyle(color: Colors.white)),
  );
}

Widget _buildIconButton(IconData icon, String url) {
  return IconButton(
    onPressed: () => _launchURL(url),
    icon: Icon(icon, color: Colors.white, size: 50),
    iconSize: 50,
  );
}

Future<void> _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}
