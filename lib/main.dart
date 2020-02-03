import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';//To load the images with cache



import './app_screens/Inscription.dart';
import './app_screens/Connexion.dart';
import './app_screens/Menu_binche.dart';
import './app_screens/Classement_alcoolo.dart';
import './app_screens/Taux_voiture.dart';


import 'dart:async';
import 'package:flutter/foundation.dart';
import 'dart:io';


void main() async {
  Socket sock = await Socket.connect('192.168.1.220', 80);
  sock.write("Poco connected !\n");

  runApp(new Connexion(sock));
}
//Aussi, quand on atteint une certaine quantité de bière, on coupe l'electrovanne !!!

//stateless : Pour les boutons, stateful : pour les interactions, checkbox et autres.

//Stateful : permet le userinteraction





class Connexion extends StatelessWidget {

  Socket socket;

  Connexion(Socket s) { //Constructeur pour prendre en argument la socket.
    this.socket = s;
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      home: Connexion_Form(
        channel : socket,
      ),
    );

  }
}






