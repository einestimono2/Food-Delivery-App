import 'package:flutter/material.dart';
import 'package:frontend/configs/configs.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        color: Colors.grey,
        padding: EdgeInsets.only(
          left: AppSize.screenWidth * 0.08,
          right: AppSize.screenWidth * 0.05,
        ),
        child: SafeArea(
          child: Row(
            children: <Widget>[
              Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://thpt-phamhongthai.edu.vn/wp-content/uploads/2022/07/avatar-con-viet-vang-ngau2b252842529.jpg',
                    ),
                    radius: 50,
                  ),
                  Positioned(
                    bottom: -13,
                    right: -13,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.camera_alt_sharp),
                    ),
                  )
                ],
              ),
              SizedBox(width: AppSize.screenWidth * 0.05),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Nguyễn Hoàng Minh Anh Quân",
                      style: Theme.of(context).textTheme.headline3,
                      maxLines: 2,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.edit,
                            color: Theme.of(context).textTheme.headline6!.color,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Edit Profile",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
