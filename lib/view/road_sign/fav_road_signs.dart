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


class FavRoadSigns extends StatefulWidget {

  @override
  _FavRoadSignsState createState() => _FavRoadSignsState();
}


class _FavRoadSignsState extends State<FavRoadSigns> implements HighwayCodeInterface {

  HighwayCodeViewModel _highwayCodeViewModel;
  HighwayCodeInterface _highwayCodeInterface;

  Widget _favSignBody;


  @override
  void initState() {

    _highwayCodeInterface = this;
    _favSignBody = Container();

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
              child: mounted ? _gridView() : Container()
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
              child: Text(AppLocalization.of(context).getTranslatedValue("fav_sign"),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                ),
              ),
            ),

            Expanded(
                flex: 2,
                child: Container()
            ),
          ],
        )
    );
  }


  NotificationListener _gridView() {

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowGlow();
        return;
      },
      child: mounted ? Container(
        padding: EdgeInsets.only(left: 5.12 * SizeConfig.widthSizeMultiplier, right: 5.12 * SizeConfig.widthSizeMultiplier),
        child: GridView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: _highwayCodeViewModel.favRoadSignList.list.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, crossAxisSpacing: 1.28 * SizeConfig.widthSizeMultiplier,
              mainAxisSpacing: .625 * SizeConfig.heightSizeMultiplier),
          itemBuilder: (BuildContext context, int index) {

            return _highwayCodeViewModel.favRoadSignList.list[index].hasImage ? GestureDetector(
              onTap: () {
                Provider.of<SettingsViewModel>(context, listen: false).playSound();
                _highwayCodeViewModel.onRoadSignSelected(index, _highwayCodeInterface, true);
              },
              child: Image.memory(_highwayCodeViewModel.favRoadSignList.list[index].image),
            ) : Container();
          },
        ),
      ) : Container(child: Center(child: CircularProgressIndicator(),),),
    );
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