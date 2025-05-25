import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class productsbycategoriespage extends StatefulWidget {
  final String categoryName;

  const productsbycategoriespage({super.key, required this.categoryName});

  @override
  State<productsbycategoriespage> createState() =>
      _productsbycategoriespageState();
}

class _productsbycategoriespageState extends State<productsbycategoriespage> {
  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchproducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    title: Text(product['title']),
                    subtitle: Text("price:${product['price']}\$"),
                    leading: Image.network(product['thumbnail']),
                  );
                },
                itemCount: products.length,
              ),
    );
  }

  Future<void> fetchproducts() async {
    final url = Uri.parse(
      'https://dummyjson.com/products/category/${widget.categoryName}',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      print(data);
      setState(() {
        products = data['products'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
}
