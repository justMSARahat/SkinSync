import 'dart:typed_data';
import 'package:flutter/material.dart';

/// In-memory UI demonstration only. No account, medical analysis or admin service.
class DemoStore extends ChangeNotifier {
  DemoStore._();
  static final DemoStore instance = DemoStore._();

  String name = 'Fabliha';
  String email = 'fabliha@example.com';
  String skinType = 'Combination';
  String skinConcern = 'Hydration';
  bool morningReminder = true;
  bool eveningReminder = true;
  bool tips = true;
  bool newsletters = false;
  Uint8List? selectedPhoto;
  final Set<String> completed = {'Cleanser', 'Toner', 'Serum'};
  final Set<String> favorites = {'Centella Soothing Cream'};
  final Set<String> savedArticles = {'Understanding Your Skin Barrier'};
  final List<String> journal = ['Skin feels softer and calmer after my morning routine.'];
  final List<String> reminders = ['Morning ritual · 8:00 AM', 'Evening ritual · 9:00 PM'];

  void editProfile(String value, String mail) { name = value; email = mail; notifyListeners(); }
  void updateSkinType(String s) {skinType=s; notifyListeners();}
  void updateConcern(String s) {skinConcern=s;notifyListeners();}
  void setPhoto(Uint8List? bytes) { selectedPhoto = bytes; notifyListeners(); }
  void toggleCompleted(String step) {if (!completed.add(step)) completed.remove(step);notifyListeners();}
  void toggleFavorite(String product) {if (!favorites.add(product)) favorites.remove(product);notifyListeners();}
  void toggleArticle(String article) {if (!savedArticles.add(article)) savedArticles.remove(article);notifyListeners();}
  void addJournal(String text) {if(text.trim().isNotEmpty){journal.insert(0,text.trim());notifyListeners();}}
  void addReminder(String text) {if(text.trim().isNotEmpty){reminders.add(text.trim());notifyListeners();}}
  void editReminder(int index,String text) {if(index>=0 && index<reminders.length){reminders[index]=text;notifyListeners();}}
  void removeReminder(int index) {if(index>=0 && index<reminders.length){reminders.removeAt(index);notifyListeners();}}
  void setMorning(bool v) { morningReminder=v; notifyListeners();}
  void setEvening(bool v) { eveningReminder=v; notifyListeners();}
  void setTips(bool v) { tips=v; notifyListeners();}
  void setNewsletters(bool v) { newsletters=v; notifyListeners();}
}
