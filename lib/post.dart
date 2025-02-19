import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final payController = TextEditingController();
  final locationController = TextEditingController();
  String? selectedPayPeriod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Title', // Changed from hintText to labelText
                border: OutlineInputBorder(),
              )
            ),
            SizedBox(height: 16.0), // Add some spacing between the fields
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200.0, // Set the desired height
              child: TextField(
                controller: descriptionController,
                maxLines: null, // Allow multiple lines
                expands: true, // Expand to fill the container
                textAlignVertical: TextAlignVertical.top, // Align text to the top
                decoration: InputDecoration(
                  hintText: 'Description of the job', // Changed from hintText to labelText
                  border: OutlineInputBorder(
                    borderSide: BorderSide()
                  ),
                ),
              )
            ),
            SizedBox(height: 16.0), // Add some spacing between the fields
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: payController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Duration',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16.0), // Add some spacing between the fields
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: 'Period',
                      border: OutlineInputBorder(),
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
            SizedBox(height: 16.0), // Add some spacing between the fields
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: payController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Pay Amount',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16.0), // Add some spacing between the fields
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: 'Pay Period',
                      border: OutlineInputBorder(),
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
                SizedBox(height: 16.0), // Add some spacing between the fields
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    hintText: 'Location',
                    border: OutlineInputBorder(),
        
                  )
                ),
                SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                      onPressed: () {
                          if (titleController.text.isEmpty || descriptionController.text.isEmpty || payController.text.isEmpty || locationController.text.isEmpty) 
                          {
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
                          }
                          else
                          {
                            // Post the job
                          }
                      },
                      child: Text("Post Job"),
                    )
                  )
              ],
            ),
        ),
      );
  }
}