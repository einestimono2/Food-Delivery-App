import 'package:flutter/material.dart';
import 'package:frontend/configs/configs.dart';
import 'package:frontend/screens/onboarding/components/components.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = "/onboarding";
  static Route route() => MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => OnboardingScreen(),
      );

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  List<Map<String, String>> _tabs = [
    {
      'title': 'Discover restaurants near you',
      'content':
          'We make it simple to find a food for you. Enter your address and let us do the rest',
      'img': 'assets/images/onboarding_1.json'
    },
    {
      'title': 'Collection of different cuisines',
      'content':
          'We have wide range of dishes. You can enjoy your favourite dishes with us',
      'img': 'assets/images/onboarding_2.json'
    },
    {
      'title': 'Delivered quickly at your place',
      'content':
          'We provide door to door service in mean time with bost quality of food',
      'img': 'assets/images/onboarding_3.json'
    },
  ];

  @override
  Widget build(BuildContext context) {
    AppSize().init(context);

    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor.withOpacity(0.75),
      body: SafeArea(
        child: Stack(
          children: [
            CustomPaint(
              painter: ArcPainter(context: context),
              child: SizedBox(
                height: AppSize.screenHeight / 1.5,
                width: AppSize.screenWidth,
              ),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15, right: 15, bottom: 15),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/auth'),
                      icon: Text(
                        'Skip',
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (value) => setState(() {
                        _currentIndex = value;
                      }),
                      itemCount: _tabs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return OnboardingContent(
                          title: _tabs[index]['title']!,
                          content: _tabs[index]['content']!,
                          img: _tabs[index]['img']!,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) => _buildDot(index),
                        ),
                      ),
                      Spacer(),
                      _buildIndicator(_currentIndex, _pageController),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.only(right: 6),
      height: 6,
      width: _currentIndex == index ? 20 : 8,
      decoration: BoxDecoration(
        color: _currentIndex == index
            ? Theme.of(context).primaryColor
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Container _buildIndicator(int currentIndex, PageController pageController) {
    return Container(
      width: 60,
      height: 60,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation(Theme.of(context).primaryColorLight),
                value: (currentIndex + 1) / 3,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                if (currentIndex < 2)
                  pageController.animateToPage(
                    currentIndex + 1,
                    duration: Duration(microseconds: 800),
                    curve: Curves.bounceInOut,
                  );
                else
                  Navigator.pushReplacementNamed(context, '/auth');
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
