import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:p/tenantnav/pdf.dart';
import 'package:p/tenantnav/bookslot.dart';
// Import your PDF viewer screen

class accommodationscreen extends StatefulWidget {
  final String accommodationId;
  final String Rent;
  final String Gender;
  final String Type;

  const accommodationscreen({
    required this.accommodationId,
    required this.Rent,
    required this.Gender,
    required this.Type,
  });

  @override
  _accommodationscreenState createState() => _accommodationscreenState();
}

class _accommodationscreenState extends State<accommodationscreen> {
  String accommodationName = '';
  String address = '';
  String cityName = '';
  String districtName = '';
  String stateName = '';
  String name = '';
  String phone = '';
  String rules = '';
  List<String> amenities = [];
  List<String> imageUrls = [];
  List<Map<String, dynamic>> roomdetails = [];
  bool isLoading = true;
  int _expandedIndex = -1;
  int _currentPageIndex = 0;
  String rulesFileUrl = '';
  @override
  void initState() {
    super.initState();
    fetchDetails();
    fetchRooms();
  }

  Future<void> fetchDetails() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('accommodation')
          .doc(widget.accommodationId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        setState(() {
          accommodationName = data?['accommodationName'] ?? '';
          address = data?['address'] ?? '';
          cityName = data?['cityName'] ?? '';
          districtName = data?['districtName'] ?? '';
          stateName = data?['stateName'] ?? '';
          name = data?['name'] ?? '';
          phone = data?['phone'] ?? '';
          rules = data?['rules'] ?? '';
          amenities = List<String>.from(data?['amenities'] ?? []);
          imageUrls = List<String>.from(data?['imageUrls'] ?? []);
          rulesFileUrl = data?['rulesFileUrl'] ?? '';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching details: $e');
    }
  }

  void fetchRooms() async {
    try {
      var collection = FirebaseFirestore.instance.collection('roomdetails');
      var query = collection.where('availability', isEqualTo: 'Available');

      if (widget.Type.isNotEmpty) {
        query = query.where('type', isEqualTo: widget.Type);
      }
      if (widget.Gender.isNotEmpty) {
        query = query.where('gender', isEqualTo: widget.Gender);
      }
      if (widget.Rent.isNotEmpty) {
        query = query.where('rent', isEqualTo: widget.Rent);
      }
      if (widget.accommodationId.isNotEmpty) {
        query =
            query.where('accommodation_id', isEqualTo: widget.accommodationId);
      }

      var querySnapshot = await query.get();

      var fetchedRoomdetails = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();

      if (mounted) {
        setState(() {
          roomdetails = fetchedRoomdetails;
        });
      }
    } catch (e) {
      print('Error fetching rooms: $e');
    }
  }

  void navigateToBookSlot(String roomId, String accommodationId) async {
    try {
      var roomDoc = await FirebaseFirestore.instance
          .collection('roomdetails')
          .doc(roomId)
          .get();

      if (roomDoc.exists) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => bookslot(
              accommodationId: accommodationId,
              roomId: roomId,
            ),
          ),
        );
      } else {
        print('Room document not found');
      }
    } catch (e) {
      print('Error navigating to book slot: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accommodation Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrls.isNotEmpty)
              Stack(
                children: [
                  SizedBox(
                    height: 200,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        // Swipe detection for changing images
                        if (details.delta.dx > 0) {
                          // Swiping from left to right
                          setState(() {
                            _currentPageIndex = (_currentPageIndex - 1)
                                .clamp(0, imageUrls.length - 1);
                          });
                        } else if (details.delta.dx < 0) {
                          // Swiping from right to left
                          setState(() {
                            _currentPageIndex = (_currentPageIndex + 1)
                                .clamp(0, imageUrls.length - 1);
                          });
                        }
                      },
                      child: PageView.builder(
                        itemCount: imageUrls.length,
                        controller:
                            PageController(initialPage: _currentPageIndex),
                        onPageChanged: (index) {
                          setState(() {
                            _currentPageIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Image.network(
                            imageUrls[index],
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    left: 8.0,
                    top: 80.0,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        setState(() {
                          _currentPageIndex = (_currentPageIndex - 1)
                              .clamp(0, imageUrls.length - 1);
                        });
                      },
                    ),
                  ),
                  Positioned(
                    right: 8.0,
                    top: 80.0,
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        setState(() {
                          _currentPageIndex = (_currentPageIndex + 1)
                              .clamp(0, imageUrls.length - 1);
                        });
                      },
                    ),
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _expandedIndex = _expandedIndex == index ? -1 : index;
                  });
                },
                children: [
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text('Details'),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            accommodationName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Address: $address',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Cityname: $cityName',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'District: $districtName',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'State: $stateName',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Name: $name',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Phone: $phone',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    isExpanded: _expandedIndex == 0,
                  ),
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text('Amenities & Rules'),
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rules: $rules',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          if (rules.isNotEmpty) // Add this condition
                            TextButton(
                              onPressed: () {
                                // Navigate to the PDF viewer screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => pdf(
                                      pdfUrl: rulesFileUrl,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'View Rules PDF',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          SizedBox(height: 8),
                          Text(
                            'Amenities:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 4),
                          for (var amenity in amenities)
                            Text(
                              '- $amenity',
                              style: TextStyle(fontSize: 16),
                            ),
                        ],
                      ),
                    ),
                    isExpanded: _expandedIndex == 1,
                  ),
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text('Room Details'),
                      );
                    },
                    body: roomdetails.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: roomdetails.length,
                            itemBuilder: (context, index) {
                              var room = roomdetails[index];
                              return GestureDetector(
                                onTap: () {
                                  navigateToBookSlot(
                                      room['id'], room['accommodation_id']);
                                },
                                child: Card(
                                  child: ListTile(
                                    title: Text(room['name'] ?? 'Loading...'),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(room['type'] ?? 'Loading...'),
                                        Text(room['rent'] ?? 'Loading...'),
                                        Text(room['gender'] ?? 'Loading...'),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text('No rooms available'),
                          ),
                    isExpanded: _expandedIndex == 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
