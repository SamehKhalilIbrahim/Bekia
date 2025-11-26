import 'package:bekia/cubit/auth_cubit/auth_bloc.dart';
import 'package:bekia/cubit/auth_cubit/auth_event.dart';
import 'package:bekia/services/remote/auth_services.dart';
import 'package:bekia/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/ui/themes/theme_model.dart';
import 'cubit/category_cubit/category_cubit.dart';
import 'cubit/hive_cubit/hive_cubit.dart';
import 'cubit/product_cubit/product_cubit_cubit.dart';
import 'core/models/product_model/product_model.dart';
import 'services/constants.dart';
import 'core/ui/themes/app_theme.dart';
import 'services/remote/supabase_config.dart';

void main() async {
  await SupabaseConfig.initialize();
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());

  await Hive.openBox<Product>(HiveConstant.favoritesProductBox);
  await Hive.openBox<Product>(HiveConstant.cartProductBox);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(const MainScreen());
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthBloc(authService: AuthService())..add(LoadCurrentUser()),
        ),

        BlocProvider(
          create: (context) => ProductCubit()..fetchProducts(category: "All"),
        ),
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => CategoryCubit()..fetchCategories()),

        BlocProvider(create: (context) => HiveCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: state.isDark ? ThemeMode.dark : ThemeMode.light,
          home: SplashScreen(),
        ),
      ),
    );
  }
}

extension SizeDevice on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
}

extension ThemeExtension on BuildContext {
  ThemeData get colors => Theme.of(this);
}
