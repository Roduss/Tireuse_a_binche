import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tireuse_a_binche/app_screens/Classement_alcoolo.dart';
import 'package:tireuse_a_binche/app_screens/Classement_bourre.dart';
import 'package:tireuse_a_binche/models/binche_user_data.dart';
import '../main.dart';
import 'package:cached_network_image/cached_network_image.dart'; //To load the images with cache
import '../models/binche_user_data.dart';
import '../utils/database_helper.dart';
import './Taux_voiture.dart';
import '../models/binche_user_data.dart';
import '../utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import './Connexion.dart';

import 'package:flutter/foundation.dart';
import 'dart:io';


///TOCHECK : L'écran s'actualisera t'il ???

class Menu_binche_Form extends StatefulWidget {
  final Binche_user binche_user;
  final String appTitle;
  final Socket channel;

  //final Socket channel;

  Menu_binche_Form(this.binche_user, this.appTitle,{Key key, this.channel}) : super (key:key);

  @override
  State<StatefulWidget> createState() {
    return Menu_binche_screen(this.binche_user, this.appTitle);
  }
}

//Vérifier qu'on ait une actualisation en tps réel, sinon
// il faut faire des SetState des variables qui sont modifiées ==>
//Elles engendrent un rafraichissement
/// Voir : https://medium.com/@thibault60000/flutter-stateful-stateless-state-fr-widgets-55988f0b439c

class Delimitor extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        //Delimiteur entre chaque data.
        height: 20,
        child: Center(
            child: Container(
          margin: EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
          height: 2,
          color: Colors.black,
        )));
  }
}

class Menu_binche_screen extends State<Menu_binche_Form> {
  DatabaseHelper helper = DatabaseHelper();
  String appTitle;
  Binche_user binche_user; //L'utilisateur qui est connecté.

  TextEditingController binchebue = TextEditingController();
  TextEditingController bincherestante = TextEditingController();
  TextEditingController tauxalc = TextEditingController();
  TextEditingController grasgagne = TextEditingController();
  TextEditingController pompespourfit = TextEditingController();



  Menu_binche_screen(this.binche_user, this.appTitle);
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Binche_user> userList;
  int count = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();





  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    /*if (userList == null) {
      userList = List<Binche_user>();
      updateListView();//Permet de récupérer la db dans l'ordre choisi !
    }*/
    ///Regarder si besoin de ces lignes au dessus.

    binchebue.text = binche_user.qtebinche.toString();

    //TODO: gérer le binche restante
    tauxalc.text = Calctauxalc().toString();
    grasgagne.text = Calcgras().toString();
    pompespourfit.text = Calcfit().toString();


