import "package:flutter/material.dart";

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: Theme.of(context).textTheme.headline4!.copyWith(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.normal,
              ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(
            context,
            '/auth',
            arguments: {"signUp": true},
          ),
          child: Text(
            "Sign Up",
            style: Theme.of(context).textTheme.headline4!.copyWith(
                  fontStyle: FontStyle.italic,
                ),
          ),
        ),
      ],
    );
  }
}
