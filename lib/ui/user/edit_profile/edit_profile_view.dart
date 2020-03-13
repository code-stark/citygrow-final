import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalproductstore/api/common/ps_resource.dart';
import 'package:digitalproductstore/config/ps_colors.dart';

import 'package:digitalproductstore/config/ps_config.dart';
import 'package:digitalproductstore/config/ps_constants.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/model/user_model.dart';
import 'package:digitalproductstore/provider/user/user_provider.dart';
import 'package:digitalproductstore/repository/user_repository.dart';
import 'package:digitalproductstore/ui/common/base/ps_widget_with_appbar.dart';
import 'package:digitalproductstore/ui/common/ps_textfield_widget.dart';
import 'package:digitalproductstore/ui/common/ps_ui_widget.dart';
import 'package:digitalproductstore/ui/common/dialog/error_dialog.dart';
import 'package:digitalproductstore/ui/common/dialog/loading_dialog.dart';
import 'package:digitalproductstore/ui/common/dialog/success_dialog.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/holder/profile_update_view_holder.dart';
import 'package:digitalproductstore/viewobject/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfileView extends StatefulWidget { final DocumentSnapshot snapshot;

  const EditProfileView({Key key, @required this.snapshot}) : super(key: key);

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView>
    with SingleTickerProviderStateMixin {
  UserRepository userRepository;
  UserProvider userProvider;
  PsValueHolder psValueHolder;
  AnimationController animationController;
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController aboutMeController = TextEditingController();
  bool bindDataFirstTime = true;
 
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
    userRepository = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }
    final Users users = Provider.of<Users>(context);

    return WillPopScope(
        onWillPop: _requestPop,
        child: PsWidgetWithAppBar<UserProvider>(
            appBarTitle: Utils.getString(context, 'edit_profile__title') ?? '',
            initProvider: () {
              return UserProvider(
                  repo: userRepository, psValueHolder: psValueHolder);
            },
            onProviderReady: (UserProvider provider) async {
              await provider.getUserFromDB(provider.psValueHolder.loginUserId);
              userProvider = provider;
            },
            builder:
                (BuildContext context, UserProvider provider, Widget child) {
              if (users != null && users.uid != null) {
                // if (bindDataFirstTime) {
                //   userNameController.text = provider.user.data.userName;
                //   emailController.text = provider.user.data.userEmail;
                //   phoneController.text = provider.user.data.userPhone;
                //   aboutMeController.text = provider.user.data.userAboutMe;
                //   bindDataFirstTime = false;
                // }

                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _ImageWidget(userProvider: provider,snapshot: widget.snapshot,),
                      _UserFirstCardWidget(
                        userProvider: provider,
                        userNameController: userNameController,
                        emailController: emailController,
                        phoneController: phoneController,
                        aboutMeController: aboutMeController,
                      ),
                      const SizedBox(
                        height: ps_space_8,
                      ),
                      _TwoButtonWidget(
                        userProvider: provider,
                        userNameController: userNameController,
                        emailController: emailController,
                        phoneController: phoneController,
                        aboutMeController: aboutMeController,
                      ),
                      const SizedBox(
                        height: ps_space_20,
                      )
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }));
  }
}

class _TwoButtonWidget extends StatelessWidget {
  const _TwoButtonWidget(
      {@required this.userProvider,
      @required this.userNameController,
      @required this.emailController,
      @required this.phoneController,
      @required this.aboutMeController});

