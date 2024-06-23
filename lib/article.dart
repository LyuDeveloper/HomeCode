import 'dart:convert';
// 导入dart:html包

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:flutter_web_home/article_read.dart';

class ArticlePage extends StatefulWidget {
  @override
  ArticlePageCode createState() => ArticlePageCode();
}

class ArticlePageCode extends State<ArticlePage> {
  List<Map<String, dynamic>> files = [];

  @override
  void initState() {
    super.initState();
    _loadFileNames(); 
  }

  Future<void> _loadFileNames() async {
    try {
      final String response = await rootBundle.loadString('files.json');
      final List<dynamic> data = json.decode(response);
      setState(() {
        files = data.map((e) => e as Map<String, dynamic>).toList();
      });
    } catch (e) {
      print("Error loading file names: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 300.0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('文章'),
              background: Image.asset("bg.png", fit: BoxFit.cover,),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.only(top: 10),
          ),
          SliverToBoxAdapter(
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: List.generate(files.length, (index) {
                final file = files[index];
                final fileName = file['name'];
                final lastModified = file['lastModified'];

                return ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ReadArtPage(filename: fileName),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 200),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        fileName,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        lastModified,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

