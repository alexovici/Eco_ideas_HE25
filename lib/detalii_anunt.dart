import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DetaliiAnunt extends StatefulWidget {
  final Map<String, dynamic> post;

  const DetaliiAnunt({super.key, required this.post});

  @override
  _DetaliiAnuntState createState() => _DetaliiAnuntState();
}

class _DetaliiAnuntState extends State<DetaliiAnunt> {
  final TextEditingController _descriptionController = TextEditingController();
  final DatabaseReference databaseReference = FirebaseDatabase.instance.refFromURL('https://muncitor-pe-loc-default-rtdb.europe-west1.firebasedatabase.app/Posts');
  final userId = FirebaseAuth.instance.currentUser?.uid;

  Future<String?> getUserIdFromPost(String postTitle) async {
    final DataSnapshot snapshot = await databaseReference.child(postTitle).child('userid').get();
    if (snapshot.exists) {
      return snapshot.value as String?;
    }
    return null;
  }

  void applyForJob(BuildContext context) async {
    if (userId != null) {
      // Get the userId of the post publisher
      final postUserId = await getUserIdFromPost(widget.post['title']);
      if (postUserId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to retrieve post publisher information.')),
        );
        return;
      }

      // Check if the user is the publisher
      if (postUserId == userId) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You cannot apply for your own job post.')),
        );
        return;
      }

      // Check if the user has already applied
      final applicantsRef = databaseReference.child(widget.post['title']).child('applicants');
      final snapshot = await applicantsRef.orderByChild('userId').equalTo(userId).once();
      if (snapshot.snapshot.value != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You have already applied for this job.')),
        );
        return;
      }

      // Apply for the job with user description
      applicantsRef.push().set({
        'userId': userId,
        'description': _descriptionController.text,
      }).then((_) {
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
        title: Text(widget.post['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.post['title'],
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text('Description: ${widget.post['description']}'),
            Text('Pay: ${widget.post['pay']} / ${widget.post['payPeriod']}'),
            Text('Duration: ${widget.post['duration']} ${widget.post['workPeriod']}(s)'),
            Text('Location: ${widget.post['location']}'),
            Text('What makes you the right fit for this job?',
            style: TextStyle(
              fontSize: 20.0,
            ),),
            SizedBox(height: 20.0),
            TextField(
              controller: _descriptionController,
              maxLines: 5, // Set the maximum number of lines to make the textbox bigger
              decoration: InputDecoration(
                labelText: 'Enter your description',
                border: OutlineInputBorder(),
              ),
            ),
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