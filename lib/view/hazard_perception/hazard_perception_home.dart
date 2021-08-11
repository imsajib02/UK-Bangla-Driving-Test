import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/resources/images.dart';
import 'package:ukbangladrivingtest/route/route_manager.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view_model/hazard_practise_view_model.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:ukbangladrivingtest/widgets/footer.dart';
import 'package:ukbangladrivingtest/widgets/header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';


final List<String> _items = <String>['INTRODUCTION', 'PRACTISE', 'PROGRESS', 'MOCK TEST', 'MORE CLIPS', 'PRACTICAL DRIVING LESSONS'];
final List<String> _itemsBangla = <String>['ভূমিকা', 'অনুশীলন', 'অগ্রগতি', 'মক পরীক্ষা', 'আরও ক্লিপস', 'ব্যবহারিক ড্রাইভিং পাঠ'];

final List<Widget> _itemIcons = <Widget>[Icon(Icons.movie, color: Colors.white, size: 10.25 * SizeConfig.imageSizeMultiplier,), Transform(alignment: Alignment.center, transform: Matrix4.rotationY(math.pi), child: Icon(Icons.call_made, color: Colors.white, size: 10.25 * SizeConfig.imageSizeMultiplier,),),
  Icon(Icons.insert_chart, color: Colors.white, size: 10.25 * SizeConfig.imageSizeMultiplier,), Icon(Icons.timer, color: Colors.white, size: 10.25 * SizeConfig.imageSizeMultiplier,), Icon(Icons.file_download, color: Colors.white, size: 10.25 * SizeConfig.imageSizeMultiplier,),
  Image.asset(Images.steeringIcon, color: Colors.white, height: 5 * SizeConfig.heightSizeMultiplier, width: 10.25 * SizeConfig.widthSizeMultiplier,)];



class HazardPerceptionHome extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HazardPerceptionPage();
  }
}

class _HazardPerceptionPage extends State<HazardPerceptionHome> {

  SettingsViewModel _settingsViewModel;


  @override
  void initState() {

//    SystemChrome.setPreferredOrientations([
//      DeviceOrientation.landscapeRight,
//      DeviceOrientation.landscapeLeft,
//    ]);

    super.initState();
  }


  @override
  void didChangeDependencies() {

    _settingsViewModel = Provider.of<SettingsViewModel>(context);

    Provider.of<HazardPractiseViewModel>(context, listen: false).getStoredHazardClips();
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
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
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          Visibility(
            visible: false,
            child: Expanded(
                flex: 4,
                child: Header()
            ),
          ),

          Expanded(
            flex: 6,
            child: Container(
              alignment: Alignment.center,
              color: Colors.red,
              padding: EdgeInsets.only(top: 3.75 * SizeConfig.heightSizeMultiplier),
              child: Text(AppLocalization.of(context).getTranslatedValue("hazard_perception_title"),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.headline1.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),

          Expanded(
            flex: 15,
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                child: Container(
                  width: 180,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      Flexible(
                        flex: 2,
                        child: _itemIcons[1],
                      ),

                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(top: 1.25 * SizeConfig.heightSizeMultiplier),
                          child: Text(_settingsViewModel.isEnglish ? _items[1] : _itemsBangla[1],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                Provider.of<SettingsViewModel>(context, listen: false).playSound();
                _onSelected(1);
              },
            ),
          ),

          Expanded(
              flex: 2,
              child: Footer()
          ),
        ],
      ),
    );
  }


  GridView _gridView() {

    return GridView.builder(
      itemCount: _items.length,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: _items.length, crossAxisSpacing: 6.25 * SizeConfig.heightSizeMultiplier),
      itemBuilder: (BuildContext context, int index) {

        return GestureDetector(
          child: Container(
            margin: EdgeInsets.only(bottom: 8.75 * SizeConfig.heightSizeMultiplier),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Flexible(
                  flex: 2,
                  child: _itemIcons[index],
                ),

                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(top: 1.25 * SizeConfig.heightSizeMultiplier),
                    child: Text(_settingsViewModel.isEnglish ? _items[index] : _itemsBangla[index],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Provider.of<SettingsViewModel>(context, listen: false).playSound();
            _onSelected(index);
          },
        );
      },
    );
  }


  Container _footer() {

    return Container(
      alignment: Alignment.center,
      color: Colors.black,
      child: Row(
        children: <Widget>[

          Expanded(
              flex: 1,
              child: GestureDetector(
                child: Container(
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: 10.25 * SizeConfig.imageSizeMultiplier,
                  ),
                ),
              )
          ),

          Expanded(
              flex: 1,
              child: GestureDetector(
                child: Container(
                  child: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 10.25 * SizeConfig.imageSizeMultiplier,
                  ),
                ),
              )
          ),

          Expanded(
              flex: 1,
              child: GestureDetector(
                child: Container(
                  child: Icon(
                    Icons.star_border,
                    color: Colors.white,
                    size: 10.25 * SizeConfig.imageSizeMultiplier,
                  ),
                ),
              )
          ),

          Expanded(
              flex: 1,
              child: GestureDetector(
                child: Container(
                  child: Icon(
                    Icons.share,
                    color: Colors.white,
                    size: 10.25 * SizeConfig.imageSizeMultiplier,
                  ),
                ),
              )
          ),

          Expanded(
              flex: 1,
              child: GestureDetector(
                child: Container(
                  child: Icon(
                    Icons.local_offer,
                    color: Colors.white,
                    size: 10.25 * SizeConfig.imageSizeMultiplier,
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }


  void _onSelected(int index) {

    switch (index) {

      case 0:
        Navigator.of(context).pushNamed(RouteManager.HAZARD_INTRODUCTION_PAGE_ROUTE);
        break;

      case 1:
        Navigator.of(context).pushNamed(RouteManager.HAZARD_PRACTISE_PAGE_ROUTE);
        break;

      case 2:
        break;

      case 3:
        break;

      case 4:
        break;

      case 5:
        break;
    }
  }


  @override
  dispose(){

//    SystemChrome.setPreferredOrientations([
//      DeviceOrientation.portraitUp,
//      DeviceOrientation.portraitDown,
//    ]);

    super.dispose();
  }
}