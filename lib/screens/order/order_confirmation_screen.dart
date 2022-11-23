import 'package:ecommerce_bloc/models/product_model.dart';

import 'package:ecommerce_bloc/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OrderConfirmation extends StatelessWidget {
  static const String routeName = '/order-confirmation';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const OrderConfirmation(),
    );
  }

  const OrderConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Order Confirmation'),
      bottomNavigationBar: const CustomNavBar(screen: routeName),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  color: Colors.black,
                  width: double.infinity,
                  height: 300,
                ),
                Positioned(
                  left: (MediaQuery.of(context).size.width - 100) / 2,
                  top: 125,
                  child: SvgPicture.asset(
                    'lib/assets/svgs/garlands.svg',
                  ),
                ),
                Positioned(
                  top: 250,
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'Your order is complete',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order code : 443556',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Thank you for purchasing',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Order code : #464784',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const OrderSummary(),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Order Details',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    children:  [
                       ProductCard.summary(
                        product: Product.products[0],
                        quantity: 2,
                       ),
                            ProductCard.summary(
                        product: Product.products[1],
                        quantity: 2,
                       ),
                             ProductCard.summary(
                        product: Product.products[1],
                        quantity: 2,
                       ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

