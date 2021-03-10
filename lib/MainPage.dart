
import 'dart:ui';

import 'package:bullscows/PlayGamePage.dart';
import 'package:bullscows/PlayGameWithAiPage.dart';
import 'package:bullscows/SettingWidget.dart';
import 'package:bullscows/setting/CustomPageRoute.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();

}

class _MainPageState extends State<MainPage>{
  String title;
  double textSize = 20;

  @override
  void initState() {
    super.initState();

    title = widget.title;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _onBackPressed();
        return Future(() => false);
      },
      child: Scaffold(
        body: SafeArea(
          child: _buildPage(),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => NAlertDialog(
        title: Text("종료하시겠습니까?"),
        blur: 4,
        actions: <Widget>[
          FlatButton(
            child: Text("종료하기"),
            onPressed: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
          ),
          FlatButton(
            child: Text("취소"),
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    ) ??
        false;
  }

  Widget _buildPage() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3,
              child: Container(),
            ),
            Container(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CustomPageRoute(PlayGamePage()),
                      );
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 60,
                      height: 50,
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.grey[300],
                        child: Text('게임 시작하기', textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: textSize),),
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: const Divider(color: Colors.grey,),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CustomPageRoute(ConfigKeyAi()),
                      );
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 60,
                      height: 50,
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.grey[300],
                        child: Text('인공지능과 대전', textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: textSize),),
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: const Divider(color: Colors.grey,),
                  ),

                  GestureDetector(
                    onTap: () {
                      NAlertDialog(
                        title: Text("설정", style: TextStyle(fontSize: 25),),
                        content: Settingwidget(),
                        blur: 4,
                        actions: <Widget>[
                          FlatButton(
                            child: Text("완료", style: TextStyle(fontSize: 16),),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ).show(context, transitionType: DialogTransitionType.Bubble);
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 60,
                      height: 50,
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.grey[300],
                        child: Text('설정', textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: textSize),),
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: const Divider(color: Colors.grey,),
                  ),

                  GestureDetector(
                    onTap: () {
                      _onBackPressed();
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 60,
                      height: 50,
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.grey[300],
                        child: Text('나가기', textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: textSize),),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

}

class ConfigKeyAi extends StatefulWidget {
  @override
  _ConfigKeyAiState createState() => _ConfigKeyAiState();
}

class _ConfigKeyAiState extends State<ConfigKeyAi> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences prefs;

  int indexAi = 0;
  int numCount;
  String checkKeyMap = "";
  double textSize = 40;

  @override
  void initState() {
    super.initState();
    _prefs.then((value) {setState(() {
      prefs = value;
      numCount = value.getInt('num_count');
    });});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/background.png', fit: BoxFit.cover),
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  // color: Colors.white.withOpacity(0.1),
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(50, 255, 255, 255),
                          Color.fromARGB(220, 255, 255, 255)
                        ],
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: height/3,
                        ),
                        Container(
                          child: Column(
                            children: [
                              Text(
                                '인공지능이 맞추는\n여러분의 숫자를 입력하세요',
                                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20,),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    numCount >= 1 ? Text(checkKeyMap.length >= 1?checkKeyMap[0]:"*", style: TextStyle(fontSize: textSize*1.5),) : Text(''),
                                    numCount >= 2 ? SizedBox(width: textSize/2,) : Text(''),
                                    numCount >= 2 ? Text(checkKeyMap.length >= 2?checkKeyMap[1]:"*", style: TextStyle(fontSize: textSize*1.5),) : Text(''),
                                    numCount >= 3 ? SizedBox(width: textSize/2,) : Text(''),
                                    numCount >= 3 ? Text(checkKeyMap.length >= 3?checkKeyMap[2]:"*", style: TextStyle(fontSize: textSize*1.5),) : Text(''),
                                    numCount >= 4 ? SizedBox(width: textSize/2,) : Text(''),
                                    numCount >= 4 ? Text(checkKeyMap.length >= 4?checkKeyMap[3]:"*", style: TextStyle(fontSize: textSize*1.5),) : Text(''),
                                    numCount >= 5 ? SizedBox(width: textSize/2,) : Text(''),
                                    numCount >= 5 ? Text(checkKeyMap.length >= 5?checkKeyMap[4]:"*", style: TextStyle(fontSize: textSize*1.5),) : Text(''),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: checkKeyMap.contains("1") ? null : () {setState(() {if (indexAi >= numCount) {} else {checkKeyMap += "1"; indexAi++;}});}, child: Text('1', style: TextStyle(fontSize: width/9),),),),
                                        ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: checkKeyMap.contains("2") ? null : () {setState(() {if (indexAi >= numCount) {} else {checkKeyMap += "2"; indexAi++;}});}, child: Text('2', style: TextStyle(fontSize: width/9),),),),
                                        ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: checkKeyMap.contains("3") ? null : () {setState(() {if (indexAi >= numCount) {} else {checkKeyMap += "3"; indexAi++;}});}, child: Text('3', style: TextStyle(fontSize: width/9),),),),
                                        ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: checkKeyMap.contains("4") ? null : () {setState(() {if (indexAi >= numCount) {} else {checkKeyMap += "4"; indexAi++;}});}, child: Text('4', style: TextStyle(fontSize: width/9),),),),
                                        ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: checkKeyMap.contains("5") ? null : () {setState(() {if (indexAi >= numCount) {} else {checkKeyMap += "5"; indexAi++;}});}, child: Text('5', style: TextStyle(fontSize: width/9),),),),
                                        ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: checkKeyMap.length == numCount ? () {setState(() {
                                          Navigator.push(
                                            context,
                                            CustomPageRoute(PlayGameWithAiPage(checkKeyMap: checkKeyMap,)),
                                          ).then((value) => Navigator.pop(context));
                                        });} : null, child: Icon(FontAwesomeIcons.baseballBall, size: 20,),),),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: checkKeyMap.contains("6") ? null : () {setState(() {if (indexAi >= numCount) {} else {checkKeyMap += "6"; indexAi++;}});}, child: Text('6', style: TextStyle(fontSize: width/9),),),),
                                        ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: checkKeyMap.contains("7") ? null : () {setState(() {if (indexAi >= numCount) {} else {checkKeyMap += "7"; indexAi++;}});}, child: Text('7', style: TextStyle(fontSize: width/9),),),),
                                        ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: checkKeyMap.contains("8") ? null : () {setState(() {if (indexAi >= numCount) {} else {checkKeyMap += "8"; indexAi++;}});}, child: Text('8', style: TextStyle(fontSize: width/9),),),),
                                        ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: checkKeyMap.contains("9") ? null : () {setState(() {if (indexAi >= numCount) {} else {checkKeyMap += "9"; indexAi++;}});}, child: Text('9', style: TextStyle(fontSize: width/9),),),),
                                        ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: indexAi == 0 || checkKeyMap.contains("0") ? null : () {setState(() {if (indexAi >= numCount) {} else {checkKeyMap += "0"; indexAi++;}});}, child: Text('0', style: TextStyle(fontSize: width/9),),),),
                                        ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: () {setState(() {if (indexAi < 2) {checkKeyMap = "";indexAi = 0;} else {indexAi--;checkKeyMap = checkKeyMap.substring(0, indexAi);}});}, child: Icon(CupertinoIcons.back, size: 20),),),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   double width = MediaQuery.of(context).size.width;
  //   double height = MediaQuery.of(context).size.height;
  //   return Scaffold(
  //     body: SafeArea(
  //       child: Container(
  //         decoration: BoxDecoration(
  //           image: DecorationImage(
  //             image: AssetImage("assets/background.png"),
  //             fit: BoxFit.cover,
  //           ),
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Container(
  //               height: height/3,
  //             ),
  //             Container(
  //               // color: Colors.white.withOpacity(0.9),
  //               child: Column(
  //                 children: [
  //                   Text(
  //                     '인공지능이 맞추는\n여러분의 숫자를 입력하세요',
  //                     style: TextStyle(fontSize: 26),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                   const SizedBox(height: 20,),
  //                   Container(
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         numCount >= 1 ? Text(checkKeyMap.length >= 1?checkKeyMap[0]:"*", style: TextStyle(fontSize: textSize*1.5),) : Text(''),
  //                         numCount >= 2 ? SizedBox(width: textSize/2,) : Text(''),
  //                         numCount >= 2 ? Text(checkKeyMap.length >= 2?checkKeyMap[1]:"*", style: TextStyle(fontSize: textSize*1.5),) : Text(''),
  //                         numCount >= 3 ? SizedBox(width: textSize/2,) : Text(''),
  //                         numCount >= 3 ? Text(checkKeyMap.length >= 3?checkKeyMap[2]:"*", style: TextStyle(fontSize: textSize*1.5),) : Text(''),
  //                         numCount >= 4 ? SizedBox(width: textSize/2,) : Text(''),
  //                         numCount >= 4 ? Text(checkKeyMap.length >= 4?checkKeyMap[3]:"*", style: TextStyle(fontSize: textSize*1.5),) : Text(''),
  //                         numCount >= 5 ? SizedBox(width: textSize/2,) : Text(''),
  //                         numCount >= 5 ? Text(checkKeyMap.length >= 5?checkKeyMap[4]:"*", style: TextStyle(fontSize: textSize*1.5),) : Text(''),
  //                       ],
  //                     ),
  //                   ),
  //                   Container(
  //                     // padding: const EdgeInsets.all(10),
  //                     child: Column(
  //                       children: [
  //                         Row(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: checkKeyMap.contains("1") ? null : () {setState(() {if (indexAi >= numCount) {} else {checkKeyMap += "1"; indexAi++;}});}, child: Text('1', style: TextStyle(fontSize: width/9),),),),
  //                             ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: checkKeyMap.contains("2") ? null : () {setState(() {if (indexAi >= numCount) {} else {checkKeyMap += "2"; indexAi++;}});}, child: Text('2', style: TextStyle(fontSize: width/9),),),),
  //                             ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: checkKeyMap.contains("3") ? null : () {setState(() {if (indexAi >= numCount) {} else {checkKeyMap += "3"; indexAi++;}});}, child: Text('3', style: TextStyle(fontSize: width/9),),),),
  //                             ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: checkKeyMap.contains("4") ? null : () {setState(() {if (indexAi >= numCount) {} else {checkKeyMap += "4"; indexAi++;}});}, child: Text('4', style: TextStyle(fontSize: width/9),),),),
  //                             ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: checkKeyMap.contains("5") ? null : () {setState(() {if (indexAi >= numCount) {} else {checkKeyMap += "5"; indexAi++;}});}, child: Text('5', style: TextStyle(fontSize: width/9),),),),
  //                             ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: checkKeyMap.length == numCount ? () {setState(() {
  //                               Navigator.push(
  //                                 context,
  //                                 CustomPageRoute(PlayGameWithAiPage(checkKeyMap: checkKeyMap,)),
  //                               ).then((value) => Navigator.pop(context));
  //                             });} : null, child: Icon(FontAwesomeIcons.baseballBall, size: 20,),),),
  //                           ],
  //                         ),
  //                         Row(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: checkKeyMap.contains("6") ? null : () {setState(() {if (indexAi >= numCount) {} else {checkKeyMap += "6"; indexAi++;}});}, child: Text('6', style: TextStyle(fontSize: width/9),),),),
  //                             ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: checkKeyMap.contains("7") ? null : () {setState(() {if (indexAi >= numCount) {} else {checkKeyMap += "7"; indexAi++;}});}, child: Text('7', style: TextStyle(fontSize: width/9),),),),
  //                             ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: checkKeyMap.contains("8") ? null : () {setState(() {if (indexAi >= numCount) {} else {checkKeyMap += "8"; indexAi++;}});}, child: Text('8', style: TextStyle(fontSize: width/9),),),),
  //                             ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: checkKeyMap.contains("9") ? null : () {setState(() {if (indexAi >= numCount) {} else {checkKeyMap += "9"; indexAi++;}});}, child: Text('9', style: TextStyle(fontSize: width/9),),),),
  //                             ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: indexAi == 0 || checkKeyMap.contains("0") ? null : () {setState(() {if (indexAi >= numCount) {} else {checkKeyMap += "0"; indexAi++;}});}, child: Text('0', style: TextStyle(fontSize: width/9),),),),
  //                             ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: () {setState(() {if (indexAi < 2) {checkKeyMap = "";indexAi = 0;} else {indexAi--;checkKeyMap = checkKeyMap.substring(0, indexAi);}});}, child: Icon(CupertinoIcons.back, size: 20),),),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

