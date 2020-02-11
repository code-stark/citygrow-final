import 'package:digitalproductstore/db/common/ps_dao.dart';
import 'package:digitalproductstore/viewobject/purchased_product.dart';
import 'package:sembast/sembast.dart';

class PurchasedProductDao extends PsDao<PurchasedProduct> {
  PurchasedProductDao._() {
    init(PurchasedProduct());
  }

  static const String STORE_NAME = 'PurchasedProduct';
  final String _primaryKey = 'id';

  // Singleton instance
  static final PurchasedProductDao _singleton = PurchasedProductDao._();

  // Singleton accessor
  static PurchasedProductDao get instance => _singleton;

  @override
  Filter getFilter(PurchasedProduct object) {
    return Filter.equals(_primaryKey, object.id);
  }

  @override
  String getPrimaryKey(PurchasedProduct object) {
    return object.id;
  }

  @override
  String getStoreName() {
    return STORE_NAME;
  }
}
