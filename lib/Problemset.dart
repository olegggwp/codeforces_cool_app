import 'dart:convert';

import 'package:go_hard/Submissions.dart';
import 'package:http/http.dart' as http;


abstract class Problemset{
  static Map<String, Problem> problem_map = {};
  static Set<String> problems_id_set = {};
  static bool loaded = false;

  static fromMap(Map<String, dynamic> map){
    problem_map.clear();
    for(Map<String, dynamic> pr in map['result']['problems']){
      Problem np = Problem.fromMap(pr);
      problem_map[np.globalId] = np;
      problems_id_set.add(np.globalId);
    }
  }

  static Future<String> getProblemset() async{
    final response = await http.get(Uri.parse(
        'https://codeforces.com/api/problemset.problems'));
    if(response.statusCode == 200){
      Problemset.problem_map = {};
      Problemset.fromMap(jsonDecode(response.body));
      loaded = true;
      return "OK";
    }
    throw Exception('Failed to load ProblemReq');
    return "error";
  }

}

class Problem {
  late String name;
  late int? rating;
  late int contestId;
  late String index;
  late String globalId;
  String state = "none";
  bool watched = false;

  List<Submission> submissions = [];

  Problem(this.name, this.rating, this.contestId, this.index){
   this.globalId = this.contestId.toString() + this.index;
  }

  static Problem fromMap(Map<String, dynamic> map){
    return Problem(map['name'], map['rating'], map['contestId'], map['index']);
  }

}