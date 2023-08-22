import 'package:flutter/material.dart';
import 'package:gps/components/log/logger.dart';

class LogWindow extends StatefulWidget {
  const LogWindow({Key? key}) : super(key: key);

  @override
  State<LogWindow> createState() => _LogWindowState();
}

class _LogWindowState extends State<LogWindow> {
  late ScrollController _scrollController; // ScrollController 추가

  Future<String>? logDataFuture;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(); // ScrollController 초기화
    logDataFuture = LogModule.readLogFile();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(decoration: BoxDecoration(color: Colors.grey),
            child: Text('보여지는 로그는 창을 연 시점의 로그입니다.')),
        Container(
          height: 310,
          width: 500,
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: FutureBuilder<String>(
            future: logDataFuture,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                });

                return SingleChildScrollView(
                  controller: _scrollController, // ScrollController 할당
                  child: Text(
                    snapshot.data ?? '',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
