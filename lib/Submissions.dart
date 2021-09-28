import 'dart:convert';
import 'package:go_hard/Problemset.dart';
import 'package:http/http.dart' as http;

import 'maindata.dart';

abstract class Submissions {
  static late List<Submission> list_sub = [];
  static bool loaded = false;

  static fromMap(Map<String, dynamic> map) {
    if (map['status'] == "OK") {
      for (Map<String, dynamic> sb in map["result"]) {
        list_sub.add(Submission.fromMap(sb));
      }
    }
  }

  static Future<String> checkSubs() async {
    await User.loadHandle();
    final response = await http.get(Uri.parse(
        'https://codeforces.com/api/user.status?handle=' + User.handle + '&from=1'));
    if (response.statusCode == 200) {
      //  OK
      list_sub = [];
      fromMap(jsonDecode(response.body));
      for(Submission sbm in list_sub){
        Problemset.problem_map[sbm.globalId]?.submissions.add(sbm);
        Problemset.problem_map[sbm.globalId]?.watched = true;
        Problemset.problem_map[sbm.globalId]?.state = "Tryed";
        if(sbm.verdict == "OK")
          Problemset.problem_map[sbm.globalId]?.state = "Solved";
      }
      loaded = true;

      return 'OK';
    } else {
      return "error";
    }
  }
}

class Submission {
  late int id;
  late int contestid;
  late String prIndex;
  late String verdict;
  late String globalId;

  Submission(this.id, this.contestid, this.prIndex, this.verdict){
    this.globalId = contestid.toString() + prIndex;
  }

  static Submission fromMap(Map<String, dynamic> map) {
    return Submission(
        map['id'], map["contestId"], map['problem']['index'], map['verdict']);
  }
}