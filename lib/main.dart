import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalproductstore/locator.dart';
import 'package:digitalproductstore/model/product_model.dart';
import 'package:digitalproductstore/ui/basket/list/basket_list_container.dart';
import 'package:digitalproductstore/ui/blog/detail/blog_view.dart';
import 'package:digitalproductstore/ui/blog/list/blog_list_container.dart';
import 'package:digitalproductstore/ui/checkout/checkout_view.dart';
import 'package:digitalproductstore/ui/checkout/checkout_success_view.dart';
import 'package:digitalproductstore/ui/checkout/credit_card_view.dart';
import 'package:digitalproductstore/ui/comment/detail/comment_detail_list_view.dart';
import 'package:digitalproductstore/ui/comment/list/comment_list_view.dart';
import 'package:digitalproductstore/ui/force_update/force_update_view.dart';
import 'package:digitalproductstore/ui/gallery/detail/gallery_view.dart';
import 'package:digitalproductstore/ui/gallery/grid/gallery_grid_view.dart';
import 'package:digitalproductstore/ui/history/list/history_list_container.dart';
import 'package:digitalproductstore/ui/noti/notification_setting/notification_setting_view.dart';
import 'package:digitalproductstore/ui/product/collection_product/product_list_by_collection_id_view.dart';
import 'package:digitalproductstore/ui/product/detail/product_detail_view.dart';
import 'package:digitalproductstore/ui/product/favourite/favourite_product_list_container.dart';
import 'package:digitalproductstore/ui/product/list_with_filter/product_list_with_filter_container.dart';
import 'package:digitalproductstore/ui/product/purchase_product/purchase_product_container_view.dart';
import 'package:digitalproductstore/ui/rating/list/rating_list_view.dart';
import 'package:digitalproductstore/ui/setting/setting_container_view.dart';
import 'package:digitalproductstore/ui/setting/setting_privacy_policy_view.dart';
import 'package:digitalproductstore/ui/transaction/detail/transaction_item_list_view.dart';
import 'package:digitalproductstore/ui/transaction/list/transaction_list_container.dart';
import 'package:digitalproductstore/ui/user/phone/sign_in/phone_sign_in_container_view.dart';
import 'package:digitalproductstore/ui/user/phone/verify_phone/verify_phone_container_view.dart';
import 'package:digitalproductstore/ui/user/profile/profile_container_view.dart';
import 'package:digitalproductstore/ui/user/profile/profile_view.dart';
import 'package:digitalproductstore/ui/user/register/register_container_view.dart';
import 'package:digitalproductstore/viewobject/blog.dart';
import 'package:digitalproductstore/viewobject/comment_header.dart';
import 'package:digitalproductstore/viewobject/default_photo.dart';
import 'package:digitalproductstore/viewobject/holder/intent_holder/checkout_intent_holder.dart';
import 'package:digitalproductstore/viewobject/holder/intent_holder/credit_card_intent_holder.dart';
import 'package:digitalproductstore/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:digitalproductstore/viewobject/holder/intent_holder/verify_phone_internt_holder.dart';
import 'package:digitalproductstore/viewobject/holder/product_parameter_holder.dart';
import 'package:digitalproductstore/viewobject/noti.dart';
import 'package:digitalproductstore/viewobject/product.dart';
import 'package:digitalproductstore/viewobject/ps_app_version.dart';
import 'package:digitalproductstore/viewobject/transaction_header.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:digitalproductstore/viewobject/common/language.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digitalproductstore/config/ps_theme_data.dart';
import 'package:digitalproductstore/config/route_paths.dart';
import 'package:digitalproductstore/provider/common/ps_theme_provider.dart';
import 'package:digitalproductstore/provider/ps_provider_dependencies.dart';
import 'package:digitalproductstore/repository/ps_theme_repository.dart';
import 'package:digitalproductstore/ui/app_info/app_info_view.dart';
import 'package:digitalproductstore/ui/noti/detail/noti_view.dart';
import 'package:digitalproductstore/ui/noti/list/noti_list_view.dart';
import 'package:digitalproductstore/utils/utils.dart';
import 'package:digitalproductstore/viewobject/category.dart';
import 'package:easy_localization/easy_localization.dart';
import 'Service/auth/auth_service.dart';
import 'config/ps_config.dart';
import 'config/ps_constants.dart';
import 'db/common/ps_shared_preferences.dart';
import 'model/user_model.dart';
import 'ui/category/filter_list/category_filter_list_view.dart';
import 'ui/category/list/category_list_view_container.dart';
import 'ui/category/trending_list/trending_category_list_view.dart';
import 'ui/dashboard/core/dashboard_view.dart';
import 'ui/language/list/language_list_view.dart';
import 'ui/product/list_with_filter/filter/category/filter_list_view.dart';
import 'ui/product/list_with_filter/filter/filter/item_search_view.dart';
import 'ui/product/list_with_filter/filter/sort/item_sorting_view.dart';
import 'ui/subcategory/filter/sub_category_search_list_view.dart';
import 'ui/subcategory/list/sub_category_list_view.dart';
import 'ui/user/edit_profile/edit_profile_view.dart';
import 'ui/user/forgot_password/forgot_password_container_view.dart';
import 'ui/user/login/login_container_view.dart';
import 'ui/user/password_update/change_password_view.dart';
import 'ui/user/verify/verify_email_container_view.dart';

