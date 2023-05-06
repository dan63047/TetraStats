import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<http.Response> fetchPlayer() {
    return http.get(Uri.parse('https://ch.tetr.io/api/users/6098518e3d5155e6ec429cdc'));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Tetra Stats"),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Column(
                children: [
                  const Text("dan63047"),
                  const Text("18601 TR"),
                  TextButton(onPressed: (){print("killed");}, child: const Text(".don die"))
                ]
            )
          ],
        ),
      ),
    );
  }
}