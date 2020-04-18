import 'dart:isolate';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:waring_demo/config/app_status.dart';
import 'package:waring_demo/models/home_model.dart';
import 'package:waring_demo/network/http_request.dart';
import 'package:intl/intl.dart';
import 'dart:async';

//import 'home_child/home_child.dart';

void printHello() {
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
  // _playaudio();
  _getDataForAlarm();
}

//获得首页的数据
void _getDataForAlarm() {
  HttpRequest.request(APP_STATUS == 1
          ? 'http://47.97.251.68:3000/call//call/adminActiveCall'
          : 'http://47.97.251.68:3000/call/activeCall')
      .then((res) {
    print(res.data);
    List<HomeModel> users = [];
    for (var user in res.data) {
      users.add(HomeModel.fromJson(user));
    }

    if (users.length > 0) {
      _playaudio();
    }
  });
}

void _playaudio() {
  if (APP_STATUS == 2) {
    // 00:00 - 07:30
    // 11:00 - 13:00
    // 16:30 - 23:59
    DateTime now = DateTime.now();
    int hour = now.hour;
    int minute = now.minute;

    if (hour == 7 && minute > 30) {
      return;
    }

    if (hour >= 8 && hour < 11) {
      return;
    }

    if (hour >= 13 && hour < 16) {
      return;
    }

    if (hour == 16 && minute < 30) {
      return;
    }
  }
  final AudioCache player = AudioCache();
  for (var i = 0; i < 3; i++) {
    player.play('messenger.mp3');
  }
}

class Home extends StatelessWidget {
  final Widget child;

  Home({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              APP_STATUS == 1 ? '管理员' : (APP_STATUS == 2 ? '员工时间段' : '员工全天')),
        ),
        body: HomeBody());
  }
}

class HomeBody extends StatefulWidget {
  final Widget child;

  HomeBody({Key key, this.child}) : super(key: key);

  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  List<HomeModel> userList = [];
  String latestId = '-1';
  Timer _timer;

  get index => null;
  @override
  void initState() {
    super.initState();
    this._getData();
    this._startTimer();
    this._startTimerManager();
  }

  Widget build(BuildContext context) {
    return Center(
        child: ListView.builder(
      itemCount: userList.length,
      itemBuilder: (BuildContext context, int index) {
        var id = userList[index].id;
        return Card(
          margin: EdgeInsets.all(10),
          elevation: 10,
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.all(10),
            // decoration: BoxDecoration(
            //     border: Border(
            //         bottom: BorderSide(width: 10, color: Color(0xffe2e2e2)))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 9),
                  child: Text(
                    '警报时间:' +
                        DateFormat.yMd()
                            .add_jm()
                            .format(DateTime.parse(userList[index].createdAt)),
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  ),
                ),
                SizedBox(height: 12),
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            // Row(
                            //   children: <Widget>[
                            //     Text('警报楼号：',
                            //         style: TextStyle(
                            //             fontSize: 14, color: Colors.black54)),
                            //     Container(
                            //       padding: EdgeInsets.symmetric(
                            //           vertical: 5, horizontal: 9),
                            //       decoration: BoxDecoration(
                            //           color: Colors.red,
                            //           borderRadius: BorderRadius.circular(5)),
                            //       child: Text(
                            //         userList[index].building + '号楼',
                            //         style: TextStyle(
                            //             fontSize: 18, color: Colors.white),
                            //       ),
                            //     )
                            //   ],
                            // ),
                            // SizedBox(height: 12),
                            Row(
                              children: <Widget>[
                                Text('警报楼层：',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black54)),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 9),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    userList[index].floor,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: <Widget>[
                                Text('警报楼床：',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black54)),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 9),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    userList[index].bed + '床',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        // FlatButton(
                        //   color: Colors.red,
                        //   highlightColor: Colors.blue[700],
                        //   colorBrightness: Brightness.dark,
                        //   splashColor: Colors.grey,
                        //   child: Text("了解"),
                        //   shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(5)),
                        //   onPressed: () {
                        //     HttpRequest.request(
                        //             'http://47.97.251.68:3000/call/inActiveCall/' +
                        //                 id,
                        //             method: 'post')
                        //         .then((res) {
                        //       print(res);
                        //       this._getData();
                        //     });
                        //   },
                        // )
                      ],
                    )),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  width: double.infinity,
                  // decoration: BoxDecoration(
                  //     color: Color(0xfff2f2f2),
                  //     borderRadius: BorderRadius.circular(5)),
                  // child: Text(
                  //   '住户信息：' + userList[index].id,
                  //   style: TextStyle(fontSize: 14, color: Colors.black54),
                  // ),
                )
              ],
            ),
          ),
        );
      },
    ));
  }

  //获得首页的数据
  void _getData() {
    HttpRequest.request(APP_STATUS == 1
            ? 'http://47.97.251.68:3000/call//call/adminActiveCall'
            : 'http://47.97.251.68:3000/call/activeCall')
        .then((res) {
      print(res.data);
      List<HomeModel> users = [];
      for (var user in res.data) {
        users.add(HomeModel.fromJson(user));
      }
      setState(() {
        this.userList = users;

        if (users.length > 0) {
          _playaudio();
        }

        // if (this.latestId == '-1') {
        //   if (users.length > 0) {
        //     this.latestId = users[0].id;
        //   } else {
        //     this.latestId = '0';
        //   }
        // } else {
        //   if (users.length > 0) {
        //     if (this.latestId != users[0].id) {
        //       _playaudio();
        //     }
        //     this.latestId = users[0].id;
        //   }
        // }
      });
    });
  }

  void _startTimer() {
    /*创建循环*/
    _timer = new Timer.periodic(new Duration(seconds: 5), (timer) {
      setState(() {
        this._getData();
      });
    });
  }

  void _startTimerManager() async {
    final int helloAlarmID = 0;
    await AndroidAlarmManager.initialize();
    await AndroidAlarmManager.periodic(
        const Duration(seconds: 10), helloAlarmID, printHello);

    /*创建循环*/
    // _timer = new Timer.periodic(new Duration(seconds: 5), (timer) {
    //   setState(() {
    //     this._getData();
    //   });
    // });
  }
}
