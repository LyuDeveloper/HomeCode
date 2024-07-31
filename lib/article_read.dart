import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'dart:convert';
import 'package:go_router/go_router.dart';

class ReadArtPage extends StatefulWidget{
  const ReadArtPage({super.key, required this.filename});

  final String filename;

  @override
  State<ReadArtPage> createState() => _ReadArtPage(filename: filename);
}

class TitleTextWidget extends StatelessWidget {
  final String name;
  TitleTextWidget({required this.name});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _fetchTitle(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Row(children: [Icon(Icons.no_sim),SizedBox(width: 10,),Text('加载出错',style: TextStyle(fontSize: 18))]);
        } else if (snapshot.hasData) {
          return Row(children: [const Icon(Icons.article),const SizedBox(width: 10,),Text(snapshot.data!,style: TextStyle(fontSize: 18))]);
        } else {
          return const Row(children: [Icon(Icons.no_sim),SizedBox(width: 10,),Text('加载出错',style: TextStyle(fontSize: 18))]);
        }
      },
    );
  }

  Future<String?> _fetchTitle() async {
    try {
      final contents = await rootBundle.loadString('files.json');
      final data = jsonDecode(contents) as List<dynamic>;

      for (var item in data) {
        if (item['link'] == name) {
          return item['title'] as String?;
        }
      }
    } catch (e) {
      print('Error reading JSON file: $e');
    }
    return null;
  }
}

class _ReadArtPage extends State<ReadArtPage>{
  String filename;
  _ReadArtPage({required this.filename});

  Future<bool?> ShareDialog() {

    final String currentUrl = Uri.base.toString();
    final String url = Uri.parse(currentUrl).toString();
    
    const copyBar = SnackBar(
      content: Text('已复制到剪切板'),
      duration: Duration(milliseconds: 1500),
    );

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Icon(Icons.share),
          content: Column(mainAxisSize: MainAxisSize.min,children: [const Text('本文地址'),Card(
                          child: Container(width: 400,height: 50,alignment: Alignment.center,child: Text(url,textAlign: TextAlign.center),))],),
          actions: <Widget>[
            FilledButton(onPressed: () {Clipboard.setData(ClipboardData(text: url));ScaffoldMessenger.of(context).showSnackBar(copyBar);}, child: const Text('复制'))
          ],
        );
      }
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitleTextWidget(name: filename),
        actions: [IconButton(onPressed: () async {await ShareDialog();}, icon: Icon(Icons.share)),
                  IconButton(onPressed: (){GoRouter.of(context).pushNamed("HomePage");}, icon: Icon(Icons.home))],
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
                  const Text(': - (',style: TextStyle(fontSize: 80)),
                  const Text("哦呦, 出错了",style: TextStyle(fontSize: 30),),
                  const Text('你所访问的文章无法加载\n'),
                  Text('${snapshot.error}',style: const TextStyle(color: Colors.blueGrey),textAlign: TextAlign.center,)
                ],
              ),
            );
          }else{
            print('article/$filename');
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
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