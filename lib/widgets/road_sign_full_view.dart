import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:provider/provider.dart';


class RoadSignFullView extends StatefulWidget {

  final Uint8List _image;

  RoadSignFullView(this._image);

  @override
  _RoadSignFullViewState createState() => _RoadSignFullViewState();
}


class _RoadSignFullViewState extends State<RoadSignFullView> {


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        return Future(() => false);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[

              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.12 * SizeConfig.widthSizeMultiplier, right: 5.12 * SizeConfig.widthSizeMultiplier),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(image: MemoryImage(widget._image),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Positioned(
                top: 2.5 * SizeConfig.heightSizeMultiplier,
                right: 5.12 * SizeConfig.widthSizeMultiplier,
                child: GestureDetector(
                  child: Icon(Icons.cancel, size: 11.53 * SizeConfig.imageSizeMultiplier, color: Colors.red,
                  ),
                  onTap: () {
                    Provider.of<SettingsViewModel>(context, listen: false).playSound();
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}