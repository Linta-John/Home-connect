import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
//import 'package:intl/intl.dart';

class add1 extends StatefulWidget {
  const add1({Key? key}) : super(key: key);

  @override
  _add1State createState() => _add1State();
}

class _add1State extends State<add1> {
  final _formKey = GlobalKey<FormState>();
  final _accnameController = TextEditingController();
  final _stateNameController = TextEditingController();
  final _districtNameController = TextEditingController();
  final _cityNameController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _rentController = TextEditingController();
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('accommodation');

  List<String> availabilityOptions = ['Available', 'Not Available'];
  List<String> genderOptions = ['Male', 'Female', 'Any'];
  List<String> roomOptions = ['Single', 'Double', 'Triple', 'Multi'];
  List<String> amenities = [];

  String imageUrl = '';
  String? availability;
  String? genderPreference;
  String? roomtype;

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
        'accommodationName': _accnameController.text,
        'stateName': _stateNameController.text,
        'districtName': _districtNameController.text,
        'cityName': _cityNameController.text,
        'name': _nameController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'rent': _rentController.text,
        'gender': genderPreference,
        'availability': availability,
        'roomtype': roomtype,
        'amenities': amenities,
        'imageUrl': imageUrl,
      };

      await _reference.add(dataToSend);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share living space'),
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
              controller: _accnameController,
              decoration: InputDecoration(
                labelText: 'ACCOMMOMODATION NAME',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter accomodation name';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'NAME',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter name';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'ADDRESS',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              maxLines: null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter address';
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
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'PHONE NUMBER',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter phone ';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: availability,
                    onChanged: (value) {
                      setState(() {
                        availability = value;
                      });
                    },
                    items: availabilityOptions.map((option) {
                      return DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Availability',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: genderPreference,
                    onChanged: (value) {
                      setState(() {
                        genderPreference = value;
                      });
                    },
                    items: genderOptions.map((option) {
                      return DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Gender Preference',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: roomtype,
                    onChanged: (value) {
                      setState(() {
                        roomtype = value;
                      });
                    },
                    items: roomOptions.map((option) {
                      return DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Room Type',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _rentController,
              decoration: InputDecoration(
                labelText: 'RENT',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter rent';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              children: amenities.map((amenity) {
                return Chip(
                  label: Text(amenity),
                  // Assuming icons are available for the amenities you mentioned
                  avatar: amenity == 'Washer'
                      ? Icon(Icons.local_laundry_service)
                      : amenity == 'Water'
                          ? Icon(Icons.opacity)
                          : amenity == 'Wifi'
                              ? Icon(Icons.wifi)
                              : amenity == 'Air conditioning'
                                  ? Icon(Icons.ac_unit)
                                  : null,
                  onDeleted: () {
                    setState(() {
                      amenities.remove(amenity);
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Select Amenities'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text('Washer'),
                          onTap: () {
                            setState(() {
                              amenities.add('Washer');
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: Text('Food'),
                          onTap: () {
                            setState(() {
                              amenities.add('Food');
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: Text('Wifi'),
                          onTap: () {
                            setState(() {
                              amenities.add('Wifi');
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: Text('Air conditioning'),
                          onTap: () {
                            setState(() {
                              amenities.add('Air conditioning');
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Text('Add Amenities'),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_location),
              label: const Text('ADD LOCATION'),
              onPressed: () {
                // Add location logic
              },
            ),
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