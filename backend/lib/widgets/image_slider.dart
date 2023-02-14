import 'dart:async';

import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({
    Key? key,
    required this.images,
    this.autoPlay = true,
  }) : super(key: key);

  final List<String> images;
  final bool autoPlay;

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  late Timer _timer;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);

    // Auto next page
    if (widget.autoPlay) {
      _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
        if (_currentPage < widget.images.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }

        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          itemCount: widget.images.length,
          controller: _pageController,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (page) {
            setState(() {
              _currentPage = page;
            });
          },
          itemBuilder: (context, index) {
            return SizedBox.expand(
              child: Image.network(
                widget.images[index],
                fit: BoxFit.fill,
              ),
            );
          },
        ),
        Positioned(
          bottom: 5,
          right: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.images.length,
              (index) => buildDot(index),
            ),
          ),
        ),
      ],
    );
  }

  InkWell buildDot(int index) {
    return InkWell(
      onTap: () {
        if (_currentPage == index) {
          return;
        } else {
          setState(() {
            _currentPage = index;
            _pageController.animateToPage(
              _currentPage,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(right: 5),
        height: 7,
        width: _currentPage == index ? 20 : 10,
        decoration: BoxDecoration(
          color: _currentPage == index ? Colors.red : Colors.white,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}
