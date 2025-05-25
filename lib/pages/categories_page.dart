import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:login_api/pages/products_by_categories_page.dart';

class categoriespage extends StatefulWidget {
  const categoriespage({super.key});

  @override
  State<categoriespage> createState() => _categoriespageState();
}

class _categoriespageState extends State<categoriespage> {
  List<String> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchcategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text(
          "CategoriesProducts",
          style: TextStyle(fontFamily: 'font1', fontSize: 25),
        ),
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(category),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => productsbycategoriespage(
                                    categoryName: category,
                                  ),
                            ),
                          );
                        },
                      ),
                      Divider(thickness: 2, color: Colors.blue),
                    ],
                  );
                },
                itemCount: categories.length,
              ),
    );
  }

  Future<void> fetchcategories() async {
    final url = Uri.parse('https://dummyjson.com/products/category-list');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = convert.jsonDecode(response.body);
      setState(() {
        categories = List<String>.from(data);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        print("error");
      });
    }
  }
}
