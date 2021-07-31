import 'package:flutter/material.dart';

import 'map_1.dart';
import 'map_2.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/maps.png'), fit: BoxFit.cover)),
            ),
          ),
          SafeArea(
            child: Container(
              constraints: BoxConstraints.expand(height: double.infinity),
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey),
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(50))),
              transform: Matrix4.rotationZ(0.2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('images/icon-google-maps.png'))),
                  ),
                  Text('in Flutter',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700])),
                  SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Map1();
                        }));
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      child: Text(
                        'Google Maps v1',
                        style: TextStyle(color: Colors.white),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Map2();
                        }));
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.blue),
                      child: Text(
                        'Google Maps v2',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
