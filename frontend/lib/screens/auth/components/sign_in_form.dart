import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/configs/app_size.dart';
import 'package:frontend/constants/constants.dart';
import 'package:frontend/screens/screens.dart';
import 'package:frontend/widgets/widgets.dart';

import '../../../blocs/blocs.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _obscure = true;
  bool loading = false;

  void _signinWithAccount() {
    if (_formKey.currentState!.validate()) {
      context.read<SigninBloc>().add(SigninSubmit(
            email: _emailController.text,
            password: _passwordController.text,
          ));
    }
  }

  void _signinWithGoogle() {
    print('Clicked to Google!');
  }

  void _signinWithFacebook() {
    print('Clicked to Facebook!');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SigninBloc, SigninState>(
      listener: (context, state) {
        if (state is SigninLoading) {
          setState(() {
            loading = true;
          });
        } else if (state is SigninFailed) {
          setState(() {
            loading = false;
          });
          showSnackBar(context, state.message);
        } else if (state is SigninLoaded) {
          setState(() {
            loading = false;
          });
          showSnackBar(context, "Đăng nhập thành công!");
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        }
      },
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.screenWidth * 0.07,
              vertical: 15,
            ),
            child: Column(
              children: <Widget>[
                Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Column(
                      children: [
                        Card(
                          elevation: 2.0,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 20,
                            ),
                            child: Form(
                              key: _formKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: Column(
                                children: <Widget>[
                                  InputField(
                                    border: false,
                                    hintText: "Enter your email address",
                                    title: "Email",
                                    controller: _emailController,
                                    textInputType: TextInputType.emailAddress,
                                    validator: emailValidator,
                                    prefixIcon: Icon(Icons.email_rounded),
                                  ),
                                  SizedBox(height: 20),
                                  InputField(
                                    border: false,
                                    hintText: "Enter your password",
                                    title: "Password",
                                    obscureText: _obscure,
                                    controller: _passwordController,
                                    validator: passwordValidator,
                                    prefixIcon: Icon(Icons.lock_rounded),
                                    suffixIcon: IconButton(
                                      splashRadius: 18,
                                      onPressed: () => setState(() {
                                        _obscure = !_obscure;
                                      }),
                                      icon: Icon(
                                        _obscure
                                            ? Icons.visibility_rounded
                                            : Icons.visibility_off_rounded,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 1),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pushNamed(
                                          context,
                                          ForgotPasswordScreen.routeName,
                                        ),
                                        child: Text(
                                          'Forgot Password?',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6!,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        alignment: Alignment.center,
                        width: 200,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).brightness == Brightness.dark
                                  ? Theme.of(context).primaryColorLight
                                  : Theme.of(context).primaryColorDark,
                            ],
                            begin: FractionalOffset(0.2, 0.2),
                            end: FractionalOffset(1.0, 1.0),
                            stops: <double>[0.0, 1.0],
                            tileMode: TileMode.clamp,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.2),
                              spreadRadius: 1.5,
                              blurRadius: 1,
                            )
                          ],
                        ),
                        child: TextButton(
                          onPressed: () => _signinWithAccount(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 35,
                              vertical: 7,
                            ),
                            child: Text(
                              "SIGN IN",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Colors.white10,
                            Colors.white,
                          ],
                          begin: FractionalOffset(0.0, 0.0),
                          end: FractionalOffset(1.0, 1.0),
                          stops: <double>[0.0, 1.0],
                          tileMode: TileMode.clamp,
                        ),
                      ),
                      width: AppSize.screenWidth / 3,
                      height: 1.5,
                    ),
                    Text(
                      'Or',
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(color: Colors.white),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Colors.white,
                            Colors.white10,
                          ],
                          begin: FractionalOffset(0.0, 0.0),
                          end: FractionalOffset(1.0, 1.0),
                          stops: <double>[0.0, 1.0],
                          tileMode: TileMode.clamp,
                        ),
                      ),
                      width: AppSize.screenWidth / 3,
                      height: 1.5,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FloatingActionButton.extended(
                      heroTag: "btn1",
                      backgroundColor: Color(0xFFDE4B39),
                      onPressed: () => _signinWithGoogle(),
                      label: Row(
                        children: <Widget>[
                          Image.asset(
                            "assets/icons/google.png",
                            fit: BoxFit.cover,
                            width: 32,
                            height: 32,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Google   ',
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(color: Colors.white.withOpacity(.95)),
                          ),
                        ],
                      ),
                    ),
                    FloatingActionButton.extended(
                      heroTag: "btn2",
                      backgroundColor: Color(0xFF3B5999),
                      onPressed: () => _signinWithFacebook(),
                      label: Row(
                        children: <Widget>[
                          Image.asset(
                            "assets/icons/facebook.png",
                            fit: BoxFit.cover,
                            width: 28,
                            height: 28,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Facebook',
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(color: Colors.white.withOpacity(.95)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (loading)
            Positioned(
              top: AppSize.screenHeight * 0.1,
              right: AppSize.screenWidth / 3,
              child: Container(
                color: Colors.transparent,
                child: CustomLoading(),
              ),
            )
        ],
      ),
    );
  }
}
