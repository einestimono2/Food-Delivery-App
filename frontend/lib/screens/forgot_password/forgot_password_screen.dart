import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/configs/configs.dart';
import 'package:frontend/constants/constants.dart';
import 'package:frontend/screens/screens.dart';
import 'package:frontend/widgets/widgets.dart';

import '../../blocs/blocs.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = "/forgot";
  static Route route() => MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => ForgotPasswordScreen(),
      );

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: "Forgot Password",
      ),
      body: BlocListener<SignupBloc, SignupState>(
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
            setState(() {
              loading = false;
            });
            Navigator.of(context).pushReplacementNamed(
              OTPScreen.routeName,
              arguments: {"resetPassword": true},
            );
          }
        },
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: AppSize.screenHeight * 0.1),
                Text(
                  "Forgot Password",
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(height: AppSize.screenHeight * 0.02),
                Text(
                  "Please enter your email and we will send \nyou OTP to reset your account",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: AppSize.screenHeight * 0.1),
                Padding(
                  padding: EdgeInsets.all(AppSize.screenWidth * 0.1),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        InputField(
                          title: "Email",
                          hintText: "Enter your email",
                          textInputType: TextInputType.emailAddress,
                          validator: emailValidator,
                          controller: _emailController,
                          prefixIcon: Icon(Icons.email_rounded),
                        ),
                        SizedBox(height: AppSize.screenHeight * 0.05),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(40),
                              vertical: getProportionateScreenHeight(15),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<SignupBloc>().add(ForgotPassword(
                                    email: _emailController.text,
                                  ));
                            }
                          },
                          child: Text(
                            "Continue",
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                NoAccountText(),
                SizedBox(height: AppSize.screenHeight * 0.02),
              ],
            ),
            if (loading)
              Container(
                width: double.maxFinite,
                height: double.maxFinite,
                child: CustomLoading(),
              )
          ],
        ),
      ),
    );
  }
}
