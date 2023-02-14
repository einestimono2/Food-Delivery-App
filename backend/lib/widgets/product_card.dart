import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime/mime.dart';

import '../blocs/blocs.dart';
import '../constants/constants.dart';
import '../models/models.dart';
import 'widgets.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    required this.categories,
    required this.currentCategory,
    required this.restaurantID,
  }) : super(key: key);

  final List<Category> categories;
  final Category currentCategory;
  final String restaurantID;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;

  late Category productCategory;

  dynamic _fileBytes;
  String? _mimeType;
  bool isFeatured = false;

  bool loading = false;
  bool error = false;

  @override
  void initState() {
    super.initState();

    productCategory = widget.currentCategory;

    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
  }

  _showError(String error) => showSnackBar(
        context,
        error,
        backgroundColor: Colors.black87,
      );

  _pickImage() async {
    var mediaData = await ImagePickerWeb.getImageInfo;

    if (mediaData == null) return _showError("Image error!");

    setState(() {
      _fileBytes = mediaData.data;
      _mimeType = lookupMimeType('', headerBytes: mediaData.data);
    });
  }

  _addProduct() {
    if (_nameController.text == '' ||
        _priceController.text == '' ||
        _descriptionController.text == '') {
      return _showError('Please fill in all required information!');
    }

    if (double.tryParse(_priceController.text) == null) {
      return _showError('Price invalid!');
    }

    if (_fileBytes == null || _mimeType == null) {
      return _showError("Please choose photo of category!");
    }

    Product product = Product(
      restaurant: widget.restaurantID,
      category: productCategory.id!,
      isFeatured: isFeatured,
      name: _nameController.text,
      description: _descriptionController.text,
      image: 'data:$_mimeType;base64,${base64Encode(_fileBytes)}',
      price: double.parse(_priceController.text),
    );

    BlocProvider.of<RestaurantDetailsBloc>(context).add(
      AddRestaurantProduct(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    final outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(
        color: Colors.grey,
        width: 1,
      ),
    );

    return Dialog(
      child: BlocListener<RestaurantDetailsBloc, RestaurantDetailsState>(
        listener: (context, state) {
          if (state is RestaurantDetailsLoading) {
            setState(() {
              loading = true;
            });
          }

          if (state is RestaurantDetailsLoaded) {
            setState(() {
              loading = false;
            });

            if (!error) {
              _showError("Added the product!");
              Navigator.pop(context);
            } else {
              setState(() {
                error = false;
              });
            }
          }

          if (state is RestaurantDetailsError) {
            _showError(state.message);

            setState(() {
              loading = false;
              error = true;
            });
          }
        },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 1.25,
          child: Stack(
            children: [
              Column(
                children: [
                  InputField(
                    title: "Name *",
                    hintText: "Enter product name",
                    controller: _nameController,
                  ),
                  InputField(
                    title: "Description *",
                    hintText: "Enter product's description",
                    controller: _descriptionController,
                    isTextArea: true,
                    minLines: 3,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Category *",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.015,
                                ),
                                SizedBox(
                                  width: double.maxFinite,
                                  child: DropdownButtonFormField<Category>(
                                    decoration: InputDecoration(
                                      enabledBorder: outlineInputBorder,
                                      focusedBorder: outlineInputBorder,
                                      border: outlineInputBorder,
                                    ),
                                    value: productCategory,
                                    items: widget.categories
                                        .map(
                                          (e) => DropdownMenuItem<Category>(
                                            value: e,
                                            child: Text(e.name),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) => setState(() {
                                      productCategory = value!;
                                    }),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                ),
                              ],
                            ),
                            InputField(
                              title: "Price *",
                              hintText: "Enter product's price",
                              controller: _priceController,
                            ),
                            Row(
                              children: <Widget>[
                                const Text(
                                  "Featured",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.01,
                                ),
                                Checkbox(
                                  value: isFeatured,
                                  onChanged: (value) => setState(() {
                                    isFeatured = !isFeatured;
                                  }),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Product Image *",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                            Container(
                              height: 222,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                              child: InkWell(
                                onTap: () => _pickImage(),
                                child: _fileBytes == null
                                    ? const Center(
                                        child: Icon(Icons.file_upload_outlined),
                                      )
                                    : Image.memory(
                                        _fileBytes,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ),
                      onPressed: () => _addProduct(),
                      child: const Text("ADD PRODUCT"),
                    ),
                  ),
                ],
              ),
              loading
                  ? Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const CustomLoading(),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
