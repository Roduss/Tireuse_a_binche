import 'package:flutter/material.dart';
import './main.dart';
import 'package:cached_network_image/cached_network_image.dart'; //To load the images with cache

//Récupérer de la data dans une textbox.

class Menu_binche_Form extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Menu_binche_screen();
  }
}

class Delimitor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return SizedBox( //Delimiteur entre chaque data.
        height: 20,
        child : Center(
            child : Container(
              margin : EdgeInsetsDirectional.only(start : 1.0, end : 1.0),
              height: 2,
              color : Colors.black,
            )
        )
    );
  }
}

class Menu_binche_screen extends State<Menu_binche_Form> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(left:10,top:10),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Row(
              children : <Widget>[
                 FadeInImage.assetNetwork(
              placeholder: 'images/loading.gif',
              image:
                  'https://assets.afcdn.com/recipe/20170607/67554_w300h300c1.jpg',
              width: 130,
              height: 70,
            ),
                Expanded(
                  child : Text(
                    "Bues :",
                    textDirection: TextDirection.ltr,
                    style : TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 20,
                      color:Colors.black),
                    )
                  ),
                Expanded(
          child : Text(" TODO Récupérer nb binches ici")

      ),

                ],
                ),

            Delimitor(),

            Row(
              children : <Widget>[
                FadeInImage.assetNetwork(
                  placeholder: 'images/loading.gif',
                  image:
                  'https://assets.afcdn.com/recipe/20170607/67554_w300h300c1.jpg',
                  width: 130,
                  height: 70,
                ),
                Expanded(
                    child : Text(
                      "Restantes :( :",
                      textDirection: TextDirection.ltr,
                      style : TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 20,
                          color:Colors.black),
                    )
                ),
                Expanded(
                    child : Text(" TODO Récupérer nb binches  restantes ici")

                ),

              ],
            ),

            Delimitor(),

            Row(
              children: <Widget>[
                Expanded(
                    child : Text(
                      "Ton taux d'alcoolémie ma couille :",
                      textDirection: TextDirection.ltr,
                      style : TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 20,
                          color:Colors.black),
                    )
                ),
                Expanded(
                    child : Text(
                      "TODO : Calcul taux alcoolémie en fonction nb binches bues",
                      textDirection: TextDirection.ltr,
                      style : TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 20,
                          color:Colors.black),
                    )
                ),
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
                    child : Text(
                      "Le gras gagné :",
                      textDirection: TextDirection.ltr,
                      style : TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 20,
                          color:Colors.black),
                    )
                ),
                Expanded(
                    child : Text(
                      "TODO : Calcul kcal et tout",
                      textDirection: TextDirection.ltr,
                      style : TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 20,
                          color:Colors.black),
                    )
                ),
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
                    child : Text(
                      "Nb de pompes nécéssaires pour redevenir fit :",
                      textDirection: TextDirection.ltr,
                      style : TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 20,
                          color:Colors.black),
                    )
                ),
                Expanded(
                    child : Text(
                      "TODO : Calcul kcal d'une pompe et tout",
                      textDirection: TextDirection.ltr,
                      style : TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 20,
                          color:Colors.black),
                    )
                ),
              ],
            ),
            Delimitor(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  padding: EdgeInsets.all(20),
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Alcoolo_voiture()),
                    );
                  },
                  child: Text('Quand reprendre la ture-voi ?',
                  /*style : TextStyle(
                  fontSize : 12),*/
                  ),
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
              ],

            ),
            ],
            ),


        ),
      );

  }
}
