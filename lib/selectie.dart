import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

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

  Future<String?> getUserEmail(String userId) async {
    final DatabaseReference userRef = FirebaseDatabase.instance.refFromURL('https://muncitor-pe-loc-default-rtdb.europe-west1.firebasedatabase.app/users/$userId');
    final DataSnapshot emailSnapshot = await userRef.child('email').get();
    if (emailSnapshot.exists) {
      return emailSnapshot.value as String?;
    }
    return null;
  }

  void fetchApplicants() async {
    final applicantsSnapshot = await databaseReference.child(widget.jobTitle).child('applicants').once();
    final applicantsData = applicantsSnapshot.snapshot.value as Map<dynamic, dynamic>? ?? {};
    final List<Map<String, dynamic>> loadedApplicants = [];

    for (var entry in applicantsData.entries) {
      final userId = entry.value['userId'];
      final userEmail = await getUserEmail(userId);
      final userDescription = entry.value['description'] ?? 'No description';
      loadedApplicants.add({
        'userId': userId,
        'userEmail': userEmail ?? 'Unknown',
        'description': userDescription,
      });
    }

    setState(() {
      applicants = loadedApplicants;
    });
  }

  void selectApplicant(String userId) async {
    final applicantsSnapshot = await databaseReference.child(widget.jobTitle).child('applicants').once();
    final applicantsData = applicantsSnapshot.snapshot.value as Map<dynamic, dynamic>? ?? {};

    String? applicantKey;
    for (var entry in applicantsData.entries) {
      if (entry.value['userId'] == userId) {
        applicantKey = entry.key;
        break;
      }
    }

    if (applicantKey != null) {
      await databaseReference.child(widget.jobTitle).child('applicants').child(applicantKey).update({
        'selected': true,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Applicant selected successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to select applicant.')),
      );
    }
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User ID: ${applicant['userId']}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Email: ${applicant['userEmail']}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Description: ${applicant['description']}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () => selectApplicant(applicant['userId']),
                    child: Text('Select'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}