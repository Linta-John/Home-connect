import 'package:flutter/material.dart';
import 'package:p/owner/ow4.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: owneradd2(),
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.purple,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(backgroundColor: Colors.purple),
        ),
      ),
    );
  }
}

class owneradd2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Create a new listing'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Accommodation Name',
                labelStyle: TextStyle(color: Colors.white),
                hintText: 'Accommodation name',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Rules',
                labelStyle: TextStyle(color: Colors.white),
                hintText: 'Rules and regulations',
              ),
              maxLines: null,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement upload photos functionality
              },
              child: Text('Upload Photos'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Gender preference',
              ),
              items: ['Male', 'Female', 'Any'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {
                // Implement change functionality
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Room type',
              ),
              items: ['Single', 'Double', 'Triple'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {
                // Implement change functionality
              },
            ),
            SizedBox(height: 16),
            CounterFormField(
              labelText: 'Rent amount',
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Availability',
              ),
              items: ['Available', 'Not Available'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {
                // Implement change functionality
              },
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              children: <Widget>[
                Chip(
                  label: Text('Washer'),
                  avatar: Icon(Icons.local_laundry_service),
                ),
                Chip(
                  label: Text('Water'),
                  avatar: Icon(Icons.opacity),
                ),
                Chip(
                  label: Text('Wifi'),
                  avatar: Icon(Icons.wifi),
                ),
                Chip(
                  label: Text('Air conditioning'),
                  avatar: Icon(Icons.ac_unit),
                ),
                // Add more amenities as needed
              ],
            ),
            SizedBox(height: 16),
            IconButton(
              onPressed: () {
                // Implement add amenities functionality
              },
              icon: Icon(Icons.add),
              tooltip: 'Add amenities',
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Implement save functionality
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ow4()),
                );
              },
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CounterFormField extends StatefulWidget {
  final String labelText;

  CounterFormField({required this.labelText});

  @override
  _CounterFormFieldState createState() => _CounterFormFieldState();
}

class _CounterFormFieldState extends State<CounterFormField> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: widget.labelText,
            ),
            controller: TextEditingController(text: '$_counter'),
            readOnly: true,
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            setState(() {
              _counter++;
            });
          },
        ),
      ],
    );
  }
}
