import 'package:digitalproductstore/viewobject/product.dart';
import 'package:sembast/sembast.dart';
import 'package:digitalproductstore/db/common/ps_dao.dart' show PsDao;

class BasketDao extends PsDao<Product> {
  BasketDao._() {
    init(Product());
  }
  static const String STORE_NAME = 'Basket';
  final String _primaryKey = 'id';

  // Singleton instance
  static final BasketDao _singleton = BasketDao._();

  // Singleton accessor
  static BasketDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(Product object) {
    return object.id;
  }

  @override
  Filter getFilter(Product object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
