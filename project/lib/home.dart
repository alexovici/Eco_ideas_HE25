import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'detalii_anunt.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.refFromURL('https://muncitor-pe-loc-default-rtdb.europe-west1.firebasedatabase.app/Posts');
  List<Map<String, dynamic>> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  void fetchPosts() {
    databaseReference.once().then((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      final List<Map<String, dynamic>> loadedPosts = [];
      data.forEach((key, value) {
        loadedPosts.add({
          'title': key,
          'description': value['description'],
          'pay': value['pay'],
          'duration': value['duration'],
          'location': value['location'],
          'payPeriod': value['payPeriod'],
          'workPeriod': value['workPeriod'],
        });
      });
      setState(() {
        posts = loadedPosts;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Job Posts'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context){
                    return DetaliiAnunt(post: post);
                  }
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.all(10.0),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['title'],
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text('Description: ${post['description']}'),
                    Text('Pay: ${post['pay']} / ${post['payPeriod']}'),
                    Text('Duration: ${post['duration']} ${post['workPeriod']}(s)'),
                    Text('Location: ${post['location']}'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}