import 'package:flutter/material.dart';
import 'package:interintel/models/product_model.dart';
import 'package:interintel/providers/product_provider.dart';
import 'package:interintel/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final form_Key = GlobalKey<FormState>();
  Product newProduct = Product(
      id: DateTime.now().toString(), description: '', price: 0.0, title: '');
  void productForm(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add product Form'),
            content: Form(
                key: form_Key,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      onSaved: (value) {
                        newProduct = Product(
                            id: DateTime.now().toString(),
                            description: newProduct.description,
                            price: newProduct.price,
                            title: value!);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Title',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onSaved: (value) {
                        newProduct = Product(
                            id: DateTime.now().toString(),
                            description: value!,
                            price: newProduct.price,
                            title: newProduct.title);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Description',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        newProduct = Product(
                            id: DateTime.now().toString(),
                            description: newProduct.description,
                            price: double.parse(value!),
                            title: newProduct.title);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Price',
                      ),
                    ),
                  ],
                )),
            actions: [
              TextButton.icon(
                  onPressed: () {
                    submitForm();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add')),
              const SizedBox(
                width: 20,
              ),
              TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text('Cancel'))
            ],
          );
        });
  }

  void submitForm() {
    form_Key.currentState!.save();
    Provider.of<ProductProvider>(context, listen: false)
        .productCreation(newProduct);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          productForm(context);
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Shopify..'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Products...',
              style: TextStyle(fontSize: 25),
            ),
          ),
          Consumer<ProductProvider>(builder: (context, notifier, child) {
            int length = notifier.product.length;
            return Wrap(
              children: length <= 0
                  ? [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'No products available; Click Plus button to add.',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      )
                    ]
                  : List.generate(length, (index) {
                      final prodData = notifier.product[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(
                                    id: prodData.id,
                                  )));
                        },
                        child: ListTile(
                          leading: const CircleAvatar(
                            radius: 25,
                            child: Icon(Icons.shopping_bag),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(prodData.title),
                              Text(prodData.description),
                            ],
                          ),
                          trailing: Text(
                            '${prodData.price} Ksh',
                            style: const TextStyle(
                                color: Colors.green, fontSize: 18),
                          ),
                        ),
                      );
                    }),
            );
          })
        ],
      ),
    );
  }
}
