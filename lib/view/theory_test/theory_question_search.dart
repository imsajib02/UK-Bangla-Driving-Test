import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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


class TheoryQuestionSearch extends StatefulWidget {

  @override
  _TheoryQuestionSearchState createState() => _TheoryQuestionSearchState();
}


class _TheoryQuestionSearchState extends State<TheoryQuestionSearch> implements QuestionSearchInterface {

  TextEditingController _controller = TextEditingController();

  QuestionViewModel _questionViewModel;
  SettingsViewModel _settingsViewModel;

  QuestionSearchInterface _questionSearchInterface;
  FocusNode _focusNode = FocusNode();
  Widget _mainBody;


  @override
  void initState() {

    _controller.text = "";
    _questionSearchInterface = this;
    _mainBody = Container();
    super.initState();
  }


  @override
  void didChangeDependencies() {

    _questionViewModel = Provider.of<QuestionViewModel>(context);
    _settingsViewModel = Provider.of<SettingsViewModel>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {

      _questionViewModel.removeDisposedStatus();
      _questionViewModel.getAllQuestions();

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
              flex: 2,
              child: _searchBar()
          ),

          Expanded(
              flex: 14,
              child: _mainBody
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
              flex: 8,
              child: Align(
                alignment: Alignment.center,
                child: Text(AppLocalization.of(context).getTranslatedValue("search_question"),
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



  Container _searchBar() {

    return Container(
      color: Colors.lightGreen[500],
      padding: EdgeInsets.all(2.5 * SizeConfig.heightSizeMultiplier),
      child: TextField(
        focusNode: _focusNode,
        controller: _controller,
        keyboardType: TextInputType.text,
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.headline5,
        textInputAction: TextInputAction.search,
        onSubmitted: (input) {
          showSearchList();
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(25),
        ],
        cursorColor: Colors.black,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(.625 * SizeConfig.heightSizeMultiplier),
          focusColor: Colors.white70,
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: .512 * SizeConfig.widthSizeMultiplier, color: Colors.white70),
          ),
          filled: true,
          fillColor: Colors.white70,
          prefixIcon: GestureDetector(child: Icon(Icons.search, color: Colors.black54,),
          onTap: () {
            showSearchList();
          },),
          suffixIcon: GestureDetector(child: Icon(Icons.cancel, color: Colors.black,),
          onTap: () {
            Provider.of<SettingsViewModel>(context, listen: false).playSound();
            _clearInput();
          },),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: .512 * SizeConfig.widthSizeMultiplier, color: Colors.black54),
          ),
        ),
        onChanged: (input) {

          if(input.length > 0) {
            _questionViewModel.filterQuestions(input, _questionSearchInterface);
          }
          else {
            _clearInput();
          }
        },
      ),
    );
  }



  Future<bool> _onBackPressed() {

    Navigator.pop(context);
    Navigator.of(context).pushNamed(RouteManager.THEORY_TEST_PAGE_ROUTE);
    return Future(() => false);
  }



  @override
  void showSearchList() {

    setState(() {

      if(_questionViewModel.filterList.list.length > 0) {
        _mainBody = _listView();
      }
      else {
        _mainBody = Container(
          padding: EdgeInsets.all(3.75 * SizeConfig.heightSizeMultiplier),
          child: Text(AppLocalization.of(context).getTranslatedValue("no_question_found"),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.normal),
          ),
        );
      }
    });
  }



  NotificationListener _listView() {

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowGlow();
        return;
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
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
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        margin: EdgeInsets.only(left: 5.12 * SizeConfig.widthSizeMultiplier, right: 2.56 * SizeConfig.widthSizeMultiplier),
                          padding: EdgeInsets.only(top: 1.25 * SizeConfig.heightSizeMultiplier, bottom: 1.25 * SizeConfig.heightSizeMultiplier),
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
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context).textTheme.subtitle2.copyWith(fontWeight: FontWeight.normal),
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
                              ) : Expanded(flex: 2, child: Container()),

                              Expanded(
                                flex: 2,
                                child: Icon(Icons.arrow_forward_ios, size: 8.97 * SizeConfig.imageSizeMultiplier, color: Colors.black87,),
                              ),
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
                      height: .25 * SizeConfig.heightSizeMultiplier,
                      color: Colors.black54,
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
                    child: Text(_settingsViewModel.isEnglish ? AppLocalization.of(context).getTranslatedValue("page") + _questionViewModel.currentPage.toString() +
                        AppLocalization.of(context).getTranslatedValue("of") + _questionViewModel.totalPage.toString() :
                    _questionViewModel.stringTotalPage + AppLocalization.of(context).getTranslatedValue("page") + AppLocalization.of(context).getTranslatedValue("of") +
                        _questionViewModel.stringCurrentPage + AppLocalization.of(context).getTranslatedValue("number"),
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



  void _clearInput() {

    _questionViewModel.clearFilterList();
    _controller.text = "";

    setState(() {
      _mainBody = Container();
    });
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



  @override
  void dispose() {
    _controller.dispose();
    _questionViewModel.resetModel();
    _focusNode.dispose();
    super.dispose();
  }



  @override
  void showFavList() {
  }


  @override
  void onNoFavourites() {
  }
}