import 'package:flutter/material.dart';
import 'package:frontend/configs/configs.dart';
import 'package:lottie/lottie.dart';

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    Key? key,
    required this.title,
    required this.content,
    required this.img,
  }) : super(key: key);

  final String title;
  final String content;
  final String img;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset(
          img,
          fit: BoxFit.contain,
          height: AppSize.screenHeight / 3,
        ),
        Spacer(flex: 3),
        Text(title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline1!
            // .copyWith(color: Colors.black),
            ),
        const SizedBox(height: 40),
        Text(
          content,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(fontWeight: FontWeight.normal),
        ),
        Spacer(),
      ],
    );
  }
}
