import 'package:flutter/material.dart';
import 'package:p/components/navigation.dart';

class home1 extends StatefulWidget {
  @override
  State<home1> createState() => _home1State();
}

class _home1State extends State<home1> {
  List<String> properties = ['Property 1', 'Property 2', 'Property 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.home), // Home Icon
            SizedBox(width: 8), // Spacer
            Text('HOMECONNECT'), // Text
          ],
        ),
      ),
      body: Container(
        color: Colors.black,
        child: ListView.builder(
          itemCount: properties.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.purple.shade700,
              child: ListTile(
                title: Text(
                  properties[index],
                  style: TextStyle(color: Colors.white),
                ),
                trailing: ElevatedButton(
                  child: Text('Update'),
                  onPressed: () {
                    // Add functionality to update the property
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}

// Ensure your BottomNavigation widget supports the dark theme too.
