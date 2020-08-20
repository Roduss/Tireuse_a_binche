import 'dart:async';
import 'package:flutter/material.dart';

import '../utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/foundation.dart';
import 'dart:io';

class Settings_Form extends StatefulWidget {
  final Socket channel;

  Settings_Form({Key key, this.channel}) : super(key: key);

  @override
  Settings_Screen createState() => Settings_Screen();
}
/*class Jsonval { //Json objects pour envoi plus simple
  final String deg_alc;
  final String contenance;

  Jsonval(this.deg_alc, this.contenance);

  Jsonval.fromMappedJson(Map<String, dynamic> json)
      : deg_alc = json['deg_alc'],
        contenance = json['contenance'];

  Map<String, dynamic> toJson() =>
      {
        'deg_alc': deg_alc,
        'contenance': contenance,
      };
}
*/

class Settings_Screen extends State<Settings_Form> {
  DatabaseHelper helper = DatabaseHelper();

  TextEditingController tauxalc = TextEditingController();
  TextEditingController taillefut = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    final appTitle = 'Paramétrage tireuse';

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
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: ListView(
            children: <Widget>[
              TextField(
                controller: tauxalc,
                style: textStyle,
                decoration: InputDecoration(
                    labelText: "Degré d'alcool du fut",
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              SizedBox(height: 50),
              TextField(
                controller: taillefut,
                style: textStyle,
                decoration: InputDecoration(
                    labelText: "Contenance du fut",
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              RaisedButton(
                color: Theme.of(context).primaryColorDark,
                textColor: Theme.of(context).primaryColorLight,
                child: Text(
                  'Envoi',
                  textScaleFactor: 1.5,
                ),
                onPressed: () =>
                    _showDialog(context, tauxalc.text, taillefut.text),
              ),
              RaisedButton(
                color: Theme.of(context).primaryColorDark,
                textColor: Theme.of(context).primaryColorLight,
                child: Text(
                  '!Reset BDD!',
                  textScaleFactor: 1.5,
                ),
                onPressed: () =>
                _showmyDialog(context),
              ),
            ],
          ),
        ));
  }

  _save_contenance(double mydeg_alc, double mycontenance) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_contenance_key';
    final key1 = 'my_deg_alc_key';
    final key2 = 'my_real_contenance_key';

    if (mydeg_alc > 0 &&
        mydeg_alc < 50 &&
        mycontenance > 0 &&
        mycontenance < 30) {
      prefs.setDouble(key, 0);
      prefs.setDouble(key1, mydeg_alc);
      prefs.setDouble(key2, mycontenance);
      print('binche bue remise à zéro maggle.');
    } else {
      showSnackBar(context, "Mauvaises val dukon, explosion tireuse !");
    }
  }

  Future<void> _showDialog(
      BuildContext context, String deg_alc, String contenance) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Envoyer ?"),
            content: new Text(
                "C'est les bonnes valeurs hein ? Sinon ça fout la merde - Utiliser un . pour nb décimaux !!!"),
            actions: <Widget>[
              FlatButton(
                child: Text("Oui"),
                onPressed: () {
                  //_sendvalue(context, deg_alc, contenance);
                  _save_contenance(
                      double.parse(deg_alc), double.parse(contenance));
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


  Future<void> _showmyDialog(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Reset?"),
            content: new Text(
                "Fais gaffe, ça va casser la soirasse"),
            actions: <Widget>[
              FlatButton(
                child: Text("Oui"),
                onPressed: () {
                  Resetbdd();
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


  void showSnackBar(BuildContext context, String message) {
    var snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: "J'explose aussi",
        onPressed: () {
          //Remettre l'user dans le game, a voir si on garde. Ou si on supprimer vraiment comme ça.
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);

    ///TODO : vérifier que ça fonctionne, sinon changer comme dans connexion.dart.
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
  void Resetbdd() async {
    bool result;
      result = await helper.resetQuantBue();
      if (result == true) {
        print("Sucess pour remettre alcool a 0");
      } else {
        print("Error updating db :(");
        print(result);
      }
    }
  }

