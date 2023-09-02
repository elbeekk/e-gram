import 'package:flutter/material.dart';
class VarProvider with ChangeNotifier{
bool darkMode = false;
String docIdCurrentUser = '';
void setDocId(String docId){
  docIdCurrentUser=docId;
  notifyListeners();
}
void changeMode(bool currentMode){
  darkMode=!currentMode;
  notifyListeners();
}
}