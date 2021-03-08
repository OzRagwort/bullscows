

import 'dart:math';

import 'package:bullscows/MainPage.dart';
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

class PlayGamePage extends StatefulWidget {
  @override
  _PlayGamePageState createState() => _PlayGamePageState();
}

class _PlayGamePageState extends State<PlayGamePage> {

  List<String> customString = [
    '좀 더 생각해봐~',
    '아냐아냐',
    '거의 다 왔어!',
    '',
    '',
    '',
    '',
    '',
  ];

  List<ChatMessage> messages = [
    ChatMessage(messageContent: "숫자를 맞춰보세요!", messageType: "receiver"),
  ];

  ScrollController _controller = ScrollController();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences prefs;

  Map<int, String> keyMap = new Map<int, String>();
  Map<int, String> map = new Map<int, String>();
  int index = 0;
  int messageCount = 0;
  int numCount;
  int hint;
  bool viewRecord = false;

  Color color = Color(0xff1890ff);
  double textSize = 40;

  void _setKeyMap() {
    _prefs.then((value) {setState(() {
      numCount = value.getInt(('num_count'));

      for (int i = 0 ; i < numCount ; i++) {
        while(true) {
          var rd = Random();
          String v = rd.nextInt(9).toString();
          if (keyMap.containsValue(v)) {
            continue;
          } else {
            keyMap[i] = v;
            break;
          }
        }
      }
    });});
  }

