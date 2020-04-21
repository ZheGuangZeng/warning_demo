import 'package:flutter/material.dart';
import 'package:waring_demo/models/history_model.dart';
import 'package:intl/intl.dart';

class HistoryItem extends StatelessWidget {
  final HistoryModel item;
  HistoryItem(this.item);

  @override
  Widget build(BuildContext context) {
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
                        .add_jms()
                        .format(DateTime.parse(item.createdAt).toLocal()),
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 9),
              child: Column(
                children: <Widget>[
                  // Row(
                  //   children: <Widget>[
                  //     Text('警报楼号：',
                  //         style:
                  //             TextStyle(fontSize: 14, color: Colors.black54)),
                  //     Container(
                  //       padding:
                  //           EdgeInsets.symmetric(vertical: 5, horizontal: 9),
                  //       decoration: BoxDecoration(
                  //           color: Color.fromARGB(255, 238, 205, 144),
                  //           borderRadius: BorderRadius.circular(5)),
                  //       child: Text(
                  //         item.building + '号楼',
                  //         style: TextStyle(fontSize: 18, color: Colors.white),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  // SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      Text('警报楼层：',
                          style:
                              TextStyle(fontSize: 14, color: Colors.black54)),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 9),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 238, 205, 144),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          (item.floor != null) ? item.floor : '',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      Text('警报楼床：',
                          style:
                              TextStyle(fontSize: 14, color: Colors.black54)),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 9),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 238, 205, 144),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          item.bed + '床',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              width: double.infinity,
              // decoration: BoxDecoration(
              //     color: Color(0xfff2f2f2),
              //     borderRadius: BorderRadius.circular(5)),
              // child: Text(
              //   '住户信息：' + item.id,
              //   style: TextStyle(fontSize: 14, color: Colors.black54),
              // ),
            )
          ],
        ),
      ),
    );
  }
}
