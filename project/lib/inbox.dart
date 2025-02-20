import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_4/selectie.dart';

Future<String?> getUserEmail(String userId) async {
  final DatabaseReference userRef = FirebaseDatabase.instance.refFromURL('https://muncitor-pe-loc-default-rtdb.europe-west1.firebasedatabase.app/users/$userId');
  final DataSnapshot emailSnapshot = await userRef.child('email').get();
  if (emailSnapshot.exists) {
    return emailSnapshot.value as String?;
  }
  return null;
}

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
      final postedJobsSnapshot = await databaseReference.orderByChild('userid').equalTo(userId).once();
      final postedJobsData = postedJobsSnapshot.snapshot.value as Map<dynamic, dynamic>? ?? {};
      final List<Map<String, dynamic>> loadedPostedJobs = [];
      for (var entry in postedJobsData.entries) {
        final jobTitle = entry.key;
        final applicants = entry.value['applicants'] as Map<dynamic, dynamic>? ?? {};
        final List<Map<String, dynamic>> loadedApplicants = [];
        bool isAnyApplicantSelected = false;
        for (var applicantEntry in applicants.entries) {
          final applicantUserId = applicantEntry.value['userId'];
          final applicantEmail = await getUserEmail(applicantUserId);
          final applicantDescription = applicantEntry.value['description'] ?? 'No description';
          final isSelected = applicantEntry.value['selected'] ?? false;
          if (isSelected) {
            isAnyApplicantSelected = true;
          }
          loadedApplicants.add({
            'userId': applicantUserId,
            'userEmail': applicantEmail ?? 'Unknown',
            'description': applicantDescription,
            'selected': isSelected,
          });
        }
        loadedPostedJobs.add({
          'title': jobTitle,
          'applicants': loadedApplicants,
          'isAnyApplicantSelected': isAnyApplicantSelected,
        });
      }

      // Fetch jobs I applied to
      final appliedJobsSnapshot = await databaseReference.once();
      final appliedJobsData = appliedJobsSnapshot.snapshot.value as Map<dynamic, dynamic>? ?? {};
      final List<Map<String, dynamic>> loadedAppliedJobs = [];
      for (var entry in appliedJobsData.entries) {
        final jobTitle = entry.key;
        final applicants = entry.value['applicants'] as Map<dynamic, dynamic>? ?? {};
        bool isSelectedForJob = false;
        for (var applicantEntry in applicants.entries) {
          if (applicantEntry.value['userId'] == userId && applicantEntry.value['selected'] == true) {
            isSelectedForJob = true;
            break;
          }
        }
        loadedAppliedJobs.add({
          'title': jobTitle,
          'description': entry.value['description'],
          'isSelectedForJob': isSelectedForJob,
        });
      }

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
                        final applicants = job['applicants'] as List<Map<String, dynamic>>;
                        final isAnyApplicantSelected = job['isAnyApplicantSelected'] as bool;
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return SelectiePage(jobTitle: job['title']);
                                },
                              ),
                            );
                          },
                          child: Card(
                            color: isAnyApplicantSelected ? Colors.green[100] : Colors.white,
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
                                  ...applicants.map((applicant) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Email: ${applicant['userEmail']}'),
                                        Text('Description: ${applicant['description']}'),
                                        if (applicant['selected'] == true)
                                          Text('Selected: ${applicant['userEmail']}'),
                                      ],
                                    );
                                  }).toList(),
                                ],
                              ),
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
                        final isSelectedForJob = job['isSelectedForJob'] as bool;
                        return Card(
                          color: isSelectedForJob ? Colors.green[100] : Colors.white,
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
                                if (isSelectedForJob)
                                  Text('Applicant selected for this job'),
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