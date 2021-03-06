import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sout_development/providers/auth.dart';

class Header extends StatefulWidget {
  Header(this.nameVisible);
  final bool nameVisible;

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool locationOn = false;

  @override
  Widget build(BuildContext context) {
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;

    final auth = Provider.of<Auth>(context);

    return Container(
        height: MediaQuery.of(context).size.height / 12,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                widget.nameVisible
                    ? Text('Emma',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            letterSpacing: .8,
                            color: Colors.black.withOpacity(.7),
                            fontSize: 33.0 * curScaleFactor,
                            fontWeight: FontWeight.bold))
                    : Text(''),
                SizedBox(height: 1.2),
                widget.nameVisible
                    ? Text('June O7 2020, 6:39am',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            letterSpacing: .8,
                            color: Colors.black.withOpacity(.5),
                            fontSize: 10.0 * curScaleFactor,
                            fontWeight: FontWeight.bold))
                    : Text('')
              ],
            ),
            Container(
              width: 100.0,
              height: 50.0,
              //color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('My location',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          letterSpacing: .8,
                          color: Colors.black.withOpacity(.5),
                          fontSize: 10 * curScaleFactor,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 1.4),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Container(
                        height: 28.0,
                        width: 70.0,
                        color: Colors.white,
                        child: FlatButton(
                            onPressed: () {
                              setState(() {
                                locationOn
                                    ? locationOn = false
                                    : locationOn = true;
                              });
                            },
                            padding: EdgeInsets.all(0.0),
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                    top: 1.0,
                                    left: 12.0,
                                    right: 12.0,
                                    bottom: 1.0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        AnimatedOpacity(
                                            opacity: locationOn ? 1 : 0,
                                            duration:
                                                Duration(milliseconds: 500),
                                            child: Text('ON')),
                                        AnimatedOpacity(
                                            opacity: locationOn ? 0 : 1,
                                            duration:
                                                Duration(milliseconds: 500),
                                            child: Text('OFF'))
                                      ],
                                    )),
                                AnimatedPositioned(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease,
                                    top: 1.0,
                                    right: locationOn ? 1.0 : 40.0,
                                    bottom: 1.0,
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        child: Container(
                                          width: 28.0,
                                          height: 28.0,
                                          child: FlatButton(
                                            child: Text(
                                              '',
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                locationOn
                                                    ? locationOn = false
                                                    : locationOn = true;
                                              });
                                            },
                                            color: locationOn
                                                ? Color(0xFF3edd9c)
                                                : Colors.red.withOpacity(.9),
                                            padding: EdgeInsets.all(8.0),
                                          ),
                                        )))
                              ],
                            )),
                      ))
                ],
              ),
            )
          ],
        ));
  }
}
