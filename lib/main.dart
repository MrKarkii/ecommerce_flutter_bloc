import 'package:ecommerce_bloc/config/app_router.dart';
import 'package:ecommerce_bloc/config/theme.dart';
import 'package:ecommerce_bloc/repositories/category/category_repository.dart';
import 'package:ecommerce_bloc/repositories/checkout/checkout_repository.dart';
import 'package:ecommerce_bloc/repositories/local_storage_repository/local_storage_repository.dart';
import 'package:ecommerce_bloc/repositories/product/product_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'blocs/blocs.dart';
import 'firebase_options.dart';
import 'models/product_model.dart';
import 'screens/screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => WishlistBloc(
            localStorageRepository: LocalStorageRepository(),
          )..add(StartWishlist()),
        ),
        BlocProvider(
          create: (_) => CartBloc()..add(CartStarted()),
        ),
        BlocProvider(
          create: (_) => CategoryBloc(
            categoryRepository: CategoryRepository(),
          )..add(LoadCategories()),
        ),
        BlocProvider(
          create: (_) => ProductBloc(
            productRepository: ProductRepository(),
          )..add(LoadProducts()),
        ),
        BlocProvider(
          create: (context) => CheckoutBloc(
            cartBloc: context.read<CartBloc>(),
            checkoutRepository: CheckoutRepository(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: theme(),
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: SplashScreen.routeName,
        //home: const HomeScreen(),
      ),
    );
  }
}
