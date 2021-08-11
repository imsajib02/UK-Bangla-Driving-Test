import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/interace/highway_code_interface.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/route/route_manager.dart';
import 'package:ukbangladrivingtest/utils/constants.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view_model/highway_code_view_model.dart';
import 'package:ukbangladrivingtest/view_model/question_view_model.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class HighwayCodeCategory extends StatefulWidget {

  @override
  _HighwayCodeCategoryState createState() => _HighwayCodeCategoryState();
}


class _HighwayCodeCategoryState extends State<HighwayCodeCategory> implements HighwayCodeInterface {

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

    WidgetsBinding.instance.addPostFrameCallback((_) {

      Provider.of<QuestionViewModel>(context, listen: true).getAnsweringLanguage(context);
    });

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
        color: Color(0xFF4682B4),
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
              child: Text(AppLocalization.of(context).getTranslatedValue("highway_code"),
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
                    radius: 3.85 * SizeConfig.imageSizeMultiplier,
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
        itemCount: mounted ? _highwayCodeViewModel.allCategoryList.length : 0,
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(.25 * SizeConfig.heightSizeMultiplier),
        itemBuilder: (BuildContext context, int index) {

          return Column(
            children: <Widget>[

              GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: <Widget>[

                    Expanded(
                      flex: 5,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(1.87 * SizeConfig.heightSizeMultiplier),
                        margin: EdgeInsets.only(bottom: .375 * SizeConfig.heightSizeMultiplier,
                            right: 1.28 * SizeConfig.widthSizeMultiplier, left: 1.28 * SizeConfig.widthSizeMultiplier),
                        child: Text(mounted ? (_questionViewModel.languageID == Constants.questionAnswerLanguageIdList[0] ? _highwayCodeViewModel.allCategoryList[index] :
                        _highwayCodeViewModel.allCategoryListBangla[index]) : "",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.w500, color: Color(0xFF4682B4)),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 1,
                      child: Icon(Icons.arrow_forward_ios, size: 7.69 * SizeConfig.imageSizeMultiplier, color: Color(0xFF4682B4),),
                    ),
                  ],
                ),
                onTap: () {
                  Provider.of<SettingsViewModel>(context, listen: false).playSound();
                  _highwayCodeViewModel.getHighwayCodeDetails(index, _highwayCodeInterface);
                },
              ),

              Container(
                height: 1,
                color: Colors.black38,
              ),
            ],
          );
        },
      ) : Container(child: Center(child: CircularProgressIndicator(),),),
    );
  }


  void _onBackPressed() {
    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.HOME_PAGE_ROUTE);
  }


  @override
  void dispose() {
    super.dispose();
  }


  @override
  void showHighwayContents() {
    Navigator.of(context).pushNamed(RouteManager.HIGHWAY_CODE_DETAILS_PAGE_ROUTE);
  }


  @override
  void scrollToTop() {
  }


  @override
  void showRoadSignContents(int categoryIndex, {int subCategoryIndex}) {
  }
}