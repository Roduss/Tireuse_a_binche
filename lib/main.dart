import 'package:flutter/material.dart';

import './app_screens/Connexion.dart';

import 'dart:io';


void main() async {
  Socket sock = await Socket.connect('192.168.1.220', 80);
  sock.write("Poco connected !\n");

  runApp(new Connexion(sock)); //ça tu vas le changer du coup
}


///TODO : Ajouter écran de connexion avec une textfield pour entrer l'adresse internet du bail
///Avec genre un timeout au cas ou ça foire, mais qui donne les infos limite.
///Mettre un bouton de déconnexion aussi sur la page des users.



class Connexion extends StatelessWidget {

  Socket socket;

  Connexion(Socket s) { //Constructeur pour prendre en argument la socket.
    this.socket = s;
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
  ///Il faudra donc passer cette channel sur les autres pages et ajouter notre page.
      home: Connexion_Form(
        channel : socket,
      ),
    );

  }
}






