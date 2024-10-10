import 'package:flutter/material.dart';
import 'package:perpustakaan/themes.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage(
                  'assets/icon_pdf.png'),
            ),
            SizedBox(height: 20),
            Text(
              'Username',
              style: TextStyle(fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: textColor),
            ),
            Text(
              'mandriyan@example.com',
              style: TextStyle(fontSize: 15,
              color: iconPertama),
            ),
          ],
        ),
      ),
    );
  }
}
