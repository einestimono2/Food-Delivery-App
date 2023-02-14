import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/blocs/blocs.dart';
import 'package:frontend/configs/configs.dart';
import 'package:frontend/models/models.dart';

class SettingForm extends StatefulWidget {
  const SettingForm({Key? key}) : super(key: key);

  @override
  State<SettingForm> createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 3,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.screenWidth * 0.05,
          ),
          child: Column(
            children: <Widget>[
              SizedBox(height: AppSize.screenHeight * 0.05),
              BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, state) => TextButton(
                  onPressed: () => {},
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.dark_mode_sharp),
                        title: Text(
                          "Dark mode",
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(fontSize: 16),
                        ),
                        trailing: Switch(
                          value:
                              Theme.of(context).brightness == Brightness.dark,
                          onChanged: (value) {
                            BlocProvider.of<ThemeBloc>(context).add(
                              UpdateTheme(
                                appTheme: !value
                                    ? AppTheme.lightTheme
                                    : AppTheme.darkTheme,
                              ),
                            );
                          },
                        ),
                      ),
                      Divider(
                        color: Theme.of(context).textTheme.headline1!.color,
                        thickness: 1,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSize.screenHeight * 0.05),
              TextButton(
                onPressed: () {},
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.password_outlined),
                      title: Text(
                        "Change password",
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontSize: 16),
                      ),
                      trailing: Icon(
                        Icons.arrow_right_outlined,
                        color: Theme.of(context).textTheme.headline1!.color,
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).textTheme.headline1!.color,
                      thickness: 1,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.logout_outlined),
                      title: Text(
                        "Log Out",
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontSize: 16),
                      ),
                      trailing: Icon(
                        Icons.arrow_right_outlined,
                        color: Theme.of(context).textTheme.headline1!.color,
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).textTheme.headline1!.color,
                      thickness: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
