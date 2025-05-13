
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:login_api/pages/user_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
class loginpage extends StatefulWidget {
const loginpage({super.key});

@override
State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
final _formkey=GlobalKey<FormState>();
final usernamecontroller=TextEditingController();
final passwordcontroller=TextEditingController();
bool isobscure=true;
@override
Widget build(BuildContext context) {

return Scaffold(
body: SingleChildScrollView(
child: Column(children: [
Container(width: double.infinity,height: 200,decoration: BoxDecoration(
color: Colors.green,borderRadius: BorderRadius.vertical(bottom: Radius.circular(45))
),
child: Align(
alignment: Alignment.center,
child: Text("login",style: TextStyle(color: Colors.white,fontSize: 35,fontWeight: FontWeight.bold,))),)
,SizedBox(height: 150,),
Form(
key:_formkey,
child: Column(
children: [Container(
width: 350,
height: 90,
child: TextFormField(
controller: usernamecontroller,
validator: (value){
if(value!.isEmpty){
return "please enter your user name";
}
final usernameRegexp=RegExp(r'^[a-zA-Z0-9._]+$');
if(!usernameRegexp.hasMatch(value)){
return "Username can only contain letters,numbers,underscore,and periods";
}
},
style: TextStyle(fontSize: 20),
decoration: InputDecoration(
errorMaxLines: 2,
prefixIcon: Icon(Icons.person,color: Colors.green,size: 30,),
fillColor: Colors.black12.withAlpha(10),
filled: true,
contentPadding: EdgeInsets.all(15),
labelText: "user name",
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(20),
borderSide: BorderSide(color: Colors.black54)
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(20),
borderSide: BorderSide(color: Colors.green,width: 3)
),
focusedErrorBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(20),
borderSide: BorderSide(color: Colors.red,width: 3)
)
),
)),
SizedBox(height: 20,),
Container(

width: 350,
height: 90,
child: TextFormField(
controller: passwordcontroller,
validator: (value){
if(value!.isEmpty){
return "please enter your password";
}
},
style: TextStyle(fontSize: 20),
obscureText: isobscure,
decoration: InputDecoration(

prefixIcon:  Icon(Icons.password,color: Colors.green,size: 30,),
suffixIcon: IconButton(onPressed: (){
setState(() {
isobscure = !isobscure;
});
}, icon: Icon(isobscure?Icons.visibility_off:Icons.visibility)) ,
fillColor: Colors.black12.withAlpha(10),
filled: true,
contentPadding: EdgeInsets.all(15),
labelText: "password",
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(20),
borderSide: BorderSide(color: Colors.black54)
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(20),
borderSide: BorderSide(color: Colors.green,width: 3)
),
focusedErrorBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(20),
borderSide: BorderSide(color: Colors.red,width: 3)
),
errorBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(20),
borderSide: BorderSide(color: Colors.red,width: 3)
)
),
)),
SizedBox(height: 100,),
ElevatedButton(
style: ElevatedButton.styleFrom(padding: EdgeInsets.only(top: 8,bottom: 8,right: 100,left: 100),backgroundColor: Colors.green,elevation: 4,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
onPressed: (){
if(_formkey.currentState!.validate()){
login();
}
}, child: Text("Login",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)))],
))
],),
),
);
}
Future<void> login() async{
final url=Uri.parse("https://dummyjson.com/auth/login");
final response=await http.post(url,headers:{'Content-Type':'application/json'},body: convert.jsonEncode({'username':usernamecontroller.text,'password':passwordcontroller.text}));
if(response.statusCode==200){
final data= convert.jsonDecode(response.body);
final token=data['token'];
final prefs=await SharedPreferences.getInstance();
await prefs.setString('token', token);
await getuserinfo(token);
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Center(child: Text("login successful",style: TextStyle(fontSize: 25),)),behavior: SnackBarBehavior.floating,margin: EdgeInsets.all(10),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),));
}
else{
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Center(child: Text("login failed",style: TextStyle(fontSize: 25),)),behavior: SnackBarBehavior.floating,margin: EdgeInsets.all(10),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),));
}
}
Future<void> getuserinfo(String token) async{
final url=Uri.parse("https://dummyjson.com/auth/me");
final response=await http.get(url,headers: {'Authorization':'Bearer $token'});
if(response.statusCode==200){
final userdata=convert.jsonDecode(response.body);
final prefs=await SharedPreferences.getInstance();
await prefs.setString('user', convert.jsonEncode(userdata));
Navigator.of(context).push(MaterialPageRoute(builder: (context)=>userpage()));
}
}
}