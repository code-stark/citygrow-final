import 'package:digitalproductstore/Service/auth/auth_service.dart';
import 'package:digitalproductstore/api/common/ps_resource.dart';

import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_config.dart';
import 'package:digitalproductstore/config/ps_constants.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/locator.dart';
import 'package:digitalproductstore/provider/user/user_provider.dart';
import 'package:digitalproductstore/repository/user_repository.dart';
import 'package:digitalproductstore/ui/common/dialog/error_dialog.dart';
import 'package:digitalproductstore/ui/common/dialog/loading_dialog.dart';
import 'package:digitalproductstore/ui/common/dialog/warning_dialog_view.dart';
import 'package:digitalproductstore/ui/dashboard/core/dashboard_view.dart';
import 'package:digitalproductstore/ui/user/profile/profile_view.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/holder/user_register_parameter_holder.dart';
import 'package:digitalproductstore/viewobject/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView(
      {Key key,
      this.animationController,
      this.onRegisterSelected,
      this.goToLoginSelected,
      @required this.buildContexts})
      : super(key: key);
  final AnimationController animationController;
  final Function onRegisterSelected, goToLoginSelected;
  final BuildContext buildContexts;

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  UserRepository repo1;
  PsValueHolder valueHolder;
  TextEditingController nameController;
  TextEditingController emailController;
  TextEditingController passwordController;

  @override
  void initState() {
    animationController =
        AnimationController(duration: animation_duration, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
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
    valueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
      child: ChangeNotifierProvider<UserProvider>(
        create: (BuildContext context) {
          final UserProvider provider =
              UserProvider(repo: repo1, psValueHolder: valueHolder);

          return provider;
        },
        child: Consumer<UserProvider>(builder:
            (BuildContext context, UserProvider provider, Widget child) {
          nameController = TextEditingController(
              text: provider.psValueHolder.userNameToVerify);
          emailController = TextEditingController(
              text: provider.psValueHolder.userEmailToVerify);
          passwordController = TextEditingController(
              text: provider.psValueHolder.userPasswordToVerify);

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
                                  _TextFieldWidget(
                                    nameText: nameController,
                                    emailText: emailController,
                                    passwordText: passwordController,
                                  ),
                                  const SizedBox(
                                    height: ps_space_8,
                                  ),
                                  _SignInButtonWidget(
                                    buildContexts: widget.buildContexts,
                                    animationController: animationController,
                                    provider: provider,
                                    nameTextEditingController: nameController,
                                    emailTextEditingController: emailController,
                                    passwordTextEditingController:
                                        passwordController,
                                    onRegisterSelected:
                                        widget.onRegisterSelected,
                                  ),
                                  const SizedBox(
                                    height: ps_space_16,
                                  ),
                                  _TextWidget(
                                    goToLoginSelected: widget.goToLoginSelected,
                                  ),
                                  const SizedBox(
                                    height: ps_space_64,
                                  ),
                                ],
                              ),
                            ));
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
        Utils.getString(context, 'register__login'),
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(color: Colors.orange),
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

class _TextFieldWidget extends StatefulWidget {
  const _TextFieldWidget({
    @required this.nameText,
    @required this.emailText,
    @required this.passwordText,
  });

  final TextEditingController nameText, emailText, passwordText;
  @override
  __TextFieldWidgetState createState() => __TextFieldWidgetState();
}

class __TextFieldWidgetState extends State<_TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    const EdgeInsets _marginEdgeInsetWidget = EdgeInsets.only(
        left: ps_space_16,
        right: ps_space_16,
        top: ps_space_4,
        bottom: ps_space_4);

    const Widget _dividerWidget = Divider(
      height: ps_space_1,
    );
    return Card(
      elevation: 0.3,
      margin: const EdgeInsets.only(left: ps_space_32, right: ps_space_32),
      child: Column(
        children: <Widget>[
          Container(
            margin: _marginEdgeInsetWidget,
            child: TextField(
              controller: widget.nameText,
              style: Theme.of(context).textTheme.button.copyWith(),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Utils.getString(context, 'register__user_name'),
                  hintStyle: Theme.of(context).textTheme.button.copyWith(),
                  icon: Icon(Icons.people,
                      color: Theme.of(context).iconTheme.color)),
            ),
          ),
          _dividerWidget,
          Container(
            margin: _marginEdgeInsetWidget,
            child: TextField(
              controller: widget.emailText,
              style: Theme.of(context).textTheme.button.copyWith(),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Utils.getString(context, 'register__email'),
                  hintStyle: Theme.of(context).textTheme.button.copyWith(),
                  icon: Icon(Icons.email,
                      color: Theme.of(context).iconTheme.color)),
            ),
          ),
          _dividerWidget,
          Container(
            margin: _marginEdgeInsetWidget,
            child: TextField(
              controller: widget.passwordText,
              obscureText: true,
              style: Theme.of(context).textTheme.button.copyWith(),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Utils.getString(context, 'register__password'),
                  hintStyle: Theme.of(context).textTheme.button.copyWith(),
                  icon: Icon(Icons.lock,
                      color: Theme.of(context).iconTheme.color)),
              // keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconAndTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: ps_space_32,
        ),
        Container(
          width: 90,
          height: 90,
          child: Image.asset(
            'assets/images/digital_product_logo_white.png',
          ),
        ),
        const SizedBox(
          height: ps_space_8,
        ),
        Text(
          Utils.getString(context, 'app_name'),
          style: Theme.of(context).textTheme.subtitle1.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        const SizedBox(
          height: ps_space_52,
        ),
      ],
    );
  }
}

