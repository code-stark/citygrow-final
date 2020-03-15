import 'dart:convert';
import 'dart:io';

import 'package:digitalproductstore/Service/auth/auth_service.dart';
import 'package:digitalproductstore/api/common/ps_resource.dart';

import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_constants.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/locator.dart';
import 'package:digitalproductstore/model/user_model.dart';
import 'package:digitalproductstore/provider/user/user_provider.dart';
import 'package:digitalproductstore/repository/user_repository.dart';
import 'package:digitalproductstore/ui/common/dialog/error_dialog.dart';
import 'package:digitalproductstore/ui/common/dialog/loading_dialog.dart';
import 'package:digitalproductstore/ui/common/dialog/warning_dialog_view.dart';
import 'package:digitalproductstore/ui/noti/detail/noti_view.dart';
import 'package:digitalproductstore/ui/user/profile/profile_view.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/holder/fb_login_parameter_holder.dart';
import 'package:digitalproductstore/viewobject/holder/google_login_parameter_holder.dart';
import 'package:digitalproductstore/viewobject/holder/user_login_parameter_holder.dart';
import 'package:digitalproductstore/viewobject/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class LoginView extends StatefulWidget {
  const LoginView(
      {Key key,
      this.animationController,
      this.animation,
      this.onProfileSelected,
      this.onForgotPasswordSelected,
      this.onSignInSelected,
      this.onPhoneSignInSelected,
      this.onFbSignInSelected,
      this.onGoogleSignInSelected,
      @required this.buildContexts})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final Function onProfileSelected,
      onForgotPasswordSelected,
      onSignInSelected,
      onPhoneSignInSelected,
      onFbSignInSelected,
      onGoogleSignInSelected;
  final BuildContext buildContexts;
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  UserRepository repo1;
  PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    widget.animationController.forward();
    const Widget _spacingWidget = SizedBox(
      height: ps_space_28,
    );

    repo1 = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
        child: ChangeNotifierProvider<UserProvider>(
      create: (BuildContext context) {
        final UserProvider provider =
            UserProvider(repo: repo1, psValueHolder: psValueHolder);
        // provider.postUserLogin(userLoginParameterHolder.toMap());
        return provider;
      },
      child: Consumer<UserProvider>(
          builder: (BuildContext context, UserProvider provider, Widget child) {
        return AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
                opacity: widget.animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - widget.animation.value), 0.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          _HeaderIconAndTextWidget(),
                          _TextFieldAndSignInButtonWidget(
                            animationController: widget.animationController,
                            provider: provider,
                            text: Utils.getString(context, 'login__submit'),
                            onProfileSelected: widget.onProfileSelected,
                          ),
                          _spacingWidget,
                          _DividerORWidget(),
                          _spacingWidget,
                          _LoginWithPhoneWidget(
                              onPhoneSignInSelected:
                                  widget.onPhoneSignInSelected),
                          // Currently Facebook Login is still not available
                          // https://github.com/roughike/flutter_facebook_login/issues/231
                          if (Platform.isAndroid)
                            _LoginWithFbWidget(
                                userProvider: provider,
                                onFbSignInSelected: widget.onFbSignInSelected),
                          _LoginWithGoogleWidget(
                              userProvider: provider,
                              onGoogleSignInSelected:
                                  widget.onGoogleSignInSelected),
                          _spacingWidget,
                          _ForgotPasswordAndRegisterWidget(
                            provider: provider,
                            animationController: widget.animationController,
                            onForgotPasswordSelected:
                                widget.onForgotPasswordSelected,
                            onSignInSelected: widget.onSignInSelected,
                          ),
                          _spacingWidget,
                        ],
                      ),
                    )));
          },
        );
      }),
    ));
  }
}

