import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(children: [Icon(Icons.error),SizedBox(width: 10,),Text('出现错误',style: TextStyle(fontSize: 18))]),
        actions: [IconButton(onPressed: (){context.pushReplacementNamed('HomePage');}, icon: const Icon(Icons.home))],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(':-(',style: TextStyle(fontSize: 80),textAlign: TextAlign.center,),
            Text("哦呦, 出错了",style: TextStyle(fontSize: 30),),
            Text('你所访问的页面不存在\n'),
            Text('404 Not Found',style: TextStyle(color: Colors.blueGrey)),
          ],
        ),
      ),
    );
  }
}
