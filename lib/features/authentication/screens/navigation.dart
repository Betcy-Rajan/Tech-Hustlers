import 'package:flutter/material.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the second screen using a named route.
            
          },
          child: const Text('Launch screen'),
        ),
      ),
    );
  }
}