  @override
  void initState() {
    super.initState();
    _setKeyMap();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (numCount != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: CupertinoColors.systemTeal.darkHighContrastColor,
          leading: Container(),
          leadingWidth: 0,
          actions: [
            /// 기록만보기
            FlatButton(
              onPressed: () {setState(() {
                viewRecord = viewRecord ^ true;
              });},
              child: Text('기록만 보기', style: TextStyle(fontSize: 18),),
            ),

            /// 힌트보기
            FlatButton(
              onPressed: () {
                NAlertDialog(
                  title: hint == null ? Text("알고싶은 숫자를 클릭하세요") : Text("거의 다 왔어요!"),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      numCount >= 1 ? ButtonTheme(minWidth: 20, child: FlatButton(onPressed: hint == null ? () {setState(() {hint = 0; messages.add(new ChatMessage(messageContent: "첫 번째 숫자는 " + keyMap[0] + '입니다!', messageType: 'receiver')); Future.delayed(Duration(milliseconds: 100)).then((value) => _controller.jumpTo(_controller.position.maxScrollExtent)); Navigator.pop(context);});} : () {}, child: Text(hint == 0?keyMap[0]:"*", style: TextStyle(fontSize: textSize),),)) : Text(''),
                      numCount >= 2 ? ButtonTheme(minWidth: 20, child: FlatButton(onPressed: hint == null ? () {setState(() {hint = 1; messages.add(new ChatMessage(messageContent: "두 번째 숫자는 " + keyMap[1] + '입니다!', messageType: 'receiver')); Future.delayed(Duration(milliseconds: 100)).then((value) => _controller.jumpTo(_controller.position.maxScrollExtent)); Navigator.pop(context);});} : () {}, child: Text(hint == 1?keyMap[1]:"*", style: TextStyle(fontSize: textSize),),)) : Text(''),
                      numCount >= 3 ? ButtonTheme(minWidth: 20, child: FlatButton(onPressed: hint == null ? () {setState(() {hint = 2; messages.add(new ChatMessage(messageContent: "세 번째 숫자는 " + keyMap[2] + '입니다!', messageType: 'receiver')); Future.delayed(Duration(milliseconds: 100)).then((value) => _controller.jumpTo(_controller.position.maxScrollExtent)); Navigator.pop(context);});} : () {}, child: Text(hint == 2?keyMap[2]:"*", style: TextStyle(fontSize: textSize),),)) : Text(''),
                      numCount >= 4 ? ButtonTheme(minWidth: 20, child: FlatButton(onPressed: hint == null ? () {setState(() {hint = 3; messages.add(new ChatMessage(messageContent: "네 번째 숫자는 " + keyMap[3] + '입니다!', messageType: 'receiver')); Future.delayed(Duration(milliseconds: 100)).then((value) => _controller.jumpTo(_controller.position.maxScrollExtent)); Navigator.pop(context);});} : () {}, child: Text(hint == 3?keyMap[3]:"*", style: TextStyle(fontSize: textSize),),)) : Text(''),
                      numCount >= 5 ? ButtonTheme(minWidth: 20, child: FlatButton(onPressed: hint == null ? () {setState(() {hint = 4; messages.add(new ChatMessage(messageContent: "다섯 번째 숫자는 " + keyMap[4] + '입니다!', messageType: 'receiver')); Future.delayed(Duration(milliseconds: 100)).then((value) => _controller.jumpTo(_controller.position.maxScrollExtent)); Navigator.pop(context);});} : () {}, child: Text(hint == 4?keyMap[4]:"*", style: TextStyle(fontSize: textSize),),)) : Text(''),
                    ],
                  ),
                  blur: 4,
                  actions: <Widget>[
                    FlatButton(
                      child: Text("계속하기", style: TextStyle(fontSize: 16),),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ).show(context, transitionType: DialogTransitionType.Bubble);
              },
              child: Text('힌트 보기', style: TextStyle(fontSize: 18),),
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
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => MainPage()),
                              (route) => false,);
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) => PlayGamePage())
                        );
                      },
                    ),
                    FlatButton(
                      child: Text("그만하기", style: TextStyle(fontSize: 16),),
                      onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => MainPage()),
                            (route) => false,),
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
                      height: viewRecord == true && messages[index].messageType == 'sender' ? 0 : 72,
                      padding: EdgeInsets.only(left: 14,right: 14,top: 5,bottom: 5),
                      child: Align(
                        alignment: (messages[index].messageType == "receiver" ? Alignment.topLeft : Alignment.topRight),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (messages[index].messageType  == "receiver" ? Colors.yellowAccent[200] : Colors.orange[200]),
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
                    numCount >= 1 ? Text(map.containsKey(0)?map[0]:"*", style: TextStyle(fontSize: textSize),) : Text(''),
                    numCount >= 2 ? SizedBox(width: textSize/2,) : Text(''),
                    numCount >= 2 ? Text(map.containsKey(1)?map[1]:"*", style: TextStyle(fontSize: textSize),) : Text(''),
                    numCount >= 3 ? SizedBox(width: textSize/2,) : Text(''),
                    numCount >= 3 ? Text(map.containsKey(2)?map[2]:"*", style: TextStyle(fontSize: textSize),) : Text(''),
                    numCount >= 4 ? SizedBox(width: textSize/2,) : Text(''),
                    numCount >= 4 ? Text(map.containsKey(3)?map[3]:"*", style: TextStyle(fontSize: textSize),) : Text(''),
                    numCount >= 5 ? SizedBox(width: textSize/2,) : Text(''),
                    numCount >= 5 ? Text(map.containsKey(4)?map[4]:"*", style: TextStyle(fontSize: textSize),) : Text(''),
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
                        ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: map.containsValue("1") ? null : () {setState(() {if (index >= numCount) {} else {map[index] = "1"; index++;}});}, child: Text('1', style: TextStyle(fontSize: width/9),),),),
                        ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: map.containsValue("2") ? null : () {setState(() {if (index >= numCount) {} else {map[index] = "2"; index++;}});}, child: Text('2', style: TextStyle(fontSize: width/9),),),),
                        ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: map.containsValue("3") ? null : () {setState(() {if (index >= numCount) {} else {map[index] = "3"; index++;}});}, child: Text('3', style: TextStyle(fontSize: width/9),),),),
                        ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: map.containsValue("4") ? null : () {setState(() {if (index >= numCount) {} else {map[index] = "4"; index++;}});}, child: Text('4', style: TextStyle(fontSize: width/9),),),),
                        ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: map.containsValue("5") ? null : () {setState(() {if (index >= numCount) {} else {map[index] = "5"; index++;}});}, child: Text('5', style: TextStyle(fontSize: width/9),),),),
                        ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: map.length == numCount ? () {setState(() {_checkNumber(map); map.clear(); index=0;});} : null, child: Icon(FontAwesomeIcons.baseballBall),),),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: map.containsValue("6") ? null : () {setState(() {if (index >= numCount) {} else {map[index] = "6"; index++;}});}, child: Text('6', style: TextStyle(fontSize: width/9),),),),
                        ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: map.containsValue("7") ? null : () {setState(() {if (index >= numCount) {} else {map[index] = "7"; index++;}});}, child: Text('7', style: TextStyle(fontSize: width/9),),),),
                        ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: map.containsValue("8") ? null : () {setState(() {if (index >= numCount) {} else {map[index] = "8"; index++;}});}, child: Text('8', style: TextStyle(fontSize: width/9),),),),
                        ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: map.containsValue("9") ? null : () {setState(() {if (index >= numCount) {} else {map[index] = "9"; index++;}});}, child: Text('9', style: TextStyle(fontSize: width/9),),),),
                        ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: map.containsValue("0") ? null : () {setState(() {if (index >= numCount) {} else {map[index] = "0"; index++;}});}, child: Text('0', style: TextStyle(fontSize: width/9),),),),
                        ButtonTheme(minWidth: width/7, height: width/6, child: FlatButton(onPressed: () {setState(() {index > 0 ? map.remove(--index) : index=0;});}, child: Icon(CupertinoIcons.back),),),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }
  }

  void _checkNumber(Map<int, String> map) {
    messageCount++;
    int strike = 0;
    int ball = 0;
    String senders = "";
    for (int i = 0 ; i < numCount ; i++) {
      senders += map[i];
      if (keyMap[i] == map[i]) {
        strike++;
        continue;
      } else if (keyMap.containsValue(map[i])) {
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
    }
    else if(strike == numCount) {
      setState(() {
        messages.add(new ChatMessage(messageContent: senders, messageType: "sender"));
        messages.add(new ChatMessage(messageContent: "CLEAR!!!", messageType: "receiver"));
        Future.delayed(Duration(milliseconds: 100)).then((value) => _controller.jumpTo(_controller.position.maxScrollExtent));
        NAlertDialog(
          title: Text("정답입니다!", style: TextStyle(fontSize: 30),),
          content: Text("시도 횟수 : $messageCount 번", style: TextStyle(fontSize: 20),),
          blur: 4,
          actions: <Widget>[
            FlatButton(
              child: Text("다시하기", style: TextStyle(fontSize: 16),),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => MainPage()),
                      (route) => false,);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => PlayGamePage())
                );
              },
            ),
            FlatButton(
              child: Text("메뉴로", style: TextStyle(fontSize: 16),),
              onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) => MainPage()),
                    (route) => false,),
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
    }
  }

}
