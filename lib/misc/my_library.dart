import 'package:flutter/material.dart';
Widget botonRojo(BuildContext context, String text, Function fun ) {
  return new Container(
    width: MediaQuery.of(context).size.width,
    margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
    alignment: Alignment.center,
    child: new Row(
      children: <Widget>[
        new Expanded(
          child: new FlatButton(
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
            color: Colors.green,
            onPressed: () => fun,
            child: new Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 20.0,
              ),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Expanded(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}





Widget cardButon(BuildContext context, icon, String text, Function fun ) {
  return


    InkWell(
        onTap: () => fun,
        child:
        Card(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            elevation: 10.0,
            child:
            Container(
                padding: new EdgeInsets.all(5.0),
                width: MediaQuery.of(context).size.width/2 - 30,
                height: 140.0,
                child:

                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(icon,size: 40.0,),
                      Text(text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                        //color: Colors.white,
                        fontSize: 17.0,

                      ))
//onTap: () => _sendNotification(estado.idEstado),
                    ]
                )
            )
        )
    );
}