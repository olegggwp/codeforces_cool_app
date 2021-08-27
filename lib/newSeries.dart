
import 'package:go_hard/Problemset.dart';

import 'maindata.dart';

void createNewSeries(){
  User.week_list = [];
  User.loadSeriesRating();
  int cnt = 0;
  for(String gid in Problemset.problems_id_set){
    Problem? pr = Problemset.problem_map[gid];
    if(pr == null){
      throw Exception("newSeries : create : There is global Id in set but not in map");
    }
    if(pr.rating != User.series_rating)
      continue;
    if(pr.watched == true)
      continue;
    User.week_list.add(gid);
    cnt++;
    if(cnt == User.sereis_size)
      break;
  }
  User.setWeekList();
}