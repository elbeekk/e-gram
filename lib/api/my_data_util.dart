import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDataUtil{
  String getLastActive({required BuildContext context,required String lastActive}){
    final int i = int.tryParse(lastActive) ?? -1;
    if(i == -1) return 'Last seen not available';
    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();
    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if(time.day==now.day && time.month==now.month&&time.year==now.year){
      return 'last seen at $formattedTime';
    }

    if((now.difference(time).inHours / 24).round()==1){
      return 'last seen yesterday at $formattedTime';
    }

    String month = getMonth(time);
    return 'last seen on ${time.day} $month on $formattedTime';
  }
  static String getMonth(DateTime time){
    switch(time.month){
      case 1: return 'Jan';
      case 2: return 'Feb';
      case 3: return 'Mar';
      case 4: return 'Apr';
      case 5: return 'May';
      case 6: return 'Jun';
      case 7: return 'Jul';
      case 8: return 'Aug';
      case 9: return 'Sept';
      case 10: return 'Oct';
      case 11: return 'Nov';
      case 12: return 'Dec';
    }
    return 'NA';
  }
}