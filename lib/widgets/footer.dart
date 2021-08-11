import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/route/route_manager.dart';
import 'package:ukbangladrivingtest/utils/constants.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'dart:io' show Platform;
import '../utils/size_config.dart';

class Footer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      height: 15 * SizeConfig.heightSizeMultiplier,
      alignment: Alignment.center,
      color: Colors.black,
      child: Row(
        children: <Widget>[

          Expanded(
              flex: 1,
              child: GestureDetector(
                child: Container(
                  child: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 10 * SizeConfig.imageSizeMultiplier,
                  ),
                ),
                onTap: () {
                  Provider.of<SettingsViewModel>(context, listen: false).playSound();
                  Navigator.of(context).pushNamed(RouteManager.SETTINGS_PAGE_ROUTE);
                },
              )
          ),
          Expanded(
              flex: 1,
              child: GestureDetector(
                child: Container(
                  child: Icon(
                    Icons.share,
                    color: Colors.white,
                    size: 10 * SizeConfig.imageSizeMultiplier,
                  ),
                ),
                onTap: () {

                  Provider.of<SettingsViewModel>(context, listen: false).playSound();

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
}