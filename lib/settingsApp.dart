import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_hard/madrawer.dart';

import 'maindata.dart';

class SettingsLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      drawer: CoolDrawer(),
      body: ListView(
        children: [
          NameField(),
          RateField(),
        ],
      ),
    );
  }
}

class NameField extends StatefulWidget {
  @override
  createState() => new NameFieldState();
}

class NameFieldState extends State<NameField> {
  bool editingMode = false;
  Color? nameclr = Colors.green[100];

  NameFieldState({this.editingMode = false});

  @override
  Widget build(BuildContext context) {
    if (!this.editingMode) {
      return Padding(
          padding: EdgeInsets.fromLTRB(8.0, 10.0, 10.0, 8.0),
          child: Row(
            children: [
              Icon(Icons.account_circle_outlined, color: nameclr,),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(User.handle,
                    style: TextStyle(
                      fontSize: 18,
                    )),
              )),
              IconButton(
                  onPressed: () {
                    setState(() {
                      editingMode = !editingMode;
                    });
                  },
                  icon: Icon(Icons.edit))
            ],
          ));
    } else {
      String tempname = "";
      return Padding(
          padding: EdgeInsets.fromLTRB(8.0, 10.0, 10.0, 8.0),
          child: Row(
            children: [
              Icon(Icons.account_circle_outlined),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(hintText: "Type here"),
                  initialValue: User.handle,
                  onFieldSubmitted: (String submited) {
                    User.handle = submited;
                    User.setHandle();
                    setState(() {
                      editingMode = !editingMode;
                    });
                  },
                  onChanged: (String txt) {
                    tempname = txt;
                  },
                ),
              )),
              IconButton(
                  onPressed: () {
                    if (tempname != "") User.handle = tempname;
                    User.setHandle();
                    setState(() {
                      editingMode = !editingMode;
                    });
                  },
                  icon: Icon(Icons.done))
            ],
          ));
    }
  }
}

class RateField extends StatefulWidget {
  @override
  createState() => new RateFieldState();
}

class RateFieldState extends State<RateField> {
  bool editingMode = false;
  Color? nameclr = Colors.green[100];
  String tempname = "";
  RateFieldState({this.editingMode = false});

  @override
  Widget build(BuildContext context) {
    User.loadSeriesRating().then((_){
      setState(() {});
    });
    if (!this.editingMode) {
      return Padding(
          padding: EdgeInsets.fromLTRB(8.0, 10.0, 10.0, 8.0),
          child: Row(
            children: [
              Icon(Icons.account_circle_outlined, color: nameclr,),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(User.series_rating.toString(),
                        style: TextStyle(
                          fontSize: 18,
                        )),
                  )),
              IconButton(
                  onPressed: () {

                    setState(() {
                      editingMode = !editingMode;
                    });
                  },
                  icon: Icon(Icons.edit))
            ],
          ));
    } else {
      return Padding(
          padding: EdgeInsets.fromLTRB(8.0, 10.0, 10.0, 8.0),
          child: Row(
            children: [
              Icon(Icons.account_circle_outlined),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:  TextFormField(
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(hintText: "Type rating here"),
                      initialValue: User.series_rating.toString(),
                      onFieldSubmitted: (String submited) {
                        try {
                          User.series_rating = int.parse(submited);
                          User.setSeriesRating();
                        } catch (FormatException){};
                        setState(() {
                          editingMode = !editingMode;
                        });
                      },
                      onChanged: (String txt) {
                        tempname = txt;
                      },
                    ),
                  )),
              IconButton(
                  onPressed: () {
                    if (tempname != ""){
                      try {
                          User.series_rating = int.parse(tempname);
                          User.setSeriesRating();
                        } catch (FormatException){};
                    }
                    setState(() {
                      editingMode = !editingMode;
                    });
                  },
                  icon: Icon(Icons.done))
            ],
          ));
    }
  }
}

