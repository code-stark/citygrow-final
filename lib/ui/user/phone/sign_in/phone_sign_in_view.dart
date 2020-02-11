import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/config/ps_config.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/provider/user/user_provider.dart';
import 'package:digitalproductstore/repository/user_repository.dart';
import 'package:digitalproductstore/ui/common/dialog/error_dialog.dart';
import 'package:digitalproductstore/ui/common/dialog/warning_dialog_view.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/holder/intent_holder/verify_phone_internt_holder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhoneSignInView extends StatefulWidget {
  const PhoneSignInView(
      {Key key,
      this.animationController,
      this.goToLoginSelected,
      this.phoneSignInSelected})
      : super(key: key);
  final AnimationController animationController;
  final Function goToLoginSelected;
  final Function phoneSignInSelected;
  @override
  _PhoneSignInViewState createState() => _PhoneSignInViewState();
}

class _PhoneSignInViewState extends State<PhoneSignInView>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
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
                                  nameController: nameController,
                                  phoneController: phoneController,
                                ),
                                const SizedBox(
                                  height: ps_space_8,
                                ),
                                _SendButtonWidget(
                                  provider: provider,
                                  nameController: nameController,
                                  phoneController: phoneController,
                                  phoneSignInSelected:
                                      widget.phoneSignInSelected,
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
        Utils.getString(context, 'phone_signin__back_login'),
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
  const _CardWidget(
      {@required this.nameController, @required this.phoneController});

  final TextEditingController nameController;
  final TextEditingController phoneController;
  @override
  Widget build(BuildContext context) {
    const EdgeInsets _marginEdgeInsetsforCard = EdgeInsets.only(
        left: ps_space_16,
        right: ps_space_16,
        top: ps_space_4,
        bottom: ps_space_4);
    return Card(
      elevation: 0.3,
      margin: const EdgeInsets.only(left: ps_space_32, right: ps_space_32),
      child: Column(
        children: <Widget>[
          Container(
            margin: _marginEdgeInsetsforCard,
            child: TextField(
              controller: nameController,
              style: Theme.of(context).textTheme.body1.copyWith(),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Utils.getString(context, 'register__user_name'),
                  hintStyle: Theme.of(context).textTheme.body1.copyWith(),
                  icon: Icon(Icons.people,
                      color: Theme.of(context).iconTheme.color)),
            ),
          ),
          const Divider(
            height: ps_space_1,
          ),
          Container(
            margin: _marginEdgeInsetsforCard,
            child: TextField(
              controller: phoneController,
              style: Theme.of(context).textTheme.button.copyWith(),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '+959123456789',
                  hintStyle: Theme.of(context).textTheme.button.copyWith(),
                  icon: Icon(Icons.phone,
                      color: Theme.of(context).iconTheme.color)),
              // keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }
}

class _SendButtonWidget extends StatefulWidget {
  const _SendButtonWidget(
      {@required this.provider,
      @required this.nameController,
      @required this.phoneController,
      @required this.phoneSignInSelected});
  final UserProvider provider;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final Function phoneSignInSelected;

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
  Future<String> verifyPhone() async {
    String verificationId;
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      verificationId = verId;
    };
    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      verificationId = verId;
      print('code has been send');

      if (widget.phoneSignInSelected != null) {
        widget.phoneSignInSelected(widget.nameController.text,
            widget.phoneController.text, verificationId);
      } else {
        Navigator.pushReplacementNamed(
            context, RoutePaths.user_phone_verify_container,
            arguments: VerifyPhoneIntentHolder(
                userName: widget.nameController.text,
                phoneNumber: widget.phoneController.text,
                phoneId: verificationId));
      }
    };
    final PhoneVerificationCompleted verifySuccess = (AuthCredential user) {
      print('verify');
    };
    final PhoneVerificationFailed verifyFail = (AuthException exception) {
      print('${exception.message}');
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: '${exception.message}',
            );
          });
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phoneController.text,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifySuccess,
        verificationFailed: verifyFail);
    return verificationId;
  }

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
            if (widget.nameController.text.isEmpty) {
              callWarningDialog(context,
                  Utils.getString(context, 'warning_dialog__input_name'));
            } else if (widget.phoneController.text.isEmpty) {
              callWarningDialog(context,
                  Utils.getString(context, 'warning_dialog__input_phone'));
            } else {
              await verifyPhone();
            }
          },
          child: Text(
            Utils.getString(context, 'login__phone_signin'),
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(color: Colors.white),
          )),
    );
  }
}
