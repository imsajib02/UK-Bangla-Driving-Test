import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/route/route_manager.dart';
import 'package:ukbangladrivingtest/utils/constants.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

final List<Color> _categoryColorCodes = <Color>[Colors.lightGreen[500], Colors.deepOrangeAccent, Colors.pink[800], Colors.purple[700], Colors.deepPurple, Colors.indigo[800], Colors.lightBlue, Colors.green[800],
  Colors.lightGreen[400], Colors.deepOrangeAccent, Colors.pink[800], Colors.purple[700], Colors.deepPurple, Colors.indigo[800], Colors.lightBlue];

class ChapterSelection extends StatefulWidget {

  @override
  _ChapterSelectionState createState() => _ChapterSelectionState();
}


class _ChapterSelectionState extends State<ChapterSelection> {

  SettingsViewModel _settingsViewModel;


  @override
  Widget build(BuildContext context) {

    _settingsViewModel = Provider.of<SettingsViewModel>(context, listen: true);

    return WillPopScope(
      onWillPop: () {

        _onBackPressed();
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
              flex: 2,
              child: _header()
          ),

          Expanded(
              flex: 10,
              child: mounted ? _listView() : Container()
          ),
        ],
      ),
    );
  }


  Container _header() {

    return Container(
        width: double.infinity,
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(bottom: 4.375 * SizeConfig.heightSizeMultiplier),
        color: Colors.black87,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[

            Expanded(
              flex: 2,
              child: GestureDetector(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 3.85 * SizeConfig.imageSizeMultiplier,
                  child: Icon(Icons.arrow_back, color: Colors.black,),
                ),
                onTap: () {
                  Provider.of<SettingsViewModel>(context, listen: false).playSound();
                  _onBackPressed();
                },
              ),
            ),

            Expanded(
              flex: 5,
              child: Text(AppLocalization.of(context).getTranslatedValue("chapter_wise_theory"),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: Visibility(
                visible: false,
                child: Container(),
              ),
            ),
          ],
        )
    );
  }


  NotificationListener _listView() {

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowGlow();
        return;
      },
      child: ListView.builder(
        itemCount: Constants.categories.length-1,
        itemBuilder: (BuildContext context, int index) {

          String number = "";

          if(_settingsViewModel.isEnglish) {

            number = (index + 1).toString();
          }
          else {

            number = _translateNumber(index + 1);
          }

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.only(top: 1.875 * SizeConfig.heightSizeMultiplier),
                  child: Container(
                      padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
                      margin: EdgeInsets.only(bottom: 4 * SizeConfig.heightSizeMultiplier, left: 4.10 * SizeConfig.widthSizeMultiplier, right: 4.10 * SizeConfig.widthSizeMultiplier),
                      decoration: BoxDecoration(
                        color: _categoryColorCodes[index + 1],
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top: 1.35 * SizeConfig.heightSizeMultiplier),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              Text(Constants.categories[index + 1],
                                style: GoogleFonts.poppins(
                                  textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                                ),
                              ),

                              SizedBox(height: .625 * SizeConfig.heightSizeMultiplier,),

                              Text(Constants.categoriesBangla[index + 1],
                                style: GoogleFonts.poppins(
                                  textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  ),
                ),

                Positioned(
                  right: 7.69 * SizeConfig.widthSizeMultiplier,
                  child: Container(
                    height: 3.75 * SizeConfig.heightSizeMultiplier,
                    padding: EdgeInsets.only(left: 2.56 * SizeConfig.widthSizeMultiplier,
                        right: 2.56 * SizeConfig.widthSizeMultiplier),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(AppLocalization.of(context).getTranslatedValue("chapter") + ":  " + number,
                      style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {

              Provider.of<SettingsViewModel>(context, listen: false).playSound();
              //_onSelected(index);
            },
          );
        },
      ),
    );
  }


  void _onBackPressed() {
    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.THEORY_TEST_PAGE_ROUTE);
  }


  @override
  void dispose() {
    super.dispose();
  }


  String _translateNumber(int number) {

    String inBangla = "";

    for(int i=0; i<number.toString().length; i++) {

      for(int j=0; j<Constants.englishNumeric.length; j++) {

        if(number.toString()[i] == Constants.englishNumeric[j]) {

          inBangla = inBangla + Constants.banglaNumeric[j];
          break;
        }
      }
    }

    return inBangla;
  }
}