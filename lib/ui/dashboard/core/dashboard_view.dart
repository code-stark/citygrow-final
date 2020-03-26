import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalproductstore/config/ps_config.dart';
import 'package:digitalproductstore/config/ps_constants.dart';
import 'package:digitalproductstore/config/ps_dimens.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/model/user_model.dart';
import 'package:digitalproductstore/provider/basket/basket_provider.dart';
import 'package:digitalproductstore/provider/shop_info/shop_info_provider.dart';
import 'package:digitalproductstore/provider/user/user_provider.dart';
import 'package:digitalproductstore/repository/basket_repository.dart';
import 'package:digitalproductstore/repository/product_repository.dart';
import 'package:digitalproductstore/repository/shop_info_repository.dart';
import 'package:digitalproductstore/repository/user_repository.dart';
import 'package:digitalproductstore/ui/basket/list/basket_list_view.dart';
import 'package:digitalproductstore/ui/blog/list/blog_list_view.dart';
import 'package:digitalproductstore/ui/category/list/category_list_view.dart';
import 'package:digitalproductstore/ui/collection/header_list/collection_header_list_view.dart';
import 'package:digitalproductstore/ui/contact/contact_us_view.dart';
import 'package:digitalproductstore/ui/common/dialog/confirm_dialog_view.dart';
import 'package:digitalproductstore/ui/common/dialog/noti_dialog.dart';
import 'package:digitalproductstore/ui/dashboard/home/home_dashboard_view.dart';
import 'package:digitalproductstore/ui/history/list/history_list_view.dart';
import 'package:digitalproductstore/ui/language/setting/language_setting_view.dart';
import 'package:digitalproductstore/ui/product/favourite/favourite_product_list_view.dart';
import 'package:digitalproductstore/ui/product/list_with_filter/product_list_with_filter_container.dart';
import 'package:digitalproductstore/ui/product/list_with_filter/product_list_with_filter_view.dart';
import 'package:digitalproductstore/ui/product/purchase_product/purchase_product_grid_view.dart';
import 'package:digitalproductstore/ui/search/home_item_search_view.dart';
import 'package:digitalproductstore/ui/shop/shop_info_view.dart';
import 'package:digitalproductstore/ui/transaction/list/transaction_list_view.dart';
import 'package:digitalproductstore/ui/setting/setting_view.dart';
import 'package:digitalproductstore/ui/user/forgot_password/forgot_password_view.dart';
import 'package:digitalproductstore/ui/user/login/login_view.dart';
import 'package:digitalproductstore/ui/user/phone/sign_in/phone_sign_in_view.dart';
import 'package:digitalproductstore/ui/user/phone/verify_phone/verify_phone_view.dart';
import 'package:digitalproductstore/ui/user/profile/profile_view.dart';
import 'package:digitalproductstore/ui/user/register/register_view.dart';
import 'package:digitalproductstore/ui/user/verify/verify_email_view.dart';
import 'package:digitalproductstore/viewobject/common/ps_value_holder.dart';
import 'package:digitalproductstore/viewobject/holder/product_parameter_holder.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:digitalproductstore/config/ps_colors.dart';
import 'package:digitalproductstore/utils/utils.dart';

