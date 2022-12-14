import 'package:ecommerce_bloc/blocs/product/product_bloc.dart';
import 'package:ecommerce_bloc/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/widgets.dart';
import '../../models/product_model.dart';

class CatalogScreen extends StatelessWidget {
  static const String routeName = '/catalog';

  static Route route({required Category category}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => CatalogScreen(
        category: category,
      ),
    );
  }

  final Category category;

  const CatalogScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: category.name),
      bottomNavigationBar: const CustomNavBar(screen: routeName,),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProductLoaded) {
            final List<Product> categoryProducts = state.products
                .where((product) => product.category == category.name)
                .toList();
            return GridView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 16.0,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.15,
              ),
              itemCount: categoryProducts.length,
              itemBuilder: (context, index) {
                return Center(
                  child: ProductCard.catalog(
                    product: categoryProducts[index],
                   
                  ),
                );
              },
            );
          } else {
            return const Text('Something went worng');
          }
        },
      ),
    );
  }
}
