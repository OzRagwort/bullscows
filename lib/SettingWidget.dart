
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settingwidget extends StatefulWidget {
  @override
  _SettingwidgetState createState() => _SettingwidgetState();
}

class _SettingwidgetState extends State<Settingwidget> {

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences prefs;

  int _numRadioBtnVal;
  int _diffRadioBtnVal;

  void _handleNumChange(int value) {
    setState(() {
      _numRadioBtnVal = value;
      prefs.setInt('num_count', value);
    });
  }

  void _handleDiffChange(int value) {
    setState(() {
      _diffRadioBtnVal = value;
      prefs.setInt('game_diff', value);
    });
  }

  void _setPrefs() {
    _prefs.then((value) {setState(() {
      prefs = value;
      _numRadioBtnVal = prefs.getInt('num_count');
      _diffRadioBtnVal = prefs.getInt('game_diff');
    });});
  }

  @override
  void initState() {
    _setPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 200,
      child: Column(
        children: [
          Text(
            '자리수 변경',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.start,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Radio<int>(
                  value: 3,
                  groupValue: _numRadioBtnVal,
                  onChanged: _handleNumChange,
                ),
                Text("3자리"),
                Radio<int>(
                  value: 4,
                  groupValue: _numRadioBtnVal,
                  onChanged: _handleNumChange,
                ),
                Text("4자리"),
                Radio<int>(
                  value: 5,
                  groupValue: _numRadioBtnVal,
                  onChanged: _handleNumChange,
                ),
                Text("5자리"),
              ],
            ),
          ),
          Text(
            '인공지능 난이도 변경',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.start,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Radio<int>(
                  value: 1,
                  groupValue: _diffRadioBtnVal,
                  onChanged: _handleDiffChange,
                ),
                Text("쉬움"),
                Radio<int>(
                  value: 2,
                  groupValue: _diffRadioBtnVal,
                  onChanged: _handleDiffChange,
                ),
                Text("보통"),
                Radio<int>(
                  value: 3,
                  groupValue: _diffRadioBtnVal,
                  onChanged: _handleDiffChange,
                ),
                Text("어려움!!"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

