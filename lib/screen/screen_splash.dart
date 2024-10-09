import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ScreenSplash extends StatelessWidget {
  const ScreenSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CarouselSlider(
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height,
          autoPlay: true,
          viewportFraction: 1.0,
        ),
        items: [
          SplashPage(
            title: 'Welcome Screen',
            description: 'Welcome to the E-Library App!',
          ),
          SplashPage(
            title: 'Explore Books',
            description: 'Discover thousands of books in our library!',
          ),
          SplashPage(
            title: 'Read Anywhere',
            description: 'Read books online or offline!',
          ),
        ],
      ),
    );
  }
}

class SplashPage extends StatelessWidget {
  final String title;
  final String description;

  const SplashPage({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: const BoxDecoration(color: Colors.black),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Ubah warna teks agar kontras dengan background hitam
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white, // Warna teks putih agar terlihat jelas
            ),
            textAlign: TextAlign.center, // Tambahkan pengaturan textAlign untuk merapikan teks
          ),
        ],
      ),
    );
  }
}
