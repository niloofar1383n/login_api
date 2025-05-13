import 'package:flutter/material.dart';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class userpage extends StatelessWidget {
  Future<Map<String,dynamic>> loaduserdata()async{
    final prefs=await SharedPreferences.getInstance();
    final jsonString=prefs.getString('user')??'{}';
    return convert.jsonDecode(jsonString!);
  }
  const userpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text("user information"),
      ),
      body: FutureBuilder(future: loaduserdata(), builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        final user=snapshot.data as Map<String,dynamic>;
        return ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text("name ${user['firstName']} ${user['lastName']}"),
            Text("Age ${user['age']}")
          ],
        );
      }),
    );
  }
}