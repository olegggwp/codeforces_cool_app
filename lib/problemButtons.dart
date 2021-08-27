import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

double getElev(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return 2.0;
  }
  return 4.0;
}

Color getColorSha(Set<MaterialState> states) {
  return Colors.black;
}

Color allOne(Set<MaterialState> states, Color clr) {
  return clr;
}

Color getColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return Colors.white;
  }
  return Colors.white;
}

void _launchURL(String url) async =>
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

class ProblemToSolve extends StatelessWidget {
  late String title;
  late String description;
  late String url;
  late Color clr;
  late bool dropToDoButton;
  bool inToDo = false;
  Icon whatIconOfStar(){
    if(inToDo){
      return Icon(Icons.star, );
    }else{
      return Icon(Icons.star_border_outlined, color: Colors.yellow,);
    }
  }

  ProblemToSolve(this.title, this.description, this.url , this.clr, [this.dropToDoButton = false]);

  @override
  Widget build(BuildContext context) {
    if(!dropToDoButton){
      return Padding(
        padding: EdgeInsets.all(6.0),
        child: TextButton(
          onPressed: () {
            _launchURL(url);
          },
          child: Padding(
              padding: EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(1.0, 0.0, 0.0, 6.0),
                    child: Text(
                      title,
                      // textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  Text(
                    description,
                    // textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              )),
          style: ButtonStyle(
              alignment: Alignment.centerLeft,
              shadowColor: MaterialStateProperty.resolveWith(
                      (states) => getColorSha(states)),
              backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => allOne(states, clr)),
              elevation:
              MaterialStateProperty.resolveWith((states) => getElev(states))),
        ),
      );
    }else{
      return Padding(
        padding: EdgeInsets.all(6.0),
        child: TextButton(
          onPressed: () {
            _launchURL(url);
          },
          child: Padding(
              padding: EdgeInsets.all(6.0),
              child: Expanded(
                child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(1.0, 0.0, 0.0, 6.0),
                          child: Text(
                            title,
                            // textAlign: TextAlign.justify,
                            // textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                        Text(
                          description,
                          // textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: IconButton(onPressed: (){}, padding: EdgeInsets.all(2.0) , icon: whatIconOfStar()))
                ],),
              )),
          style: ButtonStyle(
              alignment: Alignment.centerLeft,
              shadowColor: MaterialStateProperty.resolveWith(
                      (states) => getColorSha(states)),
              backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => allOne(states, clr)),
              elevation:
              MaterialStateProperty.resolveWith((states) => getElev(states))),
        ),
      );
    }

  }
}
