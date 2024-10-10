import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../home/home.dart';
import 'package:perpustakaan/themes.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  _ScreenSplashState createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CarouselSlider(
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3), // Interval auto play
          enlargeCenterPage: true,
        ),
        items: [
          splashPage('Welcome to E-Library App'),
          splashPage('Have Fun!'),
          splashPage('Tap to Get Started!'),
        ],
      ),
    );
  }

  Widget splashPage(String text) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Jika text adalah 'Tap to Get Started!'
            if (text == 'Tap to Get Started!')
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
                },
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 15,
                    color: iconPertama,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
