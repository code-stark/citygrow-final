import 'package:digitalproductstore/api/common/ps_resource.dart';

import 'package:digitalproductstore/config/ps_colors.dart';
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
import 'package:digitalproductstore/viewobject/holder/resend_code_holder.dart';
import 'package:digitalproductstore/viewobject/holder/user_email_verify_parameter_holder.dart';
import 'package:digitalproductstore/viewobject/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView(
      {Key key,
      this.animationController,
      this.onProfileSelected,
      this.onSignInSelected})
      : super(key: key);

  final AnimationController animationController;
  final Function onProfileSelected, onSignInSelected;
  @override
  _VerifyEmailViewState createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  UserRepository repo1;
  PsValueHolder valueHolder;

  @override
  Widget build(BuildContext context) {
    widget.animationController.forward();

    final Widget _dividerWidget = Divider(
      color: Utils.isLightMode(context) ? Colors.white : Colors.black54,
      height: ps_space_2,
    );
    final Widget _greyLineWidget = Column(
      children: <Widget>[
        const SizedBox(
          height: ps_space_16,
        ),
        Divider(
          color: Utils.isLightMode(context) ? Colors.black54 : Colors.white,
          height: ps_space_1,
        ),
        const SizedBox(
          height: ps_space_32,
        )
      ],
    );

    repo1 = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    return ChangeNotifierProvider<UserProvider>(
      create: (BuildContext context) {
        final UserProvider provider =
            UserProvider(repo: repo1, psValueHolder: valueHolder);
        // provider.postUserRegister(userRegisterParameterHolder.toMap());
        return provider;
      },
      child: Consumer<UserProvider>(
          builder: (BuildContext context, UserProvider provider, Widget child) {
        return SingleChildScrollView(
            child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
                color:
                    Utils.isLightMode(context) ? Colors.white : Colors.black54,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      _dividerWidget,
                      _HeaderTextWidget(userProvider: provider),
                      _TextFieldAndButtonWidget(
                        provider: provider,
                        onProfileSelected: widget.onProfileSelected,
                      ),
                      _greyLineWidget,
                      _ChangeEmailAndRecentCodeWidget(
                        provider: provider,
                        userEmailText: provider.psValueHolder.userIdToVerify,
                        onSignInSelected: widget.onSignInSelected,
                      ),
                    ],
                  ),
                )),
            //_imageInCenterWidget,
          ],
        ));
      }),
    );
  }
}

class _TextFieldAndButtonWidget extends StatefulWidget {
  const _TextFieldAndButtonWidget({
    @required this.provider,
    this.onProfileSelected,
    // @required this.userId,
  });
  final UserProvider provider;
  final Function onProfileSelected;
  // final String userId;

  @override
  __TextFieldAndButtonWidgetState createState() =>
      __TextFieldAndButtonWidgetState();
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

class __TextFieldAndButtonWidgetState extends State<_TextFieldAndButtonWidget> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController userIdTextField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: ps_space_76,
        ),
        TextField(
          textAlign: TextAlign.center,
          controller: codeController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: Utils.getString(
                context, 'email_verify__enter_verification_code'),
            hintStyle: Theme.of(context).textTheme.button.copyWith(),
          ),
          style: Theme.of(context).textTheme.subtitle1.copyWith(),
        ),
        const SizedBox(
          height: ps_space_8,
        ),
        Container(
          margin: const EdgeInsets.only(left: ps_space_16, right: ps_space_16),
          child: MaterialButton(
            color: ps_ctheme__color_speical,
            height: 40,
            minWidth: double.infinity,
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7.0)),
            ),
            onPressed: () async {
              if (codeController.text.isEmpty) {
                callWarningDialog(context,
                    Utils.getString(context, 'warning_dialog__code_require'));
              } else {
                if (await utilsCheckInternetConnectivity()) {
                  final EmailVerifyParameterHolder emailVerifyParameterHolder =
                      EmailVerifyParameterHolder(
                    userId: widget.provider.psValueHolder.userIdToVerify,
                    code: codeController.text,
                  );

                  final PsResource<User> _apiStatus = await widget.provider
                      .postUserEmailVerify(emailVerifyParameterHolder.toMap());

                  if (_apiStatus.data != null) {
                    widget.provider.replaceVerifyUserData('', '', '', '');
                    widget.provider.replaceLoginUserId(_apiStatus.data.userId);

                    if (widget.onProfileSelected != null) {
                      await widget.provider
                          .replaceVerifyUserData('', '', '', '');
                      await widget.provider
                          .replaceLoginUserId(_apiStatus.data.userId);
                      await widget.onProfileSelected(_apiStatus.data.userId);
                    } else {
                      Navigator.pop(context, _apiStatus.data);
                    }
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
                        Utils.getString(context, 'email_verify__submit'),
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
        )
      ],
    );
  }
}

