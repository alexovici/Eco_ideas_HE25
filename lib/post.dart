import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PostPage(),
    );
  }
}

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final payController = TextEditingController();
  final durationController = TextEditingController();
  final locationController = TextEditingController();
  String? selectedPayPeriod;
  String? selectedWorkPeriod;

  final DatabaseReference databaseReference = FirebaseDatabase.instance.refFromURL('https://muncitor-pe-loc-default-rtdb.europe-west1.firebasedatabase.app/Posts');

  void uploadJobDetails() {
    String title = titleController.text;
    String description = descriptionController.text;
    String pay = payController.text;
    String duration = durationController.text;
    String location = locationController.text;
    String payPeriod = selectedPayPeriod ?? '';
    String workPeriod = selectedWorkPeriod ?? '';

    Map<String, dynamic> jobDetails = {
      'description': description,
      'pay': pay,
      'duration': duration,
      'location': location,
      'payPeriod': payPeriod,
      'workPeriod': workPeriod,
    };

    databaseReference.child(title).set(jobDetails).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Job posted successfully!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post job: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text(
          'Post a Job',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              elevation: 5.0,
              margin: EdgeInsets.symmetric(vertical: 10.0),
              color: Colors.grey.shade200,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200.0,
                      child: TextField(
                        controller: descriptionController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          labelText: 'Description of the job',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: durationController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Duration',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Period',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            value: selectedWorkPeriod,
                            items: ['hour', 'day', 'week', 'month'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedPayPeriod = newValue;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: payController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Pay Amount',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Pay Period',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            value: selectedPayPeriod,
                            items: ['hour', 'day', 'week', 'month'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedPayPeriod = newValue;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: locationController,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (titleController.text.isEmpty ||
                              descriptionController.text.isEmpty ||
                              payController.text.isEmpty ||
                              locationController.text.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text('Please fill in all fields'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                            return;
                          } else {
                            uploadJobDetails();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text(
                          "Post Job",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}