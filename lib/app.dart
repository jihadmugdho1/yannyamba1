import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'core/bindings/controller_binder.dart';
import 'core/localization/app_localizations.dart';
import 'core/utils/theme/theme.dart';
import 'core/services/deep_link_service.dart';
import 'routes/app_routes.dart';
import 'main_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize deep link service AFTER the first frame
    // This ensures GetX is fully initialized before we try to handle any deep links
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        DeepLinkService().initialize();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoute.getMainScreen(),
          getPages: AppRoute.routes,
          initialBinding: ControllerBinder(),
          themeMode: ThemeMode.light,
          theme: AppTheme.lightTheme,
          translations: AppLocalizations(),
          locale: const Locale('fr', 'FR'),
          fallbackLocale: const Locale('fr', 'FR'),
          // Prevent GetX from trying to handle deep links automatically
          // We'll handle them manually in DeepLinkService
          unknownRoute: GetPage(
            name: '/notfound',
            page: () => const MainScreen(),
          ),
          builder: (context, widget) {
            final mediaQueryData = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQueryData.copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: widget!,
            );
          },
        );
      },
    );
  }
}