    return Scaffold(
      key: _scaffoldKey,

      appBar: AppBar(
        title: Text(appTitle),

        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              //To control the back button on top of screen
              moveToLastScreen();
            }),

      ),
      body: SingleChildScrollView(

        child : Center(
        child: Container(
          padding: EdgeInsets.only(left: 10, top: 10),
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  FadeInImage.assetNetwork(
                    placeholder: 'images/loading.gif',
                    image:
                        'https://assets.afcdn.com/recipe/20170607/67554_w300h300c1.jpg',
                    width: 130,
                    height: 70,
                  ),
                  Expanded(
                      child: Text(
                    "Bues (25cl):",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 20,
                        color: Colors.black),
                  )),
                  Expanded(
                      child: TextField(
                    //Normalement ça devrait s'update.
                    controller: binchebue,
                    style: textStyle,
                        focusNode: new AlwaysDisabledFocusNode(),
                  )),
                ],
              ),
              Delimitor(),
              Row(
                children: <Widget>[
                  FadeInImage.assetNetwork(
                    placeholder: 'images/loading.gif',
                    image:
                        'https://assets.afcdn.com/recipe/20170607/67554_w300h300c1.jpg',
                    width: 130,
                    height: 70,
                  ),
                  Expanded(
                      child: Text(
                    "Restantes :",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 20,
                        color: Colors.black),
                  )),
                  StreamBuilder(
                    stream: widget.channel,
                    builder: (context, snapshot) {
                      if(snapshot.hasError){
                        debugPrint(snapshot.error);
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Text(snapshot.hasData
                            ? '${String.fromCharCodes(snapshot.data)}'
                            : "loading"),
                      );
                    },

                  ),
                  
                  ///ça maaaarche ! Sauf au retour, il faut flush quand on fait un changement de screen je pense, parce que le snapshot est pas vide !
                  /*Expanded(
                      child: TextField(
                    //Normalement ça devrait s'update.
                    controller: bincherestante,
                    style: textStyle,
                        focusNode: new AlwaysDisabledFocusNode(),
                  )),*/
                  //TODO:Faire ça en fonction de la quantité du fut qu'il faudra rentrer et stocket sur l'arduino
                ],
              ),
              Delimitor(),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                    "Ton taux d'alcoolémie ma couille : (g/L)",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 20,
                        color: Colors.black),
                  )),
                  Expanded(
                      child: TextField(
                          //Normalement ça devrait s'update.
                          controller: tauxalc,
                          style: textStyle,
                          focusNode: new AlwaysDisabledFocusNode(),
                          onChanged: (value) {
                            updateTauxAlc();
                          })),
                ],
              ),
              Delimitor(),
              Row(
                children: <Widget>[
                  FadeInImage.assetNetwork(
                    placeholder: 'images/loading.gif',
                    image:
                        'https://optimyse-db56.kxcdn.com/wp-content/uploads/2016/03/consequences-de-l-obesite.png',
                    width: 130,
                    height: 70,
                  ),
                  Expanded(
                      child: Text(
                    "Le gras gagné : (kg)",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 20,
                        color: Colors.black),
                  )),
                  Expanded(
                      child: TextField(
                    //Normalement ça devrait s'update.
                    controller: grasgagne, //1 binche de 25 = 150 kcal
                    focusNode: new AlwaysDisabledFocusNode(),

                    style: textStyle,
                  )),
                ],
              ),
              Delimitor(),
              Row(
                children: <Widget>[
                  FadeInImage.assetNetwork(
                    placeholder: 'images/loading.gif',
                    image:
                        'https://i.pinimg.com/originals/bd/9b/8c/bd9b8c97d8026924d12a189dc38f3ee7.jpg',
                    width: 130,
                    height: 70,
                  ),
                  Expanded(
                      child: Text(
                    "Nb de pompes nécéssaires pour redevenir fit :",
                    textDirection: TextDirection.ltr,

                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 20,
                        color: Colors.black),
                  )),
                  Expanded(
                      child: TextField(
                    //Normalement ça devrait s'update.
                    controller: pompespourfit,
                        focusNode: new AlwaysDisabledFocusNode(),
                    style: textStyle,
                  )),
                ],
              ),
              Delimitor(),


              RaisedButton(
                    padding: EdgeInsets.all(20),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Alcoolo_voiture_Form()),
                      );
                    },
                    child: Text(
                      'Quand reprendre la ture-voi ?',
                      /*style : TextStyle(
                  fontSize : 12),*/
                    ),
                  ),
              Delimitor(),
                  RaisedButton(
                    padding: EdgeInsets.all(20),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Classement_alcoolo_Form()),
                      );
                    },
                    child: Text(
                      'Qui a le plus bu ce soir ?', //TODO : en mode qui a le plus bu, et qui est le plus bourré.
                      /*style : TextStyle(
                        fontSize : 12),*/
                    ),
                  ),
              Delimitor(),

              RaisedButton(
                padding: EdgeInsets.all(20),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Classement_bourre_Form()),
                  );
                },
                child: Text(
                  'Qui est le plus bourré ce soir ?', //TODO : en mode qui a le plus bu, et qui est le plus bourré.
                  /*style : TextStyle(
                        fontSize : 12),*/
                ),
              ),

              Delimitor(),



            ],
          ),
        ),
      ),
    ),
    );
  }



  void moveToLastScreen() {
    Navigator.pop(context, true); ///Voir si le "true fait pas chier"
  }

  void updateTauxAlc() {
    binche_user.degalc = double.parse(tauxalc.text);

    ///A voir si nécéssaire, parce que dans inscription on fait juste un updatename.
    //updateListView(); //Vérifier que ça marche, ou sinon il faut juste update_user ???


    //Il faut aussi envoyer la valeur à la db !
  }

//Essayer de garder la qtebinche bue pour les calculs je pense.
  double Calctauxalc() {
    double alcool =
        (binche_user.qtebinche.toDouble()); //*deg_alc*0,8)/0,7*poids


    return alcool;
  }

  void updateListView(){
    final Future<Database> dbFuture = databaseHelper.initializeDatabase(); //On ouvre la db
    dbFuture.then((database){

      Future<List<Binche_user>> userListFuture = databaseHelper.getUserList(); //On rechoppe la liste des users
      userListFuture.then((userList){
        setState(() {
          this.userList = userList; //On envoie la nouvelle userList a la db !
          this.count = userList.length; //et sa nouvelle longueur
        });
      });
    });
  }

  double Calcgras() {
    //1 demi = 150kcal. --- 1 kg = 7000 kcal
    double result = (binche_user.qtebinche.toDouble() * 150) / 7000;
    return result;
  }

  double Calcfit() {
    //1 pompe = 6 cal =>1000 cal = 1 kcal
    //Mais c'est trop, du coup on va dire : 15 pompes = 1 bière.
    double result = binche_user.qtebinche.toDouble() * 15;

    ///Car il peut y avoir bc de pompes
    return result;
  }


  void showSnackBar(BuildContext context, String message) {
    var snackBar = SnackBar(

      content: Text(message),
      action: SnackBarAction(
        label: "Seeeers toi à boire mon graaand !",
        onPressed: () {
          //Remettre l'user dans le game, a voir si on garde. Ou si on supprimer vraiment comme ça.
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar); ///TODO : vérifier que ça fonctionne, sinon changer comme dans connexion.dart.
  }

  /*void dispose(){
    widget.channel.flush();
    super.dispose();
  }*/

}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}


