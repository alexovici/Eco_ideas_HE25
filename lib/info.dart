import 'package:flutter/material.dart';

class DespreNoi extends StatefulWidget {
  const DespreNoi({super.key});

  @override
  State<DespreNoi> createState() => _DespreNoiState();
}

class _DespreNoiState extends State<DespreNoi> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Despre Noi',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins',
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
        ),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'Schimbam vieti!',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                  ),
                )
                ),
              ),
            Image.asset('photos/pietroi.png'),
            Container(
              margin: EdgeInsets.all(20.0),
              child: Text(
                    'Într-o lume în continuă schimbare, găsirea unui loc de muncă poate fi o provocare, mai ales pentru muncitorii necalificați. Aplicația „Muncitor Rapid” vine în ajutorul acestora, oferindu-le acces rapid la oferte de muncă potrivite abilităților lor. Cu o interfață simplă și intuitivă, aplicația le permite utilizatorilor să-și creeze un profil, să-și aleagă domeniile de interes și să primească notificări despre joburile disponibile în apropierea lor. Angajatorii pot publica anunțuri și contacta direct candidații potriviți, reducând timpul de recrutare. Această aplicație reprezintă o soluție modernă pentru cei care caută un venit stabil și oportunități mai bune, conectând rapid angajatorii cu forța de muncă de care au nevoie.',
                  style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20.0,
                ),
              ),
            ),
            Image.asset('photos/job.png'),
          ],
        ),
      )
    );
  }
}