import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/home.dart';
import 'package:flutter_application_4/inbox.dart';
import 'package:flutter_application_4/info.dart';
import 'package:flutter_application_4/post.dart';
import 'package:flutter_application_4/profile.dart';
import 'package:flutter_application_4/search.dart';
import 'package:flutter_application_4/login.dart';
import 'firebase_options.dart'; // Ensure this file is generated

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;
  List<Widget> pages = [
    HomePage(),
    SearchPage(),
    PostPage(),
    InboxPage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        backgroundColor: Colors.green,
        title: Text('Muncitor pe loc',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins' 
        ),),
        elevation: 0.0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
              return DespreNoi();
            }));
          }, icon: Icon(Icons.info))
        ],
        ),
        body: pages[currentPage],
        bottomNavigationBar: NavigationBar(destinations: [
          NavigationDestination(icon: Icon(Icons.home), label:'home',),
          NavigationDestination(icon: Icon(Icons.search), label: 'search'),
          NavigationDestination(icon: Icon(Icons.add), label: 'post'),
          NavigationDestination(icon: Icon(Icons.mail), label: 'inbox'),
          NavigationDestination(icon: Icon(Icons.person), label: 'profile',)
        ],
        onDestinationSelected: (int index){
          setState((){
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
        ),
    );
  }
}