class _SignInButtonWidget extends StatefulWidget {
  const _SignInButtonWidget(
      {@required this.provider,
      @required this.nameTextEditingController,
      @required this.emailTextEditingController,
      @required this.passwordTextEditingController,
      this.onRegisterSelected,
      @required this.animationController,
      @required this.buildContexts});
  final UserProvider provider;
  final Function onRegisterSelected;
  final TextEditingController nameTextEditingController,
      emailTextEditingController,
      passwordTextEditingController;
  final AnimationController animationController;
  final BuildContext buildContexts;
  @override
  __SignInButtonWidgetState createState() => __SignInButtonWidgetState();
}

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

int _currentIndex = REQUEST_CODE__MENU_HOME_FRAGMENT;

dynamic callWarningDialog(BuildContext context, String text) {
  showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return WarningDialog(
          message: Utils.getString(context, text),
        );
      });
}

class __SignInButtonWidgetState extends State<_SignInButtonWidget> {
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
          if (widget.nameTextEditingController.text.isEmpty) {
            callWarningDialog(context,
                Utils.getString(context, 'warning_dialog__input_name'));
          } else if (widget.emailTextEditingController.text.isEmpty) {
            callWarningDialog(context,
                Utils.getString(context, 'warning_dialog__input_email'));
          } else if (widget.passwordTextEditingController.text.isEmpty) {
            callWarningDialog(context,
                Utils.getString(context, 'warning_dialog__input_password'));
          } else {
            if (await utilsCheckInternetConnectivity()) {
              final ProgressDialog progressDialog = loadingDialog(
                context,
              );
              progressDialog.show();
              final FirebaseUser result = await sl
                  .get<AuthService>()
                  .registerWithEmailAndPassword(
                      widget.emailTextEditingController.text,
                      widget.passwordTextEditingController.text,
                      widget.nameTextEditingController.text);
              if (result == null) {
                progressDialog.hide();
              } else {
                progressDialog.hide();
                Navigator.of(widget.buildContexts, rootNavigator: true).pop();
                return Navigator.pushReplacement<dynamic, dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => DashboardView()
                        // ProfileView(
                        //       flag: _currentIndex,
                        //       scaffoldKey: scaffoldKey,
                        //       animationController: widget.animationController,
                        //     )
                        ));
              }
              // final UserRegisterParameterHolder userRegisterParameterHolder =
              //     UserRegisterParameterHolder(
              //   userId: '',
              //   userName: widget.nameTextEditingController.text,
              //   userEmail: widget.emailTextEditingController.text,
              //   userPassword: widget.passwordTextEditingController.text,
              //   userPhone: '',
              //   deviceToken: widget.provider.psValueHolder.deviceToken,
              // );

              // final PsResource<User> _apiStatus = await widget.provider
              //     .postUserRegister(userRegisterParameterHolder.toMap());

              // if (_apiStatus.data != null) {
              //   final User user = _apiStatus.data;

              //   //verify
              //   await widget.provider.replaceVerifyUserData(
              //       _apiStatus.data.userId,
              //       _apiStatus.data.userName,
              //       _apiStatus.data.userEmail,
              //       widget.passwordTextEditingController.text);

              //   widget.provider.psValueHolder.userIdToVerify = user.userId;
              //   widget.provider.psValueHolder.userNameToVerify = user.userName;
              //   widget.provider.psValueHolder.userEmailToVerify =
              //       user.userEmail;
              //   widget.provider.psValueHolder.userPasswordToVerify =
              //       user.userPassword;

              //   //
              //   if (widget.onRegisterSelected != null) {
              //     await widget.onRegisterSelected();
              //   } else {
              //   final dynamic returnData = await Navigator.pushNamed(
              //     context,
              //     RoutePaths.user_verify_email_container,
              //   );

              //   if (returnData != null && returnData is User) {
              //     final User user = returnData;
              //     if (Provider != null && Provider.of != null) {
              //       widget.provider.psValueHolder =
              //           Provider.of<PsValueHolder>(context);
              //     }
              //     widget.provider.psValueHolder.loginUserId = user.userId;
              //     widget.provider.psValueHolder.userIdToVerify = '';
              //     widget.provider.psValueHolder.userNameToVerify = '';
              //     widget.provider.psValueHolder.userEmailToVerify = '';
              //     widget.provider.psValueHolder.userPasswordToVerify = '';
              //     print(user.userId);
              // Navigator.of(context,rootNavigator: true).pop();
              //   }
              // }
              // } else {
              // showDialog<dynamic>(
              //     context: context,
              //     builder: (BuildContext context) {
              //       return ErrorDialog(
              //         message: _apiStatus.message,
              //       );
              //     });
              // }
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
                    Utils.getString(context, 'register__register'),
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