Future<void> main() async {
  // add this, and it should be the first line in main method
  WidgetsFlutterBinding.ensureInitialized();

  final FirebaseMessaging _fcm = FirebaseMessaging();
  if (Platform.isIOS) {
    _fcm.requestNotificationPermissions(const IosNotificationSettings());
  }

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.getString('codeC') == null) {
    await prefs.setString('codeC', null);
    await prefs.setString('codeL', null);
  }
  setupLocator();
  runApp(EasyLocalization(
      child: MultiProvider(providers: <SingleChildCloneableWidget>[
    Provider<ProductList>(
      create: (BuildContext context) => ProductList(),
    ),
    StreamProvider<Users>.value(
      value: AuthService().users,
    ),
  ], child: PSApp())));
}

class PSApp extends StatefulWidget {
  @override
  _PSAppState createState() => _PSAppState();
}

class _PSAppState extends State<PSApp> {
  bool _isLanguageLoaded = false;

  Completer<ThemeData> themeDataCompleter;
  PsSharedPreferences psSharedPreferences;

  @override
  void initState() {
    super.initState();

    _isLanguageLoaded = false;
  }

  Future<ThemeData> getSharePerference(
      EasyLocalizationProvider provider, dynamic data) {
    Utils.psPrint('>> get share perference');
    if (themeDataCompleter == null) {
      Utils.psPrint('init completer');
      themeDataCompleter = Completer<ThemeData>();
    }

    if (psSharedPreferences == null) {
      Utils.psPrint('init ps shareperferences');
      psSharedPreferences = PsSharedPreferences.instance;
      Utils.psPrint('get shared');
      psSharedPreferences.futureShared.then((SharedPreferences sh) {
        psSharedPreferences.shared = sh;

        Utils.psPrint('init theme provider');
        final PsThemeProvider psThemeProvider = PsThemeProvider(
            repo: PsThemeRepository(psSharedPreferences: psSharedPreferences));

        Utils.psPrint('get theme');
        final ThemeData themeData = psThemeProvider.getTheme();
        //independentProviders.add(Provider.value(value: psSharedPreferences));
        //providerList = [...providers];
        themeDataCompleter.complete(themeData);
        Utils.psPrint('themedata loading completed');
      });
    }

    return themeDataCompleter.future;
  }

