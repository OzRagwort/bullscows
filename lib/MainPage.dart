
import 'package:bullscows/PlayGamePage.dart';
import 'package:bullscows/PlayGameWithAiPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ndialog/ndialog.dart';

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
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  '숫자야구. \n'
                      '으아아아',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PlayGamePage()),
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
                        MaterialPageRoute(builder: (context) => PlayGameWithAiPage()),
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
