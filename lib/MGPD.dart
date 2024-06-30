import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MatesPhotoDownload extends StatefulWidget{
  @override
  _MatesPhotoDownload createState() => _MatesPhotoDownload();
}

class _MatesPhotoDownload extends State<MatesPhotoDownload> with SingleTickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('欢迎'),
              background: Image.asset("bg.png",fit: BoxFit.cover,),
            ),
          ),
          const SliverPadding(
              padding: EdgeInsets.only(top: 10),
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('  海内存知己，天涯若比邻。',style: TextStyle(fontSize: 20),),
                Text('在此下载于2024/6/11拍摄的照片',style: TextStyle(fontSize: 15),),
                Text('有包含不同文件的压缩包',style: TextStyle(fontSize: 15),),
                Text('它们的内容一样，但是使用不同的文件格式',style: TextStyle(fontSize: 15),)
              ],
            )
          ),
          SliverPadding(
              padding: EdgeInsets.only(top: 10),
          ),
          SliverToBoxAdapter(
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'JPG'),
                Tab(text: 'JPG & RAW',)
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 400,
              child: TabBarView(
                controller: _tabController,
                children: [
                  JPG_Page(),
                  JPG_RAW_Page()
              ],
            )
            
            ),
          )
        ],
      ),
    );
  }
}

class JPG_Page extends StatelessWidget{
  const JPG_Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.photo),
        Text("从这下载的是JPG格式的照片压缩包"),
        Text("这些照片拥有完整的内容，以及更高的压缩比"),
        Text("这带来了更小的内存占用"),
        Text("如果你只想浏览照片，建议下载这个文件"),
        Text("\n访问密码:k2vl\n", style: TextStyle(fontSize: 10),),
        Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Spacer(flex: 22,),
            Expanded(flex: 20, child: FilledButton(onPressed: (){launchUrlString('https://cloud.189.cn/web/share?code=aYjErqV3Uruu（访问码：k2vl）');} ,child: Text('前往下载'),)),//k2vl
            Spacer(flex: 22,)
          ],
        ),
        Text("\n即将前往:天翼云盘",style: TextStyle(color: Colors.grey,fontSize: 10),),
        Text("若无法打开，请点击下方按钮复制链接\n",style: TextStyle(color: Colors.grey,fontSize: 10),),
        Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Spacer(flex: 22,),
            Expanded(flex: 20, child: ElevatedButton(onPressed: (){Clipboard.setData(ClipboardData(text: "https://cloud.189.cn/web/share?code=aYjErqV3Uruu（访问码：k2vl）"));} ,child: Text('复制'))),
            Spacer(flex: 22,),
          ]
        )
      ]
    );
  }
}

class JPG_RAW_Page extends StatelessWidget{
  const JPG_RAW_Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.photo_camera_back),
        Text("从这下载的是JPG和RAW(CR3)格式的照片压缩包"),
        Text("这些照片拥有完整的内容，以及更完整的数据"),
        Text("这带来了更大的内存占用，同时有利于复杂照片编辑"),
        Text("如果你想进行较专业的照片编辑，建议下载这个文件"),
        Text("\n访问密码:ywk1\n", style: TextStyle(fontSize: 10),),
        Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Spacer(flex: 22,),
            Expanded(flex: 20, child: FilledButton(onPressed: (){launchUrlString('https://cloud.189.cn/web/share?code=m2E3mireIf6v（访问码：ywk1）');} ,child: Text('前往下载'))),//ywk1
            Spacer(flex: 22,),
          ],
        ),
        Text("\n即将前往:天翼云盘",style: TextStyle(color: Colors.grey,fontSize: 10),),
        Text("若无法打开，请点击下方按钮复制链接\n",style: TextStyle(color: Colors.grey,fontSize: 10),),
        Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Spacer(flex: 22,),
            Expanded(flex: 20, child: ElevatedButton(onPressed: (){Clipboard.setData(ClipboardData(text: "https://cloud.189.cn/web/share?code=m2E3mireIf6v（访问码：ywk1）"));} ,child: Text('复制'))),
            Spacer(flex: 22,),
          ]
        )
      ],
    );
  }
}