import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/resources/images.dart';
import 'package:ukbangladrivingtest/route/route_manager.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view_model/mock_test_view_model.dart';
import 'package:ukbangladrivingtest/view_model/question_view_model.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class TheoryMockIntro extends StatefulWidget {

  @override
  _TheoryMockIntroState createState() => _TheoryMockIntroState();
}


class _TheoryMockIntroState extends State<TheoryMockIntro> {

  MockTestViewModel _mockTestViewModel;


  @override
  void didChangeDependencies() {

    _mockTestViewModel = Provider.of<MockTestViewModel>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {

      _mockTestViewModel.removeDisposedStatus();
      _mockTestViewModel.getMockTestQuestions();
    });

    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Builder(
          builder: (BuildContext context) {

            return _body();
          },
        ),
      ),
    );
  }



  Widget _body() {

    return Container(
      child: Column(
        children: <Widget>[

          Expanded(
              flex: 3,
              child: _header()
          ),

          Expanded(
              flex: 5,
              child: _iconView()
          ),

          Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
                  child: Text(AppLocalization.of(context).getTranslatedValue("mock_intro_message"),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.subtitle2.copyWith(fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ),
          ),

          Expanded(
              flex: 4,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  child: Container(
                    height: 6.25 * SizeConfig.heightSizeMultiplier,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 15.38 * SizeConfig.widthSizeMultiplier, right: 15.38 * SizeConfig.widthSizeMultiplier,
                        bottom: 7.5 * SizeConfig.heightSizeMultiplier),
                    decoration: BoxDecoration(
                      color: Colors.lightGreen[700],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(AppLocalization.of(context).getTranslatedValue("start_test"),
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () {
                    Provider.of<SettingsViewModel>(context, listen: false).playSound();
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed(RouteManager.MOCK_TEST_QUESTION_VIEW_ROUTE);
                  },
                ),
              ),
          ),
        ],
      ),
    );
  }



  Container _header() {

    return Container(
        width: double.infinity,
        color: Colors.black87,
        padding: EdgeInsets.only(top: 5 * SizeConfig.heightSizeMultiplier),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Expanded(
              flex: 5,
              child: GestureDetector(
                child: Padding(
                  padding: EdgeInsets.only(left: 5.12 * SizeConfig.widthSizeMultiplier),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 3.84 * SizeConfig.imageSizeMultiplier,
                      child: Icon(Icons.arrow_back, color: Colors.black,),
                    ),
                  ),
                ),
                onTap: () {
                  Provider.of<SettingsViewModel>(context, listen: false).playSound();
                  _onBackPressed();
                },
              ),
            ),

            Expanded(
              flex: 8,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(AppLocalization.of(context).getTranslatedValue("mock_test"),
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headline4.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }



  Container _iconView() {

    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(left: 5.12 * SizeConfig.widthSizeMultiplier, right: 5.12 * SizeConfig.widthSizeMultiplier, top: 12.5 * SizeConfig.heightSizeMultiplier),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(right: 2.56 * SizeConfig.widthSizeMultiplier),
              padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
              decoration: BoxDecoration(
                color: Colors.lime[600],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 4.61 * SizeConfig.imageSizeMultiplier,
                    child: Icon(Icons.timer, size: 5.89 * SizeConfig.imageSizeMultiplier, color: Colors.lime[600],),
                  ),

                  Text(AppLocalization.of(context).getTranslatedValue("57"),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.headline3.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),

                  Text(AppLocalization.of(context).getTranslatedValue("minutes"),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white, fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(left: 1.28 * SizeConfig.widthSizeMultiplier, right: 1.28 * SizeConfig.widthSizeMultiplier),
              padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
              decoration: BoxDecoration(
                color: Colors.teal[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 4.61 * SizeConfig.imageSizeMultiplier,
                    child: Image.asset(Images.questionIcon, width: 5.64 * SizeConfig.widthSizeMultiplier, height: 2.75 * SizeConfig.heightSizeMultiplier, color: Colors.teal[300]),
                  ),

                  Text(AppLocalization.of(context).getTranslatedValue("50"),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.headline3.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),

                  Text(AppLocalization.of(context).getTranslatedValue("questions"),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white, fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(left: 2.56 * SizeConfig.widthSizeMultiplier),
              padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
              decoration: BoxDecoration(
                color: Colors.green[400],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 4.61 * SizeConfig.imageSizeMultiplier,
                    child: Icon(Icons.thumb_up, size: 5.12 * SizeConfig.imageSizeMultiplier, color: Colors.green[400],),
                  ),

                  Text(AppLocalization.of(context).getTranslatedValue("43_50"),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.headline3.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),

                  Text(AppLocalization.of(context).getTranslatedValue("to_pass"),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white, fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  Future<bool> _onBackPressed() {

    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.THEORY_TEST_PAGE_ROUTE);
    return Future(() => false);
  }



  @override
  void dispose() {
    super.dispose();
  }
}