import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/interace/question_search_interface.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/model/QuestionView.dart';
import 'package:ukbangladrivingtest/route/route_manager.dart';
import 'package:ukbangladrivingtest/utils/constants.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view_model/question_view_model.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class FavouriteTheoryQuestions extends StatefulWidget {

  @override
  _FavouriteTheoryQuestionsState createState() => _FavouriteTheoryQuestionsState();
}


class _FavouriteTheoryQuestionsState extends State<FavouriteTheoryQuestions> implements QuestionSearchInterface {

  QuestionViewModel _questionViewModel;
  SettingsViewModel _settingsViewModel;
  QuestionSearchInterface _questionSearchInterface;

  Widget _mainBody;


  @override
  void initState() {

    _mainBody = Container(child: Center(child: CircularProgressIndicator(),),);

    _questionSearchInterface = this;
    super.initState();
  }



  @override
  void didChangeDependencies() {

    _questionViewModel = Provider.of<QuestionViewModel>(context);
    _settingsViewModel = Provider.of<SettingsViewModel>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {

      _questionViewModel.removeDisposedStatus();
      _questionViewModel.getFavQuestions(_questionSearchInterface);

      Provider.of<QuestionViewModel>(context, listen: true).getVoiceOverStatus();
      Provider.of<QuestionViewModel>(context, listen: true).getAnsweringLanguage(context);
    });

    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: Builder(
          builder: (BuildContext context) {

            return _body();
          },
        ),
      ),
    );
  }



  Widget _body() {

    return Container(
      child: Column(
        children: <Widget>[

          Expanded(
              flex: 3,
              child: _header()
          ),

          Expanded(
              flex: 15,
              child: mounted ? _mainBody : Container(),
          ),
        ],
      ),
    );
  }



  Container _header() {

    return Container(
        width: double.infinity,
        color: Colors.black87,
        padding: EdgeInsets.only(top: 5 * SizeConfig.heightSizeMultiplier),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Expanded(
              flex: 4,
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
              flex: 4,
              child: Align(
                alignment: Alignment.center,
                child: Text(AppLocalization.of(context).getTranslatedValue("favourites"),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 4,
              child: GestureDetector(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 3.84 * SizeConfig.imageSizeMultiplier,
                  child: Text(mounted ? _questionViewModel.language : "",
                    style: Theme.of(context).textTheme.subtitle2,),
                ),
                onTap: () {
                  Provider.of<SettingsViewModel>(context, listen: false).playSound();
                  _questionViewModel.alterLanguage(context, interface: _questionSearchInterface);
                },
              ),
            ),
          ],
        )
    );
  }



  SingleChildScrollView _listView() {

    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return;
        },
        child: Column(
          children: <Widget>[

            ListView.builder(
              shrinkWrap: true,
              itemCount: _questionViewModel.filterList.list.length < 20 ? _questionViewModel.filterList.list.length :
              ((_questionViewModel.currentPage * 20) < _questionViewModel.filterList.list.length ? 20 :
              (_questionViewModel.filterList.list.length - ((_questionViewModel.currentPage-1) * 20))),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {

                return Column(
                  children: <Widget>[

                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                          margin: EdgeInsets.only(left: 6.41 * SizeConfig.widthSizeMultiplier, right: 6.41 * SizeConfig.widthSizeMultiplier),
                          padding: EdgeInsets.all(1.625 * SizeConfig.heightSizeMultiplier),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.lightGreen[500],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[

                              Expanded(
                                flex: 8,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 2.56 * SizeConfig.widthSizeMultiplier),
                                  child: Text(_questionViewModel.languageID == Constants.questionAnswerLanguageIdList[0] ?
                                  _questionViewModel.filterList.list[((_questionViewModel.currentPage - 1) * 20) + index].question :
                                  _questionViewModel.filterList.list[((_questionViewModel.currentPage - 1) * 20) + index].questionInBangla,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 1.75 * SizeConfig.textSizeMultiplier, color: Colors.white, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),

                              _questionViewModel.filterList.list[((_questionViewModel.currentPage - 1) * 20) + index].hasImage ? Expanded(
                                flex: 2,
                                child: Container(
                                  width: 10.25 * SizeConfig.widthSizeMultiplier,
                                  height: 3.75 * SizeConfig.heightSizeMultiplier,
                                  padding: EdgeInsets.only(left: 1.28 * SizeConfig.widthSizeMultiplier),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(image: MemoryImage(_questionViewModel.filterList.list[((_questionViewModel.currentPage - 1) * 20) + index].image),
                                        fit: BoxFit.fill
                                    ),
                                  ),
                                ),
                              ) : Container(),
                            ],
                          )
                      ),
                      onTap: () {
                        Provider.of<SettingsViewModel>(context, listen: false).playSound();

                        QuestionView questionView = QuestionView(((_questionViewModel.currentPage - 1) * 20) + index, _questionSearchInterface);
                        Navigator.of(context).pushNamed(RouteManager.QUESTION_SEARCH_VIEW_ROUTE, arguments: questionView);
                      },
                    ),

                    Container(
                      width: double.infinity,
                      height: 1 * SizeConfig.heightSizeMultiplier,
                      color: Colors.transparent,
                    )
                  ],
                );
              },
            ),

            Container(
              margin: EdgeInsets.only(left: 5.12 * SizeConfig.widthSizeMultiplier, right: 2.56 * SizeConfig.widthSizeMultiplier),
              padding: EdgeInsets.only(top: 1.5 * SizeConfig.heightSizeMultiplier, bottom: 1.5 * SizeConfig.heightSizeMultiplier),
              child: Row(
                children: <Widget>[

                  Expanded(
                    flex: 2,
                    child: Visibility(
                      visible: _questionViewModel.currentPage > 1,
                      child: GestureDetector(
                        child: Icon(Icons.arrow_back_ios, size: 8.97 * SizeConfig.imageSizeMultiplier, color: Colors.black87,),
                        onTap: () {
                          Provider.of<SettingsViewModel>(context, listen: false).playSound();
                          _loadPage(false);
                        },
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 8,
                    child: Text((_settingsViewModel.isEnglish ? "" : _questionViewModel.stringTotalPage) +
                        AppLocalization.of(context).getTranslatedValue("page") + (_settingsViewModel.isEnglish ? _questionViewModel.currentPage.toString() : "") +
                        AppLocalization.of(context).getTranslatedValue("of") + (_settingsViewModel.isEnglish ? _questionViewModel.totalPage.toString():
                    _questionViewModel.stringCurrentPage + AppLocalization.of(context).getTranslatedValue("number")),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle2.copyWith(fontWeight: FontWeight.normal)),
                  ),

                  Expanded(
                    flex: 2,
                    child: Visibility(
                      visible: _questionViewModel.currentPage < _questionViewModel.totalPage,
                      child: GestureDetector(
                        child: Icon(Icons.arrow_forward_ios, size: 8.97 * SizeConfig.imageSizeMultiplier, color: Colors.black87,),
                        onTap: () {
                          Provider.of<SettingsViewModel>(context, listen: false).playSound();
                          _loadPage(true);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  void _loadPage(bool isNext) {

    setState(() {

      _mainBody = Container(
        child: Center(
          child: Text(AppLocalization.of(context).getTranslatedValue("loading"),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4,),
        ),
      );
    });

    if(isNext) {
      _questionViewModel.increasePageNumber();
    }
    else {
      _questionViewModel.decreasePageNumber();
    }

    Timer(const Duration(milliseconds: 1000), () {

      setState(() {
        _mainBody = _listView();
      });
    });
  }



  Future<bool> _onBackPressed() {

    Navigator.pop(context);
    return Future(() => false);
  }


  @override
  void dispose() {
    _questionViewModel.resetModel();
    super.dispose();
  }



  @override
  void showFavList() {

    setState(() {
      _mainBody = _listView();
    });
  }



  @override
  void showSearchList() {
  }



  @override
  void onNoFavourites() {

    if(mounted) {

      setState(() {

        _mainBody = Container(
          padding: EdgeInsets.all(3.75 * SizeConfig.heightSizeMultiplier),
          child: Text(AppLocalization.of(context).getTranslatedValue("no_favourites"),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.normal),
          ),
        );
      });
    }
  }
}