import 'package:digitalproductstore/api/common/ps_resource.dart';
import 'package:digitalproductstore/config/ps_colors.dart';

import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/provider/user/user_provider.dart';
import 'package:digitalproductstore/repository/user_repository.dart';
import 'package:digitalproductstore/ui/common/base/ps_widget_with_appbar.dart';
import 'package:digitalproductstore/ui/common/dialog/error_dialog.dart';
import 'package:digitalproductstore/ui/common/dialog/success_dialog.dart';
import 'package:digitalproductstore/ui/common/ps_textfield_widget.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/api_status.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/holder/change_password_holder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordView extends StatefulWidget {
  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  UserRepository userRepo;
  PsValueHolder psValueHolder;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    userRepo = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    const Widget _largeSpacingWidget = SizedBox(
      height: ps_space_8,
    );
    return PsWidgetWithAppBar<UserProvider>(
        appBarTitle: Utils.getString(context, 'change_password__title') ?? '',
        initProvider: () {
          return UserProvider(repo: userRepo, psValueHolder: psValueHolder);
        },
        onProviderReady: (UserProvider provider) {
          return provider;
        },
        builder: (BuildContext context, UserProvider provider, Widget child) {
          return SingleChildScrollView(
              child: Container(
            padding: const EdgeInsets.all(ps_space_16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PsTextFieldWidget(
                    titleText:
                        Utils.getString(context, 'change_password__password'),
                    textAboutMe: false,
                    hintText:
                        Utils.getString(context, 'change_password__password'),
                    textEditingController: passwordController),
                PsTextFieldWidget(
                    titleText: Utils.getString(
                        context, 'change_password__confirm_password'),
                    textAboutMe: false,
                    hintText: Utils.getString(
                        context, 'change_password__confirm_password'),
                    textEditingController: confirmPasswordController),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: PsButtonWidget(
                    provider: provider,
                    passwordController: passwordController,
                    confirmPasswordController: confirmPasswordController,
                  ),
                ),
                _largeSpacingWidget,
              ],
            ),
          ));
        });
  }
}

class PsButtonWidget extends StatelessWidget {
  const PsButtonWidget({
    @required this.passwordController,
    @required this.confirmPasswordController,
    @required this.provider,
  });

  final TextEditingController passwordController, confirmPasswordController;
  final UserProvider provider;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        color: ps_ctheme__color_speical,
        textColor: Colors.white,
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: provider != null
            ? provider.isLoading
                ? Text(
                    Utils.getString(context, 'login__loading'),
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: Colors.white),
                  )
                : Text(
                    Utils.getString(context, 'change_password__save'),
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
        onPressed: () async {
          if (passwordController.text != '' &&
              confirmPasswordController.text != '') {
            if (passwordController.text == confirmPasswordController.text) {
              if (await utilsCheckInternetConnectivity()) {
                final ChangePasswordParameterHolder contactUsParameterHolder =
                    ChangePasswordParameterHolder(
                        userId: provider.psValueHolder.loginUserId,
                        userPassword: passwordController.text);

                final PsResource<ApiStatus> _apiStatus = await provider
                    .postChangePassword(contactUsParameterHolder.toMap());

                if (_apiStatus.data != null) {
                  passwordController.clear();
                  confirmPasswordController.clear();

                  showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return SuccessDialog(
                          message: _apiStatus.data.status,
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
                        message: Utils.getString(
                            context, 'error_dialog__no_internet'),
                      );
                    });
              }
            } else {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      message: Utils.getString(
                          context, 'change_password__not_equal'),
                    );
                  });
            }
          } else {
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  return ErrorDialog(
                    message: Utils.getString(context, 'change_password__error'),
                  );
                });
          }
        });
  }
}
