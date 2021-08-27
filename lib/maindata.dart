import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

abstract class User {
  static String name = "olegBelyaev";
  static String status = "idk";
  static String rank = "none";
  static String maxRank = "none";
  static int rating = 10;
  static int maxRating = 10;
  static int checked_cnt = 0;
  static List<String> week_list = ['1550E'];
  static int sereis_size = 10;
  static int series_rating = 2300;

  static loadWeekList() async {
    SharedPreferences prefs = await  SharedPreferences.getInstance() ;
    dynamic t = prefs.getStringList('week_list');
    if(t != null){
      User.week_list = [];
      User.week_list = t;
  }
  }

  static loadSeriesRating() async {
    SharedPreferences prefs = await  SharedPreferences.getInstance() ;
    dynamic t = prefs.getInt('series_rating');
    if(t != null)
      User.series_rating = t;
  }

  static setWeekList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'week_list', User.week_list);
  }

  static setSeriesRating() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        'series_rating', User.series_rating);
  }
}




