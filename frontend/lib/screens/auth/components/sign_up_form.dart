import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/configs/configs.dart';
import 'package:frontend/constants/constants.dart';
import 'package:frontend/screens/screens.dart';
import 'package:frontend/widgets/widgets.dart';

import '../../../blocs/blocs.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool loading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePasword = true;
  bool _obscureConfirmationPasword = true;

  void _signupWithAccount() {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<SignupBloc>(context).add(
        SignupSubmit(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state is SignupLoading) {
          setState(() {
            loading = true;
          });
        } else if (state is SignupFailed) {
          setState(() {
            loading = false;
          });
          showSnackBar(context, state.message);
        } else if (state is SignupLoaded) {
          showSnackBar(context, state.message ?? "");
          Future.delayed(const Duration(seconds: 1));
          setState(() {
            loading = false;
          });
          Navigator.of(context).pushReplacementNamed(OTPScreen.routeName);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSize.screenWidth * 0.07,
          right: AppSize.screenWidth * 0.07,
          top: 15,
          bottom: 1,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Column(
                      children: [
                        Card(
                          elevation: 2.0,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 20,
                              bottom: 5,
                            ),
                            child: Form(
                              key: _formKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: Column(
                                children: <Widget>[
                                  InputField(
                                    border: false,
                                    hintText: "Enter your name",
                                    title: "Name",
                                    controller: _nameController,
                                    textInputType: TextInputType.name,
                                    validator: nameValidator,
                                    prefixIcon: Icon(Icons.info_rounded),
                                  ),
                                  SizedBox(height: 10),
                                  InputField(
                                    border: false,
                                    hintText: "Enter your email address",
                                    title: "Email",
                                    controller: _emailController,
                                    textInputType: TextInputType.emailAddress,
                                    validator: emailValidator,
                                    prefixIcon: Icon(Icons.email_rounded),
                                  ),
                                  SizedBox(height: 10),
                                  InputField(
                                    border: false,
                                    hintText: "Enter your password",
                                    title: "Password",
                                    obscureText: _obscurePasword,
                                    controller: _passwordController,
                                    validator: passwordValidator,
                                    prefixIcon: Icon(Icons.lock_rounded),
                                    suffixIcon: IconButton(
                                      splashRadius: 18,
                                      onPressed: () => setState(() {
                                        _obscurePasword = !_obscurePasword;
                                      }),
                                      icon: Icon(
                                        _obscurePasword
                                            ? Icons.visibility_rounded
                                            : Icons.visibility_off_rounded,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  InputField(
                                    border: false,
                                    hintText:
                                        "Enter your confirmation password",
                                    title: "Confirmation",
                                    obscureText: _obscureConfirmationPasword,
                                    controller: _confirmPasswordController,
                                    validator: (value) =>
                                        confirmationPasswordValidator(
                                      value,
                                      _passwordController.text,
                                    ),
                                    prefixIcon: Icon(Icons.lock_rounded),
                                    suffixIcon: IconButton(
                                      splashRadius: 18,
                                      onPressed: () => setState(() {
                                        _obscureConfirmationPasword =
                                            !_obscureConfirmationPasword;
                                      }),
                                      icon: Icon(
                                        _obscureConfirmationPasword
                                            ? Icons.visibility_rounded
                                            : Icons.visibility_off_rounded,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 50),
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
                          onPressed: () => _signupWithAccount(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 35,
                              vertical: 7,
                            ),
                            child: Text(
                              "SIGN UP",
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
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "By pressing 'SIGN UP' you agree to our ",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () => showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) =>
                              _buildTermAndConditions(context),
                        ),
                        child: Text(
                          " term & conditions.",
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.lightBlueAccent,
                                    fontWeight: FontWeight.w900,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
      ),
    );
  }

  Container _buildTermAndConditions(BuildContext context) {
    return Container(
      height: AppSize.screenHeight * 0.3,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.screenWidth * 0.1,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          color: Theme.of(context).backgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(
              child: Text(
                'Term & Conditions',
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      decoration: TextDecoration.underline,
                    ),
              ),
            ),
            SizedBox(height: AppSize.screenHeight * 0.005),
            Text(
              '1. abc',
              style: Theme.of(context).textTheme.headline6!,
            ),
            Text(
              '2. abc',
              style: Theme.of(context).textTheme.headline6!,
            ),
            Text(
              '3. abc',
              style: Theme.of(context).textTheme.headline6!,
            ),
            Text(
              '4. abc',
              style: Theme.of(context).textTheme.headline6!,
            ),
            Text(
              '5. abc',
              style: Theme.of(context).textTheme.headline6!,
            ),
          ],
        ),
      ),
    );
  }
}
