import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                  'assets/profile.jpg'), // Ganti dengan gambar profil Anda
            ),
            SizedBox(height: 20),
            Text(
              'User Name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'mandri@example.com',
              style: TextStyle(fontSize: 18),
            ),
            // Tambahkan lebih banyak informasi profil di sini
          ],
        ),
      ),
    );
  }
}
