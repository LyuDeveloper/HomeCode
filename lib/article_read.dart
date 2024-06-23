import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ReadArtPage extends StatelessWidget {
  String filename;
  String filetitle;

  ReadArtPage({required this.filename,required this.filetitle});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(filetitle),
      ),
      body:FutureBuilder(
        future: rootBundle.loadString('article/$filename'),
        builder: (BuildContext context,AsyncSnapshot snapshot){
          if(snapshot.hasData){
            return Markdown(data: snapshot.data);
          }else if (snapshot.hasError) {
            print('Error loading article: ${snapshot.error}');  
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error),
                  const Text("加载出错"),
                  Text('${snapshot.error}',style: const TextStyle(color: Colors.blueGrey,fontSize: 8),)
                ],
              ),
            );
          }else{
            print('article/$filename');
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                  ),
                  Text("加载中")
                ],
              ),
            );
          }
        },
      ),
    );
  }
}