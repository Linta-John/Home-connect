import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class update extends StatefulWidget {
  final String accommodationId;

  const update({Key? key, required this.accommodationId}) : super(key: key);

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<update> {
  final _formKey = GlobalKey<FormState>();
  final _accommodationNameController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _rulesController = TextEditingController();

  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('accommodation');

  List<String> amenities = [];
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> _pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    try {
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');
      Reference referenceImageToUpload =
          referenceDirImages.child(uniqueFileName);

      if (kIsWeb) {
        Uint8List? data = await file.readAsBytes();
        await referenceImageToUpload.putData(data);
      } else {
        File imageFile = File(file.path);
        await referenceImageToUpload.putFile(imageFile);
      }

      String imageUrl = await referenceImageToUpload.getDownloadURL();
      // Add imageUrl to a list to store all uploaded image URLs
      setState(() {
        imageUrls.add(
            imageUrl); // Assume you have declared List<String> imageUrls = []; at the top
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> _submitDetails() async {
    if (_formKey.currentState!.validate()) {
      // Fetch the current user's ID from FirebaseAuth
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('No user logged in')));
        return;
      }

      Map<String, dynamic> dataToSend = {
        'accommodationName': _accommodationNameController.text,
        'name': _nameController.text,
        'phone': _phoneController.text,
        'rules': _rulesController.text,
        'amenities': amenities,
        'userId': currentUser.uid, // Add the current user's ID
        'imageUrls': imageUrls, // Include the imageUrls list here
      };

      // Fetch the existing document from Firestore
      DocumentSnapshot snapshot =
          await _reference.doc(widget.accommodationId).get();
      if (snapshot.exists) {
        // Extract existing data from the document
        Map<String, dynamic> existingData =
            snapshot.data() as Map<String, dynamic>;

        // Check if there are any changes in the data
        bool hasChanges = false;
        existingData.forEach((key, value) {
          if (dataToSend[key] != null && dataToSend[key] != value) {
            hasChanges = true;
          }
        });

        if (hasChanges) {
          // If there are changes, update the existing document
          await _reference.doc(widget.accommodationId).update(dataToSend);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Details updated successfully')));
        }
      } else {
        // If the document doesn't exist, inform the user
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Document does not exist')));
      }
      Navigator.pop(context);
    }
  }

  Future<void> fetchDetails() async {
    DocumentSnapshot snapshot =
        await _reference.doc(widget.accommodationId).get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      _accommodationNameController.text = data['accommodationName'] ?? '';
      _nameController.text = data['name'] ?? '';
      _phoneController.text = data['phone'] ?? '';
      _rulesController.text = data['rules'] ?? '';
      amenities = List<String>.from(data['amenities'] ?? []);
      imageUrls = List<String>.from(data['imageUrls'] ?? []);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EDIT ACCOMODATION DETAILS'),
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
              controller: _accommodationNameController,
              decoration: InputDecoration(
                labelText: 'ACCOMODATION NAME',
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
                labelText: 'OWNER NAME',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              maxLines: null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter name';
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
                  return 'Please enter phone number';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _rulesController,
              decoration: InputDecoration(
                labelText: 'RULES AND REGULATIONS',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter rules and regulation';
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
              icon: const Icon(Icons.add_a_photo),
              label: const Text('Upload Image'),
              onPressed: _pickImage,
            ),
            Wrap(
              spacing: 8.0,
              children: imageUrls.asMap().entries.map((entry) {
                int index = entry.key;
                String imageUrl = entry.value;

                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Image.network(
                      imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        setState(() {
                          imageUrls.removeAt(index);
                        });
                      },
                    ),
                  ],
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _submitDetails();
              },
              child: Text(
                'Submit',
                style: TextStyle(
                  color: Colors.black, // Change the text color to white
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(255, 194, 71, 175), // light pink color
              ),
            )
          ],
        ),
      ),
    );
  }
}
