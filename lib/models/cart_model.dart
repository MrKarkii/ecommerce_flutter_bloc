import 'package:ecommerce_bloc/models/product_model.dart';
import 'package:equatable/equatable.dart';

class Cart extends Equatable {
  final List<Product> products;
  const Cart({this.products = const <Product>[]});

  @override
  List<Object?> get props => [products];

//Mapping the cart products to deduplicate the products in the cart

  Map productQuantity(products) {
    var quantity = {};

    products.forEach((product) {
      if (!quantity.containsKey(product)) {
        quantity[product] = 1;
      } else {
        quantity[product] += 1;
      }
    });
    return quantity;
  }

  //Calculations

  double get subTotal =>
      products.fold(0, (total, current) => total + current.price);

  String get subTotalString => subTotal.toStringAsFixed(2);

  double deliveryFee(subTotal) {
    if (subTotal >= 30.0) {
      return 0.0;
    } else {
      return 10.0;
    }
  }

  String get deliveryFeeString => deliveryFee(subTotal).toStringAsFixed(2);

  String freeDelivery(subTotal) {
    if (subTotal >= 30.0) {
      return 'You have free delivery';
    } else {
      double missing = 30.0 - subTotal;
      return 'Add \$${missing.toStringAsFixed(2)} for FREE Delivery';
    }
  }

  String get freeDeliveryString => freeDelivery(subTotal);

  double total(subTotal, deliveryFee) {
    return subTotal + deliveryFee(subTotal);
  }

  String get totalString => total(subTotal, deliveryFee).toStringAsFixed(2);
}