class DashboardView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<DashboardView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  AnimationController animationController;

  Animation<double> animation;
  BasketRepository basketRepository;

  String appBarTitle = 'Home';
  int _currentIndex = REQUEST_CODE__MENU_HOME_FRAGMENT;
  String _userId = '';
  bool isLogout = false;
  bool isFirstTime = true;
  String phoneUserName = '';
  String phoneNumber = '';
  String phoneId = '';

  final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();
  ShopInfoProvider shopInfoProvider;

  @override
  void initState() {
    animationController = AnimationController(
        duration: animation_duration, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  int getBottonNavigationIndex(int param) {
    int index = 0;
    switch (param) {
      case REQUEST_CODE__MENU_HOME_FRAGMENT:
        index = 0;
        break;
      case REQUEST_CODE__DASHBOARD_SHOP_INFO_FRAGMENT:
        index = 1;
        break;
      case REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT:
        index = 2;
        break;
      case REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT:
        index = 2;
        break;
      case REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT:
        index = 2;
        break;
      case REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT:
        index = 2;
        break;
      case REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT:
        index = 2;
        break;
      case REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT:
        index = 2;
        break;
      case REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT:
        index = 2;
        break;
      case REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT:
        index = 2;
        break;
      case REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT:
        index = 3;
        break;
      case REQUEST_CODE__DASHBOARD_BASKET_FRAGMENT:
        index = 4;
        break;
      default:
        index = 0;
        break;
    }
    return index;
  }

  dynamic getIndexFromBottonNavigationIndex(int param) {
    final Users users = Provider.of<Users>(context);
    int index = REQUEST_CODE__MENU_HOME_FRAGMENT;
    String title;
    final PsValueHolder psValueHolder =
        Provider.of<PsValueHolder>(context);
    switch (param) {
      case 0:
        index = REQUEST_CODE__MENU_HOME_FRAGMENT;
        title = Utils.getString(context,
            'app_name'); //Utils.getString(context, 'dashboard__home');
        break;
      case 1:
        index = REQUEST_CODE__DASHBOARD_SHOP_INFO_FRAGMENT;
        title = Utils.getString(
            context, 'home__bottom_app_bar_shop_info');
        break;
      case 2:
        index = REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT;
        title = (users != null ||
                users.uid != null ||
                users.uid != '')
            ? Utils.getString(context, 'home__bottom_app_bar_login')
            : Utils.getString(
                context, 'home__bottom_app_bar_verify_email');
        break;
      case 3:
        index = REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT;
        title =
            Utils.getString(context, 'home__bottom_app_bar_search');
        break;
      case 4:
        index = REQUEST_CODE__DASHBOARD_BASKET_FRAGMENT;
        title = Utils.getString(
            context, 'home__bottom_app_bar_basket_list');
        break;
      default:
        index = 0;
        title = Utils.getString(context,
            'app_name'); //Utils.getString(context, 'dashboard__home');
        break;
    }
    return <dynamic>[title, index];
  }

  ShopInfoRepository shopInfoRepository;
  UserRepository userRepository;
  ProductRepository productRepository;
  PsValueHolder valueHolder;
  @override
  Widget build(BuildContext context) {
    shopInfoRepository = Provider.of<ShopInfoRepository>(context);
    userRepository = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);
    productRepository =
        Provider.of<ProductRepository>(context); // later check
    basketRepository = Provider.of<BasketRepository>(context);
    final dynamic data = EasyLocalizationProvider.of(context).data;

    timeDilation = 1.0;

    if (isFirstTime) {
      appBarTitle = Utils.getString(context,
          'app_name'); //Utils.getString(context, 'dashboard__home');
      isFirstTime = false;
    }

    Future<void> updateSelectedIndexWithAnimation(
        String title, int index) async {
      await animationController.reverse().then<dynamic>((void data) {
        if (!mounted) {
          return;
        }

        setState(() {
          appBarTitle = title;
          _currentIndex = index;
        });
      });
    }

    Future<bool> _onWillPop() {
      return showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ConfirmDialogView(
                    description: Utils.getString(
                        context, 'home__quit_dialog_description'),
                    leftButtonText: Utils.getString(
                        context, 'app_info__cancel_button_name'),
                    rightButtonText:
                        Utils.getString(context, 'dialog__ok'),
                    onAgreeTap: () {
                      SystemNavigator.pop();
                    });
              }) ??
          false;
    }

    final Animation<double> animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.5 * 1, 1.0,
                curve: Curves.fastOutSlowIn)));
    final Users user = Provider.of<Users>(context);
    return EasyLocalizationProvider(
      data: data,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          key: scaffoldKey,
          drawer: Drawer(
            child: ChangeNotifierProvider<UserProvider>(
              create: (BuildContext context) {
                return UserProvider(
                    repo: userRepository, psValueHolder: valueHolder);
              },
              child: Consumer<UserProvider>(
                builder: (BuildContext context, UserProvider provider,
                    Widget child) {
                  print(provider.psValueHolder.loginUserId);
                  return ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        _DrawerHeaderWidget(),
                        ListTile(
                          title: Text(Utils.getString(
                              context, 'home__drawer_menu_home')),
                        ),
                        _DrawerMenuWidget(
                            icon: Icons.store,
                            title: Utils.getString(
                                context, 'home__drawer_menu_home'),
                            index: REQUEST_CODE__MENU_HOME_FRAGMENT,
                            onTap: (String title, int index) {
                              Navigator.pop(context);
                              updateSelectedIndexWithAnimation(
                                  Utils.getString(
                                      context, 'app_name'),
                                  index);
                            }),
                        StreamBuilder<QuerySnapshot>(
                            stream: Firestore.instance
                                .collection('ProductListID')
                                .where('ProductReview',
                                    isEqualTo: true)
                                .where('Featured Product',
                                    isEqualTo: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return _DrawerMenuWidget(
                                  icon: Icons.category,
                                  title: Utils.getString(context,
                                      'home__drawer_menu_category'),
                                  index:
                                      REQUEST_CODE__MENU_CATEGORY_FRAGMENT,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext
                                                    context) =>
                                                ProductListWithFilterContainerView(
                                                    productParameterHolder:
                                                        ProductParameterHolder()
                                                            .getLatestParameterHolder(),
                                                    appBarTitle: Utils
                                                        .getString(
                                                            context,
                                                            'dashboard__feature_product'),
                                                    productList: snapshot
                                                        .data
                                                        .documents)));
                                  });
                            }),
                        _DrawerMenuWidget(
                            icon: Icons.schedule,
                            title: Utils.getString(context,
                                'home__drawer_menu_latest_product'),
                            index:
                                REQUEST_CODE__MENU_LATEST_PRODUCT_FRAGMENT,
                            onTap: (String title, int index) {
                              Navigator.pop(context);
                              updateSelectedIndexWithAnimation(
                                  title, index);
                            }),
                        _DrawerMenuWidget(
                            icon: Feather.percent,
                            title: Utils.getString(context,
                                'home__drawer_menu_discount_product'),
                            index:
                                REQUEST_CODE__MENU_DISCOUNT_PRODUCT_FRAGMENT,
                            onTap: (String title, int index) {
                              Navigator.pop(context);
                              updateSelectedIndexWithAnimation(
                                  title, index);
                            }),
                        // _DrawerMenuWidget(
                        //     icon: Icons.trending_up,
                        //     title: Utils.getString(
                        //         context, 'home__drawer_menu_trending_product'),
                        //     index: REQUEST_CODE__MENU_TRENDING_PRODUCT_FRAGMENT,
                        //     onTap: (String title, int index) {
                        //       Navigator.pop(context);
                        //       updateSelectedIndexWithAnimation(title, index);
                        //     }),
                        // _DrawerMenuWidget(
                        //     icon: Feather.book_open,
                        //     title:
                        //         Utils.getString(context, 'home__menu_drawer_blog'),
                        //     index: REQUEST_CODE__MENU_BLOG_FRAGMENT, //17
                        //     onTap: (String title, int index) {
                        //       Navigator.pop(context);
                        //       updateSelectedIndexWithAnimation(title, index);
                        //     }),
                        // _DrawerMenuWidget(
                        //     icon: Icons.folder_open,
                        //     title: Utils.getString(
                        //         context, 'home__menu_drawer_collection'),
                        //     index: REQUEST_CODE__MENU_COLLECTION_FRAGMENT,
                        //     onTap: (String title, int index) {
                        //       Navigator.pop(context);
                        //       updateSelectedIndexWithAnimation(title, index);
                        //     }),
                        const Divider(
                          height: ps_space_1,
                        ),
                        ListTile(
                          title: Text(Utils.getString(context,
                              'home__menu_drawer_user_info')),
                        ),
                        // TODO(Profile LogoOut): Profile LogoOut
                        _DrawerMenuWidget(
                            icon: Icons.person,
                            title: Utils.getString(
                                context, 'home__menu_drawer_profile'),
                            index:
                                REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT,
                            onTap: (String title, int index) {
                              Navigator.pop(context);
                              title = (user != null ||
                                      user.uid != null ||
                                      user.uid != '')
                                  ? Utils.getString(context,
                                      'home__menu_drawer_profile')
                                  : Utils.getString(context,
                                      'home__bottom_app_bar_verify_email');
                              updateSelectedIndexWithAnimation(
                                  title, index);
                            }),
                        if (user != null)
                          if (user.uid != null && user.uid != '')
                            Visibility(
                              visible: true,
                              child: _DrawerMenuWidget(
                                  icon: Icons.favorite_border,
                                  title: Utils.getString(context,
                                      'home__menu_drawer_favourite'),
                                  index:
                                      REQUEST_CODE__MENU_FAVOURITE_FRAGMENT,
                                  onTap: (String title, int index) {
                                    Navigator.pop(context);
                                    updateSelectedIndexWithAnimation(
                                        title, index);
                                  }),
                            ),
                        if (user.uid != null)
                          if (user.uid != null && user.uid != '')
                            Visibility(
                              visible: true,
                              child: _DrawerMenuWidget(
                                icon: Icons.swap_horiz,
                                title: Utils.getString(context,
                                    'home__menu_drawer_transaction'),
                                index:
                                    REQUEST_CODE__MENU_TRANSACTION_FRAGMENT,
                                onTap: (String title, int index) {
                                  Navigator.pop(context);
                                  updateSelectedIndexWithAnimation(
                                      title, index);
                                },
                              ),
                            ),
                        // if (user.uid != null)
                        //   if (user.uid != null && user.uid != '')
                        //     Visibility(
                        //       visible: true,
                        //       child: _DrawerMenuWidget(
                        //           icon: Icons.book,
                        //           title: Utils.getString(
                        //               context, 'home__menu_drawer_user_history'),
                        //           index:
                        //               REQUEST_CODE__MENU_USER_HISTORY_FRAGMENT, //14
                        //           onTap: (String title, int index) {
                        //             Navigator.pop(context);
                        //             updateSelectedIndexWithAnimation(title, index);
                        //           }),
                        //     ),
                        if (user.uid != null)
                          if (user.uid != null && user.uid != '')
                            Visibility(
                              visible: true,
                              child: _DrawerMenuWidget(
                                  icon: FontAwesome.product_hunt,
                                  title: Utils.getString(context,
                                      'home__menu_drawer_purchased_product'),
                                  index:
                                      REQUEST_CODE__MENU_PURCHASED_PRODUCT_FRAGMENT, //14
                                  onTap: (String title, int index) {
                                    Navigator.pop(context);
                                    updateSelectedIndexWithAnimation(
                                        title, index);
                                  }),
                            ),
                        if (user.uid != null)
                          if (user.uid != null && user.uid != '')
                            Visibility(
                              visible: true,
                              child: ListTile(
                                leading: Icon(
                                  Icons.power_settings_new,
                                  color: Utils.isLightMode(context)
                                      ? ps_ctheme__color_speical
                                      : Colors.white,
                                ),
                                title: Text(
                                  Utils.getString(context,
                                      'home__menu_drawer_logout'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1,
                                ),
                                onTap: () async {
                                  Navigator.pop(context);
                                  showDialog<dynamic>(
                                      context: context,
                                      builder:
                                          (BuildContext context) {
                                        return ConfirmDialogView(
                                            description: Utils.getString(
                                                context,
                                                'home__logout_dialog_description'),
                                            leftButtonText:
                                                Utils.getString(
                                                    context,
                                                    'home__logout_dialog_cancel_button'),
                                            rightButtonText:
                                                Utils.getString(
                                                    context,
                                                    'home__logout_dialog_ok_button'),
                                            onAgreeTap: () async {
                                              setState(() {
                                                _currentIndex =
                                                    REQUEST_CODE__MENU_HOME_FRAGMENT;
                                              });
                                              provider
                                                  .replaceLoginUserId(
                                                      '');

                                              await FacebookLogin()
                                                  .logOut();
                                              await GoogleSignIn()
                                                  .signOut();
                                              await FirebaseAuth
                                                  .instance
                                                  .signOut();
                                            });
                                      });
                                },
                              ),
                            ),
                        const Divider(
                          height: ps_space_1,
                        ),
                        ListTile(
                          title: Text(Utils.getString(
                              context, 'home__menu_drawer_app')),
                        ),
                        _DrawerMenuWidget(
                            icon: Icons.g_translate,
                            title: Utils.getString(context,
                                'home__menu_drawer_language'),
                            index:
                                REQUEST_CODE__MENU_LANGUAGE_FRAGMENT,
                            onTap: (String title, int index) {
                              Navigator.pop(context);
                              updateSelectedIndexWithAnimation(
                                  '', index);
                            }),
                        _DrawerMenuWidget(
                            icon: Icons.contacts,
                            title:
                                Utils.getString(context,
                                    'home__menu_drawer_contact_us'),
                            index:
                                REQUEST_CODE__MENU_CONTACT_US_FRAGMENT,
                            onTap: (String title, int index) {
                              Navigator.pop(context);
                              updateSelectedIndexWithAnimation(
                                  title, index);
                            }),
                        _DrawerMenuWidget(
                            icon: Icons.settings,
                            title: Utils.getString(
                                context, 'home__menu_drawer_setting'),
                            index:
                                REQUEST_CODE__MENU_SETTING_FRAGMENT,
                            onTap: (String title, int index) {
                              Navigator.pop(context);
                              updateSelectedIndexWithAnimation(
                                  title, index);
                            }),
                        ListTile(
                          leading: Icon(
                            Icons.star_border,
                            color: Utils.isLightMode(context)
                                ? ps_ctheme__color_speical
                                : Colors.white,
                          ),
                          title: Text(
                            Utils.getString(context,
                                'home__menu_drawer_rate_this_app'),
                            style:
                                Theme.of(context).textTheme.bodyText1,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            utilsLaunchURL();
                          },
                        )
                      ]);
                },
              ),
            ),
          ),
          appBar: AppBar(
            backgroundColor: (appBarTitle ==
                        Utils.getString(
                            context, 'home__verify_email') ||
                    appBarTitle ==
                        Utils.getString(context, 'home_verify_phone'))
                ? ps_ctheme__color_speical
                : Theme.of(context).appBarTheme.color,
            title: Text(
              appBarTitle,
              style: Theme.of(context).textTheme.title.copyWith(
                  fontWeight: FontWeight.bold,
                  color: (appBarTitle ==
                              Utils.getString(
                                  context, 'home__verify_email') ||
                          appBarTitle ==
                              Utils.getString(
                                  context, 'home_verify_phone'))
                      ? Colors.white
                      : Utils.isLightMode(context)
                          ? ps_ctheme__color_speical
                          : Colors
                              .white //Theme.of(context).appBarTheme.color,
                  ),
            ),
            titleSpacing: 0,
            elevation: 0,
            iconTheme: IconThemeData(
                color: (appBarTitle ==
                            Utils.getString(
                                context, 'home__verify_email') ||
                        appBarTitle ==
                            Utils.getString(
                                context, 'home_verify_phone'))
                    ? Colors.white
                    : Utils.isLightMode(context)
                        ? ps_ctheme__color_speical
                        : Colors.white),
            textTheme: Theme.of(context).textTheme,
            brightness: Utils.getBrightnessForAppBar(context),
            actions: <Widget>[
              // IconButton(
              //   icon: Icon(
              //     Icons.notifications_none,
              //     color: (appBarTitle ==
              //                 Utils.getString(context, 'home__verify_email') ||
              //             appBarTitle ==
              //                 Utils.getString(context, 'home_verify_phone'))
              //         ? Colors.white
              //         : Theme.of(context).iconTheme.color,
              //   ),
              //   onPressed: () {
              //     Navigator.pushNamed(
              //       context,
              //       RoutePaths.notiList,
              //     );
              //   },
              // ),
              // IconButton(
              //   icon: Icon(
              //     Feather.book_open,
              //     color: (appBarTitle ==
              //                 Utils.getString(context, 'home__verify_email') ||
              //             appBarTitle ==
              //                 Utils.getString(context, 'home_verify_phone'))
              //         ? Colors.white
              //         : Theme.of(context).iconTheme.color,
              //   ),
              //   onPressed: () {
              //     Navigator.pushNamed(
              //       context,
              //       RoutePaths.blogList,
              //     );
              //   },
              // ),
              ChangeNotifierProvider<BasketProvider>(
                  create: (BuildContext context) {
                final BasketProvider provider =
                    BasketProvider(repo: basketRepository);
                provider.loadBasketList();
                return provider;
              }, child: Consumer<BasketProvider>(builder:
                      (BuildContext context,
                          BasketProvider basketProvider,
                          Widget child) {
                final Users users = Provider.of<Users>(context);

                return StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('AppUsers')
                        .document(users.uid)
                        .collection('cart')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Stack(
                        children: <Widget>[
                          Container(
                            width: ps_space_40,
                            height: ps_space_40,
                            margin: const EdgeInsets.only(
                                top: ps_space_8,
                                left: ps_space_8,
                                right: ps_space_8),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black38,
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.shopping_basket,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          InkWell(
                              child: Container(
                                width: ps_space_40,
                                height: ps_space_40,
                                margin: const EdgeInsets.only(
                                    top: ps_space_8,
                                    left: ps_space_8,
                                    right: ps_space_8),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black54,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    snapshot.data.documents.length >
                                            99
                                        ? '99+'
                                        : snapshot
                                            .data.documents.length
                                            .toString(),
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline
                                        .copyWith(
                                            fontSize: ps_space_16,
                                            color: Colors.white),
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              onTap: () {
                                utilsNavigateOnUserVerificationView(
                                    context, () {
                                  Navigator.pushNamed(
                                    context,
                                    RoutePaths.basketList,
                                  );
                                });
                              }),
                        ],
                      );
                    });
              })),
            ],
          ),
          bottomNavigationBar: _currentIndex ==
                      REQUEST_CODE__MENU_HOME_FRAGMENT ||
                  _currentIndex ==
                      REQUEST_CODE__DASHBOARD_SHOP_INFO_FRAGMENT ||
                  _currentIndex ==
                      REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT ||
                  _currentIndex ==
                      REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT || //go to profile
                  _currentIndex ==
                      REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT || //go to forgot password
                  _currentIndex ==
                      REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT || //go to register
                  _currentIndex ==
                      REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT || //go to email verify
                  _currentIndex ==
                      REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT ||
                  _currentIndex ==
                      REQUEST_CODE__DASHBOARD_BASKET_FRAGMENT ||
                  _currentIndex ==
                      REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT ||
                  _currentIndex ==
                      REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT ||
                  _currentIndex ==
                      REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT
              ? Visibility(
                  visible: true,
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    currentIndex:
                        getBottonNavigationIndex(_currentIndex),
                    showUnselectedLabels: true,
                    backgroundColor: Utils.isLightMode(context)
                        ? Colors.white
                        : Colors.black87,
                    selectedItemColor: ps_ctheme__color_speical,
                    elevation: 10,
                    onTap: (int index) {
                      final dynamic _returnValue =
                          getIndexFromBottonNavigationIndex(index);

                      updateSelectedIndexWithAnimation(
                          _returnValue[0], _returnValue[1]);
                    },
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(
                          Icons.store,
                          size: 20,
                        ),
                        title: Text(
                          Utils.getString(context, 'dashboard__home'),
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.info_outline),
                        title: Text(
                          Utils.getString(context,
                              'home__bottom_app_bar_shop_info'),
                        ),
                      ),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.person),
                          title: Text(
                            Utils.getString(context,
                                'home__bottom_app_bar_login'),
                          )),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.search),
                        title: Text(
                          Utils.getString(
                              context, 'home__bottom_app_bar_search'),
                        ),
                      ),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.shopping_cart),
                          title: Text(
                            Utils.getString(context,
                                'home__bottom_app_bar_basket_list'),
                          ))
                    ],
                  ),
                )
              : null,
          floatingActionButton: _currentIndex ==
                      REQUEST_CODE__MENU_HOME_FRAGMENT ||
                  _currentIndex ==
                      REQUEST_CODE__DASHBOARD_SHOP_INFO_FRAGMENT ||
                  _currentIndex ==
                      REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT ||
                  _currentIndex ==
                      REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT ||
                  _currentIndex ==
                      REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT ||
                  _currentIndex ==
                      REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT ||
                  _currentIndex ==
                      REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT ||
                  _currentIndex ==
                      REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT ||
                  _currentIndex ==
                      REQUEST_CODE__DASHBOARD_BASKET_FRAGMENT ||
                  _currentIndex ==
                      REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT ||
                  _currentIndex ==
                      REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT ||
                  _currentIndex ==
                      REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT
              ? Container(
                  height: 65.0,
                  width: 65.0,
                  child: FittedBox(
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: ps_ctheme__color_speical
                                    .withOpacity(0.3),
                                offset: const Offset(1.1, 1.1),
                                blurRadius: 10.0),
                          ],
                        ),
                        child: Container()),
                  ),
                )
              : null,
          body: Builder(
            builder: (BuildContext context) {
              final Users users = Provider.of<Users>(context);
              if (_currentIndex ==
                  REQUEST_CODE__DASHBOARD_SHOP_INFO_FRAGMENT) {
                // 1 Way
                //
                // return MultiProvider(
                //     providers: <SingleChildCloneableWidget>[
                //       ChangeNotifierProvider<ShopInfoProvider>(
                //           builder: (BuildContext context) {
                //         provider = ShopInfoProvider(repo: repo1);
                //         provider.loadShopInfo();
                //         return provider;
                //       }),
                //       ChangeNotifierProvider<UserInfo
                //     ],
                //     child: CustomScrollView(
                //       scrollDirection: Axis.vertical,
                //       slivers: <Widget>[
                //         _SliverAppbar(
                //           title: 'Shop Info',
                //           scaffoldKey: scaffoldKey,
                //         ),
                //         ShopInfoView(
                //             shopInfoProvider: provider,
                //             animationController: animationController,
                //             animation: Tween<double>(begin: 0.0, end: 1.0)
                //                 .animate(CurvedAnimation(
                //                     parent: animationController,
                //                     curve: Interval((1 / 2) * 1, 1.0,
                //                         curve: Curves.fastOutSlowIn))))
                //       ],
                //     ));
                // 2nd Way
                return ChangeNotifierProvider<ShopInfoProvider>(
                    create: (BuildContext context) {
                      final ShopInfoProvider shopInfoProvider =
                          ShopInfoProvider(
                              repo: shopInfoRepository,
                              psValueHolder: valueHolder,
                              ownerCode: 'DashboardView');
                      shopInfoProvider.loadShopInfo();
                      return shopInfoProvider;
                    },
                    child: CustomScrollView(
                      scrollDirection: Axis.vertical,
                      slivers: <Widget>[
                        ShopInfoView(
                            animationController: animationController,
                            animation:
                                Tween<double>(begin: 0.0, end: 1.0)
                                    .animate(CurvedAnimation(
                                        parent: animationController,
                                        curve: const Interval(
                                            (1 / 2) * 1, 1.0,
                                            curve: Curves
                                                .fastOutSlowIn))))
                      ],
                    ));
              } else if (_currentIndex ==
                  REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
                return ChangeNotifierProvider<UserProvider>(
                    create: (BuildContext context) {
                  final UserProvider provider = UserProvider(
                      repo: userRepository,
                      psValueHolder: valueHolder);
                  //provider.getUserLogin();
                  return provider;
                }, child: Consumer<UserProvider>(builder:
                        (BuildContext context, UserProvider provider,
                            Widget child) {
                  if (users != null ||
                      users.uid != null ||
                      users.uid != '') {
                    if (users.uid == null ||
                        users.uid == null ||
                        users.uid == null ||
                        users.uid == '') {
                      return _CallLoginWidget(
                          currentIndex: _currentIndex,
                          animationController: animationController,
                          animation: animation,
                          updateCurrentIndex:
                              (String title, int index) {
                            if (index != null) {
                              updateSelectedIndexWithAnimation(
                                  title, index);
                            }
                          },
                          updateUserCurrentIndex: (String title,
                              int index, String userId) {
                            if (index != null) {
                              updateSelectedIndexWithAnimation(
                                  title, index);
                            }
                            if (userId != null) {
                              _userId = userId;
                              provider.psValueHolder.loginUserId =
                                  userId;
                            }
                          });
                    } else {
                      return ProfileView(
                        scaffoldKey: scaffoldKey,
                        animationController: animationController,
                        flag: _currentIndex,
                      );
                    }
                  }
                  // } else {
                  //   return _CallVerifyEmailWidget(
                  //       animationController: animationController,
                  //       animation: animation,
                  //       currentIndex: _currentIndex,
                  //       updateCurrentIndex: (String title, int index) {
                  //         updateSelectedIndexWithAnimation(title, index);
                  //       },
                  //       updateUserCurrentIndex:
                  //           (String title, int index, String userId) async {
                  //         if (userId != null) {
                  //           _userId = userId;
                  //           provider.psValueHolder.loginUserId = userId;
                  //         }
                  //         setState(() {
                  //           appBarTitle = title;
                  //           _currentIndex = index;
                  //         });
                  //       });
                  // }
                }));
              }
              if (_currentIndex ==
                  REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT) {
                // 2nd Way
                //SearchProductProvider searchProductProvider;

                return CustomScrollView(
                  scrollDirection: Axis.vertical,
                  slivers: <Widget>[
                    HomeItemSearchView(
                        animationController: animationController,
                        animation: animation,
                        productParameterHolder:
                            ProductParameterHolder()
                                .getLatestParameterHolder())
                  ],
                );
              } else if (_currentIndex ==
                      REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT ||
                  _currentIndex ==
                      REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                return Stack(children: <Widget>[
                  Image.asset(
                    'assets/images/login_app_bg.jpg',
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  CustomScrollView(
                      scrollDirection: Axis.vertical,
                      slivers: <Widget>[
                        PhoneSignInView(
                            animationController: animationController,
                            goToLoginSelected: () {
                              animationController
                                  .reverse()
                                  .then<dynamic>((void data) {
                                if (!mounted) {
                                  return;
                                }
                                if (_currentIndex ==
                                    REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                                  updateSelectedIndexWithAnimation(
                                      Utils.getString(
                                          context, 'home_login'),
                                      REQUEST_CODE__MENU_LOGIN_FRAGMENT);
                                }
                                if (_currentIndex ==
                                    REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT) {
                                  updateSelectedIndexWithAnimation(
                                      Utils.getString(
                                          context, 'home_login'),
                                      REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT);
                                }
                              });
                            },
                            phoneSignInSelected: (String name,
                                String phoneNo, String verifyId) {
                              phoneUserName = name;
                              phoneNumber = phoneNo;
                              phoneId = verifyId;
                              if (_currentIndex ==
                                  REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                                updateSelectedIndexWithAnimation(
                                    Utils.getString(
                                        context, 'home_verify_phone'),
                                    REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT);
                              }
                              if (_currentIndex ==
                                  REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT) {
                                updateSelectedIndexWithAnimation(
                                    Utils.getString(
                                        context, 'home_verify_phone'),
                                    REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT);
                              }
                            })
                      ])
                ]);
              } else if (_currentIndex ==
                      REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT ||
                  _currentIndex ==
                      REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
                return _CallVerifyPhoneWidget(
                    userName: phoneUserName,
                    phoneNumber: phoneNumber,
                    phoneId: phoneId,
                    animationController: animationController,
                    animation: animation,
                    currentIndex: _currentIndex,
                    updateCurrentIndex: (String title, int index) {
                      updateSelectedIndexWithAnimation(title, index);
                    },
                    updateUserCurrentIndex: (String title, int index,
                        String userId) async {
                      if (userId != null) {
                        _userId = userId;
                      }
                      setState(() {
                        appBarTitle = title;
                        _currentIndex = index;
                      });
                    });
              } else if (_currentIndex ==
                      REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT ||
                  _currentIndex ==
                      REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT) {
                return ProfileView(
                  scaffoldKey: scaffoldKey,
                  animationController: animationController,
                  flag: _currentIndex,
                  userId: _userId,
                );
              } else if (_currentIndex ==
                  REQUEST_CODE__MENU_CATEGORY_FRAGMENT) {
                return CategoryListView();
              } else if (_currentIndex ==
                  REQUEST_CODE__MENU_LATEST_PRODUCT_FRAGMENT) {
                return ProductListWithFilterView(
                  key: const Key('1'),
                  animationController: animationController,
                  productParameterHolder: ProductParameterHolder()
                      .getLatestParameterHolder(),
                );
              } else if (_currentIndex ==
                  REQUEST_CODE__MENU_DISCOUNT_PRODUCT_FRAGMENT) {
                return ProductListWithFilterView(
                  key: const Key('2'),
                  animationController: animationController,
                  productParameterHolder: ProductParameterHolder()
                      .getDiscountParameterHolder(),
                );
              } else if (_currentIndex ==
                  REQUEST_CODE__MENU_TRENDING_PRODUCT_FRAGMENT) {
                return ProductListWithFilterView(
                  key: const Key('3'),
                  animationController: animationController,
                  productParameterHolder: ProductParameterHolder()
                      .getTrendingParameterHolder(),
                );
              } else if (_currentIndex ==
                      REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT ||
                  _currentIndex ==
                      REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT) {
                return Stack(children: <Widget>[
                  Image.asset(
                    'assets/images/login_app_bg.jpg',
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  CustomScrollView(
                      scrollDirection: Axis.vertical,
                      slivers: <Widget>[
                        ForgotPasswordView(
                          animationController: animationController,
                          goToLoginSelected: () {
                            animationController
                                .reverse()
                                .then<dynamic>((void data) {
                              if (!mounted) {
                                return;
                              }
                              if (_currentIndex ==
                                  REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT) {
                                updateSelectedIndexWithAnimation(
                                    Utils.getString(
                                        context, 'home_login'),
                                    REQUEST_CODE__MENU_LOGIN_FRAGMENT);
                              }
                              if (_currentIndex ==
                                  REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT) {
                                updateSelectedIndexWithAnimation(
                                    Utils.getString(
                                        context, 'home_login'),
                                    REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT);
                              }
                            });
                          },
                        )
                      ])
                ]);
              } else if (_currentIndex ==
                      REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT ||
                  _currentIndex ==
                      REQUEST_CODE__MENU_REGISTER_FRAGMENT) {
                return Stack(children: <Widget>[
                  Image.asset(
                    'assets/images/login_app_bg.jpg',
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  CustomScrollView(
                      scrollDirection: Axis.vertical,
                      slivers: <Widget>[
                        RegisterView(
                            buildContexts: context,
                            animationController: animationController,
                            onRegisterSelected: () {
                              if (_currentIndex ==
                                  REQUEST_CODE__MENU_REGISTER_FRAGMENT) {
                                updateSelectedIndexWithAnimation(
                                    Utils.getString(context,
                                        'home__verify_email'),
                                    REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT);
                              }
                              if (_currentIndex ==
                                  REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT) {
                                updateSelectedIndexWithAnimation(
                                    Utils.getString(context,
                                        'home__verify_email'),
                                    REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT);
                              }
                            },
                            goToLoginSelected: () {
                              animationController
                                  .reverse()
                                  .then<dynamic>((void data) {
                                if (!mounted) {
                                  return;
                                }
                                if (_currentIndex ==
                                    REQUEST_CODE__MENU_REGISTER_FRAGMENT) {
                                  updateSelectedIndexWithAnimation(
                                      Utils.getString(
                                          context, 'home_login'),
                                      REQUEST_CODE__MENU_LOGIN_FRAGMENT);
                                }
                                if (_currentIndex ==
                                    REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT) {
                                  updateSelectedIndexWithAnimation(
                                      Utils.getString(
                                          context, 'home_login'),
                                      REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT);
                                }
                              });
                            })
                      ])
                ]);
              } else if (_currentIndex ==
                      REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT ||
                  _currentIndex ==
                      REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT) {
                return _CallVerifyEmailWidget(
                    animationController: animationController,
                    animation: animation,
                    currentIndex: _currentIndex,
                    updateCurrentIndex: (String title, int index) {
                      updateSelectedIndexWithAnimation(title, index);
                    },
                    updateUserCurrentIndex: (String title, int index,
                        String userId) async {
                      if (userId != null) {
                        _userId = userId;
                      }
                      setState(() {
                        appBarTitle = title;
                        _currentIndex = index;
                      });
                    });
              } else if (_currentIndex ==
                      REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT ||
                  _currentIndex ==
                      REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                return _CallLoginWidget(
                    currentIndex: _currentIndex,
                    animationController: animationController,
                    animation: animation,
                    updateCurrentIndex: (String title, int index) {
                      updateSelectedIndexWithAnimation(title, index);
                    },
                    updateUserCurrentIndex:
                        (String title, int index, String userId) {
                      setState(() {
                        if (index != null) {
                          appBarTitle = title;
                          _currentIndex = index;
                        }
                      });
                      if (userId != null) {
                        _userId = userId;
                      }
                    });
              } else if (_currentIndex ==
                  REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
                return ChangeNotifierProvider<UserProvider>(
                    create: (BuildContext context) {
                  final UserProvider provider = UserProvider(
                      repo: userRepository,
                      psValueHolder: valueHolder);
//TODO: userlogin
                  return provider;
                }, child: Consumer<UserProvider>(builder:
                        (BuildContext context, UserProvider provider,
                            Widget child) {
                  if (user != null ||
                      user.uid != null ||
                      user.uid != '') {
                    if (user == null ||
                        user.uid == null ||
                        user.uid == null ||
                        user.uid == '') {
                      return Stack(
                        children: <Widget>[
                          Image.asset(
                            'assets/images/login_app_bg.jpg',
                            height: double.infinity,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          CustomScrollView(
                              scrollDirection: Axis.vertical,
                              slivers: <Widget>[
                                LoginView(
                                  animationController:
                                      animationController,
                                  animation: animation,
                                  onGoogleSignInSelected:
                                      (String userId) {
                                    setState(() {
                                      _currentIndex =
                                          REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT;
                                      _userId = userId;
                                      provider.psValueHolder
                                          .loginUserId = userId;
                                    });
                                  },
                                  onFbSignInSelected:
                                      (String userId) {
                                    setState(() {
                                      _currentIndex =
                                          REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT;
                                      _userId = userId;
                                      provider.psValueHolder
                                          .loginUserId = userId;
                                    });
                                  },
                                  onPhoneSignInSelected: () {
                                    if (_currentIndex ==
                                        REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                                      updateSelectedIndexWithAnimation(
                                          Utils.getString(context,
                                              'home_phone_signin'),
                                          REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
                                    }
                                    if (_currentIndex ==
                                        REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT) {
                                      updateSelectedIndexWithAnimation(
                                          Utils.getString(context,
                                              'home_phone_signin'),
                                          REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
                                    }
                                    if (_currentIndex ==
                                        REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
                                      updateSelectedIndexWithAnimation(
                                          Utils.getString(context,
                                              'home_phone_signin'),
                                          REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
                                    }
                                    if (_currentIndex ==
                                        REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
                                      updateSelectedIndexWithAnimation(
                                          Utils.getString(context,
                                              'home_phone_signin'),
                                          REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
                                    }
                                  },
                                  onProfileSelected: (String userId) {
                                    setState(() {
                                      _currentIndex =
                                          REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT;
                                      _userId = userId;
                                      provider.psValueHolder
                                          .loginUserId = userId;
                                    });
                                  },
                                  onForgotPasswordSelected: () {
                                    setState(() {
                                      _currentIndex =
                                          REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT;
                                      appBarTitle = Utils.getString(
                                          context,
                                          'home__forgot_password');
                                    });
                                  },
                                  onSignInSelected: () {
                                    updateSelectedIndexWithAnimation(
                                        Utils.getString(context,
                                            'home__register'),
                                        REQUEST_CODE__MENU_REGISTER_FRAGMENT);
                                  },
                                ),
                              ])
                        ],
                      );
                    } else {
                      return ProfileView(
                        scaffoldKey: scaffoldKey,
                        animationController: animationController,
                        flag: _currentIndex,
                      );
                    }
                  } else {
                    return _CallVerifyEmailWidget(
                        animationController: animationController,
                        animation: animation,
                        currentIndex: _currentIndex,
                        updateCurrentIndex:
                            (String title, int index) {
                          updateSelectedIndexWithAnimation(
                              title, index);
                        },
                        updateUserCurrentIndex: (String title,
                            int index, String userId) async {
                          if (userId != null) {
                            _userId = userId;
                            provider.psValueHolder.loginUserId =
                                userId;
                          }
                          setState(() {
                            appBarTitle = title;
                            _currentIndex = index;
                          });
                        });
                  }
                }));
              } else if (_currentIndex ==
                  REQUEST_CODE__MENU_FAVOURITE_FRAGMENT) {
                return FavouriteProductListView(
                    animationController: animationController);
              } else if (_currentIndex ==
                  REQUEST_CODE__MENU_TRANSACTION_FRAGMENT) {
                return TransactionListView(
                    scaffoldKey: scaffoldKey,
                    animationController: animationController);
              } else if (_currentIndex ==
                  REQUEST_CODE__MENU_USER_HISTORY_FRAGMENT) {
                return HistoryListView(
                    animationController: animationController);
              } else if (_currentIndex ==
                  REQUEST_CODE__MENU_PURCHASED_PRODUCT_FRAGMENT) {
                return PurchasedProductGridView(
                    animationController: animationController);
              } else if (_currentIndex ==
                  REQUEST_CODE__MENU_COLLECTION_FRAGMENT) {
                return CollectionHeaderListView(
                    animationController: animationController);
              } else if (_currentIndex ==
                  REQUEST_CODE__MENU_LANGUAGE_FRAGMENT) {
                return LanguageSettingView(
                    animationController: animationController,
                    languageIsChanged: () {
                      // _currentIndex = REQUEST_CODE__MENU_LANGUAGE_FRAGMENT;
                      // appBarTitle = Utils.getString(
                      //     context, 'home__menu_drawer_language');

                      //updateSelectedIndexWithAnimation(
                      //  '', REQUEST_CODE__MENU_LANGUAGE_FRAGMENT);
                      // setState(() {});
                    });
              } else if (_currentIndex ==
                  REQUEST_CODE__MENU_CONTACT_US_FRAGMENT) {
                return ContactUsView(
                    animationController: animationController);
              } else if (_currentIndex ==
                  REQUEST_CODE__MENU_SETTING_FRAGMENT) {
                return SettingView(
                  animationController: animationController,
                );
              } else if (_currentIndex ==
                  REQUEST_CODE__MENU_BLOG_FRAGMENT) {
                return BlogListView(
                  animationController: animationController,
                );
              } else if (_currentIndex ==
                  REQUEST_CODE__DASHBOARD_BASKET_FRAGMENT) {
                return BasketListView(
                  animationController: animationController,
                );
              } else {
                animationController.forward();
                return HomeDashboardViewWidget(
                    _scrollController, animationController, context,
                    (String payload) {
                  return showDialog<dynamic>(
                    context: context,
                    builder: (_) {
                      return NotiDialog(message: '$payload');
                    },
                  );
                });
              }
            },
          ),
        ),
      ),
    );
  }
}

// class _BottomAppBarWidget extends StatelessWidget {
//   const _BottomAppBarWidget({
//     Key key,
//     @required this.icon,
//     @required this.title,
//     @required this.onTap,
//     @required this.index,
//     @required this.paddingEdgeInsetWidget,
//   }) : super(key: key);

//   final IconData icon;
//   final String title;
//   final Function onTap;
//   final int index;
//   final EdgeInsets paddingEdgeInsetWidget;
//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//         iconSize: 30.0,
//         padding: paddingEdgeInsetWidget,
//         icon: Icon(
//           icon,
//           //color: ps_wtheme_text__primary_color,
//         ),
//         onPressed: () {
//           onTap(title, index);
//         });
//   }
// }

class _CallLoginWidget extends StatelessWidget {
  const _CallLoginWidget(
      {@required this.animationController,
      @required this.animation,
      @required this.updateCurrentIndex,
      @required this.updateUserCurrentIndex,
      @required this.currentIndex});
  final Function updateCurrentIndex;
  final Function updateUserCurrentIndex;
  final AnimationController animationController;
  final Animation<double> animation;
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          'assets/images/login_app_bg.jpg',
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        CustomScrollView(scrollDirection: Axis.vertical, slivers: <
            Widget>[
          LoginView(
            animationController: animationController,
            animation: animation,
            onGoogleSignInSelected: (String userId) {
              if (currentIndex == REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateUserCurrentIndex(
                    Utils.getString(
                        context, 'home__menu_drawer_profile'),
                    REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                    userId);
              } else {
                updateUserCurrentIndex(
                    Utils.getString(
                        context, 'home__menu_drawer_profile'),
                    REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                    userId);
              }
            },
            onFbSignInSelected: (String userId) {
              if (currentIndex == REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateUserCurrentIndex(
                    Utils.getString(
                        context, 'home__menu_drawer_profile'),
                    REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                    userId);
              } else {
                updateUserCurrentIndex(
                    Utils.getString(
                        context, 'home__menu_drawer_profile'),
                    REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                    userId);
              }
            },
            onPhoneSignInSelected: () {
              if (currentIndex == REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
              }
              if (currentIndex ==
                  REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
              }
              if (currentIndex ==
                  REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
              }
              if (currentIndex ==
                  REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
              }
            },
            onProfileSelected: (String userId) {
              if (currentIndex == REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateUserCurrentIndex(
                    Utils.getString(
                        context, 'home__menu_drawer_profile'),
                    REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                    userId);
              } else {
                updateUserCurrentIndex(
                    Utils.getString(
                        context, 'home__menu_drawer_profile'),
                    REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                    userId);
              }
            },
            onForgotPasswordSelected: () {
              if (currentIndex == REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home__forgot_password'),
                    REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT);
              } else {
                updateCurrentIndex(
                    Utils.getString(context, 'home__forgot_password'),
                    REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT);
              }
            },
            onSignInSelected: () {
              if (currentIndex == REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home__register'),
                    REQUEST_CODE__MENU_REGISTER_FRAGMENT);
              } else {
                updateCurrentIndex(
                    Utils.getString(context, 'home__register'),
                    REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
              }
            },
          ),
        ])
      ],
    );
  }
}

