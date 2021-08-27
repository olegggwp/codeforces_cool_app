import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_hard/archieveList.dart';
import 'package:go_hard/maindata.dart';
import 'package:go_hard/settingsApp.dart';

import 'main.dart';

class CoolDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Drawer(
        child: ListView(
      children: [
        DrawerHeader(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.blue, Colors.teal])),
            child: Container(
              child: Column(
                children: [
                  Material(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image.asset(
                        'images/img.jpg',
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                  Text(
                    User.name,
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            )),
        TextButton(
            child: Text("Main"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
        ),
        TextButton(
          child: Text("Archieve"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ArchieveList()),
            );
          },
        ),
        TextButton(
          child: Text("Settings"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsLayout()),
            );
          },
        ),
        Text("haha"),
        Text("huhu")
      ],
    ));
  }
}
