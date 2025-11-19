import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'cubit/category_cubit/category_cubit.dart';
import 'cubit/hive_cubit/hive_cubit.dart';
import 'cubit/product_cubit/product_cubit_cubit.dart';
import 'core/models/product_model.dart';
import 'services/constants.dart';
import 'core/ui/themes/app_theme.dart';
import 'views/splash/splash_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  await Hive.openBox<Product>(HiveConstant.favoritesProductBox);
  await Hive.openBox<Product>(HiveConstant.cartProductBox);
  runApp(const MainScreen());
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductCubit()),
        BlocProvider(create: (context) => CategoryCubit()..fetchCategories()),

        BlocProvider(create: (context) => HiveCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.light,
        home: const SplashScreen(),
      ),
    );
  }
}

extension SizeDevice on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
}

extension ColorSchemeExtension on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
}