class _HeaderTextWidget extends StatelessWidget {
  const _HeaderTextWidget({@required this.userProvider});
  final UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ps_space_200,
      width: double.infinity,
      child: Stack(children: <Widget>[
        Container(
            color: ps_ctheme__color_speical,
            padding:
                const EdgeInsets.only(left: ps_space_16, right: ps_space_16),
            height: ps_space_160,
            width: double.infinity,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: ps_space_28,
                ),
                Text(
                  Utils.getString(context, 'email_verify__title1'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: ps_wtheme_white_color),
                ),
                Text(
                  (userProvider.psValueHolder.userEmailToVerify == null)
                      ? ''
                      : userProvider.psValueHolder.userEmailToVerify,
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: ps_wtheme_white_color),
                ),
              ],
            )),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 90,
            height: 90,
            child: const CircleAvatar(
              backgroundImage:
                  ExactAssetImage('assets/images/verify_email_icon.jpg'),
            ),
          ),
        )
      ]),
    );
  }
}

class _ChangeEmailAndRecentCodeWidget extends StatefulWidget {
  const _ChangeEmailAndRecentCodeWidget({
    @required this.provider,
    @required this.userEmailText,
    this.onSignInSelected,
  });
  final UserProvider provider;
  final String userEmailText;
  final Function onSignInSelected;

  @override
  __ChangeEmailAndRecentCodeWidgetState createState() =>
      __ChangeEmailAndRecentCodeWidgetState();
}

class __ChangeEmailAndRecentCodeWidgetState
    extends State<_ChangeEmailAndRecentCodeWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        MaterialButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          height: 40,
          child: Text(Utils.getString(context, 'email_verify__change_email')),
          textColor: ps_ctheme__color_speical,
          onPressed: () {
            if (widget.onSignInSelected != null) {
              widget.onSignInSelected();
            } else {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(
                context,
                RoutePaths.user_register_container,
              );
            }
          },
          // Material(
          //   child: InkWell(
          //     child: Text(
          //       'Change Email',
          //       style: Theme.of(context)
          //           .textTheme
          //           .button
          //           .copyWith(color: Colors.deepOrange),
          //     ),
          //     onTap: () {
        ),

        MaterialButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          height: 40,
          child: Text(Utils.getString(context, 'email_verify__resent_code')),
          textColor: ps_ctheme__color_speical,
          onPressed: () async {
            if (await utilsCheckInternetConnectivity()) {
              final ResendCodeParameterHolder resendCodeParameterHolder =
                  ResendCodeParameterHolder(
                userEmail: widget.provider.psValueHolder.userEmailToVerify,
              );

              final PsResource<ApiStatus> _apiStatus = await widget.provider
                  .postResendCode(resendCodeParameterHolder.toMap());

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
          },
        ),
        // Material(
        //   child: Container(
        //     height: ps_space_20,
        //     color: Colors.white,
        //     child: InkWell(
        //       child: Text(
        //         'Resent Code',
        //         style: Theme.of(context)
        //             .textTheme
        //             .button
        //             .copyWith(color: Colors.deepOrange),
        //       ),
        //       onTap: () async {

        //       },
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
