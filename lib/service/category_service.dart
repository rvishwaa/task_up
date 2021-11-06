import 'package:task_up/models/category.dart';
import 'package:task_up/repositories/repository.dart';

class CategoryService{
  Repository _repository;
  CategoryService(){
    _repository = Repository();
  }
  saveCategory(Category category) async {
    return await _repository.insertData('categories', category.CategoryMap());
  }

  readCategory() async {
    return await _repository.readData('categories');
  }

  readCategoryById(categoryId) async {
    return await _repository.readDataById('categories', categoryId);
  }

  updateCategory(Category category) async {
    return await _repository.updateData('categories', category.CategoryMap());
  }

  deleteCategory(categoryId) async {
    return await _repository.deleteData('categories', categoryId);
  }
}