  final TextEditingController userNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController aboutMeController;
  final UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: ps_space_12, right: ps_space_12),
          child: MaterialButton(
            color: ps_ctheme__color_speical,
            height: 45,
            minWidth: double.infinity,
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7.0)),
            ),
            child: Text(Utils.getString(context, 'edit_profile__save'),
                style: const TextStyle(color: Colors.white)),
            onPressed: () async {
              if (userNameController.text == '') {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        message: Utils.getString(
                            context, 'edit_profile__name_error'),
                      );
                    });
              } else if (emailController.text == '') {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        message: Utils.getString(
                            context, 'edit_profile__email_error'),
                      );
                    });
              } else {
                if (await utilsCheckInternetConnectivity()) {
                  final ProfileUpdateParameterHolder
                      profileUpdateParameterHolder =
                      ProfileUpdateParameterHolder(
                    userId: userProvider.psValueHolder.loginUserId,
                    userName: userNameController.text,
                    userEmail: emailController.text,
                    userPhone: phoneController.text,
                    userAboutMe: aboutMeController.text,
                    billingFirstName: '',
                    billingLastName: '',
                    billingCompany: '',
                    billingAddress1: '',
                    billingAddress2: '',
                    billingCountry: '',
                    billingState: '',
                    billingCity: '',
                    billingPostalCode: '',
                    billingEmail: '',
                    billingPhone: '',
                    shippingFirstName: '',
                    shippingLastName: '',
                    shippingCompany: '',
                    shippingAddress1: '',
                    shippingAddress2: '',
                    shippingCountry: '',
                    shippingState: '',
                    shippingCity: '',
                    shippingPostalCode: '',
                    shippingEmail: '',
                    shippingPhone: '',
                  );
                  final ProgressDialog progressDialog = loadingDialog(context);
                  progressDialog.show();
                  final PsResource<User> _apiStatus = await userProvider
                      .postProfileUpdate(profileUpdateParameterHolder.toMap());
                  if (_apiStatus.data != null) {
                    progressDialog.dismiss();

                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext contet) {
                          return SuccessDialog(
                            message: Utils.getString(
                                context, 'edit_profile__success'),
                          );
                        });
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
          ),
        ),
        const SizedBox(
          height: ps_space_12,
        ),
        Container(
          margin: const EdgeInsets.only(
              left: ps_space_12, right: ps_space_12, bottom: ps_space_20),
          child: MaterialButton(
            color: ps_ctheme__color_speical,
            height: 45,
            minWidth: double.infinity,
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7.0)),
            ),
            child: Text(
                Utils.getString(context, 'edit_profile__password_change'),
                style: const TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pushNamed(
                context,
                RoutePaths.user_update_password,
              );
            },
          ),
        )
      ],
    );
  }
}

class _ImageWidget extends StatefulWidget {
  const _ImageWidget({this.userProvider,@required this.snapshot});
  final UserProvider userProvider;
final DocumentSnapshot snapshot;
  @override
  __ImageWidgetState createState() => __ImageWidgetState();
}

File pickedImage;

class __ImageWidgetState extends State<_ImageWidget> {
  Future<bool> requestGalleryPermission() async {
    final Map<PermissionGroup, PermissionStatus> permissionss =
        await PermissionHandler()
            .requestPermissions(<PermissionGroup>[PermissionGroup.photos]);
    if (permissionss != null &&
        permissionss.isNotEmpty &&
        permissionss[PermissionGroup.photos] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic _pickImage() async {
      final ImageSource imageSource = await showDialog<ImageSource>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text(
                    Utils.getString(context, 'edit_profile__select_image')),
                actions: <Widget>[
                  // MaterialButton(
                  //   child: const Text('Camera'),
                  //   onPressed: () => Navigator.pop(context, ImageSource.camera),
                  // ),
                  MaterialButton(
                    child:
                        Text(Utils.getString(context, 'edit_profile__gallery')),
                    onPressed: () =>
                        Navigator.pop(context, ImageSource.gallery),
                  )
                ],
              ));

      if (imageSource != null) {
        if (ImagePicker != null &&
            ImagePicker.pickImage != null &&
            imageSource == ImageSource.gallery) {
          final File file = await ImagePicker.pickImage(source: imageSource);
          if (file != null) {
            final ProgressDialog pr = loadingDialog(context);
            pr.show();
            final PsResource<User> _apiStatus = await widget.userProvider
                .postImageUpload(widget.userProvider.psValueHolder.loginUserId,
                    PLATFORM, file);

            if (_apiStatus.data != null) {
              pr.dismiss();
              pr.hide();
              setState(() {
                pickedImage = file;
              });
            }
          }
        } else {
          pickedImage = File(''); //for not select any image from gallery

          if (pr != null) {
            pr.dismiss();
            pr.hide();
          }
        }
      }
    }
final Users users = Provider.of<Users>(context);
    final Widget _imageWidget = PsNetworkImageWithUrl(
      photoKey: '',
      url: widget.snapshot['ProfileImage'] ??
            users.imageUrl ??
            'https://www.searchpng.com/wp-content/uploads/2019/02/Profile-PNG-Icon-715x715.png',
      width: double.infinity,
      height: ps_space_200,
      boxfit: BoxFit.cover,
      onTap: () {},
    );

