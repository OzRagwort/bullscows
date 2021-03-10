import 'package:bullscows/MainPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  /// admob
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  /// 하단바
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
    ),
  );

  /// 설정값
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  if (!prefs.containsKey('num_count')) {
    prefs.setInt('num_count', 4);
  }
  if (!prefs.containsKey('game_diff')) {
    prefs.setInt('game_diff', 1);
  }

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MyApp({Key key, this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bulls And Cows',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(title: 'Bulls And Cows'),
    );
  }
}
