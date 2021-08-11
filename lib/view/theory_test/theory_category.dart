import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/interace/question_category_selection_interface.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/resources/images.dart';
import 'package:ukbangladrivingtest/route/route_manager.dart';
import 'package:ukbangladrivingtest/utils/constants.dart';
import 'package:ukbangladrivingtest/utils/response_helper.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view_model/answering_choice_view_model.dart';
import 'package:ukbangladrivingtest/view_model/question_category_selection_view_model.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';


final List<Widget> _categoryIcons = <Widget>[Icon(Icons.menu, size: 6.5 * SizeConfig.imageSizeMultiplier, color: Colors.lightGreen[500],), Icon(Icons.timer, size: 6.5 * SizeConfig.imageSizeMultiplier, color: Colors.deepOrangeAccent,), Icon(Icons.vpn_key, size: 6.5 * SizeConfig.imageSizeMultiplier, color: Colors.pink[800],),
  Icon(Icons.tag_faces, size: 6.5 * SizeConfig.imageSizeMultiplier, color: Colors.purple[700],), Icon(Icons.assignment, size: 6.5 * SizeConfig.imageSizeMultiplier, color: Colors.deepPurple,), Image.asset(Images.errorIcon, color: Colors.indigo[800], height: 4.375 * SizeConfig.heightSizeMultiplier, width: 8.97 * SizeConfig.widthSizeMultiplier,),
  Icon(Icons.traffic, size: 6.5 * SizeConfig.imageSizeMultiplier, color: Colors.lightBlue,), Image.asset(Images.emergencyIcon, color: Colors.green[800], height: 4.375 * SizeConfig.heightSizeMultiplier, width: 8.97 * SizeConfig.widthSizeMultiplier,), Image.asset(Images.busIcon, color: Colors.lightGreen[400], height: 4.375 * SizeConfig.heightSizeMultiplier, width: 8.97 * SizeConfig.widthSizeMultiplier,),
  Image.asset(Images.steeringIcon, color: Colors.deepOrangeAccent, height: 4.375 * SizeConfig.heightSizeMultiplier, width: 8.97 * SizeConfig.widthSizeMultiplier,), Image.asset(Images.roadIcon, color: Colors.pink[800], height: 4.375 * SizeConfig.heightSizeMultiplier, width: 8.97 * SizeConfig.widthSizeMultiplier,), Image.asset(Images.bookIcon, color: Colors.purple[700], height: 4.375 * SizeConfig.heightSizeMultiplier, width: 8.97 * SizeConfig.widthSizeMultiplier,),
  Image.asset(Images.clockIcon, color: Colors.deepPurple, height: 4.375 * SizeConfig.heightSizeMultiplier, width: 8.97 * SizeConfig.widthSizeMultiplier,), Image.asset(Images.screwdriverIcon, color: Colors.indigo[800], height: 4.375 * SizeConfig.heightSizeMultiplier, width: 8.97 * SizeConfig.widthSizeMultiplier,), Icon(Icons.people, size: 6.5 * SizeConfig.imageSizeMultiplier, color: Colors.lightBlue,),
  Image.asset(Images.wheelIcon, color: Colors.green[400], height: 4.375 * SizeConfig.heightSizeMultiplier, width: 8.97 * SizeConfig.widthSizeMultiplier,)];

final List<Color> _categoryColorCodes = <Color>[Colors.lightGreen[500], Colors.deepOrangeAccent, Colors.pink[800], Colors.purple[700], Colors.deepPurple, Colors.indigo[800], Colors.lightBlue, Colors.green[800],
  Colors.lightGreen[400], Colors.deepOrangeAccent, Colors.pink[800], Colors.purple[700], Colors.deepPurple, Colors.indigo[800], Colors.lightBlue];


class TheoryCategory extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _TheoryCategoryState();
  }
}

class _TheoryCategoryState extends State<TheoryCategory> implements QuestionCategorySelectionInterface {

  QuestionCategorySelectionViewModel _categorySelectionViewModel;
  SettingsViewModel _settingsViewModel;

  QuestionCategorySelectionInterface _categorySelectionInterface;

  Widget _mainBody;
  ResponseHelper _responseHelper;
  BuildContext _scaffoldContext;

