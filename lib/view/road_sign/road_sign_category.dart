import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/interace/highway_code_interface.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/model/road_sign_constructor_model.dart';
import 'package:ukbangladrivingtest/route/route_manager.dart';
import 'package:ukbangladrivingtest/utils/constants.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view_model/highway_code_view_model.dart';
import 'package:ukbangladrivingtest/view_model/question_view_model.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class RoadSignCategory extends StatefulWidget {

  @override
  _RoadSignCategoryState createState() => _RoadSignCategoryState();
}


class _RoadSignCategoryState extends State<RoadSignCategory> implements HighwayCodeInterface {

  HighwayCodeViewModel _highwayCodeViewModel;
  QuestionViewModel _questionViewModel;

  HighwayCodeInterface _highwayCodeInterface;


  @override
  void initState() {
    _highwayCodeInterface = this;
    super.initState();
  }


  @override
  void didChangeDependencies() {

    _highwayCodeViewModel = Provider.of<HighwayCodeViewModel>(context);
    _questionViewModel = Provider.of<QuestionViewModel>(context);

    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {

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
        color: Colors.lightBlue[400],
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
                  radius: 3.84 * SizeConfig.imageSizeMultiplier,
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
              child: Text(AppLocalization.of(context).getTranslatedValue("select_category"),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: Visibility(
                visible: true,
                child: GestureDetector(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 3.84 * SizeConfig.imageSizeMultiplier,
                    child: Text(mounted ? _questionViewModel.language : "",
                      style: Theme.of(context).textTheme.subtitle2,),
                  ),
                  onTap: () {
                    Provider.of<SettingsViewModel>(context, listen: false).playSound();
                    _questionViewModel.alterLanguage(context);
                  },
                ),
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
      child: mounted ? ListView.builder(
        itemCount: Constants.roadSignCategoryList.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              margin: EdgeInsets.only(left: 5.12 * SizeConfig.widthSizeMultiplier, right: 5.12 * SizeConfig.widthSizeMultiplier, bottom: 3.125 * SizeConfig.heightSizeMultiplier),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: <Widget>[

                  Expanded(
                    flex: 5,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(1.5 * SizeConfig.heightSizeMultiplier),
                      child: Text(_questionViewModel.languageID == Constants.questionAnswerLanguageIdList[0] ? Constants.roadSignCategoryList[index] :
                      Constants.roadSignCategoryListBangla[index],
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Icon(Icons.arrow_forward_ios, size: 6.41 * SizeConfig.imageSizeMultiplier, color: Colors.white,),
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
      ) : Container(child: Center(child: CircularProgressIndicator(),),),
    );
  }


  void _onSelected(int index) {

    if(Constants.roadSignSubCategoryList[index].length > 0) {

      Navigator.of(context).pushNamed(RouteManager.ROAD_SIGN_SUB_CATEGORY_PAGE_ROUTE, arguments: index);
    }
    else {

      _highwayCodeViewModel.filterRoadSigns(index, _highwayCodeInterface);
    }
  }


  void _onBackPressed() {
    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.ROAD_SIGNS_PAGE_ROUTE);
  }


  @override
  void dispose() {
    super.dispose();
  }


  @override
  void scrollToTop() {
  }


  @override
  void showHighwayContents() {
  }


  @override
  void showRoadSignContents(int categoryIndex, {int subCategoryIndex}) {

    RoadSignConstructor constructor = RoadSignConstructor(categoryIndex);
    Navigator.of(context).pushNamed(RouteManager.ROAD_SIGN_VIEW_PAGE_ROUTE, arguments: constructor);
  }
}