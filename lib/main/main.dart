import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wallet/core/constants/app_routes.dart';
import 'package:wallet/core/constants/theme/AppTheme.dart';
import 'package:wallet/core/providers/LocaleNotifier.dart';
import 'package:wallet/core/utils/LocalData.dart';

void main() => runApp(
  MultiProvider(providers: [ 
    /*
     If is created a new provider, set in this array depends if 
     is ChangeNotifierProvider, only Provider, etc
    */
    ChangeNotifierProvider(create: (context) => LocaleNotifier())
  ],
  child: const MyApp())
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late LocaleNotifier _localeNotifierProv; 
  Locale _locale = const Locale("en");

  @override
  void initState() {
    super.initState();
    _getNewLocale();
    _localeNotifierProv = context.read<LocaleNotifier>();
    _localeNotifierProv.addListener(_getNewLocale);
  }

  void _getNewLocale() async {
    Locale locale = Locale(await LocalData.get("locale"));
    setState(() => _locale = locale);
  } 

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRoutes.pages,
      title: 'Osma Wallet',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale("en"),
        Locale("es"),
      ],
      locale: _locale,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.of(context).primary),
        brightness: Brightness.light,
        useMaterial3: true,
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: AppTheme.of(context).bgOfBottomSheet
        )
      ),
      darkTheme: ThemeData(
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: AppTheme.of(context).bgOfBottomSheet
        ),
        brightness: Brightness.dark,
        colorSchemeSeed: AppTheme.of(context).primary,
      ),
      themeMode: AppTheme.themeMode,
    );
  }
}