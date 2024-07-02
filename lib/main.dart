import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_web_home/MGPD.dart';
import 'package:flutter_web_home/article_read.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        routes: {
          '/MatesPhotoDownloads': (context) => MatesPhotoDownload()
        },
        title: 'Lyu Home',
        theme: ThemeData(
          colorScheme: lightColorScheme ?? ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
       ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme ?? ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      );
    });
  }
}

class ThemeImage extends StatelessWidget {
  final String lightImage;
  final String darkImage;

  ThemeImage({
    required this.lightImage,
    required this.darkImage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final imageAsset = isDarkMode ? darkImage : lightImage;

    return Image(image: AssetImage(imageAsset));
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isProjectButtonEnabled = true;
  bool isArticleButtonEnabled = false;
  double cardWidth = 200;
  double cardHeigh = 220;

  List<Map<String, dynamic>> files = [];

  @override
  void initState() {
    super.initState();
    _loadFileNames(); 
  }

  Future<bool?> MailDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Icon(Icons.mail),
          content: const Text("邮件地址:\nlyupublic@outlook.com\n请向该邮箱发送邮件"),
          actions: <Widget>[
            OutlinedButton(onPressed: () => Navigator.of(context).pop(true), child: Text('确认')),
            FilledButton(onPressed: () {Clipboard.setData(ClipboardData(text: "lyupublic@outlook.com"));}, child: Text('复制地址'))
          ],
        );
      }
    );
  }

  Future<bool?> ContactDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Icon(Icons.person_add),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("联系我"),
              SizedBox(height: 5,),
              FilledButton.tonalIcon(onPressed: () {launchUrlString('https://space.bilibili.com/2059291308');}, icon: const Icon(Icons.live_tv, size: 15,), label: Text('B站主页')),
              SizedBox(height: 5,),
              FilledButton.tonalIcon(onPressed: () async {await MailDialog();}, icon: Icon(Icons.mail, size: 15,), label: Text('邮箱')),
            ]
          ),
          actions: <Widget>[
            FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text('确认')),
          ],
        );
      }
    );
  }

  Future<bool?> PrivateDialog() {
    String result = '';
    String see = '';
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, dialogState) => AlertDialog(
          title: Icon(Icons.lock_person),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("输入Private Key以查看私有内容"),
              TextField(
                onChanged: (a) {
                  result = a;
                },
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Private Key",
                  hintText: "在此输入",
                  prefixIcon: Icon(Icons.key)
                ),
              ),
              Text(see, style: const TextStyle(color: Colors.red),)
            ],
          ),
          actions: <Widget>[
            OutlinedButton(onPressed: () {Navigator.of(context).pop();}, child: Text('取消')),
            FilledButton(onPressed: () {
              print(result);
              if (result != '') {
                if (result == '2021mates') {
                  dialogState(() => result);
                  see = '';
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => new MatesPhotoDownload()));
                } else {
                  dialogState(() => result);
                  see = '无 ' + result + ' 的内容';
                  if (see.length >= 29) {
                    see = '无结果';
                  }
                  print('No Results');
                }
              } else {
                result = '';
                dialogState(() => result);
                see = '';
              }
            }, child: Text('确认'))
          ],
        )
      )
    );
  }

  String search_label = '文章';
  String fileWillBeLoadName = 'files.json';

  Future<void> _loadFileNames() async {
    try {
      final String response = await rootBundle.loadString(fileWillBeLoadName);
      final List<dynamic> data = json.decode(response);
      setState(() {
        files = data.map((e) => e as Map<String, dynamic>).toList();
      });
    } catch (e) {
      print("Error loading file names: $e");
    }
  }

  void toggleButtons() {
    setState(() {
      isProjectButtonEnabled = !isProjectButtonEnabled;
      isArticleButtonEnabled = !isArticleButtonEnabled;
      if(isArticleButtonEnabled == false){
        search_label = '文章'; fileWillBeLoadName = 'files.json';
        cardWidth = 200;
        cardHeigh = 220;
      };
      if(isProjectButtonEnabled == false){
        search_label = '项目'; fileWillBeLoadName = 'projects.json';
        cardWidth = 300;
        cardHeigh = 150;
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    const wait_expect = SnackBar(
      content: Text('搜索功能敬请期待~'),
      duration: Duration(milliseconds: 1500),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 300.0,
            actions: const <Widget> [ClipOval(child: Image(image: AssetImage('head.jpeg'), height: 40,))],
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Lyu Web Home'),
              background: Image.asset("bg.png", fit: BoxFit.cover,),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.only(top: 10),
          ),
          const SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                Text('欢迎访问 Lyu 的个人主页', style: TextStyle(fontSize: 25),),
                Text('本人在校学生，想在互联网上留点什么'),
                Text('于是你就看到了这个网站')
              ],
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.only(top: 20),
          ),
          SliverToBoxAdapter(
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(width: 10,),
                      FilledButton.icon(
                        onPressed: isArticleButtonEnabled ? () {toggleButtons();_loadFileNames();} : null, 
                        icon: Icon(Icons.book, size: 20,), 
                        label: Text('文章'),
                      ),
                      SizedBox(width: 10,),
                      FilledButton.icon(
                        onPressed: isProjectButtonEnabled ? () {toggleButtons(); _loadFileNames();} : null, 
                        icon: Icon(Icons.folder_copy, size: 20,), 
                        label: Text('项目'),
                      ),
                      SizedBox(width: 10,),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(search_label, style: TextStyle(fontSize: 15),),
                      SizedBox(width: 5,),
                      IconButton(onPressed: () {ScaffoldMessenger.of(context).showSnackBar(wait_expect);}, icon: const Icon(Icons.search)),
                      SizedBox(width: 10,)
                    ],
                  ),
                ),
              ],
            )
          ),
          const SliverPadding(
            padding: EdgeInsets.only(top: 20),
          ),
          SliverToBoxAdapter(
            child: Row(
              children: [
                SizedBox(width: 10,),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: List.generate(files.length, (index) {
                    final object = files[index];
                    final link = object['link'];
                    final info = object['info'];
                    final Title = object['title'];
                    final introduction = object['intro'];
                    return ElevatedButton(
                      onPressed: () {
                        if(fileWillBeLoadName == 'files.json'){
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ReadArtPage(filename: link, filetitle: Title,),
                          ));
                        }
                        
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(cardWidth, cardHeigh),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            Title,
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          Text(
                            info,
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            introduction,
                            style: TextStyle(fontSize: 10, color: Colors.black),
                          ),
                          Text(
                            '\n$link',
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          )
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 10,)
              ],
            )
          ),
          const SliverPadding(
            padding: EdgeInsets.only(top: 50),
          ),
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('\nPowered by \n', style: TextStyle(fontSize: 11)),
                SizedBox(width: 30, child: ThemeImage(lightImage: 'github.png', darkImage: 'github_white.png'),),
                SizedBox(width: 80, child: ThemeImage(lightImage: 'GitHub_Logo.png', darkImage: 'GitHub_Logo_White.png'),),
                Text('Page', style: TextStyle(fontSize: 22),),
                SizedBox(width: 5,),
                IconButton.filled(onPressed: () {launchUrlString('https://www.github.io/');}, icon: Icon(Icons.open_in_new), iconSize: 20,)
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 80),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                heroTag: "私有",
                onPressed: () async {await PrivateDialog();},
                child: Icon(Icons.lock_person),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: "联系我",
              onPressed: () async {await ContactDialog();},
              child: Icon(Icons.person_add),
            ),
          ),
        ],
      )
    );
  }
}
