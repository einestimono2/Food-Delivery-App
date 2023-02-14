import 'package:flutter/material.dart';
import 'package:frontend/configs/configs.dart';
import 'package:frontend/constants/constants.dart';
import 'package:frontend/screens/screens.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeAppBar extends StatelessWidget with PreferredSizeWidget {
  const HomeAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: AppSize.screenHeight / 4,
      backgroundColor: kPrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          // bottom: Radius.elliptical(MediaQuery.of(context).size.width, 22),
          bottom: Radius.circular(22),
        ),
      ),
      title: Text(
        'Foodies',
        style: GoogleFonts.msMadi(
          textStyle:
              Theme.of(context).textTheme.headline1!.copyWith(fontSize: 40),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: preferredSize,
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 15.0,
            left: 15.0,
            right: 10.0,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white70,
                    hintText: "What would you like to eat?",
                    hintStyle: GoogleFonts.lato(color: Colors.black),
                    labelStyle: GoogleFonts.lato(color: Colors.black),
                    suffixIcon: Icon(
                      Icons.search,
                      color: kPrimaryColor,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 5),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white70,
                ),
                child: IconButton(
                  icon: Icon(Icons.menu, color: Theme.of(context).primaryColor),
                  onPressed: () {
                    Navigator.pushNamed(context, FilterScreen.routeName);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Size get preferredSize => Size.fromHeight(130.0);
}
