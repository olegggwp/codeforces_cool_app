import 'package:flutter/material.dart';
import 'package:go_hard/Problemset.dart';
import 'package:go_hard/Submissions.dart';
import 'package:go_hard/newSeries.dart';
import 'package:go_hard/problemButtons.dart';

import 'madrawer.dart';
import 'maindata.dart';

class SimpleProblemsList extends StatelessWidget {
  // TODO: create a shared-preferences-list of problems by now
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // ProblemToSolve("Sonds good", "pt 1", Colors.white),
        // ProblemToSolve("Sonds good", "pt 2", Colors.white),
      ],
    );
  }
}

class WeekList extends StatefulWidget {
  const WeekList({Key? key}) : super(key: key);

  @override
  _WeekListState createState() => _WeekListState();
}

class _WeekListState extends State<WeekList> {
  late Future<WeekListData> wldata;
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  bool need_refr = false;

  @override
  void initState() {
    super.initState();
    wldata = LoadData();
  }

  List<ProblemToSolve> buttonsList = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: (){
              createNewSeries();
              setState(() {
                need_refr = true;
              });
              wldata = LoadData();
              wldata.whenComplete((){
                setState(() {
                  need_refr = false;
                  _messangerKey.currentState?.showSnackBar(
                      SnackBar(content: Text('new Series setted')));
                });
              });
            }, icon: Icon(Icons.gps_not_fixed_outlined)),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: IconButton(onPressed: () {
                // need_refr = true;
                setState(() {
                    need_refr = true;
                  });
                wldata = LoadData();
                wldata.whenComplete((){
                  setState(() {
                    need_refr = false;
                    _messangerKey.currentState?.showSnackBar(
                          SnackBar(content: Text('refreshed')));
                  });
                });
              }, icon: Icon(Icons.refresh_rounded)),
            )
          ],
        ),
        drawer: CoolDrawer(),
        body: Center(
            child: FutureBuilder<WeekListData>(
          future: wldata,
          builder: (context, snapshot) {
            if (snapshot.hasData && !need_refr) {
              buttonsList = [];
              for (WeekProblemData dt in snapshot.data!.pr_list) {
                if (dt.status == "Solved")
                  buttonsList.add(ProblemToSolve(
                      dt.name, dt.rating.toString(), dt.url, Colors.green));
                else if (dt.status == "Tryed")
                  buttonsList.add(ProblemToSolve(
                      dt.name, dt.rating.toString(), dt.url, Colors.orange));
                else
                  buttonsList.add(ProblemToSolve(
                      dt.name, dt.rating.toString(), dt.url, Colors.white));
              }
              return ListView(
                children: buttonsList,
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        )),
      ),
    );

    // return Column(children: buttonsList,);
  }
}

class WeekListData {
  late List<WeekProblemData> pr_list = [];
  WeekListData();
}

Future<WeekListData> LoadData() async {
  WeekListData wd = new WeekListData();
  print("start");
  await User.loadWeekList();
  print("loadingWeekList ended.");
  if(!Problemset.loaded)
    await Problemset.getProblemset();
  print("loading problem set ended.");
  // if(!Submissions.loaded)
  await Submissions.checkSubs();
  print("loading submissions ended.");
  wd.pr_list = [];
  for (String pr in User.week_list) {
    print("Hey");
    WeekProblemData wp = new WeekProblemData(pr);
    for (Submission sub in Submissions.list_sub) {
      if (wp.status == "Solved") {
        break;
      }
      // TODO : rewrite using Problem.submissions
      if (sub.globalId == wp.globalId) {
        if (sub.verdict == "OK")
          wp.status = "Solved";
        else
          wp.status = "Tryed";
      }
    }
    wd.pr_list.add(wp);
  }
  print("returning");

  return wd;
}

class WeekProblemData {
  late String globalId;
  late String name;
  late String status;
  late String url;
  late int rating;

  WeekProblemData(this.globalId) {
    this.name = Problemset.problem_map[globalId]?.name ?? "noname";
    Problem? tp = Problemset.problem_map[globalId];
    this.url = 'https://codeforces.com/problemset/problem/' +
        (tp?.contestId.toString() ?? "kop") +
        '/' +
        (tp?.index ?? "aw");
    this.rating = tp?.rating ?? -100;
    this.status = "none";
  }
}
