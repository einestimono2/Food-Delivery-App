import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/configs/configs.dart';
import 'package:frontend/constants/constants.dart';
import 'package:frontend/widgets/widgets.dart';

import '../../blocs/blocs.dart';
import 'components/components.dart';

class OTPScreen extends StatefulWidget {
  static const String routeName = "/otp";
  static Route route({required bool resetPassword}) => MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => OTPScreen(resetPassword: resetPassword),
      );

  const OTPScreen({Key? key, required this.resetPassword}) : super(key: key);

  final bool resetPassword;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  Timer? _timer;
  int _timeRemaining = 30;
  bool _timeRunning = false;

  bool resendOTP = false;
  bool loading = false;
  String? token, email, password, name;

  @override
  void initState() {
    super.initState();
    startTimeExpired();

    if (context.read<SignupBloc>().state is SignupLoaded) {
      token = (context.read<SignupBloc>().state as SignupLoaded).token;
      email = (context.read<SignupBloc>().state as SignupLoaded).email;
      password = (context.read<SignupBloc>().state as SignupLoaded).password;
      name = (context.read<SignupBloc>().state as SignupLoaded).name;
    }
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  void startTimeExpired() {
    _timeRemaining = 31;
    const onsec = Duration(seconds: 1);
    _timer = Timer.periodic(onsec, (Timer timer) {
      if (_timeRemaining == 0) {
        _timeRunning = false;
        setState(() {
          timer.cancel();
        });
      } else {
        _timeRunning = true;
        setState(() {
          _timeRemaining--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: "OTP Verification", showLeading: false),
      body: BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is SignupLoading) {
            setState(() {
              loading = true;
            });
          } else if (state is SignupFailed) {
            showSnackBar(context, '${state.message}.\nPlease resent OTP code');
            setState(() {
              loading = false;
              _timeRemaining = 0;
            });
          } else if (state is SignupLoaded) {
            if (resendOTP) {
              showSnackBar(context,
                  "OTP has been sent back. Please check your email again!");

              setState(() {
                token = state.token;
                loading = false;
                resendOTP = false;
              });
            } else {
              showSnackBar(
                context,
                widget.resetPassword
                    ? "Password reset successful. You can use new password to login!"
                    : "Email has been activated. You can use this email to login!",
              );

              Navigator.of(context).pushReplacementNamed('/auth');
            }
          }
        },
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
              ),
              child: Column(
                children: [
                  SizedBox(height: AppSize.screenHeight * 0.1),
                  Text(
                    "OTP Verification",
                    style: Theme.of(context).textTheme.headline1!,
                  ),
                  SizedBox(height: AppSize.screenHeight * 0.01),
                  RichText(
                    text: TextSpan(
                      text: "\nWe sent your code to ",
                      style: Theme.of(context).textTheme.headline6!,
                      children: [
                        TextSpan(
                          text: email,
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: kPrimaryColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  RichText(
                    text: TextSpan(
                      text: "This code is valid for ",
                      style: Theme.of(context).textTheme.headline6!,
                      children: [
                        TextSpan(
                          text: "10 minutes",
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: kPrimaryColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildTimer(),
                  SizedBox(height: AppSize.screenHeight * 0.05),
                  widget.resetPassword
                      ? OTPFormResetPassword(token: token)
                      : OTPFormActiveEmail(token: token),
                  Spacer(),
                  Visibility(
                    visible: !_timeRunning,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          resendOTP = true;
                        });
                        context.read<SignupBloc>().add(widget.resetPassword
                            ? ForgotPassword(email: email!)
                            : SignupSubmit(
                                name: name!,
                                email: email!,
                                password: password!,
                              ));
                        startTimeExpired();
                      },
                      child: Text(
                        "Resend OTP Code",
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSize.screenHeight * 0.03),
                ],
              ),
            ),
            if (loading)
              Container(
                width: double.maxFinite,
                height: double.maxFinite,
                color: Colors.transparent,
                child: CustomLoading(),
              )
          ],
        ),
      ),
    );
  }

  Padding _buildTimer() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "You can resend the OTP code after ",
            style: Theme.of(context).textTheme.headline6!,
          ),
          Text(
            "$_timeRemaining ",
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: kPrimaryColor),
          ),
          Text(
            "s",
            style: Theme.of(context).textTheme.headline6!,
          ),
        ],
      ),
    );
  }
}
