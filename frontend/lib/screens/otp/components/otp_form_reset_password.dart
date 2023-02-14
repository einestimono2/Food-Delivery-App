import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';
import '../../../configs/configs.dart';
import '../../../constants/constants.dart';
import '../../../widgets/widgets.dart';

// OTP Decoration
final otpInputDecoration2 = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: const BorderSide(color: Color(0xFF757575)),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: const BorderSide(color: Color(0xFF757575)),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: const BorderSide(color: Color(0xFF757575)),
  ),
);

class OTPFormResetPassword extends StatefulWidget {
  const OTPFormResetPassword({Key? key, this.token}) : super(key: key);

  final String? token;

  @override
  State<OTPFormResetPassword> createState() => _OTPFormResetPasswordState();
}

class _OTPFormResetPasswordState extends State<OTPFormResetPassword> {
  final _formKey = GlobalKey<FormState>();

  FocusNode? pin1FocusNode;
  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;
  FocusNode? pin5FocusNode;
  FocusNode? pin6FocusNode;

  final TextEditingController _newPasswordController = TextEditingController();

  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final TextEditingController _controller5 = TextEditingController();
  final TextEditingController _controller6 = TextEditingController();

  bool _showPassword = false;
  bool _obscurePasword = true;

  @override
  void initState() {
    super.initState();
    pin1FocusNode = FocusNode();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
  }

  @override
  void dispose() {
    pin1FocusNode!.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
    pin5FocusNode!.dispose();
    pin6FocusNode!.dispose();
    super.dispose();
  }

  void nextPin({
    String? value,
    FocusNode? focusNode,
    TextEditingController? controller,
  }) {
    if (value!.length == 1) {
      controller!.clear();
      focusNode!.requestFocus();
    }
  }

  void _resetPassword() {
    if (_controller1.text == '' ||
        _controller2.text == '' ||
        _controller3.text == '' ||
        _controller4.text == '' ||
        _controller5.text == '' ||
        _controller6.text == '') {
      return showSnackBar(context, "Please complete all information!");
    }

    String otp = _controller1.text +
        _controller2.text +
        _controller3.text +
        _controller4.text +
        _controller5.text +
        _controller6.text;

    if (widget.token != null) {
      BlocProvider.of<SignupBloc>(context).add(ResetPassword(
        token: widget.token!,
        otp: otp,
        newPassword: _newPasswordController.text,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: AppSize.screenHeight * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPIN(
                _controller1,
                _controller2,
                pin1FocusNode,
                pin2FocusNode,
                // autofocus: true,
              ),
              _buildPIN(
                _controller2,
                _controller3,
                pin2FocusNode,
                pin3FocusNode,
              ),
              _buildPIN(
                _controller3,
                _controller4,
                pin3FocusNode,
                pin4FocusNode,
              ),
              _buildPIN(
                _controller4,
                _controller5,
                pin4FocusNode,
                pin5FocusNode,
              ),
              _buildPIN(
                _controller5,
                _controller6,
                pin5FocusNode,
                pin6FocusNode,
              ),
              _buildPIN(
                _controller6,
                null,
                pin6FocusNode,
                null,
              ),
            ],
          ),
          SizedBox(height: AppSize.screenHeight * 0.05),
          Visibility(
            visible: _showPassword,
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  InputField(
                    obscureText: _obscurePasword,
                    title: "New Password",
                    hintText: "Enter your new password",
                    textInputType: TextInputType.emailAddress,
                    validator: passwordValidator,
                    controller: _newPasswordController,
                    prefixIcon: Icon(Icons.email_rounded),
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
                  SizedBox(height: AppSize.screenHeight * 0.1),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(40),
                        vertical: getProportionateScreenHeight(15),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _resetPassword();
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
        ],
      ),
    );
  }

  SizedBox _buildPIN(
      TextEditingController controller,
      TextEditingController? controllerNext,
      FocusNode? focusNode,
      FocusNode? focusNodeNext,
      {bool autofocus = false}) {
    return SizedBox(
      width: getProportionateScreenWidth(50),
      height: getProportionateScreenWidth(50),
      child: TextFormField(
        autofocus: autofocus,
        controller: controller,
        focusNode: focusNode,
        obscureText: true,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: otpInputDecoration2,
        onTap: () {
          controller.clear();
          if (focusNodeNext != null && _showPassword == true) {
            setState(() {
              _showPassword = false;
            });
          }
        },
        onChanged: (value) {
          if (focusNodeNext == null) {
            focusNode!.unfocus();
            setState(() {
              _showPassword = true;
            });
          } else {
            nextPin(
              value: value,
              focusNode: focusNodeNext,
              controller: controllerNext,
            );

            if (_showPassword = true) {
              setState(() {
                _showPassword = false;
              });
            }
          }
          ;
        },
      ),
    );
  }
}