class _CallVerifyPhoneWidget extends StatelessWidget {
  const _CallVerifyPhoneWidget(
      {this.userName,
      this.phoneNumber,
      this.phoneId,
      @required this.updateCurrentIndex,
      @required this.updateUserCurrentIndex,
      @required this.animationController,
      @required this.animation,
      @required this.currentIndex});

  final String userName;
  final String phoneNumber;
  final String phoneId;
  final Function updateCurrentIndex;
  final Function updateUserCurrentIndex;
  final int currentIndex;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: VerifyPhoneView(
          userName: userName,
          phoneNumber: phoneNumber,
          phoneId: phoneId,
          animationController: animationController,
          onProfileSelected: (String userId) {
            if (currentIndex ==
                REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
              updateUserCurrentIndex(
                  Utils.getString(
                      context, 'home__menu_drawer_profile'),
                  REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                  userId);
            } else if (currentIndex ==
                REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT) {
              updateUserCurrentIndex(
                  Utils.getString(
                      context, 'home__menu_drawer_profile'),
                  REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                  userId);
              // updateCurrentIndex(REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT);
            }
          },
          onSignInSelected: () {
            if (currentIndex ==
                REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
              updateCurrentIndex(
                  Utils.getString(context, 'home__register'),
                  REQUEST_CODE__MENU_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT) {
              updateCurrentIndex(
                  Utils.getString(context, 'home__register'),
                  REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
            }
            // else if (currentIndex ==
            //     REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
            //   updateCurrentIndex(Utils.getString(context, 'home__register'),
            //       REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
            // } else if (currentIndex ==
            //     REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
            //   updateCurrentIndex(Utils.getString(context, 'home__register'),
            //       REQUEST_CODE__MENU_REGISTER_FRAGMENT);
            // }
          },
        ));
  }
}

