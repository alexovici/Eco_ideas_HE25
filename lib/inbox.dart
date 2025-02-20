import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.refFromURL('https://muncitor-pe-loc-default-rtdb.europe-west1.firebasedatabase.app/Posts');
  final userId = FirebaseAuth.instance.currentUser?.uid;
  List<Map<String, dynamic>> jobsPostedByMe = [];
  List<Map<String, dynamic>> jobsAppliedTo = [];

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  void fetchJobs() async {
    if (userId != null) {
      // Fetch jobs posted by me
      final postedJobsSnapshot = await databaseReference.orderByChild('user').equalTo(userId).once();
      final postedJobsData = postedJobsSnapshot.snapshot.value as Map<dynamic, dynamic>? ?? {};
      final List<Map<String, dynamic>> loadedPostedJobs = [];
      postedJobsData.forEach((key, value) {
        loadedPostedJobs.add({
          'title': key,
          'applicants': value['applicants'] ?? {},
        });
      });

      // Fetch jobs I applied to
      final appliedJobsSnapshot = await databaseReference.once();
      final appliedJobsData = appliedJobsSnapshot.snapshot.value as Map<dynamic, dynamic>? ?? {};
      final List<Map<String, dynamic>> loadedAppliedJobs = [];
      appliedJobsData.forEach((key, value) {
        if (value['applicants'] != null && value['applicants'].values.any((applicant) => applicant['userId'] == userId)) {
          loadedAppliedJobs.add({
            'title': key,
            'description': value['description'],
          });
        }
      });

      setState(() {
        jobsPostedByMe = loadedPostedJobs;
        jobsAppliedTo = loadedAppliedJobs;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inbox'),
      ),
      body: Column(
        children: [
          // Section 1: Jobs Posted by Me
          Expanded(
            child: Container(
              color: Colors.blue[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Jobs Posted by Me',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: jobsPostedByMe.length,
                      itemBuilder: (context, index) {
                        final job = jobsPostedByMe[index];
                        final applicants = job['applicants'] as Map<dynamic, dynamic>;
                        return Card(
                          margin: EdgeInsets.all(10.0),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  job['title'],
                                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5.0),
                                Text('Applicants:'),
                                ...applicants.values.map((applicant) {
                                  return Text(applicant['userId']);
                                }).toList(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Section 2: Jobs I Applied To
          Expanded(
            child: Container(
              color: Colors.green[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Jobs I Applied To',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: jobsAppliedTo.length,
                      itemBuilder: (context, index) {
                        final job = jobsAppliedTo[index];
                        return Card(
                          margin: EdgeInsets.all(10.0),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  job['title'],
                                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5.0),
                                Text('Description: ${job['description']}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}