class _HeaderIconAndTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget _textWidget = Text(
      Utils.getString(context, 'app_name'),
      style: Theme.of(context)
          .textTheme
          .subtitle1
          .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
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

class _TextFieldAndSignInButtonWidget extends StatefulWidget {
  const _TextFieldAndSignInButtonWidget({
    @required this.provider,
    @required this.text,
    this.onProfileSelected,
    @required this.animationController,
  });
  final AnimationController animationController;

  final UserProvider provider;
  final String text;
  final Function onProfileSelected;

  @override
  __CardWidgetState createState() => __CardWidgetState();
}

class __CardWidgetState extends State<_TextFieldAndSignInButtonWidget> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const EdgeInsets _marginEdgeInsetsforCard = EdgeInsets.only(
        left: ps_space_16,
        right: ps_space_16,
        top: ps_space_4,
        bottom: ps_space_4);

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final int _currentIndex = REQUEST_CODE__MENU_HOME_FRAGMENT;

    return Column(
      children: <Widget>[
        Card(
          elevation: 0.3,
          margin: const EdgeInsets.only(left: ps_space_32, right: ps_space_32),
          child: Column(
            children: <Widget>[
              Container(
                margin: _marginEdgeInsetsforCard,
                child: TextField(
                  controller: emailController,
                  style: Theme.of(context).textTheme.button.copyWith(),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: Utils.getString(context, 'login__email'),
                      hintStyle: Theme.of(context).textTheme.button.copyWith(),
                      icon: Icon(Icons.email,
                          color: Theme.of(context).iconTheme.color)),
                ),
              ),
              const Divider(
                height: ps_space_1,
              ),
              Container(
                margin: _marginEdgeInsetsforCard,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: Theme.of(context).textTheme.button.copyWith(),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: Utils.getString(context, 'login__password'),
                      hintStyle: Theme.of(context).textTheme.button.copyWith(),
                      icon: Icon(Icons.lock,
                          color: Theme.of(context).iconTheme.color)),
                  // keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: ps_space_8,
        ),
        Container(
          margin: const EdgeInsets.only(left: ps_space_32, right: ps_space_32),
          child: MaterialButton(
            color: ps_ctheme__color_speical,
            height: 45,
            minWidth: double.infinity,
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7.0)),
            ),
            onPressed: () async {
              if (emailController.text.isEmpty &&
                  emailController.text.contains('@') == true) {
                callWarningDialog(context,
                    Utils.getString(context, 'warning_dialog__input_email'));
              } else if (passwordController.text.isEmpty) {
                callWarningDialog(context,
                    Utils.getString(context, 'warning_dialog__input_password'));
              } else {
                if (await utilsCheckInternetConnectivity()) {
                  // final UserLoginParameterHolder userLoginParameterHolder =
                  //     UserLoginParameterHolder(
                  //   userEmail: emailController.text,
                  //   userPassword: passwordController.text,
                  //   deviceToken: widget.provider.psValueHolder.deviceToken,
                  // );

                  final ProgressDialog progressDialog = loadingDialog(
                    context,
                  );
                  // progressDialog.show();
                  // final PsResource<User> _apiStatus = await widget.provider
                  //     .postUserLogin(userLoginParameterHolder.toMap());

                  // if (_apiStatus.data != null) {
                  progressDialog.show();

                  // widget.provider.replaceVerifyUserData('', '', '', '');
                  // widget.provider.replaceLoginUserId('_apiStatus.data.userId');
                  final FirebaseUser result = await sl
                      .get<AuthService>()
                      .signInWithEmailAndPassword(
                          emailController.text, passwordController.text);
                  if (result == null) {
                    progressDialog.hide();
                  } else {
                    progressDialog.hide();
                    Navigator.of(context, rootNavigator: true).maybePop();
                    // return Navigator.pushReplacement<dynamic, dynamic>(
                    //     context,
                    //     MaterialPageRoute<dynamic>(
                    //         builder: (BuildContext context) => ProfileView(
                    //               flag: _currentIndex,
                    //               scaffoldKey: scaffoldKey,
                    //               animationController:
                    //                   widget.animationController,
                    //             )));
                  }
                  //   if (widget.onProfileSelected != null) {
                  //     await widget.provider
                  //         .replaceVerifyUserData('', '', '', '');
                  //     await widget.provider
                  //         .replaceLoginUserId(_apiStatus.data.userId);
                  //     await widget.onProfileSelected(_apiStatus.data.userId);
                  //   } else {

                  //   }
                  // } else {
                  //   progressDialog.dismiss();
                  //   showDialog<dynamic>(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return const ErrorDialog(
                  //           message: '_apiStatus.message',
                  //         );
                  //       });
                  // }
                  // Navigator.push<dynamic>(
                  //     context,
                  //     MaterialPageRoute<dynamic>(
                  //         builder: (BuildContext context) =>
                  //             const ProfileView(flag: 1, scaffoldKey: null)));
                } else {
                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return ErrorDialog(
                          message: Utils.getString(
                              context, 'error_dialog__no_internet'),
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
                        Utils.getString(context, 'login__sign_in'),
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
        ),
      ],
    );
  }
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

class _DividerORWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const Widget _dividerWidget = Expanded(
      child: Divider(
        height: ps_space_2,
        color: Colors.white,
      ),
    );

    const Widget _spacingWidget = SizedBox(
      width: ps_space_8,
    );

    final Widget _textWidget = Text(
      'OR',
      style: Theme.of(context).textTheme.subtitle1.copyWith(
            color: Colors.white,
          ),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _dividerWidget,
        _spacingWidget,
        _textWidget,
        _spacingWidget,
        _dividerWidget,
      ],
    );
  }
}

