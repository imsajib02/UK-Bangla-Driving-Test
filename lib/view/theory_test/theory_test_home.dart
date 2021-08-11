import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/route/route_manager.dart';
import 'package:ukbangladrivingtest/utils/constants.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view_model/question_view_model.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:ukbangladrivingtest/view_model/thoery_test_view_model.dart';
import 'package:ukbangladrivingtest/widgets/footer.dart';
import 'package:ukbangladrivingtest/widgets/header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'dart:io' show Platform;


final List<String> _categories = <String>['Read All Chapter', 'Practise All Questions', 'Mock Test', 'Search Questions', 'My Questions', 'Progress Monitor', 'Stopping Distances', 'Help & Support', 'Offers & Rewards'];
final List<String> _categoriesBangla = <String>['সমস্ত অধ্যায় পড়ুন', 'সমস্ত প্রশ্ন অনুশীলন', 'মক পরীক্ষা', 'প্রশ্ন অনুসন্ধান', 'আমার প্রশ্নগুলো', 'অগ্রগতি মনিটর', 'থামার দূরত্ব ', 'সাহায্য সহযোগীতা', 'অফার এবং পুরষ্কার'];
final List<IconData> _categoryIcons = <IconData>[Icons.call_made, Icons.timer, Icons.search, Icons.favorite, Icons.assessment, Icons.swap_horiz, Icons.help, Icons.star];


class TheoryTestHome extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return TheoryTestHomeState();
  }
}

class TheoryTestHomeState extends State<TheoryTestHome> {

  TheoryTestViewModel _theoryTestViewModel;
  SettingsViewModel _settingsViewModel;


  @override
  Widget build(BuildContext context) {

    _theoryTestViewModel  = Provider.of<TheoryTestViewModel>(context);
    _settingsViewModel = Provider.of<SettingsViewModel>(context);

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushNamed(RouteManager.HOME_PAGE_ROUTE);
        return Future.value(false);
      },
      child: Scaffold(
        body: _body(),
      ),
    );
  }


  Widget _body() {

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          Expanded(
              flex: 5,
              child: Header()
          ),

          Expanded(
              flex: 17,
            child: _mainContent()
          ),

//          Expanded(
//              flex: 2,
//              child: Footer()
//          ),
        ],
      ),
    );
  }


  Container _mainContent() {

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          Visibility(
            visible: false,
            child: Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                color: Colors.green,
                padding: EdgeInsets.all(1.5 * SizeConfig.heightSizeMultiplier),
                alignment: Alignment.bottomCenter,
                child: Text(AppLocalization.of(context).getTranslatedValue("theory_test_title"),
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headline3.copyWith(color: Colors.white, fontWeight: FontWeight.w500)
                  ),
                ),
              ),
            ),
          ),

          GestureDetector(
            child: Visibility(
              visible: false,
              child: Container(
                  height: 5.5 * SizeConfig.heightSizeMultiplier,
                  padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
                  margin: EdgeInsets.only(top: 5 * SizeConfig.heightSizeMultiplier, left: 4.10 * SizeConfig.widthSizeMultiplier,
                      right: 4.10 * SizeConfig.widthSizeMultiplier, bottom: 1 * SizeConfig.heightSizeMultiplier),
                  decoration: BoxDecoration(
                    color: Colors.orange[500],
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Stack(
                    children: <Widget>[

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(AppLocalization.of(context).getTranslatedValue("activate_pass_guarantee_mode"),
                          style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 7.69 * SizeConfig.widthSizeMultiplier,
                          padding: EdgeInsets.all(.375 * SizeConfig.heightSizeMultiplier),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(
                            _theoryTestViewModel.isPassGuaranteeModeOn ? AppLocalization.of(context).getTranslatedValue("on") : AppLocalization.of(context).getTranslatedValue("off"),
                            style: Theme.of(context).textTheme.bodyText1,textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ),
            onTap: () => {

            },
          ),

          Expanded(
            flex: 10,
            child: Container(
              alignment: Alignment.center,
              child: _listView(),
            ),
          )
        ],
      ),
    );
  }


  ListView _listView() {

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: _categories.length-3,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {

        return GestureDetector(
          child: Container(
              padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
              margin: EdgeInsets.only(bottom: 4 * SizeConfig.heightSizeMultiplier, left: 4.10 * SizeConfig.widthSizeMultiplier, right: 4.10 * SizeConfig.widthSizeMultiplier),
              decoration: BoxDecoration(
                color: Colors.lightGreen[500],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        Text(_categories[index],
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                          ),
                        ),

                        SizedBox(height: 5,),

                        Text(_categoriesBangla[index],
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(_categoryIcons[index], color: Colors.white,),
                  ),
                ],
              )
          ),
          onTap: () {

            Provider.of<SettingsViewModel>(context, listen: false).playSound();
            _onSelected(index);
          },
        );
      },
    );
  }


  void _onSelected(int index) {

    switch (index) {

      case 0:
        Navigator.pop(context);
        Navigator.of(context).pushNamed(RouteManager.CHAPTER_SELECTION);
        break;

      case 1:
        Navigator.pop(context);
        Navigator.of(context).pushNamed(RouteManager.QUESTION_CATEGORY_SELECTION_PAGE_ROUTE);
        break;

      case 2:
        Navigator.pop(context);
        Navigator.of(context).pushNamed(RouteManager.MOCK_TEST_INTRO_ROUTE);
        break;

      case 3:
        Navigator.pop(context);
        Navigator.of(context).pushNamed(RouteManager.QUESTION_SEARCH_PAGE_ROUTE);
        break;

      case 4:
        //Navigator.pop(context);
        Navigator.of(context).pushNamed(RouteManager.FAV_QUESTION_VIEW_ROUTE);
        break;

      case 5:
        Navigator.pop(context);
        Navigator.of(context).pushNamed(RouteManager.PROGRESS_MONITOR_PAGE_ROUTE);
        break;
    }
  }


  Container _footer() {

    return Container(
      width: double.infinity,
      height: 15 * SizeConfig.heightSizeMultiplier,
      alignment: Alignment.center,
      color: Colors.black,
      child: Row(
        children: <Widget>[

          Visibility(
            visible: false,
            child: Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: 7.69 * SizeConfig.imageSizeMultiplier,
                    ),
                  ),
                )
            ),
          ),

          Expanded(
              flex: 1,
              child: GestureDetector(
                child: Container(
                  child: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 7.69 * SizeConfig.imageSizeMultiplier,
                  ),
                ),
              )
          ),

          Visibility(
            visible: false,
            child: Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    child: Icon(
                      Icons.star_border,
                      color: Colors.white,
                      size: 7.69 * SizeConfig.imageSizeMultiplier,
                    ),
                  ),
                )
            ),
          ),

          Expanded(
              flex: 1,
              child: GestureDetector(
                child: Container(
                  child: Icon(
                    Icons.share,
                    color: Colors.white,
                    size: 7.69 * SizeConfig.imageSizeMultiplier,
                  ),
                ),
                onTap: () {

                  if(Platform.isAndroid) {
                    Share.share(Constants.playStoreUrl);
                  }
                  else if(Platform.isIOS) {
                    Share.share(Constants.appStoreUrl);
                  }
                },
              )
          ),
        ],
      ),
    );
  }


  @override
  void dispose() {
    super.dispose();
  }
}