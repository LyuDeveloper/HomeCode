import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ReadArtPage extends StatelessWidget {
  String filename;

  ReadArtPage({required this.filename});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(filename),
      ),
      body:FutureBuilder(
        future: rootBundle.loadString('article/$filename'),
        builder: (BuildContext context,AsyncSnapshot snapshot){
          if(snapshot.hasData){
            return Markdown(data: snapshot.data);
          }else{
            return Center(
              child: Text("加载中..."),
            );
          }
        },
      ),
    );
  }
}