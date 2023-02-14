import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime/mime.dart';

import '../../blocs/blocs.dart';
import '../../configs/responsive.dart';
import '../../constants/constants.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class AddRestaurantScreen extends StatefulWidget {
  static const String routeName = "/add-restaurant";
  const AddRestaurantScreen({Key? key}) : super(key: key);

  @override
  State<AddRestaurantScreen> createState() => _AddRestaurantScreenState();
}

class _AddRestaurantScreenState extends State<AddRestaurantScreen> {
  bool loading = false;
  bool error = false;
  bool add = false;

  bool isPopular = false;

  late TextEditingController _tagController;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _addressController;
  double? lat;
  double? lon;

  List<Uint8List> images = [];
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();

    BlocProvider.of<CategoryBloc>(context).add(LoadCategories());

    _tagController = TextEditingController();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _addressController = TextEditingController();
  }

  _pickImages() async {
    var mediaData = await ImagePickerWeb.getMultiImagesAsBytes();

    if (mediaData != null) {
      for (var element in mediaData) {
        images.add(element);
      }
    }

    setState(() {});
  }

  _addRestaurant() {
    if (_tagController.text == "" ||
        _addressController.text == "" ||
        images.isEmpty ||
        lat == null ||
        lon == null) {
      showSnackBar(context, "Please fill in all required information!");
      return;
    }

    setState(() {
      add = true;
    });

    List<String> imageURL = [];

    for (var image in images) {
      var mimeType = lookupMimeType('', headerBytes: image);
      imageURL.add('data:$mimeType;base64,${base64Encode(image)}');
    }

    Restaurant restaurant = Restaurant(
      name: _nameController.text,
      description: _descriptionController.text == ""
          ? null
          : _descriptionController.text,
      images: imageURL,
      tags: _tagController.text.split(', '),
      categories: categories.isEmpty ? null : categories,
      address: Place(lat: lat!, lon: lon!, name: _addressController.text),
      isPopular: isPopular,
      openingHours: OpeningHours.openingHoursList,
    );

    BlocProvider.of<RestaurantBloc>(context).add(
      CreateRestaurant(restaurant: restaurant),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomAdminScaffold(
      route: AddRestaurantScreen.routeName,
      body: BlocListener<RestaurantBloc, RestaurantState>(
        listener: (context, state) {
          if (state is RestaurantLoading) {
            setState(() {
              loading = true;
            });
          }

          if (state is RestaurantLoaded) {
            setState(() {
              loading = false;
            });

            if (!error) {
              if (add) {
                showSnackBar(context, "Added the restaurant!");

                Navigator.pushReplacementNamed(
                  context,
                  RestaurantScreen.routeName,
                );
              }
            } else {
              setState(() {
                error = false;
              });
            }
          }

          if (state is RestaurantError) {
            showSnackBar(context, state.message);

            setState(() {
              loading = false;
              error = true;
              add = false;
            });

            BlocProvider.of<RestaurantBloc>(context).add(
              LoadRestaurants(),
            );
          }
        },
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(50, 15, 50, 30),
            width: double.maxFinite,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(width: 0.5)),
                        ),
                        child: Text(
                          "RESTAURANT INFORMATION",
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: InputField(
                            title: "Name *",
                            hintText: "Enter restaurant's name",
                            controller: _nameController,
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03),
                        Expanded(
                          child: InputTags(
                            title: "Tags *",
                            hintText: "Enter restaurant's tag",
                            controller: _tagController,
                          ),
                        ),
                      ],
                    ),
                    InputField(
                      title: "Description",
                      hintText: "Enter restaurant's description",
                      controller: _descriptionController,
                      isTextArea: true,
                    ),
                    _buildCategory(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    _buildAddress(context),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Row(
                      children: <Widget>[
                        const Text(
                          "Popular",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01),
                        Checkbox(
                          value: isPopular,
                          onChanged: (value) => setState(() {
                            isPopular = value ?? isPopular;
                          }),
                        )
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    _buildImages(context),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(50, 30, 50, 30),
                        ),
                        onPressed: () => _addRestaurant(),
                        child: Text("ADD RESTAURANT",
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                if (loading)
                  Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    height: MediaQuery.of(context).size.height * 1.5,
                    child: const CustomLoading(),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildAddress(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InputField(
                title: "Address *",
                hintText: "Enter restaurant's address",
                controller: _addressController,
                spaceEnd: false,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Text(
                '* Latitude: $lat',
                style: const TextStyle(fontSize: 14),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              Text(
                '* Longitude: $lon',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(width: 30),
        Expanded(
          flex: 3,
          child: SizedBox(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.5,
            child: MapBox(
              setAddress: ({required lat, required lon, String? name}) {
                setState(() {
                  this.lat = lat;
                  this.lon = lon;
                  _addressController.text = name ?? _addressController.text;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Row _buildImages(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Images *",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Container(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width * 0.15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              child: InkWell(
                onTap: () => _pickImages(),
                child: const Center(
                  child: Icon(Icons.file_upload_outlined),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 30),
        if (images.isNotEmpty)
          Expanded(
            child: Wrap(
              spacing: 20,
              runSpacing: 15,
              children:
                  List.generate(images.length, (i) => _buildImagePreview(i))
                      .toList(),
              // images.map((e) => _buildImagePreview(e)).toList(),
            ),
          ),
      ],
    );
  }

  SizedBox _buildImagePreview(int index) => SizedBox(
        width: MediaQuery.of(context).size.height * 0.12,
        height: MediaQuery.of(context).size.height * 0.12,
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.12,
              height: MediaQuery.of(context).size.height * 0.12,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.memory(images[index], fit: BoxFit.fill),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: () => setState(() {
                  images.removeAt(index);
                }),
                child: const Icon(
                  Icons.clear,
                  size: 16,
                  color: Colors.red,
                ),
              ),
            )
          ],
        ),
      );

  SizedBox _buildCategoryTile(Category category) => SizedBox(
        width: MediaQuery.of(context).size.width *
            ((Responsive.isDesktop(context) ||
                    Responsive.isWideDesktop(context))
                ? 0.14
                : 0.35),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: SizedBox(
            width: MediaQuery.of(context).size.height * 0.05,
            height: MediaQuery.of(context).size.height * 0.05,
            child: Image.network(category.image!, fit: BoxFit.fill),
          ),
          title: Text(category.name),
          trailing: Checkbox(
            value: categories.contains(category),
            onChanged: (value) => setState(() {
              value == true
                  ? categories.add(category)
                  : categories.remove(category);
            }),
          ),
        ),
      );

  _buildCategory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Category",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.015),
        BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const CircularProgressIndicator();
            } else if (state is CategoryLoaded) {
              return Wrap(
                spacing: 35,
                runSpacing: 20,
                children:
                    state.categories.map((e) => _buildCategoryTile(e)).toList(),
              );
            } else {
              return const Text(
                "Something went wrong!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
