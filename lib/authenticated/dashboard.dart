import 'package:flutter/material.dart';

import 'package:sout_development/authenticated/header.dart';
import 'package:provider/provider.dart';
import 'package:sout_development/providers/auth.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Material(
      child: SingleChildScrollView(
        child: ChangeNotifierProvider(
            create: (context) => Auth(),
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Color(0xFFecf0f1),
                child: Center(
                    child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 15,
                      right: 20.0,
                      left: 20.0,
                      bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Header(true),
                      SizedBox(
                        height: 10.0,
                      ),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Container(
                              height: MediaQuery.of(context).size.height / 2.5,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 5,
                                      blurRadius: 3,
                                      offset: Offset(0, 1),
                                    )
                                  ]),
                              child: Stack(
                                children: <Widget>[
                                  AspectRatio(
                                      aspectRatio: 18.0 / 17.0,
                                      child: Image(
                                          image: AssetImage(
                                            "assets/caution.png",
                                          ),
                                          fit: BoxFit.cover)),
                                ],
                              ))),
                      Padding(
                          padding: EdgeInsets.only(
                              top: 18.0, left: 23.0, right: 23.0),
                          child: Center(
                              child: Column(
                            children: <Widget>[
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 60,
                                    child: FlatButton(
                                      child: Text('My Circle',
                                          style: TextStyle(
                                            fontSize: 20,
                                          )),
                                      onPressed: () {
                                        /*Navigator.of(context)
                                        .push(_myCircleRoute());*/
                                      },
                                      color: Color(0xFF3edd9c),
                                      textColor: Colors.white,
                                      padding: EdgeInsets.all(8.0),
                                    ),
                                  )),
                              SizedBox(height: 23.0),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 60,
                                    child: FlatButton(
                                      child: Text('Share my location',
                                          style: TextStyle(
                                            fontSize: 20,
                                          )),
                                      onPressed: () {},
                                      color: Color(0xFF3edd9c),
                                      textColor: Colors.white,
                                      padding: EdgeInsets.all(8.0),
                                    ),
                                  )),
                              SizedBox(height: 23.0),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 60,
                                    child: FlatButton(
                                      child: Text('Emergency services',
                                          style: TextStyle(
                                            fontSize: 20,
                                          )),
                                      onPressed: () {},
                                      color: Color(0xFF3edd9c),
                                      textColor: Colors.white,
                                      padding: EdgeInsets.all(8.0),
                                    ),
                                  ))
                            ],
                          )))
                    ],
                  ),
                )))),
      ),
    );
  }
}