class _LoginWithPhoneWidget extends StatefulWidget {
  const _LoginWithPhoneWidget({@required this.onPhoneSignInSelected});
  final Function onPhoneSignInSelected;

  @override
  __LoginWithPhoneWidgetState createState() => __LoginWithPhoneWidgetState();
}

class __LoginWithPhoneWidgetState extends State<_LoginWithPhoneWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: ps_space_16, right: ps_space_16),
      child: Stack(
        children: <Widget>[
          MaterialButton(
            color: ps_ctheme__color_speical,
            height: 40,
            minWidth: double.infinity,
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7.0)),
            ),
            onPressed: () async {
              if (widget.onPhoneSignInSelected != null) {
                widget.onPhoneSignInSelected();
              } else {
                Navigator.pushReplacementNamed(
                  context,
                  RoutePaths.user_phone_signin_container,
                );
              }
            },
            child: Text(
              Utils.getString(context, 'login__phone_signin'),
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: Colors.white),
            ),
          ),
          Positioned(
            child: IconButton(
              icon: const Icon(
                Icons.phone,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginWithFbWidget extends StatefulWidget {
  const _LoginWithFbWidget(
      {@required this.userProvider, @required this.onFbSignInSelected});
  final UserProvider userProvider;
  final Function onFbSignInSelected;

  @override
  __LoginWithFbWidgetState createState() => __LoginWithFbWidgetState();
}

class __LoginWithFbWidgetState extends State<_LoginWithFbWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: ps_space_16, right: ps_space_16),
      child: Stack(
        children: <Widget>[
          MaterialButton(
            color: Colors.blueAccent,
            height: 40,
            minWidth: double.infinity,
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7.0)),
            ),
            onPressed: () async {
              final FacebookLogin fbLogin = FacebookLogin();

              final dynamic result =
                  await fbLogin.logIn(<String>['email', 'public_profile']);

              if (result.status == FacebookLoginStatus.loggedIn) {
                final FacebookAccessToken myToken = result.accessToken;
                FacebookAuthProvider.getCredential(accessToken: myToken.token);
                print(myToken.token);

                final String token = myToken.token;
                final dynamic graphResponse = await http.get(
                    'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
                final dynamic profile = json.decode(graphResponse.body);

                if (await utilsCheckInternetConnectivity()) {
                  final FBLoginParameterHolder fbLoginParameterHolder =
                      FBLoginParameterHolder(
                          facebookId: profile['id'],
                          userName: profile['name'],
                          userEmail: profile['email'],
                          profilePhotoUrl: '',
                          deviceToken:
                              widget.userProvider.psValueHolder.deviceToken);

                  final ProgressDialog progressDialog = loadingDialog(
                    context,
                  );
                  progressDialog.show();
                  final PsResource<User> _apiStatus = await widget.userProvider
                      .postFBLogin(fbLoginParameterHolder.toMap());

                  if (_apiStatus.data != null) {
                    widget.userProvider.replaceVerifyUserData('', '', '', '');
                    widget.userProvider
                        .replaceLoginUserId(_apiStatus.data.userId);

                    progressDialog.dismiss();
                    if (widget.onFbSignInSelected != null) {
                      widget.onFbSignInSelected(_apiStatus.data.userId);
                    } else {
                      Navigator.pop(context, _apiStatus.data);
                    }
                  } else {
                    progressDialog.dismiss();

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
                          message: Utils.getString(
                              context, 'error_dialog__no_internet'),
                        );
                      });
                }
              }
            },
            child: Text(
              Utils.getString(context, 'login__fb_signin'),
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: Colors.white),
            ),
          ),
          Positioned(
            child: IconButton(
              icon: Icon(
                FontAwesome.facebook_official,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginWithGoogleWidget extends StatefulWidget {
  const _LoginWithGoogleWidget(
      {@required this.userProvider, @required this.onGoogleSignInSelected});
  final UserProvider userProvider;
  final Function onGoogleSignInSelected;

  @override
  __LoginWithGoogleWidgetState createState() => __LoginWithGoogleWidgetState();
}

class __LoginWithGoogleWidgetState extends State<_LoginWithGoogleWidget> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<FirebaseUser> _handleSignIn() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      print('signed in' + user.displayName);
      return user;
    } catch (Exception) {
      print('not select google account');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Users user = Provider.of<Users>(context);

    return Container(
      margin: const EdgeInsets.only(left: ps_space_16, right: ps_space_16),
      child: Stack(
        children: <Widget>[
          MaterialButton(
            color: Colors.white,
            height: 40,
            minWidth: double.infinity,
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7.0)),
            ),
            onPressed: () async {
              // print(user.uid);
              await sl
                  .get<AuthService>()
                  .signInWithGoogleeee()
                  .whenComplete(() => Navigator.pop(context));
              //     .then((FirebaseUser user) async {
              //   if (user != null) {
              //     if (await utilsCheckInternetConnectivity()) {
              //       final GoogleLoginParameterHolder
              //           googleLoginParameterHolder = GoogleLoginParameterHolder(
              //               googleId: user.uid,
              //               userName: user.displayName,
              //               userEmail: user.email,
              //               profilePhotoUrl: user.photoUrl,
              //               deviceToken:
              //                   widget.userProvider.psValueHolder.deviceToken);

              //       final ProgressDialog progressDialog = loadingDialog(
              //         context,
              //       );
              //       progressDialog.show();
              //       final PsResource<User> _apiStatus = await widget
              //           .userProvider
              //           .postGoogleLogin(googleLoginParameterHolder.toMap());

              //       if (_apiStatus.data != null) {
              //         widget.userProvider.replaceVerifyUserData('', '', '', '');
              //         widget.userProvider
              //             .replaceLoginUserId(_apiStatus.data.userId);
              //         progressDialog.dismiss();

              //         if (widget.onGoogleSignInSelected != null) {
              //           widget.onGoogleSignInSelected(_apiStatus.data.userId);
              //         } else {
              //           Navigator.pop(context, _apiStatus.data);
              //         }
              //       } else {
              //         progressDialog.dismiss();

              //         showDialog<dynamic>(
              //             context: context,
              //             builder: (BuildContext context) {
              //               return ErrorDialog(
              //                 message: _apiStatus.message,
              //               );
              //             });
              //       }
              //       // if (user.uid != null) {
              //       //   progressDialog.dismiss();
              //       //   showDialog<dynamic>(
              //       //       context: context,
              //       //       builder: (BuildContext context) {
              //       //         return ErrorDialog(
              //       //           message: 'fdfdfd',
              //       //         );
              //       //       });
              //       //   Navigator.pop(context, user);
              //       // }
              //     }
              //   } else {
              //     showDialog<dynamic>(
              //         context: context,
              //         builder: (BuildContext context) {
              //           return ErrorDialog(
              //             message: Utils.getString(
              //                 context, 'error_dialog__no_internet'),
              //           );
              //         });
              //   }
              // });
              // await _handleSignIn().then((FirebaseUser user) async {
              //   if (user != null) {
              //     if (await utilsCheckInternetConnectivity()) {
              //       final GoogleLoginParameterHolder
              //           googleLoginParameterHolder = GoogleLoginParameterHolder(
              //               googleId: user.uid,
              //               userName: user.displayName,
              //               userEmail: user.email,
              //               profilePhotoUrl: user.photoUrl,
              //               deviceToken:
              //                   widget.userProvider.psValueHolder.deviceToken);

              //       final ProgressDialog progressDialog = loadingDialog(
              //         context,
              //       );
              //       progressDialog.show();
              //       final PsResource<User> _apiStatus = await widget
              //           .userProvider
              //           .postGoogleLogin(googleLoginParameterHolder.toMap());

              //       if (_apiStatus.data != null) {
              //         widget.userProvider.replaceVerifyUserData('', '', '', '');
              //         widget.userProvider
              //             .replaceLoginUserId(_apiStatus.data.userId);
              //         progressDialog.dismiss();

              //         if (widget.onGoogleSignInSelected != null) {
              //           widget.onGoogleSignInSelected(_apiStatus.data.userId);
              //         } else {
              //           Navigator.pop(context, _apiStatus.data);
              //         }
              //       } else {
              //         progressDialog.dismiss();

              //         showDialog<dynamic>(
              //             context: context,
              //             builder: (BuildContext context) {
              //               return ErrorDialog(
              //                 message: _apiStatus.message,
              //               );
              //             });
              //       }
              //     } else {
              //       showDialog<dynamic>(
              //           context: context,
              //           builder: (BuildContext context) {
              //             return ErrorDialog(
              //               message: Utils.getString(
              //                   context, 'error_dialog__no_internet'),
              //             );
              //           });
              //     }
              //   }
              // });
            },
            child: Text(
              Utils.getString(context, 'login__google_signin'),
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: Colors.black),
            ),
          ),
          Positioned(
            child: IconButton(
              icon: Icon(
                FontAwesome.google,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _ForgotPasswordAndRegisterWidget extends StatefulWidget {
  const _ForgotPasswordAndRegisterWidget(
      {Key key,
      this.provider,
      this.animationController,
      this.onForgotPasswordSelected,
      this.onSignInSelected})
      : super(key: key);

  final AnimationController animationController;
  final Function onForgotPasswordSelected;
  final Function onSignInSelected;
  final UserProvider provider;

  @override
  __ForgotPasswordAndRegisterWidgetState createState() =>
      __ForgotPasswordAndRegisterWidgetState();
}

class __ForgotPasswordAndRegisterWidgetState
    extends State<_ForgotPasswordAndRegisterWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: ps_space_40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: GestureDetector(
              child: Text(
                Utils.getString(context, 'login__forgot_password'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.button.copyWith(
                      color: Colors.white,
                    ),
              ),
              onTap: () {
                if (widget.onForgotPasswordSelected != null) {
                  widget.onForgotPasswordSelected();
                } else {
                  Navigator.pushReplacementNamed(
                    context,
                    RoutePaths.user_forgot_password_container,
                  );
                }
              },
            ),
          ),
          Flexible(
            child: GestureDetector(
              child: Text(
                Utils.getString(context, 'login__sign_up'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.button.copyWith(
                      color: Colors.white,
                    ),
              ),
              onTap: () async {
                if (widget.onSignInSelected != null) {
                  widget.onSignInSelected();
                } else {
                  final dynamic returnData =
                      await Navigator.pushReplacementNamed(
                    context,
                    RoutePaths.user_register_container,
                  );
                  if (returnData != null && returnData is User) {
                    final User user = returnData;
                    widget.provider.psValueHolder =
                        Provider.of<PsValueHolder>(context);
                    widget.provider.psValueHolder.loginUserId = user.userId;
                    widget.provider.psValueHolder.userIdToVerify = '';
                    widget.provider.psValueHolder.userNameToVerify = '';
                    widget.provider.psValueHolder.userEmailToVerify = '';
                    widget.provider.psValueHolder.userPasswordToVerify = '';
                    Navigator.pop(context, user);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
