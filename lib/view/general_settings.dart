import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/localization/localization_constrants.dart';
import 'package:ukbangladrivingtest/resources/images.dart';
import 'package:ukbangladrivingtest/route/route_manager.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:ukbangladrivingtest/widgets/header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


//final List<String> _categories = <String>['All Content', 'ADI Question Bank', 'Hazard Videos', 'Stopping Distances', 'Highway Code', 'Highway Code Quiz', 'Road Sings', 'Top 10 Reasons'];
final List<String> _categories = <String>[];
//final List<Color> _categoryColorCodes = <Color>[Colors.black, Colors.green[600], Colors.pink[900], Colors.green[600], Colors.teal[300], Colors.teal[300], Colors.deepOrangeAccent, Colors.deepPurple[300], Colors.black];
final List<Color> _categoryColorCodes = <Color>[];


class GeneralSettings extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _GeneralSettingsState();
  }
}

class _GeneralSettingsState extends State<GeneralSettings> {

  SettingsViewModel _settingsViewModel;


  @override
  Widget build(BuildContext context) {

    _settingsViewModel = Provider.of<SettingsViewModel>(context, listen: true);

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
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
              flex: SizeConfig.isMobilePortrait ? 4 : 6,
              child: Header()
          ),

          Expanded(
              flex: 13,
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                  return;
                },
                child: SingleChildScrollView(
                  child: _mainContent(),
                ),
              )
          ),
        ],
      ),
    );
  }


  Container _mainContent() {

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          Flexible(
            flex: 2,
            child: Container(
              width: double.infinity,
              color: Colors.lightBlue,
              padding: EdgeInsets.all(1.875 * SizeConfig.heightSizeMultiplier),
              alignment: Alignment.center,
              child: Text(AppLocalization.of(context).getTranslatedValue("settings"),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headline3.copyWith(color: Colors.white, fontWeight: FontWeight.w500)
                ),
              ),
            ),
          ),

          Flexible(
            flex: 19,
            child: Column(
              children: <Widget>[

                SizedBox(height: 3.5 * SizeConfig.heightSizeMultiplier),

                Container(
                  alignment: Alignment.center,
                  child: Text(AppLocalization.of(context).getTranslatedValue("language"),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),

                SizedBox(height: 3.5 * SizeConfig.heightSizeMultiplier),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    Flexible(
                      flex: 1,
                      child: Column(
                        children: <Widget>[

                          GestureDetector(
                            child: Container(
                              height: 8 * SizeConfig.heightSizeMultiplier,
                              width: 23.07 * SizeConfig.widthSizeMultiplier,
                              margin: EdgeInsets.only(bottom: 1.25 * SizeConfig.heightSizeMultiplier),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1.28 * SizeConfig.widthSizeMultiplier,
                                      color: _settingsViewModel.isEnglish ? Colors.blue : Colors.transparent)
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: AssetImage(Images.ukFlag), fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            onTap: () {
                              _settingsViewModel.playSound();
                              _settingsViewModel.changeLanguage(context, ENGLISH);
                            },
                          ),

                          Text(AppLocalization.of(context).getTranslatedValue("english"),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.subtitle2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Flexible(
                      flex: 1,
                      child: Column(
                        children: <Widget>[

                          GestureDetector(
                            child: Container(
                              height: 8 * SizeConfig.heightSizeMultiplier,
                              width: 23.07 * SizeConfig.widthSizeMultiplier,
                              margin: EdgeInsets.only(bottom: 1.25 * SizeConfig.heightSizeMultiplier),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1.28 * SizeConfig.widthSizeMultiplier,
                                      color: _settingsViewModel.isEnglish ? Colors.transparent : Colors.blue)
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: AssetImage(Images.bdFlag), fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            onTap: () {
                              _settingsViewModel.playSound();
                              _settingsViewModel.changeLanguage(context, BANGLA);
                            },
                          ),

                          Text(AppLocalization.of(context).getTranslatedValue("bangla"),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.subtitle2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 5 * SizeConfig.heightSizeMultiplier),

                GestureDetector(
                  child: Container(
                      height: 6 * SizeConfig.heightSizeMultiplier,
                      padding: EdgeInsets.only(left: 2.56 * SizeConfig.widthSizeMultiplier),
                      margin: EdgeInsets.only(left: 6.15 * SizeConfig.widthSizeMultiplier, right: 6.15 * SizeConfig.widthSizeMultiplier),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.rectangle,
                      ),
                      child: Stack(
                        children: <Widget>[

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(AppLocalization.of(context).getTranslatedValue("sound"),
                              style: GoogleFonts.poppins(
                                textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white, fontSize: 2 * SizeConfig.textSizeMultiplier),
                              ),
                            ),
                          ),

                          Align(
                            alignment: Alignment.centerRight,
                            child: Switch(
                              activeColor: Colors.lightGreenAccent,
                              value: mounted ? _settingsViewModel.isSoundOn : false,
                              onChanged: (value) {
                                _settingsViewModel.setSoundStatus();
                              },
                            ),
                          ),
                        ],
                      )
                  ),
                  onTap: () => {
                    _settingsViewModel.setSoundStatus(),
                  },
                ),

                SizedBox(height: !SizeConfig.isMobilePortrait ? 5 * SizeConfig.heightSizeMultiplier : 0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}