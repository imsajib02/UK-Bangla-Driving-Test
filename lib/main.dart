import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ukbangladrivingtest/database/dbhelper.dart';
import 'package:ukbangladrivingtest/theme/app_theme.dart';
import 'package:ukbangladrivingtest/view_model/answering_choice_view_model.dart';
import 'package:ukbangladrivingtest/view_model/hazard_practise_view_model.dart';
import 'package:ukbangladrivingtest/view_model/highway_code_view_model.dart';
import 'package:ukbangladrivingtest/view_model/home_view_model.dart';
import 'package:ukbangladrivingtest/view_model/mock_test_view_model.dart';
import 'package:ukbangladrivingtest/view_model/question_answer_view_model.dart';
import 'package:ukbangladrivingtest/view_model/question_category_selection_view_model.dart';
import 'package:ukbangladrivingtest/view_model/question_view_model.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:ukbangladrivingtest/view_model/test_result_view_model.dart';
import 'package:ukbangladrivingtest/view_model/theory_progress_view_model.dart';
import 'package:ukbangladrivingtest/view_model/thoery_test_view_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'localization/app_localization.dart';
import 'route/route_manager.dart';
import 'utils/custom_log.dart';
import 'utils/custom_trace.dart';
import 'utils/local_memory.dart';
import 'utils/size_config.dart';


void main() {

  LicenseRegistry.addLicense(() async* {

    final license1 = await rootBundle.loadString('google_fonts/BHS_OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license1);

    final license2 = await rootBundle.loadString('google_fonts/PD_OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license2);

    final license3 = await rootBundle.loadString('google_fonts/POP_OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license3);
  });

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(MyApp());
  });
}


class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale locale) {

    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }
}

class _MyAppState extends State<MyApp> {

  Locale _locale;
  LocalMemory _localMemory;
  DbHelper _dbHelper;


  @override
  void initState() {

    VideoPlayerController.setCacheSize(100 * 1024 * 1024, 200 * 1024 * 1024);

    _localMemory = LocalMemory();
    _dbHelper = DbHelper();
    super.initState();
  }


  @override
  void didChangeDependencies() {

    _localMemory.getLanguageCode().then((locale) {

      setLocale(locale);
    });

    _dbHelper.initDb();

    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (context) => HomeViewModel(),
        ),

        ChangeNotifierProvider(
          create: (context) => TheoryTestViewModel(),
        ),

        ChangeNotifierProvider(
          create: (context) => SettingsViewModel(),
        ),

        ChangeNotifierProvider(
          create: (context) => QuestionCategorySelectionViewModel(),
        ),

        ChangeNotifierProvider(
          create: (context) => AnsweringChoiceViewModel(),
        ),

        ChangeNotifierProvider(
          create: (context) => QuestionAnswerViewModel(),
        ),

        ChangeNotifierProvider(
          create: (context) => TestResultViewModel(),
        ),

        ChangeNotifierProvider(
          create: (context) => QuestionViewModel(),
        ),

        ChangeNotifierProvider(
          create: (context) => MockTestViewModel(),
        ),

        ChangeNotifierProvider(
          create: (context) => HighwayCodeViewModel(),
        ),

        ChangeNotifierProvider(
          create: (context) => TheoryProgressViewModel(),
        ),

        ChangeNotifierProvider(
          create: (context) => HazardPractiseViewModel(),
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {

        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);

            return MaterialApp(
              title: "UK-Bangla Car Driving Test",
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              locale: _locale,
              localizationsDelegates: [
                AppLocalization.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                Locale("en", "US"),
                Locale("bn", "BD"),
              ],
              localeResolutionCallback: (Locale deviceLocale, Iterable<Locale> supportedLocales) {

                for(var locale in supportedLocales) {

                  if(locale.languageCode == deviceLocale.languageCode && locale.countryCode == deviceLocale.countryCode) {

                    return deviceLocale;
                  }
                }

                return supportedLocales.first;
              },
              onGenerateRoute: RouteManager.generate,
              initialRoute: RouteManager.SPLASH_SCREEN_ROUTE,
            );
          },
        );
        },
      ),
    );
  }

  void setLocale(Locale locale) {

    CustomLogger.info(trace: CustomTrace(StackTrace.current), tag: "App Language", message: locale.languageCode);

    setState(() {
      _locale = locale;
    });
  }
}