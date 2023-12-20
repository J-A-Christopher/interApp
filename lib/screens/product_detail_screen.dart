import 'package:flutter/material.dart';
import 'package:interintel/providers/product_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final String id;
  const ProductDetailScreen({
    super.key,
    required this.id,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool value = false;
  bool isListVisible = false;
  bool matcher = false;
  List<String> textFieldValues = [];
  List<String> productFieldValues = [];
  var displayedVariants;
  var displayedProds;
  List<String> combinations = [];

  var dropDownItems = ['Size', 'Color', 'Material', 'Style'];
  String selectedItem = 'Color';

  void submitData() {
    Map<String, dynamic> productVariant = {
      'id': widget.id,
      'variants': textFieldValues
    };
    print('mazda$productVariant');
    Provider.of<ProductProvider>(context, listen: false)
        .populateList(productVariant);
  }

  void submitOptions() {
    Map<String, dynamic> productOptions = {
      'id': widget.id,
      'options': productFieldValues,
    };
    Provider.of<ProductProvider>(context, listen: false)
        .populateProductOptions(productOptions);
  }

  void entireCombinations() {
    List<String> innerList1 =
        displayedVariants.isNotEmpty ? displayedVariants[0] : [];
    List<String> innerList2 =
        displayedProds.isNotEmpty ? displayedProds[0] : [];

    for (String item1 in innerList1) {
      for (String item2 in innerList2) {
        String combination = '$item1 $item2';
        combinations.add(combination);
        print(combination);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false).product;
    final selectedProduct =
        productProvider.firstWhere((product) => product.id == widget.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedProduct.title),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, top: 12.0, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedProduct.title,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(selectedProduct.description),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Ksh: ${selectedProduct.price}')
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Options'),
                ),
                Row(
                  children: [
                    Checkbox(
                        value: value,
                        onChanged: (value) {
                          setState(() {
                            this.value = value!;
                          });
                        }),
                    const Text('This product has options like size and color')
                  ],
                ),
                Visibility(
                    visible: value,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Option name'),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                  width: 320,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 1.0),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: const Text('Size')),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.delete))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text('Option values'),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (textFieldValues.isEmpty ||
                                    textFieldValues.last.isNotEmpty) {
                                  textFieldValues.add('');
                                }
                              });
                            },
                            child: const Text('Add More Sizes'),
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: textFieldValues.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          onChanged: (value) {
                                            setState(() {
                                              textFieldValues[index] = value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(3),
                                            border: const OutlineInputBorder(),
                                            hintText: 'Size ${index + 1}',
                                          ),
                                          initialValue: textFieldValues[index],
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ],
                              );
                            },
                          ),
                          Consumer<ProductProvider>(
                              builder: (context, notifier, child) {
                            final displayedVariantsSet = notifier
                                .textFieldValues
                                .where((mappedProduct) =>
                                    mappedProduct['id'] == selectedProduct.id)
                                .map((matchedProduct) =>
                                    matchedProduct['variants'])
                                .toSet();

                            displayedVariants = displayedVariantsSet.toList();
                            return Wrap(
                              children: displayedVariants.isEmpty
                                  ? [const Text('No variants available..')]
                                  : List.generate(
                                      displayedVariants.length,
                                      (index) => Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: const Color(
                                                          0xffdadada)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Text(
                                                        '${displayedVariants[index].join(", ")}'),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )),
                            );
                          }),
                          OutlinedButton(
                            onPressed: submitData,
                            child: const Text('Done'),
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isListVisible = true;
                                    });
                                  },
                                  icon: const Icon(Icons.add)),
                              const Text('Add another option')
                            ],
                          ),
                          Visibility(
                            visible: isListVisible,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.all(5)),
                                    value: selectedItem,
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        selectedItem = newValue;
                                      }
                                    },
                                    items: dropDownItems.map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                //######################################################################################################################
                                const Text('Option values'),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (productFieldValues.isEmpty ||
                                          productFieldValues.last.isNotEmpty) {
                                        productFieldValues.add('');
                                      }
                                    });
                                  },
                                  child: const Text('Add More Options'),
                                ),
                                const SizedBox(height: 10),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: productFieldValues.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                onChanged: (value) {
                                                  setState(() {
                                                    productFieldValues[index] =
                                                        value;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.all(3),
                                                  border:
                                                      const OutlineInputBorder(),
                                                  hintText: 'Size ${index + 1}',
                                                ),
                                                initialValue:
                                                    productFieldValues[index],
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ))
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    );
                                  },
                                ),
                                Consumer<ProductProvider>(
                                    builder: (context, notifier, child) {
                                  final displayedProductsSet = notifier
                                      .productFieldValues
                                      .where((mappedProduct) =>
                                          mappedProduct['id'] ==
                                          selectedProduct.id)
                                      .map((matchedProduct) =>
                                          matchedProduct['options'])
                                      .toSet();

                                  displayedProds =
                                      displayedProductsSet.toList();
                                  return Wrap(
                                    children: displayedProds.isEmpty
                                        ? [const Text('No options available..')]
                                        : List.generate(
                                            displayedProds.length,
                                            (index) => Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            color: const Color(
                                                                0xffdadada)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Text(
                                                              '${displayedProds[index].join(", ")}'),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )),
                                  );
                                }),
                                OutlinedButton(
                                  onPressed: submitOptions,
                                  child: const Text('Done'),
                                ),

                                const Text('Variants...'),
                                ElevatedButton(
                                    onPressed: () {
                                      entireCombinations();
                                    },
                                    child: const Text('Click me')),
                                Wrap(
                                  children: List.generate(combinations.length,
                                      (index) {
                                    return Row(
                                      children: [
                                        Checkbox(
                                            value: matcher,
                                            onChanged: (value) {
                                              this.value = matcher;
                                            }),
                                        Text(combinations[index])
                                      ],
                                    );
                                  }),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
