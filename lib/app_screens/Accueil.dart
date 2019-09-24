import 'package:flutter/material.dart';
import '../Socket/game_comm.dart';
import '../Socket/websockets.dart';
import '../main.dart';


import 'dart:convert';

import 'dart:async';

import 'package:flutter/foundation.dart';


/*On a testé de copier/coller le code ici de game_comm ici, a enlever jusqu'au comm, sans grand succès*/
GameCommunication game = new GameCommunication();

class GameCommunication  {
  static final GameCommunication _game = new GameCommunication._internal();



  factory GameCommunication(){
    return _game;
  }

  GameCommunication._internal(){
    ///
    /// Initialisons la communication WebSockets
    ///
    sockets.initCommunication();

    ///
    /// et demandons d'être notifié à chaque fois qu'un message est envoyé par le serveur
    ///
    sockets.addListener(_onMessageReceived);
  }

    _onMessageReceived(serverMessage){
      ///
      /// Comme les messages sont envoyés sous forme de chaîne de caractères
      /// récupérons l'objet JSON correspondant
      ///
      Map message = json.decode(serverMessage);

      switch(message["action"]){
      ///

      }
    }
  }
///---------------------Enlever jusque la-----------------
///Changer les includes aussi - comprendre ce qui fait qu'on se connecte à ce serveur.


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