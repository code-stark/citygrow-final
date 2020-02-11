import 'package:digitalproductstore/api/common/ps_resource.dart';

import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_config.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/provider/user/user_provider.dart';
import 'package:digitalproductstore/repository/user_repository.dart';
import 'package:digitalproductstore/ui/common/dialog/error_dialog.dart';
import 'package:digitalproductstore/ui/common/dialog/success_dialog.dart';
import 'package:digitalproductstore/ui/common/dialog/warning_dialog_view.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/api_status.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/holder/forgot_password_parameter_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({
    Key key,
    this.animationController,
    this.goToLoginSelected,
  }) : super(key: key);
  final AnimationController animationController;
  final Function goToLoginSelected;
  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView>
    with SingleTickerProviderStateMixin {
  final TextEditingController userEmailController = TextEditingController();
  UserRepository repo1;
  PsValueHolder psValueHolder;
  AnimationController animationController;
  @override
  void initState() {
    animationController =
        AnimationController(duration: animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    animationController.forward();
    repo1 = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
      child: ChangeNotifierProvider<UserProvider>(
        create: (BuildContext context) {
          final UserProvider provider =
              UserProvider(repo: repo1, psValueHolder: psValueHolder);
          // provider.postUserRegister(userRegisterParameterHolder.toMap());
          return provider;
        },
        child: Consumer<UserProvider>(builder:
            (BuildContext context, UserProvider provider, Widget child) {
          return Stack(
            children: <Widget>[
              SingleChildScrollView(
                  child: AnimatedBuilder(
                      animation: animationController,
                      builder: (BuildContext context, Widget child) {
                        return FadeTransition(
                          opacity: animation,
                          child: Transform(
                            transform: Matrix4.translationValues(
                                0.0, 100 * (1.0 - animation.value), 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                _HeaderIconAndTextWidget(),
                                _CardWidget(
                                  userEmailController: userEmailController,
                                ),
                                const SizedBox(
                                  height: ps_space_8,
                                ),
                                _SendButtonWidget(
                                  provider: provider,
                                  userEmailController: userEmailController,
                                ),
                                const SizedBox(
                                  height: ps_space_16,
                                ),
                                _TextWidget(
                                    goToLoginSelected:
                                        widget.goToLoginSelected),
                              ],
                            ),
                          ),
                        );
                      }))
            ],
          );
        }),
      ),
    );
  }
}

class _TextWidget extends StatefulWidget {
  const _TextWidget({this.goToLoginSelected});
  final Function goToLoginSelected;
  @override
  __TextWidgetState createState() => __TextWidgetState();
}

class __TextWidgetState extends State<_TextWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(
        Utils.getString(context, 'forgot_psw__login'),
        style: Theme.of(context).textTheme.body1.copyWith(color: Colors.orange),
      ),
      onTap: () {
        if (widget.goToLoginSelected != null) {
          widget.goToLoginSelected();
        } else {
          Navigator.pushReplacementNamed(
            context,
            RoutePaths.login_container,
          );
        }
      },
    );
  }
}

class _HeaderIconAndTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget _textWidget = Text(
      Utils.getString(context, 'app_name'),
      style: Theme.of(context).textTheme.title.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
    );

    final Widget _imageWidget = Container(
      width: 90,
      height: 90,
      child: Image.asset(
        'assets/images/digital_product_logo_white.png',
      ),
    );
    return Column(
      children: <Widget>[
        const SizedBox(
          height: ps_space_32,
        ),
        _imageWidget,
        const SizedBox(
          height: ps_space_8,
        ),
        _textWidget,
        const SizedBox(
          height: ps_space_52,
        ),
      ],
    );
  }
}

class _CardWidget extends StatelessWidget {
  const _CardWidget({
    @required this.userEmailController,
  });

  final TextEditingController userEmailController;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.3,
      margin: const EdgeInsets.only(left: ps_space_32, right: ps_space_32),
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(
                left: ps_space_16,
                right: ps_space_16,
                top: ps_space_4,
                bottom: ps_space_4),
            child: TextField(
              controller: userEmailController,
              style: Theme.of(context).textTheme.button.copyWith(),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Utils.getString(context, 'forgot_psw__email'),
                  hintStyle: Theme.of(context).textTheme.button.copyWith(),
                  icon: Icon(Icons.email,
                      color: Theme.of(context).iconTheme.color)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SendButtonWidget extends StatefulWidget {
  const _SendButtonWidget({
    @required this.provider,
    @required this.userEmailController,
  });
  final UserProvider provider;
  final TextEditingController userEmailController;

  @override
  __SendButtonWidgetState createState() => __SendButtonWidgetState();
}

dynamic callWarningDialog(BuildContext context, String text) {
  showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return WarningDialog(
          message: Utils.getString(context, text),
        );
      });
}

class __SendButtonWidgetState extends State<_SendButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: ps_space_32, right: ps_space_32),
      child: MaterialButton(
        color: ps_ctheme__color_speical,
        height: 45,
        minWidth: double.infinity,
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        onPressed: () async {
          if (widget.userEmailController.text.isEmpty) {
            callWarningDialog(context,
                Utils.getString(context, 'warning_dialog__input_email'));
          } else {
            if (await utilsCheckInternetConnectivity()) {
              final ForgotPasswordParameterHolder
                  forgotPasswordParameterHolder = ForgotPasswordParameterHolder(
                userEmail: widget.userEmailController.text,
              );

              final PsResource<ApiStatus> _apiStatus = await widget.provider
                  .postForgotPassword(forgotPasswordParameterHolder.toMap());

              if (_apiStatus.data != null) {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return SuccessDialog(
                        message: _apiStatus.data.message,
                      );
                    });
              } else {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        message: _apiStatus.message,
                      );
                    });
              }
            } else {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      message:
                          Utils.getString(context, 'error_dialog__no_internet'),
                    );
                  });
            }
          }
        },
        child: widget.provider != null
            ? widget.provider.isLoading
                ? Text(
                    Utils.getString(context, 'login__loading'),
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: Colors.white),
                  )
                : Text(
                    Utils.getString(context, 'forgot_psw__send'),
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: Colors.white),
                  )
            : Text(
                Utils.getString(context, 'login__sign_in'),
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: Colors.white),
              ),
      ),
    );
  }
}
