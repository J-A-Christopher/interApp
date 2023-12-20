import 'package:flutter/material.dart';
import 'package:interintel/models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final List<Product> _product = [];

  List<Product> get product => [..._product];

  final List<Map<String, dynamic>> _textFieldValues = [];

  List<Map<String, dynamic>> get textFieldValues => [..._textFieldValues];

  final List<Map<String, dynamic>> _productFieldValues = [];

  List<Map<String, dynamic>> get productFieldValues => [..._productFieldValues];

  void populateList(Map<String, dynamic> names) {
    print('majina$names');

    names.forEach((key, value) {
     
      _textFieldValues.add(names);
      if (value is List) {
        print('Items in List');
        for (var item in value) {
          print('$item');
        }
      }
    });

    notifyListeners();
  }

  void populateProductOptions(Map<String, dynamic> productOptions) {
    productOptions.forEach((key, value) {
      print('prodOps$key: $value');
      _productFieldValues.add(productOptions);
      if (value is List) {
        print('Items in List');
        for (var item in value) {
          print('$item');
        }
      }
    });
    notifyListeners();
  }

  void productCreation(Product newProduct) {
    final modelProduct = Product(
        id: newProduct.id,
        description: newProduct.description,
        price: newProduct.price,
        title: newProduct.title);
    _product.add(modelProduct);
    print(modelProduct.price);
    notifyListeners();
  }
}
