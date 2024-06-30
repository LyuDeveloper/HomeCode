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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        routes: {
          '/MatesPhotoDownloads':(context) => MatesPhotoDownload()
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
    }
  );
}

}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
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

class _MyHomePageState extends State<MyHomePage> {
  
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


  Future<bool?> MailDialog(){
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Icon(Icons.mail),
          content: const Text("邮件地址:\nlyupublic@outlook.com\n请向该邮箱发送邮件"),
          actions: <Widget>[
          OutlinedButton(onPressed: () => Navigator.of(context).pop(true), child: Text('确认')),
          FilledButton(onPressed: (){Clipboard.setData(ClipboardData(text: "lyupublic@outlook.com"));}, child: Text('复制地址'))
          ],
        );
      }
    );
  }
  Future<bool?> ContactDialog(){
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Icon(Icons.person_add),
          content: Text("欢迎新朋友\n(^-^)联系方式"),
          actions: <Widget>[
            Expanded(flex: 20,child: FilledButton.icon(onPressed: () {launchUrlString('https://space.bilibili.com/2059291308');},icon: const Icon(Icons.live_tv,size: 15,) ,label: Text('B站主页')),),
            Expanded(flex: 20,child: FilledButton.icon(onPressed: () async {await MailDialog();},icon: Icon(Icons.mail,size: 15,), label: Text('邮箱'),),),
          ],
        );
      }
    );
  }
  Future<bool?> PrivateDialog(){
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
              Text(see,style: const TextStyle(color: Colors.red),)
            ],
          ),
          actions: <Widget>[
          OutlinedButton(onPressed: (){Navigator.of(context).pop();}, child: Text('取消')),
          FilledButton(onPressed: () {
            print(result);
            if (result != ''){
              if (result == '2021mates'){
                dialogState(() => result);
                see = '';
                 Navigator.push(context, new MaterialPageRoute(builder: (context) => new MatesPhotoDownload()));
              }
              else{
                dialogState(() => result);
                see = '无 '+result+' 的内容';
                if (see.length >= 29){
                  see = '无结果';
                }
                print('No Results');
              }
            }
            else{
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
  
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 300.0,
            actions: const <Widget> [ClipOval(child: Image(image: AssetImage('head.jpeg'),height: 40,))],
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Lyu Web Home'),
              background: Image.asset("bg.png",fit: BoxFit.cover,),
            ),
          ),
          const SliverPadding(
              padding: EdgeInsets.only(top: 10),
          ),
          const SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                Text('欢迎访问 Lyu 的个人主页',style: TextStyle(fontSize: 25),),
                Text('本人在校学生，想在互联网上留点什么'),
                Text('于是你就看到了这个网站')
              ],
            ),
          ),
          const SliverPadding(
              padding: EdgeInsets.only(top: 20),
          ),
          const SliverPadding(
              padding: EdgeInsets.only(top: 20),
          ),
          SliverToBoxAdapter(
            child: Flex(
              direction:Axis.horizontal,
              children: [
                const Spacer(flex: 1),
                const Expanded(
                  flex: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.book,size: 30,),
                      Text("文章",style: TextStyle(fontSize: 20))
                    ],
                  ),
                ),
                Expanded(
                  flex: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(onPressed: (){print('search');}, icon: const Icon(Icons.search))
                    ],
                  ),
                ),
                const Spacer(flex: 1)
              ],
            )
          ),
          const SliverPadding(
              padding: EdgeInsets.only(top: 20),
          ),
          SliverToBoxAdapter(
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: List.generate(files.length, (index) {
                final file = files[index];
                final fileName = file['name'];
                final lastModified = file['lastModified'];
                final fileTitle = file['filetitle'];
                final fileFirstLine = file['firstline'];
                print(file);
                print(fileName);
                print(lastModified);
                print(fileTitle);
                print(fileFirstLine);
                return ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ReadArtPage(filename: fileName,filetitle: fileTitle,),
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
                        fileTitle,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        lastModified,
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        fileFirstLine,
                        style: TextStyle(fontSize: 10,color: Colors.black),
                      ),
                      Text(
                        '\n$fileName',
                        style: TextStyle(fontSize: 10,color: Colors.grey),
                      )
                    ],
                  ),
                );
              }),
            ),
          ),
          const SliverPadding(
              padding: EdgeInsets.only(top: 50),
          ),
          
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('\nPowered by   \n', style: TextStyle(fontSize: 11)),
                SizedBox(width: 30, child: ThemeImage(lightImage: 'github.png', darkImage: 'github_white.png'),),
                SizedBox(width: 80, child: ThemeImage(lightImage: 'GitHub_Logo.png', darkImage: 'GitHub_Logo_White.png'),),
                Text('Page',style: TextStyle(fontSize: 22),),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(bottom:80),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            heroTag: "私有",
            onPressed: ()async {await PrivateDialog();},
            child: Icon(Icons.lock),),
        ),),

        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            heroTag: "联系我",
            onPressed: () async {await ContactDialog();},
          child: Icon(Icons.person_add),),
        ),
      ],
      )
    );
  }
}
