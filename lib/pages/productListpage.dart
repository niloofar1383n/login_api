import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:login_api/pages/categories_page.dart';
import 'package:login_api/pages/user_page.dart';

class productlistpage extends StatefulWidget {
  const productlistpage({super.key});

  @override
  State<productlistpage> createState() => _productlistpageState();
}

class _productlistpageState extends State<productlistpage> {
  ScrollController _scrollController = ScrollController();
  List products = [];
  int limit = 10;
  int skip = 0;
  bool hasmore = true;
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    fetchproducts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchproducts();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => userpage()));
          },
          icon: Icon(Icons.person),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => categoriespage()));
            },
            icon: Icon(Icons.category),
          ),
        ],
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          "products",
          style: TextStyle(fontFamily: 'font1', fontSize: 25),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          if (index == products.length) {
            return isloading
                ? Center(child: CircularProgressIndicator())
                : SizedBox();
          }
          final product = products[index];
          return Column(
            children: [
              ListTile(
                title: Text(product['title']),
                subtitle: Column(
                  children: [
                    SizedBox(height: 15),
                    Text(product['description']),
                    SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "price:" + product['price'].toString() + "\$",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
                leading: Image.network(product['thumbnail']),
              ),
              Divider(thickness: 2, color: Colors.blue),
            ],
          );
        },
        itemCount: products.length + 1,
        controller: _scrollController,
      ),
    );
  }

  Future<void> fetchproducts() async {
    if (isloading && !hasmore) {
      return;
    }
    setState(() {
      isloading = true;
    });
    final url = Uri.parse(
      'https://dummyjson.com/products?limit=$limit&skip=$skip',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      List newproducts = data['products'];
      setState(() {
        skip += limit;
        products.addAll(newproducts);
        isloading = false;
        if (newproducts.length < limit) {
          hasmore = false;
        }
      });
    } else {
      setState(() {
        isloading = false;
        print("error");
      });
    }
  }
}
