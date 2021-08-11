import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/resources/images.dart';
import 'package:google_fonts/google_fonts.dart';

import '../localization/app_localization.dart';
import '../utils/size_config.dart';

class Header extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 15 * SizeConfig.heightSizeMultiplier,
      padding: EdgeInsets.only(top: 6.25 * SizeConfig.heightSizeMultiplier, left: 7.69 * SizeConfig.widthSizeMultiplier, right: 7.69 * SizeConfig.widthSizeMultiplier,
          bottom: 2.5 * SizeConfig.heightSizeMultiplier),
      color: Colors.black,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          Expanded(
            flex: 5,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Expanded(
                  flex: 2,
                  child: Text("UK DRIVING TEST",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.palanquinDark(
                      textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 4.375 * SizeConfig.textSizeMultiplier, color: Colors.white),
                    )
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Text("English / Bengali",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.palanquinDark(
                      textStyle: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: double.infinity,
                height: 10 * SizeConfig.heightSizeMultiplier,
                margin: EdgeInsets.only(top: 1.25 * SizeConfig.heightSizeMultiplier, right: 2.56 * SizeConfig.widthSizeMultiplier),
                alignment: Alignment.center,
                color: Colors.white,
                child: Text("L",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.blackHanSans(
                    textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 7.5 * SizeConfig.heightSizeMultiplier, color: Colors.red),
                  )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}