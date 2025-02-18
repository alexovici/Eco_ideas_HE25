import 'package:flutter/material.dart';
import 'package:flutter_application_4/info.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),),
        centerTitle: true,
        backgroundColor: Colors.yellow,
      ),
    );
  }
}