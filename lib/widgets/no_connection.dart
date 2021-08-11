import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/interace/no_connection_interface.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/resources/images.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class NoConnection extends StatefulWidget {

  final NoConnectionInterface _hazardPractiseInterface;

  NoConnection(this._hazardPractiseInterface);

  @override
  _NoConnectionState createState() => _NoConnectionState();
}


class _NoConnectionState extends State<NoConnection> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Expanded(
              flex: 3,
              child: Image.asset(Images.noConnection),
            ),

            Expanded(
              flex: 1,
              child: Text(AppLocalization.of(context).getTranslatedValue("no_internet"),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.headline5.copyWith(color: Colors.red),
                ),
              ),
            ),

            Expanded(
              flex: 1,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 46.15 * SizeConfig.widthSizeMultiplier,
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
                  decoration: BoxDecoration(
                    color: Colors.lightGreen[500],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(AppLocalization.of(context).getTranslatedValue("try_again_btn"),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.white),
                  ),
                ),
                onTap: () {
                  Provider.of<SettingsViewModel>(context, listen: false).playSound();
                  widget._hazardPractiseInterface.tryAgain();
                },
              ),
            ),

            SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier)
          ],
        ),
      ),
    );
  }
}