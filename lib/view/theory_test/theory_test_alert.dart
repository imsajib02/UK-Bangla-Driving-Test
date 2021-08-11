import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/route/route_manager.dart';
import 'package:ukbangladrivingtest/utils/local_memory.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class ThoeryTestAlert extends StatelessWidget {

  LocalMemory _localMemory = LocalMemory();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(left: 4.10 * SizeConfig.widthSizeMultiplier, top: 6.25 * SizeConfig.heightSizeMultiplier,
          right: 4.10 * SizeConfig.widthSizeMultiplier, bottom: 4 * SizeConfig.heightSizeMultiplier),
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          border: Border.all(color: Colors.black, width: 1.02 * SizeConfig.widthSizeMultiplier, style: BorderStyle.solid)
      ),

      child: Column(
        children: <Widget>[

          Expanded(
            flex: 1,
            child: Container(
              child: Stack(
                children: <Widget>[

                  Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.feedback,
                      color: Colors.lightGreen[500],
                      size: 10 * SizeConfig.imageSizeMultiplier,
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.all(.625 * SizeConfig.heightSizeMultiplier),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.grey,
                          size: 7 * SizeConfig.imageSizeMultiplier,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              )
            )
          ),

          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.topCenter,
              child: Text(
                AppLocalization.of(context).getTranslatedValue("theory_test_entry_alert"),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.all(2 * SizeConfig.heightSizeMultiplier),
              alignment: Alignment.topCenter,
              child: Text(AppLocalization.of(context).getTranslatedValue("theory_test_entry_message"),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.subtitle2.copyWith(wordSpacing: .385 * SizeConfig.widthSizeMultiplier, height: .1875 * SizeConfig.heightSizeMultiplier),
                ),
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[

                  SizedBox(
                    width: 51.28 * SizeConfig.widthSizeMultiplier,
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.lightGreen[700],
                      child: Container(
                        child: Text(AppLocalization.of(context).getTranslatedValue("continue"),
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white, fontSize: 1.5 * SizeConfig.textSizeMultiplier)
                            )
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(.625 * SizeConfig.heightSizeMultiplier),
                      ),
                      onPressed: () {
                        Provider.of<SettingsViewModel>(context, listen: false).playSound();
                        Navigator.of(context).pushNamed(RouteManager.THEORY_TEST_PAGE_ROUTE);
                      },
                    ),
                  ),

                  SizedBox(
                    width: 51.28 * SizeConfig.widthSizeMultiplier,
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.lightGreen[700],
                      child: Container(
                        child: Text(AppLocalization.of(context).getTranslatedValue("do_not_show_again"),
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white, fontSize: 1.5 * SizeConfig.textSizeMultiplier)
                            )
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(.625 * SizeConfig.heightSizeMultiplier),
                      ),
                      onPressed: () {
                        Provider.of<SettingsViewModel>(context, listen: false).playSound();
                        _localMemory.setTheoryTestAlertShow(false);
                        Navigator.of(context).pushNamed(RouteManager.THEORY_TEST_PAGE_ROUTE);
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}