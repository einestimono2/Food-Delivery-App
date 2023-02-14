import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime/mime.dart';

import '../blocs/blocs.dart';
import '../constants/constants.dart';
import '../models/models.dart';
import 'widgets.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({
    super.key,
    this.category,
  });

  final Category? category;

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  bool loading = false;
  bool error = false;

  dynamic _fileBytes;
  String? _mimeType;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name);
    _descriptionController =
        TextEditingController(text: widget.category?.description);

    _getUint8List();
  }

  _getUint8List() async {
    if (widget.category != null) {
      Response response = await get(Uri.parse(widget.category!.image!));

      setState(() {
        _fileBytes = response.bodyBytes;
      });
    }
  }

  _pickImage() async {
    var mediaData = await ImagePickerWeb.getImageInfo;

    if (mediaData == null) return _showError("Image error!");

    setState(() {
      _fileBytes = mediaData.data;
      _mimeType = lookupMimeType('', headerBytes: mediaData.data);
    });
  }

  _showError(String error) => showSnackBar(
        context,
        error,
        backgroundColor: Colors.black87,
      );

  _addCategory() {
    if (_fileBytes == null || _mimeType == null) {
      return _showError("Please choose photo of category!");
    }

    Category category = Category(
      name: _nameController.text,
      description: _descriptionController.text,
      image: 'data:$_mimeType;base64,${base64Encode(_fileBytes)}',
    );

    BlocProvider.of<CategoryBloc>(context).add(AddCategory(category: category));
  }

  _updateCategory() {
    Category category = Category(
      id: widget.category!.id!,
      name: _nameController.text,
      description: _descriptionController.text,
      image: _mimeType == null
          ? null
          : 'data:$_mimeType;base64,${base64Encode(_fileBytes)}',
    );

    BlocProvider.of<CategoryBloc>(context)
        .add(UpdateCategory(category: category));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategoryLoading) {
            setState(() {
              loading = true;
            });
          }

          if (state is CategoryLoaded) {
            setState(() {
              loading = false;
            });

            if (!error) {
              _showError(
                widget.category == null
                    ? "Added the category!"
                    : "Updated the category!",
              );
              Navigator.pop(context);
            } else {
              setState(() {
                error = false;
              });
            }
          }

          if (state is CategoryError) {
            setState(() {
              loading = false;
              error = true;
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width / 3,
          height: MediaQuery.of(context).size.height / 2.5,
          child: Stack(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Image",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Container(
                              margin: const EdgeInsets.only(right: 25),
                              height: 150,
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
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: <Widget>[
                            InputField(
                              title: "Name",
                              hintText: "Enter category name",
                              controller: _nameController,
                            ),
                            InputField(
                              title: "Description",
                              hintText: "Enter restaurant's description",
                              controller: _descriptionController,
                              isTextArea: true,
                              minLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ),
                      onPressed: () => widget.category == null
                          ? _addCategory()
                          : _updateCategory(),
                      child: Text(widget.category == null ? "ADD" : "UPDATE"),
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
