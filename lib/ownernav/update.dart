import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Update Details',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: update(),
    );
  }
}

class update extends StatefulWidget {
  @override
  _updateState createState() => _updateState();
}

class _updateState extends State<update> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Update Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildHeading('Single Room'),
              buildItemRow('singleRoomCount', 'singleRoomRent'),
              SizedBox(height: 16.0),
              buildHeading('Double Room'),
              buildItemRow('doubleRoomCount', 'doubleRoomRent'),
              SizedBox(height: 16.0),
              buildHeading('Triple Room'),
              buildItemRow('tripleRoomCount', 'tripleRoomRent'),
              SizedBox(height: 16.0),
              buildHeading('Multi Room'),
              buildItemRow('multiRoomCount', 'multiRoomRent'),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: double.infinity, // Width of the page
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // All fields are valid, handle save button press
              // For now, it's just a placeholder
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('All fields are valid!')),
              );
            } else {
              // Some fields are empty
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please fill in all fields')),
              );
            }
          },
          child: Text(
            'Save',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.black,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildHeading(String heading) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        heading,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildItemRow(String countField, String rentField) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 12.0),
          Expanded(
            flex: 1,
            child: SizedBox(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Count',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter count of rooms';
                  }
                  return null;
                },
              ),
            ),
          ),
          SizedBox(width: 12.0),
          Expanded(
            flex: 1,
            child: SizedBox(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Rent',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter  rent';
                  }
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
