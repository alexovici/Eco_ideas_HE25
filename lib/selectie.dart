import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

  Future<String?> getUserName(String userId) async {
    final DatabaseReference databaseReference = FirebaseDatabase.instance.refFromURL('https://muncitor-pe-loc-default-rtdb.europe-west1.firebasedatabase.app/users/$userId');
    final DataSnapshot snapshot = await databaseReference.child('name').get();
    if (snapshot.exists) {
      return snapshot.value as String?;
    }
    return null;
  }

class SelectiePage extends StatefulWidget {
  final String jobTitle;

  const SelectiePage({super.key, required this.jobTitle});

  @override
  State<SelectiePage> createState() => _SelectiePageState();
}

class _SelectiePageState extends State<SelectiePage> {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.refFromURL('https://muncitor-pe-loc-default-rtdb.europe-west1.firebasedatabase.app/Posts');
  List<Map<String, dynamic>> applicants = [];

  @override
  void initState() {
    super.initState();
    fetchApplicants();
  }

  void fetchApplicants() async {
    final applicantsSnapshot = await databaseReference.child(widget.jobTitle).child('applicants').once();
    final applicantsData = applicantsSnapshot.snapshot.value as Map<dynamic, dynamic>? ?? {};
    final List<Map<String, dynamic>> loadedApplicants = [];
    applicantsData.forEach((key, value) {
      loadedApplicants.add({
        'userId': value['userId'],
      });
    });

    setState(() {
      applicants = loadedApplicants;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Applicants for ${widget.jobTitle}'),
      ),
      body: ListView.builder(
        itemCount: applicants.length,
        itemBuilder: (context, index) {
          final applicant = applicants[index];
          return Card(
            margin: EdgeInsets.all(10.0),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                applicant['userId'],
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        },
      ),
    );
  }
}