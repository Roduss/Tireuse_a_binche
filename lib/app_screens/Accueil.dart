import 'package:flutter/material.dart';
import './main.dart';

class Accueil_screen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(
        child : Column(
            mainAxisAlignment: MainAxisAlignment.center ,
            children: <Widget>[

              RaisedButton(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Connexion()),
                  );
                },
                child: Text('Connexion'),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder : (context) => Inscription()),
                  );
                },
                child: Text('Creation'),
              ),

              RaisedButton(
                padding: EdgeInsets.all(20),
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Classement_alcoolo()),
                  );
                },
                child: Text('Classement buveurs',
                  /*style : TextStyle(
                        fontSize : 12),*/
                ),
              ),


              RaisedButton(
              onPressed: () {
               Navigator.push(context,
               MaterialPageRoute(builder : (context) => Menu_binche()),
              );
              },
              child: Text('Menubinchetest'),
              ),
            ]
        )
    );

  }

}