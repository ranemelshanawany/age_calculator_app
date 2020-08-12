import 'package:age/age.dart';
import 'package:flutter/cupertino.dart';

class AgeCalculate
{
  static Future<AgeDuration> calculateAge(context, AgeDuration age, DateTime birthday, DateTime today) async{

    if (birthday != null && today != null) {
      age = Age.dateDifference(fromDate: birthday, toDate: today);
      return age;
    }
    return age;
  }

  static Future<AgeDuration> calculateNextBirthday(context, AgeDuration age, DateTime birthday, DateTime today) async{
    var nextBirthday;
    if (birthday != null && today != null) {
      if (birthday.isBefore(today )) {
        int year = today.year + 1;
        int month = birthday.month;
        int day = birthday.day;
        nextBirthday = new DateTime(year, month, day);
      } else {
        int year = today.year;
        int month = birthday.month;
        int day = birthday.day;
        nextBirthday = new DateTime(year, month, day);
      }
      age = Age.dateDifference(fromDate: today, toDate: nextBirthday);
      return age;
    }
    return age;
  }
}