import 'package:flutter/material.dart';
import 'package:task_up/screens/categories_screen.dart';
import 'package:task_up/screens/home_screen.dart';
import 'package:task_up/screens/todos_by_category.dart';
import 'package:task_up/service/category_service.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({Key key}) : super(key: key);

  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  List<Widget> _categoryList = List<Widget>();

  CategoryService _categoryService = CategoryService();
  void initState(){
    super.initState();
    getAllCategories();
  }
  getAllCategories() async {
    var categories = await _categoryService.readCategory();
    categories.forEach((category){
      setState(() {
        _categoryList.add(InkWell(
          onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> TodosByCategory(category: category['name'],))),
          child: ListTile(
            title: Text(category['name']),
          ),
        ));
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children:  <Widget> [
             UserAccountsDrawerHeader(
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('images/profile_pic.JPG'),
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
              ),
              accountName: const Text('Rishi'),
              accountEmail: const Text('rishivisvas421@gmail.com'),
            ),
            ListTile(
              leading:const Icon(Icons.home),
              title: const Text('Home'),
              onTap: ()=> Navigator.pop(context),
            ),
            ListTile(
              leading:const Icon(Icons.view_list),
              title: const Text('Categories'),
              onTap: ()=> Navigator.of(context)
        .push(MaterialPageRoute(builder: (context)=> CategoriesScreen())),
            ),
            const Divider(),
            Column(
              children: _categoryList,
            )
          ],
        ),
      ),
    );
  }
}
