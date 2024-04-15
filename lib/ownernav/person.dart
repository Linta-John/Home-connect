import 'package:flutter/material.dart';
import 'package:p/components/navigation.dart';

class person extends StatefulWidget {
  const person({super.key, required this.title});
  final String title;
  @override
  State<person> createState() => _person();
}

class _person extends State<person> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              "Profile",
              style: TextStyle(fontSize: 50),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
