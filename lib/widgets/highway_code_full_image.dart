import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view_model/highway_code_view_model.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:provider/provider.dart';


class FullImageView extends StatefulWidget {

  final Uint8List _image;

  FullImageView(this._image);

  @override
  _FullImageViewState createState() => _FullImageViewState();
}


class _FullImageViewState extends State<FullImageView> {

  HighwayCodeViewModel _highwayCodeViewModel;


  @override
  void initState() {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    super.initState();
  }



  @override
  void didChangeDependencies() {

    _highwayCodeViewModel = Provider.of<HighwayCodeViewModel>(context);
    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future(() => false);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  color: Color(0xFF4682B4),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 5.12 * SizeConfig.widthSizeMultiplier),
                  child: GestureDetector(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 3.84 * SizeConfig.imageSizeMultiplier,
                      child: Icon(Icons.arrow_back, color: Colors.black,),
                    ),
                    onTap: () {
                      Provider.of<SettingsViewModel>(context, listen: false).playSound();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),

              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.only(top: 2.5 * SizeConfig.heightSizeMultiplier, bottom: 2.5 * SizeConfig.heightSizeMultiplier),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: MemoryImage(widget._image),
                          fit: _highwayCodeViewModel.isRoadSign ? BoxFit.contain : BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  @override
  dispose(){

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }
}