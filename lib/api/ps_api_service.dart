import 'dart:io';

import 'package:digitalproductstore/config/ps_config.dart';
import 'package:digitalproductstore/config/ps_url.dart';
import 'package:digitalproductstore/viewobject/api_status.dart';
import 'package:digitalproductstore/viewobject/blog.dart';
import 'package:digitalproductstore/viewobject/category.dart';
import 'package:digitalproductstore/viewobject/comment_detail.dart';
import 'package:digitalproductstore/viewobject/comment_header.dart';
import 'package:digitalproductstore/viewobject/coupon_discount.dart';
import 'package:digitalproductstore/viewobject/default_photo.dart';
import 'package:digitalproductstore/viewobject/download_product.dart';
import 'package:digitalproductstore/viewobject/noti.dart';
import 'package:digitalproductstore/viewobject/product.dart';
import 'package:digitalproductstore/viewobject/product_collection_header.dart';
import 'package:digitalproductstore/viewobject/ps_app_info.dart';
import 'package:digitalproductstore/viewobject/rating.dart';
import 'package:digitalproductstore/viewobject/shop_info.dart';
import 'package:digitalproductstore/viewobject/sub_category.dart';
import 'package:digitalproductstore/viewobject/transaction_detail.dart';
import 'package:digitalproductstore/viewobject/transaction_header.dart';
import 'package:digitalproductstore/viewobject/user.dart';
import 'common/ps_api.dart';
import 'common/ps_resource.dart';

class PsApiService extends PsApi {
  ///
  /// App Info
  ///
  Future<PsResource<PSAppInfo>> postPsAppInfo(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '$ps_post_ps_app_info_url';
    return await postData<PSAppInfo, PSAppInfo>(PSAppInfo(), url, jsonMap);
  }

