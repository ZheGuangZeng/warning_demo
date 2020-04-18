import 'package:flutter/material.dart';
import 'package:waring_demo/views/history/history.dart';
import 'package:waring_demo/views/home/home.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Widget child;

  MyApp({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: '馨安家园',
          theme: ThemeData(
            primaryColor: Colors.black,
            brightness: Brightness.dark,
          ),
          home: MyStatckpage()),
      onWillPop: () async => false,
    );
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
    return Scaffold(
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
          BottomNavigationBarItem(icon: Icon(Icons.history), title: Text('记录'))
        ],
        onTap: (index) {
          _controller.jumpToPage(index);
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
