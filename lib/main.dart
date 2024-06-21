import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_web_home/MGPD.dart';
import 'package:url_launcher/url_launcher_string.dart';


void main() {
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

class _MyHomePageState extends State<MyHomePage> {
  Future<bool?> MailDialog(){
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Icon(Icons.mail),
          content: Text("邮件地址:\nlyupublic@outlook.com\n请向该邮箱发送邮件"),
          actions: <Widget>[
          OutlinedButton(onPressed: () => Navigator.of(context).pop(true), child: Text('确认')),
          FilledButton(onPressed: (){Clipboard.setData(ClipboardData(text: "lyupublic@outlook.com"));}, child: Text('复制地址'))
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
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Lyu Web Home'),
              background: Image.asset("bg.png",fit: BoxFit.cover,),
            ),
          ),
          const SliverPadding(
              padding: EdgeInsets.only(top: 10),
            ),
          SliverToBoxAdapter(
            child:Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                const Spacer(flex: 1,),
                Expanded(flex: 20,child: FilledButton.icon(onPressed: () async {await PrivateDialog();}, icon: const Icon(Icons.lock_person,size: 15,),label: Text('私有'),),),
                const Spacer(flex: 1,),
                Expanded(flex: 20,child: FilledButton.icon(onPressed: (){const snackBar = SnackBar(content: Text('敬请期待'),);ScaffoldMessenger.of(context).showSnackBar(snackBar);}, icon: const Icon(Icons.book,size: 15,),label: Text('文章'),),),
                const Spacer(flex: 1,),
                Expanded(flex: 20,child: FilledButton.icon(onPressed: (){const snackBar = SnackBar(content: Text('敬请期待'),);ScaffoldMessenger.of(context).showSnackBar(snackBar);}, icon: const Icon(Icons.folder_copy, size: 15,),label: Text('项目'),),),
                const Spacer(flex: 1,)
              ],
            )
          ),
          const SliverPadding(
              padding: EdgeInsets.only(top: 20),
            ),
          const SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.person,size: 40,),
                    Text("你好",textScaleFactor: 2,)
                  ],
                ),
                Text('欢迎访问 Lyu<0x2279fc8e> 的个人主页'),
                Text('本人在校学生，想在互联网上留点什么'),
                Text('于是你就看到了这个网站')
              ],
            ),
          ),
          const SliverPadding(
              padding: EdgeInsets.only(top: 20),
          ),
          SliverToBoxAdapter(
            child: ClipOval(child: Image(image: AssetImage('head.jpeg'),height: 50,),)
          ),
          
          const SliverPadding(
              padding: EdgeInsets.only(top: 20),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                const Text('联系我',textScaleFactor: 2,),
                Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    const Spacer(flex: 11,),
                    Expanded(flex: 20,child: FilledButton.icon(onPressed: () {launchUrlString('https://space.bilibili.com/2059291308');},icon: const Icon(Icons.live_tv,size: 15,) ,label: Text('B站主页')),),
                    const Spacer(flex: 1,),
                    Expanded(flex: 20,child: FilledButton.icon(onPressed: () async {await MailDialog();},icon: Icon(Icons.mail,size: 15,), label: Text('邮箱'),),),
                    const Spacer(flex: 11,),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
