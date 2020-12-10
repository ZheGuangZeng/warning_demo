import 'package:flutter/material.dart';
import 'package:waring_demo/models/history_model.dart';
import 'package:waring_demo/network/http_request.dart';
import 'history_child/history_child.dart';

class History extends StatelessWidget {
  final Widget child;

  History({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('首页'),
        ),
        body: HistoryBody());
  }
}

class HistoryBody extends StatefulWidget {
  final Widget child;

  HistoryBody({Key key, this.child}) : super(key: key);

  _HistoryBodyState createState() => _HistoryBodyState();
}

class _HistoryBodyState extends State<HistoryBody> {
  List<HistoryModel> userList = [];

  get index => null;
  @override
  void initState() {
    super.initState();
    HttpRequest.request('http://106.14.248.81:3000/call/inActiveCall')
        .then((res) {
      print(res.data);
      List<HistoryModel> users = [];
      for (var user in res.data) {
        users.add(HistoryModel.fromJson(user));
      }
      setState(() {
        this.userList = users;
      });
    });
  }

  Widget build(BuildContext context) {
    return Center(
        child: ListView.builder(
      itemCount: userList.length,
      itemBuilder: (BuildContext context, int index) {
        return HistoryItem(userList[index]);
      },
    ));
  }
}