  ///
  /// User Register
  ///
  Future<PsResource<User>> postUserRegister(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '$ps_post_ps_user_register_url';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// User Verify Email
  ///
  Future<PsResource<User>> postUserEmailVerify(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '$ps_post_ps_user_email_verify_url';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// User Login
  ///
  Future<PsResource<User>> postUserLogin(Map<dynamic, dynamic> jsonMap) async {
    const String url = '$ps_post_ps_user_login_url';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// FB Login
  ///
  Future<PsResource<User>> postFBLogin(Map<dynamic, dynamic> jsonMap) async {
    const String url = '$ps_post_ps_fb_login_url';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// Google Login
  ///
  Future<PsResource<User>> postGoogleLogin(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '$ps_post_ps_google_login_url';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// User Forgot Password
  ///
  Future<PsResource<ApiStatus>> postForgotPassword(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '$ps_post_ps_user_forgot_password_url';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// User Change Password
  ///
  Future<PsResource<ApiStatus>> postChangePassword(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '$ps_post_ps_user_change_password_url';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// User Profile Update
  ///
  Future<PsResource<User>> postProfileUpdate(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '$ps_post_ps_user_update_profile_url';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// User Phone Login
  ///
  Future<PsResource<User>> postPhoneLogin(Map<dynamic, dynamic> jsonMap) async {
    const String url = '$ps_post_ps_phone_login_url';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// User Resend Code
  ///
  Future<PsResource<ApiStatus>> postResendCode(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '$ps_post_ps_resend_code_url';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// Touch Count
  ///
  Future<PsResource<ApiStatus>> postTouchCount(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '$ps_post_ps_touch_count_url';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// Get User
  ///
  Future<PsResource<List<User>>> getUser(String userId) async {
    final String url = '$ps_user_url/api_key/$ps_api_key/user_id/$userId';

    return await getServerCall<User, List<User>>(User(), url);
  }

  Future<PsResource<User>> postImageUpload(
      String userId, String platformName, File imageFile) async {
    const String url = '$ps_image_upload_url';

    return postUploadImage<User, User>(
        User(), url, userId, platformName, imageFile);
  }

  ///
  /// Category
  ///
  Future<PsResource<List<Category>>> getCategoryList(
      int limit, int offset, Map<dynamic, dynamic> jsonMap) async {
    final String url =
        '$ps_category_url/api_key/$ps_api_key/limit/$limit/offset/$offset';

    return await postData<Category, List<Category>>(Category(), url, jsonMap);
  }

  Future<PsResource<List<Category>>> getAllCategoryList(
      Map<dynamic, dynamic> jsonMap) async {
    final String url = '$ps_category_url/api_key/$ps_api_key';

    return await postData<Category, List<Category>>(Category(), url, jsonMap);
  }

  ///
  /// Sub Category
  ///
  Future<PsResource<List<SubCategory>>> getSubCategoryList(
      int limit, int offset, String categoryId) async {
    final String url =
        '$ps_subCategory_url/api_key/$ps_api_key/limit/$limit/offset/$offset/cat_id/$categoryId';

    return await getServerCall<SubCategory, List<SubCategory>>(
        SubCategory(), url);
  }

  Future<PsResource<List<SubCategory>>> getAllSubCategoryList(
      String categoryId) async {
    final String url =
        '$ps_subCategory_url/api_key/$ps_api_key/cat_id/$categoryId';

    return await getServerCall<SubCategory, List<SubCategory>>(
        SubCategory(), url);
  }

  //noti
  Future<PsResource<List<Noti>>> getNotificationList(
      Map<dynamic, dynamic> paramMap, int limit, int offset) async {
    final String url =
        '$ps_noti_url/api_key/$ps_api_key/limit/$limit/offset/$offset';

    return await postData<Noti, List<Noti>>(Noti(), url, paramMap);
  }

  //
  /// Product
  ///
  Future<PsResource<List<Product>>> getProductList(
      Map<dynamic, dynamic> paramMap, int limit, int offset) async {
    final String url =
        '$ps_product_url/api_key/$ps_api_key/limit/$limit/offset/$offset';

    return await postData<Product, List<Product>>(Product(), url, paramMap);
  }

  Future<PsResource<Product>> getProductDetail(
      String productId, String loginUserId) async {
    final String url =
        '$ps_product_detail_url/api_key/$ps_api_key/id/$productId/login_user_id/$loginUserId';
    return await getServerCall<Product, Product>(Product(), url);
  }

  Future<PsResource<List<Product>>> getRelatedProductList(
      String productId, String categoryId, int limit, int offset) async {
    final String url =
        '$ps_relatedProduct_url/api_key/$ps_api_key/id/$productId/cat_id/$categoryId/limit/$limit/offset/$offset';
    print(url);
    return await getServerCall<Product, List<Product>>(Product(), url);
  }

  Future<PsResource<List<Product>>> getPurchasedProductList(
      String loginUserId, int limit, int offset) async {
    final String url =
        '$ps_purchasedProduct_url/api_key/$ps_api_key/login_user_id/$loginUserId/limit/$limit/offset/$offset';

    return await getServerCall<Product, List<Product>>(Product(), url);
  }

  //
  /// Product Collection
  ///
  Future<PsResource<List<ProductCollectionHeader>>> getProductCollectionList(
      int limit, int offset) async {
    final String url =
        '$ps_collection_url/api_key/$ps_api_key/limit/$limit/offset/$offset';

    return await getServerCall<ProductCollectionHeader,
        List<ProductCollectionHeader>>(ProductCollectionHeader(), url);
  }

  ///Setting
  ///

  Future<PsResource<ShopInfo>> getShopInfo() async {
    const String url = '$ps_shop_info_url/api_key/$ps_api_key';
    return await getServerCall<ShopInfo, ShopInfo>(ShopInfo(), url);
  }

  ///Blog
  ///

  Future<PsResource<List<Blog>>> getBlogList(int limit, int offset) async {
    final String url =
        '$ps_bloglist_url/api_key/$ps_api_key/limit/$limit/offset/$offset';

    return await getServerCall<Blog, List<Blog>>(Blog(), url);
  }

  ///Transaction
  ///

  Future<PsResource<List<TransactionHeader>>> getTransactionList(
      String userId, int limit, int offset) async {
    final String url =
        '$ps_transactionList_url/api_key/$ps_api_key/user_id/$userId/limit/$limit/offset/$offset';

    return await getServerCall<TransactionHeader, List<TransactionHeader>>(
        TransactionHeader(), url);
  }

  Future<PsResource<List<TransactionDetail>>> getTransactionDetail(
      String id, int limit, int offset) async {
    final String url =
        '$ps_transactionDetail_url/api_key/$ps_api_key/transactions_header_id/$id/limit/$limit/offset/$offset';
    print(url);
    return await getServerCall<TransactionDetail, List<TransactionDetail>>(
        TransactionDetail(), url);
  }

  Future<PsResource<TransactionHeader>> postTransactionSubmit(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '$ps_transaction_submit_url';
    return await postData<TransactionHeader, TransactionHeader>(
        TransactionHeader(), url, jsonMap);
  }

  ///
  /// Comments
  ///
  Future<PsResource<List<CommentHeader>>> getCommentList(
      String productId, int limit, int offset) async {
    final String url =
        '$ps_commentList_url/api_key/$ps_api_key/product_id/$productId/limit/$limit/offset/$offset';

    return await getServerCall<CommentHeader, List<CommentHeader>>(
        CommentHeader(), url);
  }

  Future<PsResource<List<CommentDetail>>> getCommentDetail(
      String headerId, int limit, int offset) async {
    final String url =
        '$ps_commentDetail_url/api_key/$ps_api_key/header_id/$headerId/limit/$limit/offset/$offset';

    return await getServerCall<CommentDetail, List<CommentDetail>>(
        CommentDetail(), url);
  }

  ///
  /// Favourites
  ///
  Future<PsResource<List<Product>>> getFavouritesList(
      String loginUserId, int limit, int offset) async {
    final String url =
        '$ps_favouriteList_url/api_key/$ps_api_key/login_user_id/$loginUserId/limit/$limit/offset/$offset';

    return await getServerCall<Product, List<Product>>(Product(), url);
  }

  ///
  /// Product List By Collection Id
  ///
  Future<PsResource<List<Product>>> getProductListByCollectionId(
      String collectionId, int limit, int offset) async {
    final String url =
        '$ps_all_collection_url/api_key/$ps_api_key/id/$collectionId/limit/$limit/offset/$offset';

    return await getServerCall<Product, List<Product>>(Product(), url);
  }

  Future<PsResource<List<CommentHeader>>> postCommentHeader(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '$ps_commentHeaderPost_url';
    return await postData<CommentHeader, List<CommentHeader>>(
        CommentHeader(), url, jsonMap);
  }

  Future<PsResource<List<CommentDetail>>> postCommentDetail(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '$ps_commentDetailPost_url';
    return await postData<CommentDetail, List<CommentDetail>>(
        CommentDetail(), url, jsonMap);
  }

  Future<PsResource<List<DownloadProduct>>> postDownloadProductList(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '$ps_downloadProductPost_url';
    return await postData<DownloadProduct, List<DownloadProduct>>(
        DownloadProduct(), url, jsonMap);
  }

  Future<PsResource<ApiStatus>> rawRegisterNotiToken(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '$ps_noti_register_url';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  Future<PsResource<ApiStatus>> rawUnRegisterNotiToken(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '$ps_noti_unregister_url';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  Future<PsResource<Noti>> postNoti(Map<dynamic, dynamic> jsonMap) async {
    const String url = '$ps_noti_post_url';
    return await postData<Noti, Noti>(Noti(), url, jsonMap);
  }

  ///
  /// Rating
  ///
  Future<PsResource<Rating>> postRating(Map<dynamic, dynamic> jsonMap) async {
    const String url = '$ps_ratingPost_url';
    return await postData<Rating, Rating>(Rating(), url, jsonMap);
  }

  Future<PsResource<List<Rating>>> getRatingList(
      String productId, int limit, int offset) async {
    final String url =
        '$ps_ratingList_url/api_key/$ps_api_key/product_id/$productId/limit/$limit/offset/$offset';

    return await getServerCall<Rating, List<Rating>>(Rating(), url);
  }

  ///
  ///Favourite
  ///
  Future<PsResource<List<Product>>> getFavouriteList(
      String loginUserId, int limit, int offset) async {
    final String url =
        '$ps_ratingList_url/api_key/$ps_api_key/login_user_id/$loginUserId/limit/$limit/offset/$offset';

    return await getServerCall<Product, List<Product>>(Product(), url);
  }

  Future<PsResource<Product>> postFavourite(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '$ps_favouritePost_url';
    return await postData<Product, Product>(Product(), url, jsonMap);
  }

  ///
  /// Gallery
  ///
  Future<PsResource<List<DefaultPhoto>>> getImageList(
      String parentImgId,
      // String imageType,
      int limit,
      int offset) async {
    final String url =
        '$ps_gallery_url/api_key/$ps_api_key/img_parent_id/$parentImgId/limit/$limit/offset/$offset';

    return await getServerCall<DefaultPhoto, List<DefaultPhoto>>(
        DefaultPhoto(), url);
  }

  ///
  /// Contact
  ///
  Future<PsResource<ApiStatus>> postContactUs(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '$ps_contact_us_url';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// CouponDiscount
  ///
  Future<PsResource<CouponDiscount>> postCouponDiscount(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '$ps_couponDiscount_url';
    return await postData<CouponDiscount, CouponDiscount>(
        CouponDiscount(), url, jsonMap);
  }

  ///
  /// Token
  ///
  Future<PsResource<ApiStatus>> getToken() async {
    const String url = '$ps_token_url/api_key/$ps_api_key';
    return await getServerCall<ApiStatus, ApiStatus>(ApiStatus(), url);
  }
}
