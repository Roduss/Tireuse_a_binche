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
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/foundation.dart';
import 'dart:io';
import '../GolbalValues.dart';

//Finir par ce lien : https://flutter.dev/docs/deployment/android

class Menu_binche_Form extends StatefulWidget {
  final Binche_user binche_user;
  final String appTitle;
  final Socket channel;
  final StreamController _onExitController;

  //final Socket channel;

  Menu_binche_Form(this.binche_user, this.appTitle, this._onExitController,
      {Key key, this.channel})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return Menu_binche_screen(
        this.binche_user, this.appTitle, this._onExitController);
  }
}

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

  TextEditingController grasgagne = TextEditingController();
  TextEditingController pompespourfit = TextEditingController();

  StreamController _onExitController = StreamController.broadcast();

  Menu_binche_screen(this.binche_user, this.appTitle, this._onExitController);
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Binche_user> userList;
  int count = 0;
  int quantitecheck = 1;
  double quant_totale;
  double bierebue = 0;
  double degalc;
  double contenance;
  double binche_restante = 0;
  double bieresolo = 0;

  final bierebuv2 = ValueNotifier(0); //Pour refresh pompes et gras gagné

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /* @override
  void dispose() {
    grasgagne.dispose();
    super.dispose();
  }*/

  changesOnField() {
    grasgagne.text = Calcgras();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  changesOnField2() {
    pompespourfit.text = Calcfit().toString();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  Future<Null> _read_contenance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = 'my_contenance_key';
    final key1 = 'my_deg_alc_key';
    final key2 = 'my_real_contenance_key';
    final value = prefs.getDouble(key) ?? 0.0;
    final value1 = prefs.getDouble(key1) ?? 0.0;
    final value2 = prefs.getDouble(key2) ?? 0.0;
    //print('function read, quant tot: $value, deg alc : $value1, contenance : $value2 \n');

    setState(() {
      quant_totale = value; //Sauvegarde la quantité totale.
      degalc = value1;
      contenance = value2;
    });
    //print("valeur quanttotale après récup : $quant_totale ");
  }

  @override
  void initState() {
    super.initState();
    bierebuv2.addListener(changesOnField);
    bierebuv2.addListener(changesOnField2);
    quant_totale = 0;
    degalc = 0;
    contenance = 0;
    _read_contenance();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    pompespourfit.text = Calcfit().toString();
    grasgagne.text = Calcgras();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(appTitle),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              //To control the back button on top of screen
              _save(); //Permet de sauvegarder la biere bue normalement.
            }),
      ),
      body: SingleChildScrollView(
        child: Center(
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
                      "Bues (cl):",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 20,
                          color: Colors.black),
                    )),
                    StreamBuilder(
                      stream: _onExitController.stream,
                      builder: (context, snapshot) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Text((() {
                            if (snapshot.hasData) {
                              bierebuv2
                                  .notifyListeners(); //Actualise taux alc et gras en tps reel
                              bierebue = double.parse(
                                      '${SeparateString(String.fromCharCodes(snapshot.data), 0)}') +
                                  binche_user.qtebinche;
                              bieresolo = double.parse(
                                      '${SeparateString(String.fromCharCodes(snapshot.data), 0)}') /
                                  100; // ?? 0.0;
                              return bierebue.toStringAsFixed(0);
                            }

                            return "loading";
                          })()),
                        );
                      },
                    ),
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
                      "Restantes (L):",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 20,
                          color: Colors.black),
                    )),
                    StreamBuilder(
                      stream: _onExitController.stream,
                      builder: (context, snapshot) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Text((() {
                            if (snapshot.hasData) {
                              binche_restante =
                                  contenance - quant_totale - bieresolo;
                              //En gros, on enleve la quantité totale et aussi ce qu'il se boit histoire d'actualiser en tps réel.
                              return binche_restante.toStringAsFixed(2);
                            }
                            return "loading";
                          })()),
                        );
                      },
                    ),
                  ],
                ),
                Delimitor(),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      "Température bière (°C)",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 20,
                          color: Colors.black),
                    )),
                    StreamBuilder(
                      stream: _onExitController.stream,
                      builder: (context, snapshot) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Text(snapshot.hasData
                              ? '${SeparateString(String.fromCharCodes(snapshot.data), 1)}'
                              : "loading"),
                        );
                      },
                    ),
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
                    StreamBuilder(
                      stream: _onExitController.stream,
                      builder: (context, snapshot) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Text((() {
                            if (snapshot.hasData) {
                              return Calctauxalc(degalc);
                            }

                            return "loading";
                          })()),
                        );
                      },
                    ),
                  ],
                ),
                Delimitor(),
                Row(
                  children: <Widget>[
                    FadeInImage.assetNetwork(
                      placeholder: 'images/loading.gif',
                      image:
                          'https://cdn.radiofrance.fr/s3/cruiser-production/2016/04/1bf93487-b769-4a8f-9aeb-42b421aa1672/838_obesite.jpg',
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
                    'Qui a le plus bu ce soir ?',
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
                    'Qui est le plus bourré ce soir ?',
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
    binche_user.qtebinche = bierebue;
    quant_totale = quant_totale + bieresolo;
    //debugPrint("On a fait le quantitecheck new user et la quantite est: $quant_totale car bieresolo vaut : $bieresolo \n ");
    _save_contenance(); //On sauvegarde avant de changer de user.
    //debugPrint("On part de menubinche, on a la bière bue : $bierebue et ce qu'on met ds la db : ${binche_user.qtebinche}");
    widget.channel.write("fer_electrovanne");
    //print("On envoie cette valeur de biere restante : $binche_restante");
    Navigator.pop(context, true);

    ///Voir si le "true fait pas chier"
  }

  String Calctauxalc(double degalc) {
    binche_user.degalc = (bierebue * degalc * 0.08) / (0.7 * binche_user.poids);
    return binche_user.degalc.toStringAsFixed(1);
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

  String Calcgras() {
    //1 demi = 150kcal. 1cl=6kcal --- 1 kg = 7000 kcal
    double result = (bierebue * 25) / 7000; //A check si double.parse est mieux
    //debugPrint("Pour le gras, on utilise cette valeur de bierebue : $bierebue\n ");
    return result.toStringAsFixed(2);
  }

  int Calcfit() {
    //1 pompe = 6 cal =>1000 cal = 1 kcal
    //Mais c'est trop, du coup on va dire : 15 pompes = 1 bière.
    double result = (bierebue / 50) * 15;
    //debugPrint("Pour les pompes, on utilise cette valeur de bierebue : $bierebue\n ");
    ///Car il peut y avoir bc de pompes
    return result.toInt();
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
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  SeparateString(String mystring, int number) {
    var newstring = mystring.split(" "); //Séparateur espace
    return newstring[number];
  }

  _save_contenance() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_contenance_key';
    prefs.setDouble(key, quant_totale);
    print('saved for quant totale $quant_totale');
  }

  void _save() async {
    moveToLastScreen();
    int result;
    if (binche_user.id != null) {
      //On update si tu existe déja
      result = await helper.updateUser(binche_user);
      print("Tu es existant, update et ton id est : $binche_user.id");
    } else {
      print("Erreur de bdd");
    }

    if (result != 0) {
      //Sucess
      print("Success saving bdd");
    } else {
      //Pas sucess
      print("Problems saving bdd");
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
