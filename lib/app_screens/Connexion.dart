import 'dart:async';
import 'package:flutter/material.dart';

import 'package:tireuse_a_binche/app_screens/Inscription.dart';
import 'package:tireuse_a_binche/app_screens/Menu_binche.dart';
import '../models/binche_user_data.dart';
import '../utils/database_helper.dart';
import '../main.dart';
import 'package:sqflite/sqflite.dart';
import './Settings.dart';
import '../GolbalValues.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/foundation.dart';
import 'dart:io';

///Ici on liste les joueurs déja inscrits.
///On met aussi un bouton pour ajouter un joueur
///
///

class Connexion_Form extends StatefulWidget {
  final Socket channel;
  Connexion_Form({Key key, this.channel}) : super(key: key);
//Constructeur pour le channel

  @override
  State<StatefulWidget> createState() {
    return Connexion_screen();
  }
}

class Connexion_screen extends State<Connexion_Form> {
  String appTitle = 'Connexion de chameau';

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Binche_user> userList;
  StreamController _onExitController = new StreamController.broadcast();
  Stream get myStream => _onExitController.stream;
  int count = 0;
  int counter = 0;
  double timelastbinche; //= await _read();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<Null> _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_double_key';
    final value = prefs.getDouble(key) ?? 0.0;
    print('function read: $value');

    setState(() {
      timelastbinche = value; //Normalement on à la bonne val
    });
    print("valeur timelastbinche après setstate : $timelastbinche ");
  }

  @override
  void initState() {
    super.initState();
    timelastbinche = 0;
    _read();
  }

  @override
  Widget build(BuildContext context) {
    if (userList == null) {
      userList = List<Binche_user>();
      updateListView(); //Permet de récupérer la db dans l'ordre choisi !
    }

    if (counter == 0) {
      ///C'est ici que le stream suscribe a mon widgetchannel.

      counter++;
      //debugPrint("Valeur counter $counter");
      _onExitController.addStream(widget.channel);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text(appTitle), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Settings_Form(
                      channel: widget
                          .channel)), //Fonctionne, permet de passer la socket sur d'autres écrans !!!
            );
          },
        )
      ]),
      body: getListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          naviguateToDetail(Binche_user('', 0, 0),
              'Allez, rejoins nous mon chameau'); //On crée un user sans nom avec 0 binches bues.
        }, //Poids par défaut : 0 kg.
        tooltip: 'Nouveau ? Rejoins nous !',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            title: Text(
              this.userList[position].name,
              style: titleStyle,
            ),
            leading: Icon(Icons.accessibility),
            trailing: GestureDetector(
              child: Icon(Icons.delete_forever),
              onTap: () {
                _showDialog(position);
              },
            ),
            onTap: () {
              widget.channel.write(
                  "ouv_electrovanne\n"); //Envoie de la variable d'ouverture électrovanne

              Resetbdd(timelastbinche);
              timelastbinche = _timeOfDayToDouble(
                  TimeOfDay.now()); //Réactualisation de la valeur
              _save(timelastbinche); //On écrit ds la mémoire
              naviguateToMenu(this.userList[position],
                  'Welcome back ${userList[position].name}');
            },
            onLongPress: () {
              naviguateToDetail(this.userList[position],
                  'change de nom petit chameau'); //On chope la position cliquée.
              //Permettre d'éditer, changer le nom en haut de l'app quoi.
            },
          ),
        );
      },
    );
  }

  double _timeOfDayToDouble(TimeOfDay tod) =>
      tod.hour + tod.minute / 60.0; //Pour réinitialiser la db à midi.

  void Resetbdd(double heurelastbinche) async {
    var now = _timeOfDayToDouble(TimeOfDay.now());
    bool result;
    print("On a heurelastbinche = $heurelastbinche et now : $now \n");
    print(
        "LE résultat de la soustraction des heures est : ${now - heurelastbinche}\n");
    if (now - heurelastbinche > 0.02 && heurelastbinche != 0 || now - heurelastbinche <0 && heurelastbinche != 0) {


      result = await databaseHelper.resetQuantBue();
      if (result == true) {
        print("Sucess pour remettre alcool a 0");
        updateListView();
      } else {
        print("Error updating db :(");
        print(result);
      }
    }
  }

  _save(double value) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_double_key';

    prefs.setDouble(key, value);
    print('saved $value');
  }

  void _delete(BuildContext context, Binche_user user) async {
    int result = await databaseHelper.deleteUser(user.id);

    debugPrint('Voici ton id : $user.id');
    if (result != 0) {

      showSnackBar(context, "Adieu chameau");
      updateListView();

    } else {
      //_scaffoldKey.currentState.showSnackBar(snackBar1);
      showSnackBar(context, "Problème de suppression");
    }
  }

  void naviguateToDetail(Binche_user user, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      //Il reçoit le true to movetolastscreen().
      return Inscription_Form(user, title);
    }));

    if (result == true) {
      updateListView();
      debugPrint("On update la listview en revenant de l'inscription");
    }
  }

  //Function to naviguate to menu binche, quand t'es connecté.

  void naviguateToMenu(Binche_user user, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Menu_binche_Form(user, title, _onExitController,
          channel: widget.channel);
    }));
    if (result == true) {
      updateListView();
      debugPrint("On update la listview en revenant du menu");
    }
  }

  void showSnackBar(BuildContext context, String message) {
    var snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: "UNDO",
        onPressed: () {
          //Remettre l'user dans le game, a voir si on garde. Ou si on supprimer vraiment comme ça.
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> dbFuture =
        databaseHelper.initializeDatabase(); //On ouvre la db
    dbFuture.then((database) {
      Future<List<Binche_user>> userListFuture =
          databaseHelper.getUserList(); //On rechoppe la liste des users
      userListFuture.then((userList) {
        setState(() {
          this.userList = userList; //On envoie la nouvelle userList a la db !
          this.count = userList.length; //et sa nouvelle longueur
        });
      });
    });
  }

  Future<void> _showDialog(int position) {
    //Probleme de context, à voir, garder le <Future> je pense
    //Mais du coup avec le Scaffold il y a un truc qui foire, essaie de chercher l'erreur sur google, ça devrait faire ;)

    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Aperoooooo"),
            content: new Text("Tu vas supprimer un chamo, t'es sur(e) ?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Oui"),
                onPressed: () {
                  _delete(context, userList[position]);

                  ///Check qu'il faille pas update la list après.
                  debugPrint(
                      "Tu dois etre deleté, nom user : ${userList[position]}, position : $position");
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Non"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
