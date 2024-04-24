import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:p/components/navigation.dart';

import 'package:p/ownernav/update.dart';

class home1 extends StatefulWidget {
  @override
  _home1State createState() => _home1State();
}

class _home1State extends State<home1> {
  String userId =
      FirebaseAuth.instance.currentUser!.uid; // Replace with actual user ID
  final User? user = FirebaseAuth.instance.currentUser;

  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(user!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData && snapshot.data != null) {
              Map<String, dynamic> userData =
                  snapshot.data!.data() as Map<String, dynamic>;
              String name = userData['name'] ?? '';
              return buildview(context, name);
            } else {
              return Center(child: Text('No data found'));
            }
          }
        },
      ),
    );
  }

  @override
  Widget buildview(BuildContext context, String name) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome....,$name'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('accommodation')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error fetching accommodations'));
          }

          List<String> accommodations =
              snapshot.data!.docs.map((doc) => doc['name'] as String).toList();

          if (accommodations.isEmpty) {
            return Center(child: Text('No accommodations found'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: accommodations.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(accommodations[index]),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => update()),
                          );
                        },
                        child: Text('Update'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 227, 73, 217),
                          foregroundColor: Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
