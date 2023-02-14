import 'package:flutter/material.dart';

class InputTags extends StatefulWidget {
  const InputTags({
    Key? key,
    this.title,
    required this.controller,
    this.hintText,
  }) : super(key: key);

  final String? title;
  final String? hintText;
  final TextEditingController controller;

  @override
  State<InputTags> createState() => _InputTagsState();
}

class _InputTagsState extends State<InputTags> {
  final TextEditingController tagController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> tags = [];

  var outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: const BorderSide(
      color: Colors.grey,
      width: 1,
    ),
  );

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        if (tagController.text != "") {
          addTag(tagController.text);
          tagController.text = "";

          setState(() {});
        }
      }
    });
  }

  void addTag(String tag) {
    if (tags.contains(tag) || tag == "") return;

    tags.add(tag);
    if (widget.controller.text.isEmpty) {
      widget.controller.text += tag;
    } else {
      widget.controller.text += ', $tag';
    }
  }

  void deleteTag(String tag) {
    int index = tags.indexOf(tag);
    tags.removeAt(index);
    if (index == 0) {
      widget.controller.text = widget.controller.text.replaceAll('$tag, ', '');
    } else {
      widget.controller.text = widget.controller.text.replaceAll(', $tag', '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Text(
              widget.title ?? "",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 3),
            Expanded(
              child: tags.isEmpty
                  ? Container()
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: tags.map((e) => _buildTag(e)).toList(),
                      ),
                    ),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.015),
        TextFormField(
          controller: tagController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: widget.hintText,
            enabledBorder: outlineInputBorder,
            focusedBorder: outlineInputBorder,
            border: outlineInputBorder,
          ),
          onFieldSubmitted: (value) {
            setState(() {
              addTag(value);
              tagController.text = "";
              _focusNode.requestFocus();
            });
          },
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
      ],
    );
  }

  Padding _buildTag(String name) => Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Chip(
            label: Text(name),
            labelPadding:
                const EdgeInsets.symmetric(horizontal: 5, vertical: -4.5),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
            deleteIcon: const Icon(
              Icons.close,
              size: 12,
              color: Colors.red,
            ),
            onDeleted: () {
              setState(() {
                deleteTag(name);
              });
            }),
      );
}
