import 'package:flutter/material.dart';
import 'package:task_up/models/category.dart';
import 'home_screen.dart';
import 'package:task_up/service/category_service.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();
  var _editCategoryNameController = TextEditingController();
  var _editCategoryDescriptionController = TextEditingController();
  var _category  = Category();
  var _categoryService = CategoryService();

  List<Category> _categoryList = List<Category>();
  var category;
  void initState(){
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    _categoryList = List<Category>();
    var categories = await _categoryService.readCategory();
    categories.forEach((category){
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category['name'];
        categoryModel.description = category['description'];
        categoryModel.id = category['id'];
        _categoryList.add(categoryModel);
      });
    });
    }
  _editCategory(BuildContext context, categoryId) async {
    category = await _categoryService.readCategoryById(categoryId);
    setState(() {
      _editCategoryNameController.text = category[0]['name'] ?? 'No Name';
      _editCategoryDescriptionController.text =
          category[0]['description'] ?? 'No Description';
    });
    _editFormDialog(context);
  }
  _showFormDialog(BuildContext context){
    return showDialog(context: context, barrierDismissible: true, builder: (param){
      return AlertDialog(
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.red,
            ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')
          ),
          TextButton(
              style: TextButton.styleFrom(
                primary: Colors.blue,
              ),
              onPressed:() async {
                _category.name = _categoryNameController.text;
                _category.description = _categoryDescriptionController.text;

                var result = await _categoryService.saveCategory(_category);
                Navigator.pop(context);
                getAllCategories();
              },
              child: const Text('Save')
          )
        ],
        title: const Text('Categories Form'),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget> [
              TextField(
                controller: _categoryNameController,
                decoration: const InputDecoration(
                  hintText: 'Write a category',
                  labelText: 'Category',
                ),
              ),
              TextField(
                controller: _categoryDescriptionController,
                decoration: const InputDecoration(
                  hintText: 'Write a description',
                  labelText: 'Description',
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  _editFormDialog(BuildContext context){
    return showDialog(context: context, barrierDismissible: true, builder: (param){
      return AlertDialog(
        actions: [
          TextButton(
              style: TextButton.styleFrom(
                primary: Colors.red,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')
          ),
          TextButton(
              style: TextButton.styleFrom(
                primary: Colors.blue,
              ),
              onPressed:() async {
                  _category.id = category[0]['id'];
                  _category.name = _editCategoryNameController.text;
                  _category.description = _editCategoryDescriptionController.text;

                  var result = await _categoryService.updateCategory(_category);
                  Navigator.pop(context);
                  getAllCategories();
              },
              child: const Text('Update'),
          ),
        ],
        title: const Text('Edit categories form'),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget> [
              TextField(
                controller: _editCategoryNameController,
                decoration: const InputDecoration(
                  hintText: 'Write a category',
                  labelText: 'Category',
                ),
              ),
              TextField(
                controller: _editCategoryDescriptionController,
                decoration: const InputDecoration(
                  hintText: 'Write a description',
                  labelText: 'Description',
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  _deleteFormDialog(BuildContext context, categoryId){
    return showDialog(context: context, barrierDismissible: true, builder: (param){
      return AlertDialog(
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.red,
            ),
            onPressed:() async {
              var result = await _categoryService.deleteCategory(categoryId);
              getAllCategories();
            },
            child: const Text('Yes'),
          ),
          TextButton(
              style: TextButton.styleFrom(
                primary: Colors.blue,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
          ),
        ],
        title: const Text('Are you sure, do you want to delete this category ?'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        leading: RaisedButton(
          onPressed: () {
            Navigator.popUntil(context, (route) => false);
            Navigator.pop(context);
          },
          elevation: 0.0,
          child: const Icon(Icons.arrow_back, color:Colors.white),
          color: Colors.grey.shade800,
        ),
        title: const Text('Categories'),
      ),
      body: ListView.builder(itemCount: _categoryList.length,itemBuilder: (context, index){
        return Padding(
          padding: const EdgeInsets.only(top:2.0, left: 8.0, right: 8.0),
          child: Card(
            elevation: 8.0,
            child: ListTile(
              leading: IconButton(icon: const Icon(Icons.edit), onPressed: (){
                _editCategory(context, _categoryList[index].id);
              },),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_categoryList[index].name,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              trailing: IconButton(onPressed: (){
                _deleteFormDialog(context, _categoryList[index].id);
              }, icon: const Icon(Icons.delete,
                color :Colors.red,
                size: 30,
                )
              ),
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(onPressed: () {
        _showFormDialog(context);
      },
        child: const Icon(Icons.add),
        backgroundColor: Colors.grey.shade800,
      ),
    );
  }
}