  List<bool> _categorySelection = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];


  @override
  void initState() {

    _responseHelper = ResponseHelper(context);
    _categorySelectionInterface = this;
    _mainBody = Center(child: CircularProgressIndicator());

    super.initState();
  }


  @override
  void didChangeDependencies() {

    _categorySelectionViewModel = Provider.of<QuestionCategorySelectionViewModel>(context);
    _settingsViewModel = Provider.of<SettingsViewModel>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {

      _categorySelectionViewModel.removeDisposedStatus();
      _categorySelectionViewModel.getTotalNumberOfQuestions();
      Provider.of<QuestionCategorySelectionViewModel>(context, listen: true).getCategoryWiseTotalNumberOfQuestions(_categorySelectionInterface);
    });

    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Builder(
          builder: (BuildContext context) {

            _scaffoldContext = context;
            return _body();
          },
        ),
      ),
    );
  }



  Widget _body() {

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          Expanded(
              flex: 4,
              child: _header()
          ),

          Expanded(
              flex: 15,
              child: _mainBody
          ),

          Expanded(
              flex: 2,
              child: _footer()
          ),
        ],
      ),
    );
  }



  Container _header() {

    return Container(
      width: double.infinity,
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(bottom: 3.75 * SizeConfig.heightSizeMultiplier),
      color: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          Text(AppLocalization.of(context).getTranslatedValue("categories_to_practice"),
            style: Theme.of(context).textTheme.headline3.copyWith(color: Colors.white),
          ),

          Text((_settingsViewModel.isEnglish ? _categorySelectionViewModel.numberOfQuestionsSelected.toString() : _categorySelectionViewModel.totalNumber.toString()) +
              AppLocalization.of(context).getTranslatedValue("of") + (_settingsViewModel.isEnglish ? _categorySelectionViewModel.totalNumberOfQuestions.toString() :
          _categorySelectionViewModel.totalSelected.toString()) + AppLocalization.of(context).getTranslatedValue("selected"),
            style: Theme.of(context).textTheme.headline3.copyWith(color: Colors.white),
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
        child: ListView.builder(
          itemCount: Constants.categories.length,
          shrinkWrap: true,
          padding: EdgeInsets.all(1.25 * SizeConfig.heightSizeMultiplier),
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {

            return Column(
              children: <Widget>[

                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                      margin: EdgeInsets.only(top: 1.2 * SizeConfig.heightSizeMultiplier, bottom: 1.2 * SizeConfig.heightSizeMultiplier),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                          Row(
                            children: <Widget>[

                              Expanded(
                                flex: 1,
                                child: Container(),
                              ),

                              Expanded(
                                flex: 6,
                                child: Container(
                                  padding: EdgeInsets.only(left: 2.56 * SizeConfig.widthSizeMultiplier),
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[

                                      Text(Constants.categories[index] + " - " + Constants.categoriesBangla[index],
                                        style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold, color: _categoryColorCodes[index]),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: EdgeInsets.only(right: 2.56 * SizeConfig.widthSizeMultiplier),
                                  alignment: Alignment.centerRight,
                                  child: Text((_settingsViewModel.isEnglish ? _categorySelectionViewModel.categoryInfoList[index].correctlyAnsweredPercentage.round().toString() :
                                  _categorySelectionViewModel.categoryInfoList[index].stringCorrectlyAnsweredPercentage) + "%",
                                    style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 1,
                                child: Container(),
                              ),
                            ],
                          ),

                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[

                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.all(.625 * SizeConfig.heightSizeMultiplier),
                                  child: _categoryIcons[index],
                                ),
                              ),

                              Expanded(
                                flex: 8,
                                child: Stack(
                                  children: <Widget>[

                                    LinearPercentIndicator(
                                      lineHeight: 2.2 * SizeConfig.heightSizeMultiplier,
                                      percent: _categorySelectionViewModel.categoryInfoList[index].answeringPercentage,
                                      backgroundColor: Colors.red,
                                      progressColor: Colors.yellow[400],
                                      linearStrokeCap: LinearStrokeCap.butt,
                                    ),

                                    LinearPercentIndicator(
                                      lineHeight: 2.2 * SizeConfig.heightSizeMultiplier,
                                      percent: _categorySelectionViewModel.categoryInfoList[index].correctlyAnsweredPercentage/100,
                                      backgroundColor: Colors.transparent,
                                      progressColor: Colors.lightGreen[500],
                                      linearStrokeCap: LinearStrokeCap.butt,
                                    ),
                                  ],
                                ),
                              ),

                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _categorySelection[index] ? _categoryColorCodes[index] : Colors.white,
                                      border: Border.all(color: _categoryColorCodes[index], width: .256 * SizeConfig.widthSizeMultiplier)
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(.375 * SizeConfig.heightSizeMultiplier),
                                    child: Icon(
                                      Icons.check,
                                      size: 5 * SizeConfig.imageSizeMultiplier,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: <Widget>[

                              Expanded(
                                flex: 1,
                                child: Container(),
                              ),

                              Expanded(
                                flex: 4,
                                child: Container(
                                  padding: EdgeInsets.only(left: 2.56 * SizeConfig.widthSizeMultiplier),
                                  alignment: Alignment.centerLeft,
                                  child: Text(AppLocalization.of(context).getTranslatedValue("answered") + (_settingsViewModel.isEnglish ?
                                  _categorySelectionViewModel.categoryInfoList[index].questionsAnswered.toString() :
                                  _categorySelectionViewModel.categoryInfoList[index].stringQuestionsAnswered) + "/" +
                                      (_settingsViewModel.isEnglish ? _categorySelectionViewModel.categoryInfoList[index].totalQuestions.toString() :
                                      _categorySelectionViewModel.categoryInfoList[index].stringTotalQuestions),
                                    style: Theme.of(context).textTheme.subtitle2.copyWith(fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 4,
                                child: Container(
                                  padding: EdgeInsets.only(right: 2.56 * SizeConfig.widthSizeMultiplier),
                                  alignment: Alignment.centerRight,
                                  child: Text(AppLocalization.of(context).getTranslatedValue("correctly") + (_settingsViewModel.isEnglish ?
                                  _categorySelectionViewModel.categoryInfoList[index].correctlyAnswered.toString() :
                                  _categorySelectionViewModel.categoryInfoList[index].stringCorrectlyAnswered) + "/" +
                                      (_settingsViewModel.isEnglish ? _categorySelectionViewModel.categoryInfoList[index].totalQuestions.toString() :
                                      _categorySelectionViewModel.categoryInfoList[index].stringTotalQuestions),
                                    style: Theme.of(context).textTheme.subtitle2.copyWith(fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 1,
                                child: Container(),
                              ),
                            ],
                          ),
                        ],
                      )
                  ),
                  onTap: () {
                    Provider.of<SettingsViewModel>(context, listen: false).playSound();
                    _categorySelectionViewModel.setSelectedCategory(index, _categorySelection, _categorySelectionInterface);
                  },
                ),

                Container(
                  width: double.infinity,
                  height: .25 * SizeConfig.heightSizeMultiplier,
                  margin: EdgeInsets.only(top: .25 * SizeConfig.heightSizeMultiplier, left: .512 * SizeConfig.widthSizeMultiplier, right: .512 * SizeConfig.widthSizeMultiplier),
                  color: Colors.lightGreen[500],
                )
              ],
            );
          },
        ),
    );
  }



  GestureDetector _footer() {

    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: 15 * SizeConfig.heightSizeMultiplier,
        alignment: Alignment.center,
        color: Colors.lightGreen[500],
        child: Text(AppLocalization.of(context).getTranslatedValue("start"),
          style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white),
        ),
      ),
      onTap: () {

        Provider.of<SettingsViewModel>(context, listen: false).playSound();

        if(_categorySelectionViewModel.numberOfQuestionsSelected > 0) {

          Navigator.pop(context);
          Navigator.of(context).pushNamed(RouteManager.ANSWERING_CHOICE_PAGE_ROUTE, arguments: _categorySelection);
        }
        else {

          _responseHelper.showSnackBar(_scaffoldContext, AppLocalization.of(context).getTranslatedValue("select_category"), Colors.red, 2);
        }
      },
    );
  }



  @override
  void dispose() {
    _categorySelectionViewModel.resetModel();
    super.dispose();
  }



  @override
  void showListView() {

    if(mounted) {
      setState(() {
        _mainBody = _listView();
      });
    }
  }

  @override
  void alterCategorySelection(int index) {

    if(mounted) {
      setState(() {
        _categorySelection[index] = !_categorySelection[index];
      });
    }
  }

  @override
  void selectAllCategory() {

    if(mounted) {
      setState(() {

        for(int i=0; i<_categorySelection.length; i++) {
          _categorySelection[i] = true;
        }
      });
    }
  }

  @override
  void unSelectAllCategory() {

    if(mounted) {
      setState(() {

        for(int i=0; i<_categorySelection.length; i++) {
          _categorySelection[i] = false;
        }
      });
    }
  }

  @override
  void unSelectFirstCategory() {

    if(mounted) {
      setState(() {
        _categorySelection[0] = false;
      });
    }
  }

  Future<bool> _onBackPressed() {

    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.THEORY_TEST_PAGE_ROUTE);
    return Future(() => false);
  }
}