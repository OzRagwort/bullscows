
import 'dart:math';

import 'package:bullscows/AdMobManager.dart';
import 'package:bullscows/MainPage.dart';
import 'package:bullscows/setting/CustomPageRoute.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatMessage{
  String messageContent;
  String messageType;
  ChatMessage({@required this.messageContent, @required this.messageType});
}

class PlayGameWithAiPage extends StatefulWidget {
  PlayGameWithAiPage({this.checkKeyMap});

  String checkKeyMap;

  @override
  _PlayGameWithAiPageState createState() => _PlayGameWithAiPageState();
}

class _PlayGameWithAiPageState extends State<PlayGameWithAiPage> {

  List<ChatMessage> messages = [
    ChatMessage(messageContent: "숫자를 맞춰보세요!", messageType: "receiverCheck"),
  ];

  ScrollController _controller = ScrollController();

  AdMobManager _adMobManager = new AdMobManager();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences prefs;

  var rd = Random();

  String keyMap = "";
  String map = "";
  int index = 0;
  int messageCount = 0;
  int clearCount;
  int numCount;
  int gameDiff;
  String gameDiffString;
  int hint;
  bool viewRecord = false;

  int diffCount = 0;

  Color color = Color(0xff1890ff);
  double textSize = 40;

  /// 알고리즘 관련
  String checkKeyMap = "";
  String checkMap = "";
  List<int> checkKeyList = new List<int>();
  int startNum;
  int endNum;

  void _setKeyMap() {
    _prefs.then((value) {setState(() {
      prefs = value;
      gameDiff = value.getInt('game_diff');
      numCount = value.getInt('num_count');

      if (gameDiff == 1)
        gameDiffString = "쉬움";
      else if (gameDiff == 2)
        gameDiffString = "보통";
      else if (gameDiff == 3)
        gameDiffString = "어려움";
      else
        gameDiffString = "";

      for (int i = 0 ; i < numCount ; i++) {
        while(true) {
          String v = rd.nextInt(10).toString();
          if (keyMap.contains(v)) {
            continue;
          } else {
            if (i == 0 && v == "0") {
              continue;
            }
            keyMap += v;
            break;
          }
        }
      }

      if (numCount == 3) {
        startNum = 123;
        endNum = 987;
      } else if (numCount == 4) {
        startNum = 1234;
        endNum = 9876;
      } else {
        startNum = 12345;
        endNum = 98765;
      }
      for(int i = startNum ; i <= endNum ; i++) {
        String s = i.toString();
        for (int t = 0 ; t < numCount - 1 ; t++) {
          if (s.contains(s[t], t + 1)) {
            break;
          } else if (t == numCount - 2) {
            checkKeyList.add(i);
          }
        }
      }

      _setDiffCount();
    });});
  }

  void _setDiffCount() {
    if (gameDiff == 1)
      diffCount = numCount * 2;
    else if (gameDiff == 2)
      diffCount = numCount;
    else if (gameDiff == 3)
      diffCount = 0;
  }

  @override
  void initState() {
    super.initState();
    _adMobManager.init();
    _setKeyMap();
    checkKeyMap = widget.checkKeyMap;
  }

