// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'product_freezed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$ProductTearOff {
  const _$ProductTearOff();

  _Product call(
      {@required double sellingPrice,
      @required double originalPrice,
      @required int discountPrd,
      @required String sellerUid,
      @required String prdName,
      @required String prdref,
      @required String brand,
      @required String category,
      @required String uploderName,
      @required List<String> images}) {
    return _Product(
      sellingPrice: sellingPrice,
      originalPrice: originalPrice,
      discountPrd: discountPrd,
      sellerUid: sellerUid,
      prdName: prdName,
      prdref: prdref,
      brand: brand,
      category: category,
      uploderName: uploderName,
      images: images,
    );
  }
}

// ignore: unused_element
const $Product = _$ProductTearOff();

mixin _$Product {
  double get sellingPrice;
  double get originalPrice;
  int get discountPrd;
  String get sellerUid;
  String get prdName;
  String get prdref;
  String get brand;
  String get category;
  String get uploderName;
  List<String> get images;

  $ProductCopyWith<Product> get copyWith;
}

abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res>;
  $Res call(
      {double sellingPrice,
      double originalPrice,
      int discountPrd,
      String sellerUid,
      String prdName,
      String prdref,
      String brand,
      String category,
      String uploderName,
      List<String> images});
}

class _$ProductCopyWithImpl<$Res> implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  final Product _value;
  // ignore: unused_field
  final $Res Function(Product) _then;

  @override
  $Res call({
    Object sellingPrice = freezed,
    Object originalPrice = freezed,
    Object discountPrd = freezed,
    Object sellerUid = freezed,
    Object prdName = freezed,
    Object prdref = freezed,
    Object brand = freezed,
    Object category = freezed,
    Object uploderName = freezed,
    Object images = freezed,
  }) {
    return _then(_value.copyWith(
      sellingPrice: sellingPrice == freezed
          ? _value.sellingPrice
          : sellingPrice as double,
      originalPrice: originalPrice == freezed
          ? _value.originalPrice
          : originalPrice as double,
      discountPrd:
          discountPrd == freezed ? _value.discountPrd : discountPrd as int,
      sellerUid: sellerUid == freezed ? _value.sellerUid : sellerUid as String,
      prdName: prdName == freezed ? _value.prdName : prdName as String,
      prdref: prdref == freezed ? _value.prdref : prdref as String,
      brand: brand == freezed ? _value.brand : brand as String,
      category: category == freezed ? _value.category : category as String,
      uploderName:
          uploderName == freezed ? _value.uploderName : uploderName as String,
      images: images == freezed ? _value.images : images as List<String>,
    ));
  }
}

abstract class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) then) =
      __$ProductCopyWithImpl<$Res>;
  @override
  $Res call(
      {double sellingPrice,
      double originalPrice,
      int discountPrd,
      String sellerUid,
      String prdName,
      String prdref,
      String brand,
      String category,
      String uploderName,
      List<String> images});
}

class __$ProductCopyWithImpl<$Res> extends _$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(_Product _value, $Res Function(_Product) _then)
      : super(_value, (v) => _then(v as _Product));

  @override
  _Product get _value => super._value as _Product;

  @override
  $Res call({
    Object sellingPrice = freezed,
    Object originalPrice = freezed,
    Object discountPrd = freezed,
    Object sellerUid = freezed,
    Object prdName = freezed,
    Object prdref = freezed,
    Object brand = freezed,
    Object category = freezed,
    Object uploderName = freezed,
    Object images = freezed,
  }) {
    return _then(_Product(
      sellingPrice: sellingPrice == freezed
          ? _value.sellingPrice
          : sellingPrice as double,
      originalPrice: originalPrice == freezed
          ? _value.originalPrice
          : originalPrice as double,
      discountPrd:
          discountPrd == freezed ? _value.discountPrd : discountPrd as int,
      sellerUid: sellerUid == freezed ? _value.sellerUid : sellerUid as String,
      prdName: prdName == freezed ? _value.prdName : prdName as String,
      prdref: prdref == freezed ? _value.prdref : prdref as String,
      brand: brand == freezed ? _value.brand : brand as String,
      category: category == freezed ? _value.category : category as String,
      uploderName:
          uploderName == freezed ? _value.uploderName : uploderName as String,
      images: images == freezed ? _value.images : images as List<String>,
    ));
  }
}

