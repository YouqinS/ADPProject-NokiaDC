import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:RasPiFinder/models/rasps.dart';

class ProductProvider with ChangeNotifier {
  final fireStoreService = FirebaseFirestore.instance;
  String _name;
  String _modelNumber;
  String _roles;
  // var uuid = Uuid();


  //Getters
  String get name => _name;
  String get model => _modelNumber;

  //Setters
  changeName(String value) {
    _name = value;
    notifyListeners();
  }

  changeModel(String value) {
    _modelNumber = value;
    notifyListeners();
  }

  loadValues(Rasp product) {
    _name = product.name;
    _modelNumber = product.modelNumber;
    _roles = product.roles;
  }

  // saveProduct(){
  //   print(_roles);
  //   if (_productId == null) {
  //     var newProduct = Product(name: name, model: model, productId: uuid.v4());
  //     fireStoreService.saveProduct(newProduct);
  //   } else {
  //     //Update
  //     var updatedProduct = 
  //         Product(name: name, model: _model, productId: _productId);
  //       fireStoreService.saveProduct(updatedProduct);
  //   }  
  //   // print('$name, $model');
  // }

  // removeProduct(String productId) {
  //   fireStoreService.removeProduct(productId);
  // }
}