  @override
  void dispose() {
    super.dispose();
    _adMobManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (numCount != null && gameDiff != null) {
      return WillPopScope(
        onWillPop: () {
          NAlertDialog(
            title: Text("\n그만 하시겠습니까?\n", style: TextStyle(fontSize: 25),),
            blur: 4,
            actions: <Widget>[
              FlatButton(
                child: Text("계속하기", style: TextStyle(fontSize: 16),),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text("다시하기", style: TextStyle(fontSize: 16),),
                onPressed: () {
                  if (rd.nextInt(4) == 0)
                    _adMobManager.show();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => MainPage()),
                        (route) => false,);
                  Navigator.push(
                      context,
                      CustomPageRoute(ConfigKeyAi())
                  );
                },
              ),
              FlatButton(
                child: Text("그만하기", style: TextStyle(fontSize: 16),),
                onPressed: () {
                  if (rd.nextInt(4) == 0)
                    _adMobManager.show();
                  Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => MainPage()),
                      (route) => false,);
                  },
                color: Colors.orange,
              ),
            ],
          ).show(context, transitionType: DialogTransitionType.Bubble);
          return Future(() => false);
        },
        child: Scaffold(
          body: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: CupertinoColors.systemTeal.darkHighContrastColor,
                leading: Container(),
                leadingWidth: 0,
                actions: [
                  /// 난이도
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(gameDiffString, style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),),
                    ),
                  ),

                  /// 기록만보기
                  FlatButton(
                    onPressed: () {setState(() {
                      viewRecord = viewRecord ^ true;
                      Future.delayed(Duration(milliseconds: 500)).then((value) => _controller.jumpTo(_controller.position.maxScrollExtent));
                    });},
                    child: Text('기록만 보기', style: TextStyle(fontSize: 18),),
                  ),

                  /// 포기하기
                  FlatButton(
                    onPressed: () {
                      NAlertDialog(
                        title: Text("\n그만 하시겠습니까?\n", style: TextStyle(fontSize: 25),),
                        blur: 4,
                        actions: <Widget>[
                          FlatButton(
                            child: Text("계속하기", style: TextStyle(fontSize: 16),),
                            onPressed: () => Navigator.pop(context),
                          ),
                          FlatButton(
                            child: Text("다시하기", style: TextStyle(fontSize: 16),),
                            onPressed: () {
                              if (rd.nextInt(4) == 0)
                                _adMobManager.show();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (BuildContext context) => MainPage()),
                                    (route) => false,);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (BuildContext context) => ConfigKeyAi())
                              );
                            },
                          ),
                          FlatButton(
                            child: Text("그만하기", style: TextStyle(fontSize: 16),),
                            onPressed: () {
                              if (rd.nextInt(4) == 0)
                                _adMobManager.show();
                              Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (BuildContext context) => MainPage()),
                                  (route) => false,);
                            },
                            color: Colors.orange,
                          ),
                        ],
                      ).show(context, transitionType: DialogTransitionType.Bubble);
                    },
                    child: Text('포기하기', style: TextStyle(fontSize: 18),),
                  ),
                ],
              ),
              backgroundColor: CupertinoColors.systemTeal.darkHighContrastColor,
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: messages.length,
                        controller: _controller,
                        padding: EdgeInsets.only(top: 10,bottom: 10),
                        itemBuilder: (context, index){
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeOutQuart,
                            height: viewRecord == true && messages[index].messageType != 'receiver' ? 0 : 72,
                            padding: EdgeInsets.only(left: 14,right: 14,top: 5,bottom: 5),
                            child: Align(
                              alignment: (messages[index].messageType == "sender" ? Alignment.topRight : Alignment.topLeft),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: (messages[index].messageType  == "sender" ? Colors.orange[200] : Colors.yellowAccent[200]),
                                ),
                                padding: EdgeInsets.all(16),
                                child: Text(messages[index].messageContent, style: TextStyle(fontSize: 20),),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          numCount >= 1 ? Text(map.length >= 1?map[0]:"*", style: TextStyle(fontSize: textSize),) : Text(''),
                          numCount >= 2 ? SizedBox(width: textSize/2,) : Text(''),
                          numCount >= 2 ? Text(map.length >= 2?map[1]:"*", style: TextStyle(fontSize: textSize),) : Text(''),
                          numCount >= 3 ? SizedBox(width: textSize/2,) : Text(''),
                          numCount >= 3 ? Text(map.length >= 3?map[2]:"*", style: TextStyle(fontSize: textSize),) : Text(''),
                          numCount >= 4 ? SizedBox(width: textSize/2,) : Text(''),
                          numCount >= 4 ? Text(map.length >= 4?map[3]:"*", style: TextStyle(fontSize: textSize),) : Text(''),
                          numCount >= 5 ? SizedBox(width: textSize/2,) : Text(''),
                          numCount >= 5 ? Text(map.length >= 5?map[4]:"*", style: TextStyle(fontSize: textSize),) : Text(''),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: map.contains("1") ? null : () {setState(() {if (index >= numCount) {} else {map += "1"; index++;}});}, child: Text('1', style: TextStyle(fontSize: width/9),),),),
                              ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: map.contains("2") ? null : () {setState(() {if (index >= numCount) {} else {map += "2"; index++;}});}, child: Text('2', style: TextStyle(fontSize: width/9),),),),
                              ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: map.contains("3") ? null : () {setState(() {if (index >= numCount) {} else {map += "3"; index++;}});}, child: Text('3', style: TextStyle(fontSize: width/9),),),),
                              ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: map.contains("4") ? null : () {setState(() {if (index >= numCount) {} else {map += "4"; index++;}});}, child: Text('4', style: TextStyle(fontSize: width/9),),),),
                              ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: map.contains("5") ? null : () {setState(() {if (index >= numCount) {} else {map += "5"; index++;}});}, child: Text('5', style: TextStyle(fontSize: width/9),),),),
                              ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: map.length == numCount ? () {setState(() {_checkNumber(map); map = ""; index=0;});} : null, child: Icon(FontAwesomeIcons.baseballBall),),),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: map.contains("6") ? null : () {setState(() {if (index >= numCount) {} else {map += "6"; index++;}});}, child: Text('6', style: TextStyle(fontSize: width/9),),),),
                              ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: map.contains("7") ? null : () {setState(() {if (index >= numCount) {} else {map += "7"; index++;}});}, child: Text('7', style: TextStyle(fontSize: width/9),),),),
                              ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: map.contains("8") ? null : () {setState(() {if (index >= numCount) {} else {map += "8"; index++;}});}, child: Text('8', style: TextStyle(fontSize: width/9),),),),
                              ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: map.contains("9") ? null : () {setState(() {if (index >= numCount) {} else {map += "9"; index++;}});}, child: Text('9', style: TextStyle(fontSize: width/9),),),),
                              ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: index == 0 || map.contains("0") ? null : () {setState(() {if (index >= numCount) {} else {map += "0"; index++;}});}, child: Text('0', style: TextStyle(fontSize: width/9),),),),
                              ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: () {setState(() {if (index < 2) {map = "";index = 0;} else {index--;map = map.substring(0, index);}});}, child: Icon(CupertinoIcons.back),),),
                            ],
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
      );
    } else {
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }
  }

  void _checkNumber(String map) {
    messageCount++;
    int strike = 0;
    int ball = 0;
    String senders = "";
    for (int i = 0 ; i < numCount ; i++) {
      senders += map[i];
      if (keyMap[i] == map[i]) {
        strike++;
        continue;
      } else if (keyMap.contains(map[i])) {
        ball++;
        continue;
      }
    }
    if(strike == 0 && ball == 0) {
      setState(() {
        messages.add(new ChatMessage(messageContent: senders, messageType: "sender"));
        messages.add(new ChatMessage(messageContent: senders + " -> OUT!!!", messageType: "receiver"));
      });
      Future.delayed(Duration(milliseconds: 100)).then((value) => _controller.jumpTo(_controller.position.maxScrollExtent));
      _algorithmTurn();
    }
    else if(strike == numCount) {
      setState(() {
        if (clearCount == null)
          clearCount = messageCount;
        messages.add(new ChatMessage(messageContent: senders, messageType: "sender"));
        messages.add(new ChatMessage(messageContent: "CLEAR!!!", messageType: "receiver"));
        Future.delayed(Duration(milliseconds: 100)).then((value) => _controller.jumpTo(_controller.position.maxScrollExtent));
        NAlertDialog(
          title: Text("정답! 이겼습니다!", style: TextStyle(fontSize: 30),),
          content: Text("시도 횟수 : $clearCount 번", style: TextStyle(fontSize: 20),),
          blur: 4,
          actions: <Widget>[
            FlatButton(
              child: Text("다시하기", style: TextStyle(fontSize: 16),),
              onPressed: () {
                if (rd.nextInt(4) == 0)
                  _adMobManager.show();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => MainPage()),
                      (route) => false,);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => PlayGameWithAiPage())
                );
              },
            ),
            FlatButton(
              child: Text("메뉴로", style: TextStyle(fontSize: 16),),
              onPressed: () {
                if (rd.nextInt(4) == 0)
                  _adMobManager.show();
                Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) => MainPage()),
                    (route) => false,);
              },
            ),
          ],
        ).show(context, transitionType: DialogTransitionType.Bubble);
      });
    }
    else {
      setState(() {
        messages.add(new ChatMessage(messageContent: senders, messageType: "sender"));
        messages.add(new ChatMessage(messageContent: senders + " -> S : " + strike.toString() + " / B : " + ball.toString(), messageType: "receiver"));
        Future.delayed(Duration(milliseconds: 100)).then((value) => _controller.jumpTo(_controller.position.maxScrollExtent));
      });
      _algorithmTurn();
    }
  }

  void _algorithmTurn() {
    int strike = 0;
    int ball = 0;
    checkMap = "";

    checkMap = _createValue();

    Map<String, int> results = _check(checkKeyMap, checkMap);
    strike = results['strike'];
    ball = results['ball'];

    if (strike != numCount) {
      if (diffCount == 0) {
        _findKey(results);
      } else {
        diffCount--;
      }
    }

    if(strike == 0 && ball == 0) {
      setState(() {
        messages.add(new ChatMessage(messageContent: checkMap, messageType: "receiverCheck"));
        messages.add(new ChatMessage(messageContent: checkMap + " -> OUT!!!", messageType: "sender"));
      });
      Future.delayed(Duration(milliseconds: 100)).then((value) => _controller.jumpTo(_controller.position.maxScrollExtent));
    }
    else if(strike == numCount) {
      setState(() {
        messages.add(new ChatMessage(messageContent: checkMap, messageType: "receiverCheck"));
        messages.add(new ChatMessage(messageContent: "CLEAR!!!", messageType: "sender"));
        Future.delayed(Duration(milliseconds: 100)).then((value) => _controller.jumpTo(_controller.position.maxScrollExtent));
        NAlertDialog(
          title: Text("인공지능 승리!", style: TextStyle(fontSize: 30),),
          blur: 4,
          actions: <Widget>[
            FlatButton(
              child: Text("다시하기", style: TextStyle(fontSize: 16),),
              onPressed: () {
                if (rd.nextInt(4) == 0)
                  _adMobManager.show();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => MainPage()),
                      (route) => false,);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => ConfigKeyAi())
                );
              },
            ),
            FlatButton(
              child: Text("메뉴로", style: TextStyle(fontSize: 16),),
              onPressed: () {
                if (rd.nextInt(4) == 0)
                  _adMobManager.show();
                Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) => MainPage()),
                    (route) => false,);
              },
            ),
          ],
        ).show(context, transitionType: DialogTransitionType.Bubble);
      });
    }
    else {
      setState(() {
        messages.add(new ChatMessage(messageContent: checkMap, messageType: "receiverCheck"));
        messages.add(new ChatMessage(messageContent: checkMap + " -> S : " + strike.toString() + " / B : " + ball.toString(), messageType: "sender"));
        Future.delayed(Duration(milliseconds: 100)).then((value) => _controller.jumpTo(_controller.position.maxScrollExtent));
      });
    }

  }

  /// SB 체크
  Map<String, int> _check(String key, String input) {
    Map<String, int> ret = new Map<String, int>();
    ret["strike"] = 0;
    ret["ball"] = 0;
    for (int i = 0 ; i < numCount ; i++) {
      if (key[i] == input[i]) {
        ret["strike"]++;
        continue;
      } else if (key.contains(input[i])) {
        ret["ball"]++;
        continue;
      }
    }
    return ret;
  }

  /// 답찾기 알고리즘
  void _findKey(Map<String, int> results) {
    List<int> tempList = new List<int>();
    tempList.addAll(checkKeyList);
    for (int i in tempList) {
      Map<String, int> checkResults = _check(checkMap, i.toString());
      if ((checkResults["strike"] != results["strike"] || checkResults["ball"] != results["ball"]) && checkKeyList.contains(i)) {
        checkKeyList.remove(i);
      }
    }
    setState(() {});
  }

  /// 답찾기 시도할 수 생성
  String _createValue() {
    return checkKeyList[rd.nextInt(checkKeyList.length)].toString();
  }

}
