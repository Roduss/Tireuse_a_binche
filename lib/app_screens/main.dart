import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';//To load the images with cache

import './Accueil.dart';
import './Inscription.dart';
import './Connexion.dart';
import './Menu_binche.dart';
import './Classement_alcoolo.dart';
import './Taux_voiture.dart';

void main() {
  runApp(new Accueil());
}

//stateless : Pour les boutons, stateful : pour les interactions, checkbox et autres.

//Stateful : permet le userinteraction


class Accueil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Bienvenue au FAAT club';

    return MaterialApp( //Besoin du materialApp pour faire un home.
        title: appTitle,
        theme: ThemeData.dark(),
        home: Scaffold(
        appBar: AppBar(
        title: Text(appTitle),
        ),
        body: Accueil_screen()
    ),
    );
  }
}



class Connexion extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final appTitle = 'Connexion de chameau';
    return MaterialApp(
        title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title : Text(appTitle),
        ),

      body : Connexion_Form(),

      ),
    );
  }
}



class Inscription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Allez, rejoins nous mon chameau';
    return MaterialApp(
        title: appTitle,
        home: Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body : Inscription_Form()
        ),
    );
  }
}

class Menu_binche extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final appTitle = 'Aperooo';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title : Text(appTitle),
        ),

        body : Menu_binche_Form()
      ),
    );
  }
}


class Alcoolo_voiture extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Conduire ou choisir, il faut boire';
    return MaterialApp(
      title:  appTitle,
        home:Scaffold(
          appBar: AppBar(
          title : Text(appTitle),
          ),
          body : Alcoolo_voiture_Form()
        ),
    );
  }
}


class Classement_alcoolo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Regroupement des alcoolos du coins';
    return MaterialApp(
      title:  appTitle,
      home:Scaffold(
          appBar: AppBar(
            title : Text(appTitle),
          ),
          body : Classement_alcoolo_Form()
      ),
    );
  }
}