    final Widget _editWidget = Container(
      child: IconButton(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: ps_space_2),
        iconSize: ps_space_24,
        icon: Icon(
          Icons.edit,
          color: Theme.of(context).iconTheme.color,
        ),
        onPressed: () async {
          if (await utilsCheckInternetConnectivity()) {
            requestGalleryPermission().then((bool status) async {
              if (status) {
                _pickImage();
              }
            });
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
      width: ps_space_32,
      height: ps_space_32,
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.red),
        color: Utils.isLightMode(context) ? Colors.white : Colors.black54,
        borderRadius: BorderRadius.circular(ps_space_28),
      ),
    );

    final Widget _imageInCenterWidget = Positioned(
        top: 110,
        child: Stack(
          children: <Widget>[
            Container(
                width: 90,
                height: 90,
                child: CircleAvatar(
                  child: PsNetworkCircleImage(
                    photoKey: '',
                    url: widget.snapshot['ProfileImage'] ??
            users.imageUrl ??
            'https://www.searchpng.com/wp-content/uploads/2019/02/Profile-PNG-Icon-715x715.png',
                    width: double.infinity,
                    height: ps_space_200,
                    boxfit: BoxFit.cover,
                    onTap: () async {
                      if (await utilsCheckInternetConnectivity()) {
                        requestGalleryPermission().then((bool status) async {
                          if (status) {
                            _pickImage();
                          }
                        });
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
                    },
                  ),
                )),
            Positioned(
              top: 1,
              right: 1,
              child: _editWidget,
            ),
          ],
        ));
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: ps_space_160,
          child: _imageWidget,
        ),
        Container(
          color: Colors.white54,
          width: double.infinity,
          height: ps_space_160,
        ),
        Container(
          // color: Colors.white38,
          width: double.infinity,
          height: ps_space_220,
        ),
        _imageInCenterWidget,
      ],
    );
  }
}

class _UserFirstCardWidget extends StatelessWidget {
  const _UserFirstCardWidget(
      {@required this.userProvider,
      @required this.userNameController,
      @required this.emailController,
      @required this.phoneController,
      @required this.aboutMeController});
  final UserProvider userProvider;
  final TextEditingController userNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController aboutMeController;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.3,
      margin: const EdgeInsets.only(
          left: ps_space_12,
          right: ps_space_12,
          top: ps_space_8,
          bottom: ps_space_8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: ps_space_16,
          ),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__user_name'),
              hintText: Utils.getString(context, 'edit_profile__user_name'),
              textAboutMe: false,
              phoneInputType: false,
              textEditingController: userNameController),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__email'),
              hintText: Utils.getString(context, 'edit_profile__email'),
              textAboutMe: false,
              phoneInputType: false,
              textEditingController: emailController),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__phone'),
              textAboutMe: false,
              phoneInputType: true,
              hintText: Utils.getString(context, 'edit_profile__phone'),
              textEditingController: phoneController),
          PsTextFieldWidget(
              titleText: Utils.getString(context, 'edit_profile__about_me'),
              height: ps_space_120,
              keyboardType: TextInputType.multiline,
              textAboutMe: true,
              phoneInputType: false,
              hintText: Utils.getString(context, 'edit_profile__about_me'),
              textEditingController: aboutMeController),
        ],
      ),
    );
  }
}
