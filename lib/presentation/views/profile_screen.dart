import 'package:flutter/material.dart';
import 'package:navigation/presentation/views/language_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('Profile Screen', style: TextStyle(fontSize: 32))),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: 'LanguageScreen'),
                  builder: (context) => LanguageScreen(),
                ),
              );
            },
            child: Text('Navigate to Language Screen'),
          ),
        ],
      ),
    );
  }
}