  Future<dynamic> getCurrentLang(EasyLocalizationProvider provider) async {
    if (!_isLanguageLoaded) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      provider.data.changeLocale(Locale(
          prefs.getString(LANGUAGE__LANGUAGE_CODE_KEY) ??
              defaultLanguage.languageCode,
          prefs.getString(LANGUAGE__COUNTRY_CODE_KEY) ??
              defaultLanguage.countryCode));
      _isLanguageLoaded = true;
    }
  }

  List<Locale> getSupportedLanguages() {
    final List<Locale> localeList = <Locale>[];
    for (final Language lang in psSupportedLanguageList) {
      localeList.add(Locale(lang.languageCode, lang.countryCode));
    }
    print('Loaded Languages');
    return localeList;
  }

  @override
  Widget build(BuildContext context) {
    final EasyLocalizationProvider provider2 =
        EasyLocalizationProvider.of(context);
    final dynamic data = provider2.data;

    getCurrentLang(provider2);
    return MultiProvider(
        providers: <SingleChildCloneableWidget>[
          ...providers,
        ],
        child: DynamicTheme(
            defaultBrightness: Brightness.light,
            data: (Brightness brightness) {
              if (brightness == Brightness.light) {
                return themeData(ThemeData.light());
              } else {
                return themeData(ThemeData.dark());
              }
            },
            themedWidgetBuilder: (BuildContext context, ThemeData theme) {
              return EasyLocalizationProvider(
                  data: data,
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Panacea-Soft',
                    theme: theme,
                    routes: <String, Widget Function(BuildContext)>{
                      '/': (BuildContext context) {
                        return AppInfoView();
                      },
                      '${RoutePaths.home}': (BuildContext context) =>
                          DashboardView(),
                      '${RoutePaths.force_update}': (BuildContext context) {
                        final Object args =
                            ModalRoute.of(context).settings.arguments;
                        final PSAppVersion psAppVersion = args ?? PSAppVersion;
                        return ForceUpdateView(psAppVersion: psAppVersion);
                      },
                      '${RoutePaths.user_register_container}':
                          (BuildContext context) => RegisterContainerView(),
                      '${RoutePaths.login_container}': (BuildContext context) =>
                          LoginContainerView(),
                      '${RoutePaths.user_verify_email_container}':
                          (BuildContext context) {
                        return VerifyEmailContainerView();
                      },
                      '${RoutePaths.user_forgot_password_container}':
                          (BuildContext context) =>
                              ForgotPasswordContainerView(),
                      '${RoutePaths.user_phone_signin_container}':
                          (BuildContext context) => PhoneSignInContainerView(),
                      '${RoutePaths.user_phone_verify_container}':
                          (BuildContext context) {
                        final Object args =
                            ModalRoute.of(context).settings.arguments;

                        final VerifyPhoneIntentHolder
                            verifyPhoneIntentParameterHolder =
                            args ?? VerifyPhoneIntentHolder;
                        return VerifyPhoneContainerView(
                          userName: verifyPhoneIntentParameterHolder.userName,
                          phoneNumber:
                              verifyPhoneIntentParameterHolder.phoneNumber,
                          phoneId: verifyPhoneIntentParameterHolder.phoneId,
                        );
                      },
                      '${RoutePaths.user_update_password}':
                          (BuildContext context) => ChangePasswordView(),
                      '${RoutePaths.profile}': (BuildContext context) =>
                          ProfileView(),
                      '${RoutePaths.profile_container}':
                          (BuildContext context) => ProfileContainerView(),
                      '${RoutePaths.languageList}': (BuildContext context) {
                        return LanguageListView();
                      },
                      '${RoutePaths.categoryList}': (BuildContext context) {
                        return CategoryListViewContainerView(
                          appBarTitle: Utils.getString(
                              context, 'dashboard__category_list'),
                        );
                      },
                      '${RoutePaths.notiList}': (BuildContext context) =>
                          const NotiListView(),
                      '${RoutePaths.creditCard}': (BuildContext context) {
                        final Object args =
                            ModalRoute.of(context).settings.arguments;

                        final CreditCardIntentHolder creditCardParameterHolder =
                            args ?? CreditCardIntentHolder;
                        return CreditCardView(
                            productList: creditCardParameterHolder.productList,
                            couponDiscount:
                                creditCardParameterHolder.couponDiscount,
                            transactionSubmitProvider: creditCardParameterHolder
                                .transactionSubmitProvider,
                            userLoginProvider:
                                creditCardParameterHolder.userLoginProvider,
                            basketProvider:
                                creditCardParameterHolder.basketProvider,
                            psValueHolder:
                                creditCardParameterHolder.psValueHolder,
                            name: creditCardParameterHolder.name,
                            iconData: creditCardParameterHolder.iconData);
                      },
                      '${RoutePaths.notiSetting}': (BuildContext context) =>
                          NotificationSettingView(),
                      '${RoutePaths.setting}': (BuildContext context) =>
                          SettingContainerView(),
                      '${RoutePaths.subCategoryList}': (BuildContext context) {
                        final Object args =
                            ModalRoute.of(context).settings.arguments;
                        final Category category = args ?? Category;
                        return SubCategoryListView(category: category);
                      },
                      '${RoutePaths.noti}': (BuildContext context) {
                        final Object args =
                            ModalRoute.of(context).settings.arguments;
                        final Noti noti = args ?? Noti;
                        return NotiView(noti: noti);
                      },
                      '${RoutePaths.filterProductList}':
                          (BuildContext context) {
                        final Object args =
                            ModalRoute.of(context).settings.arguments;
                        final ProductListIntentHolder productListIntentHolder =
                            args ?? ProductListIntentHolder;
                        return ProductListWithFilterContainerView(
                            appBarTitle: productListIntentHolder.appBarTitle,
                            productParameterHolder:
                                productListIntentHolder.productParameterHolder);
                      },
                      '${RoutePaths.checkoutSuccess}': (BuildContext context) =>
                          CheckoutSuccessView(),
                      '${RoutePaths.privacyPolicy}': (BuildContext context) {
                        final Object args =
                            ModalRoute.of(context).settings.arguments;
                        final int checkPolicyType = args ?? int;
                        return SettingPrivacyPolicyView(
                          checkPolicyType: checkPolicyType,
                        );
                      },
                      '${RoutePaths.purchasedProduct}':
                          (BuildContext context) =>
                              PurchasedProductContainerView(),
                      '${RoutePaths.blogList}': (BuildContext context) =>
                          BlogListContainerView(),
                      '${RoutePaths.blogDetail}': (BuildContext context) {
                        final Object args =
                            ModalRoute.of(context).settings.arguments;
                        final Blog blog = args ?? Blog;
                        return BlogView(blog: blog);
                      },
                      '${RoutePaths.transactionList}': (BuildContext context) =>
                          TransactionListContainerView(),
                      '${RoutePaths.historyList}': (BuildContext context) {
                        return HistoryListContainerView();
                      },
                      '${RoutePaths.transactionDetail}':
                          (BuildContext context) {
                        final Object args =
                            ModalRoute.of(context).settings.arguments;
                        final TransactionHeader transaction =
                            args ?? TransactionHeader;
                        return TransactionItemListView(
                          transaction: transaction,
                        );
                      },
                      '${RoutePaths.productDetail}': (BuildContext context) {
                        final Object args =
                            ModalRoute.of(context).settings.arguments;
                        final DocumentSnapshot product =
                            args ?? DocumentSnapshot;
                        return ProductDetailView(
                          productList: product,
                          // product: product,
                        );
                      },
                      '${RoutePaths.filterExpantion}': (BuildContext context) {
                        final dynamic args =
                            ModalRoute.of(context).settings.arguments;

                        return FilterListView(selectedData: args);
                      },
                      '${RoutePaths.commentList}': (BuildContext context) {
                        final Object args =
                            ModalRoute.of(context).settings.arguments;
                        final List<DocumentSnapshot> product = args ?? DocumentSnapshot;
                        return CommentListView(commentsList: product,);
                      },
                      '${RoutePaths.itemSearch}': (BuildContext context) {
                        final Object args =
                            ModalRoute.of(context).settings.arguments;
                        final ProductParameterHolder productParameterHolder =
                            args ?? ProductParameterHolder;
                        return ItemSearchView(
                            productParameterHolder: productParameterHolder);
                      },
                      '${RoutePaths.itemSort}': (BuildContext context) {
                        final Object args =
                            ModalRoute.of(context).settings.arguments;
                        final ProductParameterHolder productParameterHolder =
                            args ?? ProductParameterHolder;
                        return ItemSortingView(
                            productParameterHolder: productParameterHolder);
                      },
                      '${RoutePaths.commentDetail}': (BuildContext context) {
                        final Object args =
                            ModalRoute.of(context).settings.arguments;
                        final CommentHeader commentHeader =
                            args ?? CommentHeader;
                        return CommentDetailListView(
                          commentHeader: commentHeader,
                        );
                      },
                      '${RoutePaths.favouriteProductList}':
                          (BuildContext context) =>
                              FavouriteProductListContainerView(),
                      '${RoutePaths.productListByCollectionId}':
                          (BuildContext context) {
                        final Object args =
                            ModalRoute.of(context).settings.arguments;
                        final ProductListByCollectionIdView
                            productCollectionIdView =
                            args ?? ProductListByCollectionIdView;

                        return ProductListByCollectionIdView(
                          productCollectionHeader:
                              productCollectionIdView.productCollectionHeader,
                          appBarTitle: Utils.getString(
                              context, productCollectionIdView.appBarTitle),
                        );
                      },
                      '${RoutePaths.ratingList}': (BuildContext context) {
                        final Object args =
                            ModalRoute.of(context).settings.arguments;
                        final String productDetailId = args ?? String;
                        return RatingListView(productDetailid: productDetailId);
                      },
                      '${RoutePaths.editProfile}': (BuildContext context) {
                        final Object args =
                            ModalRoute.of(context).settings.arguments;
                        final DocumentSnapshot editprofile =
                            args ?? DocumentSnapshot;
                        return EditProfileView(
                          snapshot: editprofile,
                        );
                      },
                      '${RoutePaths.galleryGrid}': (BuildContext context) {
                        final Object args =
                            ModalRoute.of(context).settings.arguments;
                        final Product product = args ?? Product;
                        return GalleryGridView(product: product);
                      },
                      '${RoutePaths.galleryDetail}': (BuildContext context) {
                        final Object args =
                            ModalRoute.of(context).settings.arguments;
                        final DefaultPhoto selectedDefaultImage =
                            args ?? DefaultPhoto;
                        return GalleryView(
                            selectedDefaultImage: selectedDefaultImage);
                      },
                      '${RoutePaths.searchCategory}': (BuildContext context) =>
                          CategoryFilterListView(),
                      '${RoutePaths.searchSubCategory}':
                          (BuildContext context) {
                        final Object args =
                            ModalRoute.of(context).settings.arguments;
                        final String category = args ?? String;
                        return SubCategorySearchListView(categoryId: category);
                      },
                      '${RoutePaths.basketList}': (BuildContext context) {
                        
                        return BasketListContainerView();
                      },
                      '${RoutePaths.checkout}': (BuildContext context) {
                        final Object args =
                            ModalRoute.of(context).settings.arguments;
                        final CheckoutIntentHolder checkoutIntentHolder =
                            args ?? CheckoutIntentHolder;
                        return CheckoutView(
                            productList: checkoutIntentHolder.productList,
                            publishKey: checkoutIntentHolder.publishKey);
                      },
                      '${RoutePaths.trendingCategoryList}':
                          (BuildContext context) {
                        return TrendingCategoryListView();
                      },
                    },

                    // initialRoute: RoutePaths.appLoading,
                    // onGenerateRoute: Router.generateRoute,
                    localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      //app-specific localization
                      EasylocaLizationDelegate(
                          locale: data.locale ??
                              Locale(defaultLanguage.languageCode,
                                  defaultLanguage.countryCode),
                          path: 'assets/langs'),
                    ],
                    supportedLocales: getSupportedLanguages(),
                    locale: data.locale ??
                        Locale(defaultLanguage.languageCode,
                            defaultLanguage.countryCode),
                  ));
            }));
  }
}