class _$_Product extends _Product with DiagnosticableTreeMixin {
  const _$_Product(
      {@required this.sellingPrice,
      @required this.originalPrice,
      @required this.discountPrd,
      @required this.sellerUid,
      @required this.prdName,
      @required this.prdref,
      @required this.brand,
      @required this.category,
      @required this.uploderName,
      @required this.images})
      : assert(sellingPrice != null),
        assert(originalPrice != null),
        assert(discountPrd != null),
        assert(sellerUid != null),
        assert(prdName != null),
        assert(prdref != null),
        assert(brand != null),
        assert(category != null),
        assert(uploderName != null),
        assert(images != null),
        super._();

  @override
  final double sellingPrice;
  @override
  final double originalPrice;
  @override
  final int discountPrd;
  @override
  final String sellerUid;
  @override
  final String prdName;
  @override
  final String prdref;
  @override
  final String brand;
  @override
  final String category;
  @override
  final String uploderName;
  @override
  final List<String> images;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Product(sellingPrice: $sellingPrice, originalPrice: $originalPrice, discountPrd: $discountPrd, sellerUid: $sellerUid, prdName: $prdName, prdref: $prdref, brand: $brand, category: $category, uploderName: $uploderName, images: $images)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Product'))
      ..add(DiagnosticsProperty('sellingPrice', sellingPrice))
      ..add(DiagnosticsProperty('originalPrice', originalPrice))
      ..add(DiagnosticsProperty('discountPrd', discountPrd))
      ..add(DiagnosticsProperty('sellerUid', sellerUid))
      ..add(DiagnosticsProperty('prdName', prdName))
      ..add(DiagnosticsProperty('prdref', prdref))
      ..add(DiagnosticsProperty('brand', brand))
      ..add(DiagnosticsProperty('category', category))
      ..add(DiagnosticsProperty('uploderName', uploderName))
      ..add(DiagnosticsProperty('images', images));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Product &&
            (identical(other.sellingPrice, sellingPrice) ||
                const DeepCollectionEquality()
                    .equals(other.sellingPrice, sellingPrice)) &&
            (identical(other.originalPrice, originalPrice) ||
                const DeepCollectionEquality()
                    .equals(other.originalPrice, originalPrice)) &&
            (identical(other.discountPrd, discountPrd) ||
                const DeepCollectionEquality()
                    .equals(other.discountPrd, discountPrd)) &&
            (identical(other.sellerUid, sellerUid) ||
                const DeepCollectionEquality()
                    .equals(other.sellerUid, sellerUid)) &&
            (identical(other.prdName, prdName) ||
                const DeepCollectionEquality()
                    .equals(other.prdName, prdName)) &&
            (identical(other.prdref, prdref) ||
                const DeepCollectionEquality().equals(other.prdref, prdref)) &&
            (identical(other.brand, brand) ||
                const DeepCollectionEquality().equals(other.brand, brand)) &&
            (identical(other.category, category) ||
                const DeepCollectionEquality()
                    .equals(other.category, category)) &&
            (identical(other.uploderName, uploderName) ||
                const DeepCollectionEquality()
                    .equals(other.uploderName, uploderName)) &&
            (identical(other.images, images) ||
                const DeepCollectionEquality().equals(other.images, images)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(sellingPrice) ^
      const DeepCollectionEquality().hash(originalPrice) ^
      const DeepCollectionEquality().hash(discountPrd) ^
      const DeepCollectionEquality().hash(sellerUid) ^
      const DeepCollectionEquality().hash(prdName) ^
      const DeepCollectionEquality().hash(prdref) ^
      const DeepCollectionEquality().hash(brand) ^
      const DeepCollectionEquality().hash(category) ^
      const DeepCollectionEquality().hash(uploderName) ^
      const DeepCollectionEquality().hash(images);

  @override
  _$ProductCopyWith<_Product> get copyWith =>
      __$ProductCopyWithImpl<_Product>(this, _$identity);
}

abstract class _Product extends Product {
  const _Product._() : super._();
  const factory _Product(
      {@required double sellingPrice,
      @required double originalPrice,
      @required int discountPrd,
      @required String sellerUid,
      @required String prdName,
      @required String prdref,
      @required String brand,
      @required String category,
      @required String uploderName,
      @required List<String> images}) = _$_Product;

  @override
  double get sellingPrice;
  @override
  double get originalPrice;
  @override
  int get discountPrd;
  @override
  String get sellerUid;
  @override
  String get prdName;
  @override
  String get prdref;
  @override
  String get brand;
  @override
  String get category;
  @override
  String get uploderName;
  @override
  List<String> get images;
  @override
  _$ProductCopyWith<_Product> get copyWith;
}