class _CallVerifyEmailWidget extends StatelessWidget {
  const _CallVerifyEmailWidget(
      {@required this.updateCurrentIndex,
      @required this.updateUserCurrentIndex,
      @required this.animationController,
      @required this.animation,
      @required this.currentIndex});
  final Function updateCurrentIndex;
  final Function updateUserCurrentIndex;
  final int currentIndex;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: VerifyEmailView(
          animationController: animationController,
          onProfileSelected: (String userId) {
            if (currentIndex ==
                REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT) {
              updateUserCurrentIndex(
                  Utils.getString(
                      context, 'home__menu_drawer_profile'),
                  REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                  userId);
            } else if (currentIndex ==
                REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT) {
              updateUserCurrentIndex(
                  Utils.getString(
                      context, 'home__menu_drawer_profile'),
                  REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                  userId);
              // updateCurrentIndex(REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT);
            }
          },
          onSignInSelected: () {
            if (currentIndex ==
                REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT) {
              updateCurrentIndex(
                  Utils.getString(context, 'home__register'),
                  REQUEST_CODE__MENU_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT) {
              updateCurrentIndex(
                  Utils.getString(context, 'home__register'),
                  REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
              updateCurrentIndex(
                  Utils.getString(context, 'home__register'),
                  REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
              updateCurrentIndex(
                  Utils.getString(context, 'home__register'),
                  REQUEST_CODE__MENU_REGISTER_FRAGMENT);
            }
          },
        ));
  }
}

class _DrawerMenuWidget extends StatefulWidget {
  const _DrawerMenuWidget({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.onTap,
    @required this.index,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Function onTap;
  final int index;

  @override
  __DrawerMenuWidgetState createState() => __DrawerMenuWidgetState();
}

class __DrawerMenuWidgetState extends State<_DrawerMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(widget.icon,
            color: Utils.isLightMode(context)
                ? ps_ctheme__color_speical
                : Colors.white //ps_wtheme_icon_color,
            ),
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        onTap: () {
          widget.onTap(widget.title, widget.index);
        });
  }
}

class _DrawerHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Column(
        children: <Widget>[
          Image.asset(
            'assets/images/digital_product_logo_orange.png',
            width: ps_space_100,
            height: ps_space_72,
          ),
          const SizedBox(
            height: ps_space_8,
          ),
          Text(
            Utils.getString(context, 'app_name'),
            style: Theme.of(context)
                .textTheme
                .subhead
                .copyWith(color: Colors.white),
          ),
        ],
      ),
      decoration:
          const BoxDecoration(color: ps_ctheme__color_speical),
    );
  }
}
