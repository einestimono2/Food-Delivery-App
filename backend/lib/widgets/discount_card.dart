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

class DiscountCard extends StatefulWidget {
  const DiscountCard({
    super.key,
    this.discount,
  });

  final Discount? discount;

  @override
  State<DiscountCard> createState() => _DiscountCardState();
}

class _DiscountCardState extends State<DiscountCard> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  bool loading = false;
  bool error = false;

  dynamic _fileBytes;
  String? _mimeType;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.discount?.title);
    _descriptionController =
        TextEditingController(text: widget.discount?.description);

    _getUint8List();
  }

  _getUint8List() async {
    if (widget.discount != null) {
      Response response = await get(Uri.parse(widget.discount!.image!));

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

  _addDiscount() {
    if (_fileBytes == null || _mimeType == null) {
      return _showError("Please choose photo of discount!");
    }
    
    Discount discount = Discount(
      title: _titleController.text,
      description: _descriptionController.text,
      image: 'data:$_mimeType;base64,${base64Encode(_fileBytes)}',
    );

    BlocProvider.of<DiscountBloc>(context).add(AddDiscount(discount: discount));
    
  }

  _updateDiscount() {
    Discount discount = Discount(
      id: widget.discount!.id!,
      title: _titleController.text,
      description: _descriptionController.text,
      image: _mimeType == null
          ? null
          : 'data:$_mimeType;base64,${base64Encode(_fileBytes)}',
    );

    BlocProvider.of<DiscountBloc>(context)
        .add(UpdateDiscount(discount: discount));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: BlocListener<DiscountBloc, DiscountState>(
        listener: (context, state) {
          if (state is DiscountLoading) {
            setState(() {
              loading = true;
            });
          }

          if (state is DiscountLoaded) {
            setState(() {
              loading = false;
            });

            if (!error) {
              _showError(
                widget.discount == null
                    ? "Added the discount!"
                    : "Updated the discount!",
              );
              Navigator.pop(context);
            } else {
              setState(() {
                error = false;
              });
            }
          }

          if (state is DiscountError) {
            setState(() {
              loading = false;
              error = true;
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width / 3,
          height: MediaQuery.of(context).size.height / 2.4,
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
                              title: "Title",
                              hintText: "Enter discount title",
                              controller: _titleController,
                            ),
                            InputField(
                              title: "Description",
                              hintText: "Enter discount's description",
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
                      onPressed: () => widget.discount == null
                          ? _addDiscount()
                          : _updateDiscount(),
                      child: Text(widget.discount == null ? "ADD" : "UPDATE"),
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
