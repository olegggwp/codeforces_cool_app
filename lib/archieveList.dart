import 'package:flutter/material.dart';
import 'package:go_hard/Problemset.dart';
import 'package:go_hard/Submissions.dart';
import 'package:go_hard/newSeries.dart';
import 'package:go_hard/problemButtons.dart';
import 'madrawer.dart';
import 'maindata.dart';

class ArchieveList extends StatefulWidget {
  const ArchieveList({Key? key}) : super(key: key);

  @override
  _ArchieveListState createState() => _ArchieveListState();
}

class _ArchieveListState extends State<ArchieveList> {
  late Future<ArchieveListData> wldata;
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
            child: FutureBuilder<ArchieveListData>(
              future: wldata,
              builder: (context, snapshot) {
                if (snapshot.hasData && !need_refr) {
                  buttonsList = [];
                  for (ArchieveProblemData dt in snapshot.data!.pr_list) {
                    if (dt.status == "Solved")
                      buttonsList.add(ProblemToSolve(
                          dt.name, dt.rating.toString(), dt.url, Colors.green, true));
                    else if (dt.status == "Tryed")
                      buttonsList.add(ProblemToSolve(
                          dt.name, dt.rating.toString(), dt.url, Colors.orange, true));
                    else
                      buttonsList.add(ProblemToSolve(
                          dt.name, dt.rating.toString(), dt.url, Colors.white, true));
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

class ArchieveListData {
  late List<ArchieveProblemData> pr_list = [];
  ArchieveListData();
}

Future<ArchieveListData> LoadData() async {
  ArchieveListData wd = new ArchieveListData();
  bool isOk = true;
  print("start");

  print("loadingArchieveList ended.");
  if(!Problemset.loaded)
    await Problemset.getProblemset();
  print("loading problem set ended.");
  if(!Submissions.loaded)
    await Submissions.checkSubs();
  print("loading submissions ended.");
  wd.pr_list = [];
  for (String pr in Problemset.problems_id_set) {
    print("Hey");
    ArchieveProblemData wp = new ArchieveProblemData(pr);
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

class ArchieveProblemData {
  late String globalId;
  late String name;
  late String status;
  late String url;
  late int rating;

  ArchieveProblemData(this.globalId) {
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
