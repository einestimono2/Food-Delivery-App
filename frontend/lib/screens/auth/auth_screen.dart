import 'package:flutter/material.dart';
import 'package:frontend/configs/configs.dart';
import 'package:frontend/screens/auth/components/components.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = "/auth";
  static Route route({required bool signUp}) => MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => AuthScreen(signUp: signUp),
      );

  const AuthScreen({super.key, required this.signUp});

  final bool signUp;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;

  late bool isSignUp;

  @override
  void initState() {
    super.initState();
    isSignUp = widget.signUp;
    _pageController = PageController(initialPage: isSignUp ? 1 : 0);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            width: AppSize.screenWidth,
            height: AppSize.screenHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).backgroundColor,
                  Color(0xFFf7418c).withOpacity(0.7),
                  // Color(0xFFfbab66),
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 1.0),
                stops: <double>[0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: AppSize.screenHeight * 0.01),
                Image.asset(
                  'assets/icons/logo.png',
                  width: AppSize.screenWidth / 2.5,
                  fit: BoxFit.fitWidth,
                ),
                RichText(
                  text: TextSpan(
                    text: 'Welcome to ',
                    style: GoogleFonts.msMadi(
                      textStyle:
                          Theme.of(context).textTheme.headline1!.copyWith(
                                fontSize: 36,
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    children: [
                      TextSpan(
                        text: '${isSignUp ? 'Foodies,' : 'Back,'}',
                        style: GoogleFonts.msMadi(
                          textStyle:
                              Theme.of(context).textTheme.headline1!.copyWith(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: AppSize.screenHeight * 0.02),
                _buildMenuBar(context),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const ClampingScrollPhysics(),
                    onPageChanged: (int i) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        isSignUp = !isSignUp;
                      });
                    },
                    children: <Widget>[
                      ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: SignInForm(),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: const SignUpForm(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuBar(BuildContext context) {
    void _onSignInButtonPress() {
      _pageController.animateToPage(0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.decelerate);
    }

    void _onSignUpButtonPress() {
      _pageController.animateToPage(1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.decelerate);
    }

    return Container(
      width: AppSize.screenWidth * 0.85,
      height: AppSize.screenHeight * 0.0775,
      decoration: const BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(
          Radius.circular(27.5),
        ),
      ),
      child: CustomPaint(
        painter: BubbleIndicatorPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: _onSignInButtonPress,
                child: Text(
                  'Sign In',
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: isSignUp ? Colors.white : Colors.black,
                      ),
                ),
              ),
            ),
            // Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: _onSignUpButtonPress,
                child: Text(
                  'Sign Up',
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: !isSignUp ? Colors.white : Colors.black,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
