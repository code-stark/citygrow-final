import 'package:digitalproductstore/model/user_model.dart';
import 'package:digitalproductstore/ui/user/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WrapperUser extends StatelessWidget {
  final AnimationController animationController;
  final Animation<double> animation;
  WrapperUser({
    Key key,
    this.animationController,
    this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Users user = Provider.of<Users>(context);
    if (user == null) {
      return Stack(
        children: <Widget>[
          Image.asset(
            'assets/images/login_app_bg.jpg',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          CustomScrollView(scrollDirection: Axis.vertical, slivers: <Widget>[
            LoginView(
              animationController: animationController,
              animation: animation,
            ),
          ])
        ],
      );
    } else {}
  }
}
