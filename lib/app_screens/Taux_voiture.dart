import 'package:flutter/material.dart';
import '../main.dart';

class Alcoolo_voiture_Form extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Alcoolo_voiture_Screen();
  }
}

class Alcoolo_voiture_Screen extends State<Alcoolo_voiture_Form> {

  //String nb_binche="", deg_alc="", poids="";
  TextEditingController NbbincheControlled = TextEditingController();
  TextEditingController DegalcControlled = TextEditingController();
  TextEditingController PoidsControlled = TextEditingController();

  var displayAlcool = '';

  @override
  Widget build(BuildContext context) {
    return Center(
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
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Nb binches bues mon chameau"),
                    keyboardType: TextInputType.numberWithOptions(),
                     controller : NbbincheControlled,

                  ),
                ),

              ],
            ),


      Row(
        children : <Widget>[

          Expanded(
            child: TextField(
              decoration: InputDecoration(
                  hintText: "Deg d'alcool des binches"),
              keyboardType: TextInputType.numberWithOptions(),
              controller: DegalcControlled,

            ),
          ),
        ],
      ),


        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Ton poids"),
                keyboardType: TextInputType.numberWithOptions(),
                controller: PoidsControlled,

              ),
            ),
          ],
        ),


            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget>[
                Expanded(
                  child :
                RaisedButton(

                  padding: EdgeInsets.all(20),
                  onPressed: () {
                  setState(() {
                    this.displayAlcool = _CalcDegAlc();
                  });

                  },
                  child: Text('Calcule',),
                ),
                ),
                Expanded(
                  child :
                  RaisedButton(

                    padding: EdgeInsets.all(20),
                    onPressed: () {
                      setState(() {
                        _Reset();
                      });

                    },
                    child: Text('Rosette',),
                  ),
                ),
              ],
            ),

            Row(
              children: <Widget>[
                Expanded(
            child :
                Padding(
                  padding: EdgeInsets.all(20),
                  child :
                   Text(this.displayAlcool)
                   ,)
                ),
              ],
    )

          ],
        ),
      ),
    );
  }



String _CalcDegAlc(){

  double nbbinche = double.parse(NbbincheControlled.text);
  double deg_alc = double.parse(DegalcControlled.text);
  double poids = double.parse(PoidsControlled.text);
  double alcool=(nbbinche*deg_alc*0.8)/(0.7*poids);
  double heure_conduite;
  String result;

  alcool=num.parse(alcool.toStringAsFixed(2));
  heure_conduite=(alcool-0.5)/0.15;
  heure_conduite=num.parse(heure_conduite.toStringAsFixed(1));
  if(alcool>0.5) {
    result = 'Ton degré d\'alcoolémie est de : $alcool g/L Il faut que tu sois à 0.5g/L grand fou ! Il faudra donc attendre $heure_conduite h avant de tchatcher la route proprement (0.5g/l)';
  }
  else
    {
      result = 'Ton degré d\'alcoolémie est de : $alcool g/L, tu dois boire pour pouvoir espérer drifter un jour';
    }


  return result;
}


void _Reset(){
  NbbincheControlled.text='';
  DegalcControlled.text='';
  PoidsControlled.text='';
  displayAlcool='';
}
}
