import 'dart:async';
import 'dart:isolate';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foreground_service/foreground_service.dart';
import 'package:waring_demo/models/home_model.dart';
import 'package:waring_demo/network/http_request.dart';
import 'package:waring_demo/views/history/history.dart';
import 'package:waring_demo/views/home/home.dart';
import 'package:wakelock/wakelock.dart';

import 'config/app_status.dart';

void _getDataForAlarm() {
  print('_getDataForAlarm from frogroudservice: ' + DateTime.now().toString());

  HttpRequest.request(APP_STATUS == 1
          ? 'http://106.14.248.81:3000/call/adminActiveCall'
          : 'http://106.14.248.81:3000/call/activeCall')
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

Future<void> _playaudio() async {
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

  player.play('messenger.mp3');

  if (await ForegroundService.isBackgroundIsolateSetupComplete()) {
    await ForegroundService.sendToPort("message from main");
  } else {
    debugPrint("bg isolate setup not yet complete");
  }
}

void _startTimer() {
  /*创建循环*/
  Timer _timer = new Timer.periodic(new Duration(seconds: 10), (timer) {
    _getDataForAlarm();
  });
}

void main() {
  runApp(MyApp());
  // maybeStartFGS();
  startForegroundService();
}

void startForegroundService() async {
  await FlutterForegroundPlugin.setServiceMethodInterval(seconds: 5);
  await FlutterForegroundPlugin.setServiceMethod(globalForegroundService);
  await FlutterForegroundPlugin.startForegroundService(
    holdWakeLock: false,
    onStarted: () {
      print("Foreground on Started");
    },
    onStopped: () {
      print("Foreground on Stopped");
    },
    title: "Flutter Foreground Service",
    content: "This is Content",
    iconName: "ic_stat_hot_tub",
  );
}

void globalForegroundService() {
  Fluttertoast.showToast(
      msg:
          '_getDataForAlarm from frogroudservice: ' + DateTime.now().toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
  debugPrint("current datetime is ${DateTime.now()}");
  _getDataForAlarm();
}

void maybeStartFGS() async {
  ///if the app was killed+relaunched, this function will be executed again
  ///but if the foreground service stayed alive,
  ///this does not need to be re-done
  if (!(await ForegroundService.foregroundServiceIsStarted())) {
    await ForegroundService.setServiceIntervalSeconds(5);

    //necessity of editMode is dubious (see function comments)
    await ForegroundService.notification.startEditMode();

    await ForegroundService.notification
        .setTitle("Example Title: ${DateTime.now()}");
    await ForegroundService.notification
        .setText("Example Text: ${DateTime.now()}");

    await ForegroundService.notification.finishEditMode();

    await ForegroundService.startForegroundService(foregroundServiceFunction);
    await ForegroundService.getWakeLock();
  }

  ///this exists solely in the main app/isolate,
  ///so needs to be redone after every app kill+relaunch
  await ForegroundService.setupIsolateCommunication((data) {
    debugPrint("main received: $data");
  });
}

void foregroundServiceFunction() {
  debugPrint("The current time is: ${DateTime.now()}");
  ForegroundService.notification.setText("The time was: ${DateTime.now()}");

  if (!ForegroundService.isIsolateCommunicationSetup) {
    ForegroundService.setupIsolateCommunication((data) {
      debugPrint("bg isolate received: $data");
    });
  }

  ForegroundService.sendToPort("message from bg isolate");

  _startTimer();
  // _getDataForAlarm();
}

class MyApp extends StatelessWidget {
  final Widget child;

  MyApp({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '馨安家园',
        theme: ThemeData(
          primaryColor: Colors.black,
          brightness: Brightness.dark,
        ),
        home: MyStatckpage());
  }
}

class MyStatckpage extends StatefulWidget {
  final Widget child;

  MyStatckpage({Key key, this.child}) : super(key: key);

  _MyStatckpageState createState() => _MyStatckpageState();
}

class _MyStatckpageState extends State<MyStatckpage> {
  var _currentIndex = 0;
  final PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: Scaffold(
        body: PageView(
          controller: _controller,
          children: <Widget>[Home(), History()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          selectedFontSize: 18,
          selectedItemColor: Color.fromRGBO(0, 204, 187, 1),
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('首页')),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), title: Text('记录'))
          ],
          onTap: (index) {
            _controller.jumpToPage(index);
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
