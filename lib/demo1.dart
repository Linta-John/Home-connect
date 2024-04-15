/*import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add Station Details',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AddStationDetailsPage(),
    );
  }
}

class AddStationDetailsPage extends StatefulWidget {
  const AddStationDetailsPage({super.key});

  @override
  _AddStationDetailsPageState createState() => _AddStationDetailsPageState();
}

class _AddStationDetailsPageState extends State<AddStationDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _stationNameController = TextEditingController();
  final _stateNameController = TextEditingController();
  final _districtNameController = TextEditingController();
  final _cityNameController = TextEditingController();
  final _roadNameController = TextEditingController();
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('station_details');

  String imageUrl = '';
  TimeOfDay _openingTime = const TimeOfDay(hour: 6, minute: 0);
  TimeOfDay _closingTime = const TimeOfDay(hour: 21, minute: 0);
  bool _is24Hours = false;

  Future<void> _selectTime(BuildContext context, bool isOpeningTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isOpeningTime ? _openingTime : _closingTime,
    );
    if (picked != null) {
      setState(() {
        if (isOpeningTime) {
          _openingTime = picked;
        } else {
          _closingTime = picked;
        }
      });
    }
  }

  Future<void> _pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      if (kIsWeb) {
        // Handling for Flutter Web
        Uint8List? data = await file.readAsBytes();
        await referenceImageToUpload.putData(data);
      } else {
        // Handling for Flutter Mobile
        File imageFile = File(file.path);
        await referenceImageToUpload.putFile(imageFile);
      }
      imageUrl = await referenceImageToUpload.getDownloadURL();
      setState(() {}); // Update the UI
    } catch (error) {
      print(error);
    }
  }

  Future<void> _submitDetails() async {
    if (_formKey.currentState!.validate()) {
      if (imageUrl.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Please upload an image')));
        return;
      }
      Map<String, dynamic> dataToSend = {
        'stationName': _stationNameController.text,
        'stateName': _stateNameController.text,
        'districtName': _districtNameController.text,
        'cityName': _cityNameController.text,
        'roadName': _roadNameController.text,
        'is24Hours': _is24Hours,
        'openingTime': _is24Hours ? null : _formatTimeOfDay(_openingTime),
        'closingTime': _is24Hours ? null : _formatTimeOfDay(_closingTime),
        'imageUrl': imageUrl,
      };

      await _reference.add(dataToSend);
      Navigator.pop(context);
    }
  }

  String _formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); // Adjust format to your needs
    return format.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EDIT STATION DETAILS'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: _stationNameController,
              decoration: InputDecoration(
                labelText: 'STATION NAME',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter station name';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _stateNameController,
              decoration: InputDecoration(
                labelText: 'STATE',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              maxLines: null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter state';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _districtNameController,
              decoration: InputDecoration(
                labelText: 'DISTRICT',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter district';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _cityNameController,
              decoration: InputDecoration(
                labelText: 'CITY',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter city/town';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _roadNameController,
              decoration: InputDecoration(
                labelText: 'ROAD NAME OR AREA',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter road name or area';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_location),
              label: const Text('ADD LOCATION'),
              onPressed: () {
                // Add location logic
              },
            ),
            ListTile(
              title: const Text('24 HOURS'),
              trailing: Switch(
                value: _is24Hours,
                onChanged: (bool value) {
                  setState(() {
                    _is24Hours = value;
                  });
                },
              ),
            ),
            if (!_is24Hours) ...[
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('OPENING TIME'),
                      subtitle: Text('${_openingTime.format(context)}'),
                      onTap: () {
                        _selectTime(context, true);
                      },
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text('CLOSING TIME'),
                      subtitle: Text('${_closingTime.format(context)}'),
                      onTap: () {
                        _selectTime(context, false);
                      },
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_a_photo),
              label: const Text('Upload Image'),
              onPressed: _pickImage,
            ),
            if (imageUrl.isNotEmpty) Image.network(imageUrl),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitDetails,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
*/