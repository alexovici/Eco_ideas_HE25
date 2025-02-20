import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_4/detalii_anunt.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.refFromURL('https://muncitor-pe-loc-default-rtdb.europe-west1.firebasedatabase.app/Posts');
  List<Map<String, dynamic>> allPosts = [];
  List<Map<String, dynamic>> filteredPosts = [];
  TextEditingController searchController = TextEditingController();

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
        allPosts = loadedPosts;
        filteredPosts = loadedPosts;
      });
    });
  }

  void filterPosts(String query) {
    final List<Map<String, dynamic>> filtered = allPosts.where((post) {
      final titleLower = post['title'].toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredPosts = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Posts'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by title',
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                filterPosts(query);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPosts.length,
              itemBuilder: (context, index) {
                final post = filteredPosts[index];
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
                          Text('Pay: ${post['pay']}'),
                          Text('Duration: ${post['duration']}'),
                          Text('Location: ${post['location']}'),
                          Text('Pay Period: ${post['payPeriod']}'),
                          Text('Work Period: ${post['workPeriod']}'),
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
    );
  }
}