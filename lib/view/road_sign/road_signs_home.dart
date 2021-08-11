import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/route/route_manager.dart';
import 'package:ukbangladrivingtest/utils/local_memory.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view_model/highway_code_view_model.dart';
import 'package:ukbangladrivingtest/view_model/home_view_model.dart';
import 'package:ukbangladrivingtest/view_model/question_view_model.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:ukbangladrivingtest/view_model/thoery_test_view_model.dart';
import 'package:ukbangladrivingtest/widgets/footer.dart';
import 'package:ukbangladrivingtest/widgets/header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


final List<String> _categories = <String>['Categories', 'Find a sign', 'My signs', 'Quiz', 'Game', 'Offers & Rewards'];
final List<String> _categoriesBangla = <String>['বিভাগসমূহ', 'চিহ্ন সন্ধান', 'আমার চিহ্ন', 'কুইজ', 'গেম', 'অফার এবং পুরষ্কার'];
final List<IconData> _categoryIcons = <IconData>[Icons.list, Icons.search, Icons.favorite, Icons.assignment, Icons.videogame_asset, Icons.local_offer];


class RoadSignsHome extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _RoadSignsHomeState();
  }
}

class _RoadSignsHomeState extends State<RoadSignsHome> {

  HighwayCodeViewModel _highwayCodeViewModel;
  SettingsViewModel _settingsViewModel;


  @override
  void initState() {
    super.initState();
  }


  @override
  void didChangeDependencies() {

    _highwayCodeViewModel = Provider.of<HighwayCodeViewModel>(context);
    _settingsViewModel = Provider.of<SettingsViewModel>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {

      _highwayCodeViewModel.getRoadSigns();

      Provider.of<QuestionViewModel>(context, listen: true).getAnsweringLanguage(context);
    });

    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          Expanded(
              flex: 5,
              child: Header()
          ),

          Expanded(
              flex: 17,
              child: _mainContent()
          ),

//          Expanded(
//              flex: 2,
//              child: Footer()
//          ),
        ],
      ),
    );
  }

  Container _mainContent() {

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              color: Colors.lightBlue[400],
              padding: EdgeInsets.all(1.875 * SizeConfig.heightSizeMultiplier),
              alignment: Alignment.center,
              child: Text(AppLocalization.of(context).getTranslatedValue("road_signs"),
                style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headline3.copyWith(color: Colors.white, fontWeight: FontWeight.w500)
                ),
              ),
            ),
          ),

          Expanded(
            flex: 15,
            child: Container(
              alignment: Alignment.center,
              child: _listView(),
            ),
          )
        ],
      ),
    );
  }

  ListView _listView() {

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: _categories.length-3,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {

        return GestureDetector(
          child: Container(
              height: 7 * SizeConfig.heightSizeMultiplier,
              padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
              margin: EdgeInsets.only(bottom: 7 * SizeConfig.heightSizeMultiplier, left: 4.10 * SizeConfig.widthSizeMultiplier, right: 4.10 * SizeConfig.widthSizeMultiplier),
              decoration: BoxDecoration(
                color: Colors.lightBlue[400],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Stack(
                children: <Widget>[

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(_settingsViewModel.isEnglish ? _categories[index] : _categoriesBangla[index],
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(_categoryIcons[index], color: Colors.white,),
                  ),
                ],
              )
          ),
          onTap: () {
            Provider.of<SettingsViewModel>(context, listen: false).playSound();
            _onSelected(index);
          },
        );
      },
    );
  }

  void _onSelected(int index) {

    switch (index) {

      case 0:
        Navigator.of(context).pushNamed(RouteManager.ROAD_SIGN_CATEGORY_PAGE_ROUTE);
        break;

      case 1:
        Navigator.of(context).pushNamed(RouteManager.FIND_ROAD_SIGN_PAGE_ROUTE);
        break;

      case 2:
        Navigator.of(context).pushNamed(RouteManager.FAV_ROAD_SIGN_PAGE_ROUTE);
        break;

      case 3:
        break;

      case 4:
        break;

      case 5:
        break;
    }
  }


  Container _footer() {

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
                    Icons.info_outline,
                    color: Colors.white,
                    size: 7.69 * SizeConfig.imageSizeMultiplier,
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
                    size: 7.69 * SizeConfig.imageSizeMultiplier,
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
                    size: 7.69 * SizeConfig.imageSizeMultiplier,
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
                    size: 7.69 * SizeConfig.imageSizeMultiplier,
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }


  @override
  void dispose() {
    _highwayCodeViewModel.resetModel();
    super.dispose();
  }
}