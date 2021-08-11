import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:ukbangladrivingtest/route/route_manager.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view_model/highway_code_view_model.dart';
import 'package:ukbangladrivingtest/view_model/home_view_model.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:ukbangladrivingtest/widgets/footer.dart';
import 'package:ukbangladrivingtest/widgets/header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


final List<String> _categories = <String>['THEORY TEST', 'HAZARD Clips', 'HIGHWAY CODE', 'ROAD SIGNS', 'OFFERS & REWARDS', 'YOUR BONUS CONTENT'];
final List<String> _categoriesBangla = <String>['থিওরি টেস্ট', 'ঝুঁকিপূর্ণ ভিডিও ক্লিপ', 'হাইওয়ে কোড', 'রোড সাইন', 'অফার এবং পুরষ্কার', 'আপনার বোনাস বিষয়বস্তু'];
final List<Color> _categoryColorCodes = <Color>[Colors.lightGreen[500], Colors.red, Color(0xFF4682B4), Colors.lightBlue[400], Colors.grey[600], Colors.purple[600]];
final List<Color> _categoryBorderColorCodes = <Color>[Colors.green[800], Colors.blueGrey, Colors.redAccent.shade400, Colors.orange[600], Colors.grey[700], Colors.purple[700]];


class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

  HomeViewModel _homeViewModel;
  HighwayCodeViewModel _highwayCodeViewModel;
  SettingsViewModel _settingsViewModel;


  @override
  void initState() {

    Provider.of<HomeViewModel>(context, listen: false).shouldShowTheoryTestAlert();
    super.initState();
  }


  @override
  void didChangeDependencies() {

    _highwayCodeViewModel = Provider.of<HighwayCodeViewModel>(context);
    _settingsViewModel = Provider.of<SettingsViewModel>(context);

    _highwayCodeViewModel.removeDisposedStatus();
    _highwayCodeViewModel.getHighwayCodeCategoryList();

    Provider.of<SettingsViewModel>(context, listen: true).getSoundStatus();
    Provider.of<SettingsViewModel>(context, listen: true).getLanguage();

    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {

    _homeViewModel = Provider.of<HomeViewModel>(context);

    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: Scaffold(
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                Expanded(
                    flex: 6,
                    child: Header()
                ),

                Expanded(
                    flex: 4,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.all(2.5 * SizeConfig.heightSizeMultiplier),
                        decoration: BoxDecoration(
                            color: _categoryColorCodes[0],
                            shape: BoxShape.rectangle,
                        ),
                        child: Column(
                          children: <Widget>[

                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(_categories[0],
                                  style: GoogleFonts.palanquinDark(
                                    textStyle: Theme.of(context).textTheme.headline1.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(_categoriesBangla[0],
                                  style: GoogleFonts.palanquinDark(
                                    textStyle: Theme.of(context).textTheme.headline1.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {

                        Provider.of<SettingsViewModel>(context, listen: false).playSound();
                        _onSelected(0);
                      },
                    ),
                ),

                Expanded(
                  flex: 4,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(2.5 * SizeConfig.heightSizeMultiplier),
                      decoration: BoxDecoration(
                        color: _categoryColorCodes[1],
                        shape: BoxShape.rectangle,
                      ),
                      child: Column(
                        children: <Widget>[

                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(_categories[1],
                                style: GoogleFonts.palanquinDark(
                                  textStyle: Theme.of(context).textTheme.headline1.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(_categoriesBangla[1],
                                style: GoogleFonts.palanquinDark(
                                  textStyle: Theme.of(context).textTheme.headline1.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {

                      Provider.of<SettingsViewModel>(context, listen: false).playSound();
                      _onSelected(1);
                    },
                  ),
                ),

                Expanded(
                  flex: 4,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(2.5 * SizeConfig.heightSizeMultiplier),
                      decoration: BoxDecoration(
                        color: _categoryColorCodes[2],
                        shape: BoxShape.rectangle,
                      ),
                      child: Column(
                        children: <Widget>[

                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(_categories[2],
                                style: GoogleFonts.palanquinDark(
                                  textStyle: Theme.of(context).textTheme.headline1.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(_categoriesBangla[2],
                                style: GoogleFonts.palanquinDark(
                                  textStyle: Theme.of(context).textTheme.headline1.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {

                      Provider.of<SettingsViewModel>(context, listen: false).playSound();
                      _onSelected(2);
                    },
                  ),
                ),

                Expanded(
                  flex: 4,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(2.5 * SizeConfig.heightSizeMultiplier),
                      decoration: BoxDecoration(
                        color: _categoryColorCodes[3],
                        shape: BoxShape.rectangle,
                      ),
                      child: Column(
                        children: <Widget>[

                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(_categories[3],
                                style: GoogleFonts.palanquinDark(
                                  textStyle: Theme.of(context).textTheme.headline1.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(_categoriesBangla[3],
                                style: GoogleFonts.palanquinDark(
                                  textStyle: Theme.of(context).textTheme.headline1.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {

                      Provider.of<SettingsViewModel>(context, listen: false).playSound();
                      _onSelected(3);
                    },
                  ),
                ),

                Expanded(
                    flex: 2,
                    child: Footer()
                ),
              ],
            ),
          ),
      ),
    );
  }



  void _onSelected(int index) {

    switch (index) {

      case 0:
        if(_homeViewModel.shouldShow) {
          Navigator.of(context).pushNamed(RouteManager.WARNING_PAGE_ROUTE);
        }
        else {
          Navigator.of(context).pushNamed(RouteManager.THEORY_TEST_PAGE_ROUTE);
        }

        break;

      case 1:
        Navigator.of(context).pushNamed(RouteManager.HAZARD_PRACTISE_PAGE_ROUTE);
        break;

      case 2:
        Navigator.of(context).pushNamed(RouteManager.HIGHWAY_CODE_PAGE_ROUTE);
        break;

      case 3:
        Navigator.of(context).pushNamed(RouteManager.ROAD_SIGNS_PAGE_ROUTE);
        break;

      case 4:
      case 5:
    }
  }
}