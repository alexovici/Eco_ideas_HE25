import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DetaliiAnunt extends StatelessWidget {
  final Map<String, dynamic> post;

  const DetaliiAnunt({super.key, required this.post});

  void applyForJob(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final DatabaseReference databaseReference = FirebaseDatabase.instance.refFromURL('https://muncitor-pe-loc-default-rtdb.europe-west1.firebasedatabase.app/Posts');

      // Check if the user is the publisher
      if (post['user'] == userId) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You cannot apply for your own job post.')),
        );
        return;
      }

      // Check if the user has already applied
      final applicantsRef = databaseReference.child(post['title']).child('applicants');
      final snapshot = await applicantsRef.orderByChild('userId').equalTo(userId).once();
      if (snapshot.snapshot.value != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You have already applied for this job.')),
        );
        return;
      }

      // Apply for the job
      applicantsRef.push().set({'userId': userId}).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Applied for the job successfully!')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to apply for the job: $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to be logged in to apply for the job.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post['title'],
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text('Description: ${post['description']}'),
            Text('Pay: ${post['pay']} / ${post['payPeriod']}'),
            Text('Duration: ${post['duration']} ${post['workPeriod']}(s)'),
            Text('Location: ${post['location']}'),
            SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: () => applyForJob(context),
                child: Text('Apply for Job'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}