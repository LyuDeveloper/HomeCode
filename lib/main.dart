import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:go_router/go_router.dart';

import 'MGPD.dart';
import 'route.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp.router(
        title: 'Lyu Home',
        theme: ThemeData(
          colorScheme: lightColorScheme ?? ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
       ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme ?? ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
          useMaterial3: true,
        ),
        routeInformationParser: AppRoutes.router.routeInformationParser,
        routerDelegate: AppRoutes.router.routerDelegate,
      );
    });
  }
}

class ThemeImage extends StatelessWidget {
  final String lightImage;
  final String darkImage;

  const ThemeImage({super.key, 
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
  String photofolder = "article_photo/";

  List<Map<String, dynamic>> files = [];

  @override
  void initState() {
    super.initState();
    _loadFileNames(); 
  }

  Future<bool?> MailDialog() {
    
    const copyBar = SnackBar(
      content: Text('已复制到剪切板'),
      duration: Duration(milliseconds: 1500),
    );

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Icon(Icons.mail),
          content: const Text("邮件地址:\nlyupublic@outlook.com\n请向该邮箱发送邮件"),
          actions: <Widget>[
            OutlinedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('确认')),
            FilledButton(onPressed: () {Clipboard.setData(const ClipboardData(text: "lyupublic@outlook.com"));ScaffoldMessenger.of(context).showSnackBar(copyBar);}, child: const Text('复制地址'))
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
          title: const Icon(Icons.person_add),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("联系我"),
              const SizedBox(height: 5,),
              FilledButton.tonalIcon(onPressed: () {launchUrlString('https://space.bilibili.com/2059291308');}, icon: const Icon(Icons.live_tv, size: 15,), label: const Text('B站主页')),
              const SizedBox(height: 5,),
              FilledButton.tonalIcon(onPressed: () async {await MailDialog();}, icon: const Icon(Icons.mail, size: 15,), label: const Text('   邮箱   ')),
            ]
          ),
          actions: <Widget>[
            FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('确认')),
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
          title: const Icon(Icons.lock_person),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("输入Private Key以查看私有内容"),
              TextField(
                onChanged: (a) {
                  result = a;
                },
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: "Private Key",
                  hintText: "在此输入",
                  prefixIcon: Icon(Icons.key)
                ),
              ),
              Text(see, style: const TextStyle(color: Colors.red),)
            ],
          ),
          actions: <Widget>[
            OutlinedButton(onPressed: () {Navigator.of(context).pop();}, child: const Text('取消')),
            FilledButton(onPressed: () {
              if (kDebugMode) {
                print(result);
              }
              if (result != '') {
                if (result == '2021mates') {
                  dialogState(() => result);
                  see = '';
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MatesPhotoDownload()));
                } else {
                  dialogState(() => result);
                  see = '无 $result 的内容';
                  if (see.length >= 29) {
                    see = '无结果';
                  }
                }
              } else {
                result = '';
                dialogState(() => result);
                see = '';
              }
            }, child: const Text('确认'))
          ],
        )
      )
    );
  }

  String searchlabel = '文章';
  String fileWillBeLoadName = 'files.json';

  Future<void> _loadFileNames() async {
    try {
      final String response = await rootBundle.loadString(fileWillBeLoadName);
      final List<dynamic> data = json.decode(response);
      setState(() {
        files = data.map((e) => e as Map<String, dynamic>).toList();
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error loading file names: $e");
      }
    }
  }

  void toggleButtons() {
    setState(() {
      isProjectButtonEnabled = !isProjectButtonEnabled;
      isArticleButtonEnabled = !isArticleButtonEnabled;
      if(isArticleButtonEnabled == false){
        searchlabel = '文章'; fileWillBeLoadName = 'files.json';
        photofolder = 'article_photo/';
      }
      if(isProjectButtonEnabled == false){
        searchlabel = '项目'; fileWillBeLoadName = 'projects.json';
        photofolder = 'project_photo/';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const waitExpect = SnackBar(
      content: Text('搜索功能敬请期待~'),
      duration: Duration(milliseconds: 1500),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: Text(''),
            pinned: true,
            expandedHeight: 400.0,
            actions: const <Widget> [ClipOval(child: Image(image: AssetImage('head.jpeg'), height: 40,))],
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Lyu Web Home', style: TextStyle(color:Colors.white)),
              background: Image.asset("TopImg.png", fit: BoxFit.cover,),
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
                      const SizedBox(width: 10,),
                      FilledButton.icon(
                        onPressed: isArticleButtonEnabled ? () {toggleButtons();_loadFileNames();} : null, 
                        icon: const Icon(Icons.book, size: 20,), 
                        label: const Text('文章'),
                      ),
                      const SizedBox(width: 10,),
                      FilledButton.icon(
                        onPressed: isProjectButtonEnabled ? () {toggleButtons(); _loadFileNames();} : null, 
                        icon: const Icon(Icons.folder_copy, size: 20,), 
                        label: const Text('项目'),
                      ),
                      const SizedBox(width: 10,),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(searchlabel, style: const TextStyle(fontSize: 15),),
                      const SizedBox(width: 5,),
                      IconButton(onPressed: () {ScaffoldMessenger.of(context).showSnackBar(waitExpect);}, icon: const Icon(Icons.search)),
                      const SizedBox(width: 10,)
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8.0,
                runSpacing: 4.0,
                children: List.generate(files.length, (index) {
                  final object = files[index];
                  final link = object['link'];
                  final info = object['info'];
                  final title = object['title'];
                  final introduction = object['intro'];
                  final photo = object['photo'];
                  return SizedBox(
                    width: 300,
                    height: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        if(fileWillBeLoadName == 'files.json'){
                          GoRouter.of(context).pushNamed(
                            "ReadArtPage",
                            params: {'name': '$link'},
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                title,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                info,
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                introduction,
                                style: const TextStyle(fontSize: 10, color: Colors.black),
                              ),
                              Text(
                                '\n$link',
                                style: const TextStyle(fontSize: 10, color: Colors.grey),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 140,
                            width: 15,
                          ),
                          SizedBox(
                            height: 120,
                            width: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image(image: AssetImage(photofolder+photo)),
                            )
                          )
                        ],
                      )
                    ),
                  );
                }),
              ),
            )
          ),
          const SliverPadding(
            padding: EdgeInsets.only(top: 50),
          ),
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('\nPowered by \n', style: TextStyle(fontSize: 11)),
                const SizedBox(width: 30, child: ThemeImage(lightImage: 'github.png', darkImage: 'github_white.png'),),
                const SizedBox(width: 80, child: ThemeImage(lightImage: 'GitHub_Logo.png', darkImage: 'GitHub_Logo_White.png'),),
                const Text('Page', style: TextStyle(fontSize: 22),),
                const SizedBox(width: 5,),
                IconButton.filled(onPressed: () {launchUrlString('https://www.github.io/');}, icon: const Icon(Icons.open_in_new), iconSize: 20,)
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                heroTag: "私有",
                onPressed: () async {await PrivateDialog();},
                child: const Icon(Icons.lock_person),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: "联系我",
              onPressed: () async {await ContactDialog();},
              child: const Icon(Icons.person_add),
            ),
          ),
        ],
      )
    );
  }
}
