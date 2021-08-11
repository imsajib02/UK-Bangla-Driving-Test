import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/interace/highway_code_interface.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/route/route_manager.dart';
import 'package:ukbangladrivingtest/utils/constants.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view_model/highway_code_view_model.dart';
import 'package:ukbangladrivingtest/view_model/question_view_model.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:ukbangladrivingtest/widgets/highway_code_full_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class HighwayCodeDetail extends StatefulWidget {

  @override
  _HighwayCodeDetailState createState() => _HighwayCodeDetailState();
}


class _HighwayCodeDetailState extends State<HighwayCodeDetail> implements HighwayCodeInterface {

  HighwayCodeViewModel _highwayCodeViewModel;
  QuestionViewModel _questionViewModel;
  SettingsViewModel _settingsViewModel;

  HighwayCodeInterface _highwayCodeInterface;
  ScrollController _scrollController = ScrollController();



  @override
  void initState() {
    _highwayCodeInterface = this;
    super.initState();
  }



  @override
  void didChangeDependencies() {

    _highwayCodeViewModel = Provider.of<HighwayCodeViewModel>(context);
    _questionViewModel = Provider.of<QuestionViewModel>(context);
    _settingsViewModel = Provider.of<SettingsViewModel>(context);

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
              flex: 4,
              child: _header()
          ),

          Expanded(
              flex: 22,
              child: Container(
                color: Colors.white,
                child: mounted ? (_highwayCodeViewModel.contentList[_highwayCodeViewModel.number-1].list.length > 0 ? _contentView() :
                Center(
                  child: Text(AppLocalization.of(context).getTranslatedValue("no_content"),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.normal),
                    ),
                  ),
                )) : Container(),
              )
          ),

          Expanded(
              flex: 2,
              child: _highwayCodeViewModel.contentList[_highwayCodeViewModel.number-1].list.length > 0 ? _footer() : Container(color: Colors.white,),
          ),
        ],
      ),
    );
  }



  Container _header() {

    return Container(
        width: double.infinity,
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(bottom: 2.5 * SizeConfig.heightSizeMultiplier),
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
              child: Text(AppLocalization.of(context).getTranslatedValue("content"),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.headline4.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
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
                    _questionViewModel.alterLanguage(context);
                  },
                ),
              ),
            ),
          ],
        )
    );
  }



  NotificationListener _contentView() {

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowGlow();
        return;
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        child: mounted ? Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Padding(
              padding: EdgeInsets.only(left: 5.12 * SizeConfig.widthSizeMultiplier, right: 5.12 * SizeConfig.widthSizeMultiplier,
                  top: 1.875 * SizeConfig.heightSizeMultiplier, bottom: 2.5 * SizeConfig.heightSizeMultiplier),
              child: Text(mounted ? _questionViewModel.languageID == Constants.questionAnswerLanguageIdList[0] ? _highwayCodeViewModel.allCategoryList[_highwayCodeViewModel.selectedIndex] :
              _highwayCodeViewModel.allCategoryListBangla[_highwayCodeViewModel.selectedIndex] : "",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.blue.shade900, fontWeight: FontWeight.w500),
              ),
            ),

            Visibility(
              visible: mounted ? (_highwayCodeViewModel.isRoadSign ? (_highwayCodeViewModel.categoryDescription.description != null &&
                  _highwayCodeViewModel.categoryDescription.description != "") : false) : false,
              child: Container(
                padding: EdgeInsets.all(1.875 * SizeConfig.heightSizeMultiplier),
                child: Text(mounted ? (_highwayCodeViewModel.isRoadSign ? (_highwayCodeViewModel.categoryDescription.description != null &&
                    _highwayCodeViewModel.categoryDescription.description != "" ? (_questionViewModel.languageID == Constants.questionAnswerLanguageIdList[0] ?
                _highwayCodeViewModel.categoryDescription.description : _highwayCodeViewModel.categoryDescription.descriptionBangla) : "") : "") : "",
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),

            Visibility(
              visible: mounted ? _highwayCodeViewModel.subCategoryList.length > 1 : false,
              child: Container(
                padding: EdgeInsets.only(left: 7.69 * SizeConfig.widthSizeMultiplier, right: 7.69 * SizeConfig.widthSizeMultiplier),
                margin: EdgeInsets.only(bottom: 3.75 * SizeConfig.heightSizeMultiplier),
                child: Text(mounted ? (_highwayCodeViewModel.contentList.length > 1 ? (_questionViewModel.languageID == Constants.questionAnswerLanguageIdList[0] ?
                _highwayCodeViewModel.subCategoryList[_highwayCodeViewModel.number-1] : _highwayCodeViewModel.subCategoryListBangla[_highwayCodeViewModel.number-1]) : "") : "",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4.copyWith(color: Colors.blue.shade700, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            Visibility(
              visible: mounted ? (_highwayCodeViewModel.isRoadSign ? (_highwayCodeViewModel.subCategoryDescriptionList.length > 0 &&
                  _highwayCodeViewModel.subCategoryDescriptionList[_highwayCodeViewModel.number-1].description != null &&
                  _highwayCodeViewModel.subCategoryDescriptionList[_highwayCodeViewModel.number-1].description != "") : false) : false,
              child: Container(
                padding: EdgeInsets.all(1.875 * SizeConfig.heightSizeMultiplier),
                child: Text(mounted ? (_highwayCodeViewModel.isRoadSign ? (_highwayCodeViewModel.subCategoryDescriptionList.length > 0 &&
                    _highwayCodeViewModel.subCategoryDescriptionList[_highwayCodeViewModel.number-1].description != null &&
                    _highwayCodeViewModel.subCategoryDescriptionList[_highwayCodeViewModel.number-1].description != "" ?
                (_questionViewModel.languageID == Constants.questionAnswerLanguageIdList[0] ?
                _highwayCodeViewModel.subCategoryDescriptionList[_highwayCodeViewModel.number-1].description :
                _highwayCodeViewModel.subCategoryDescriptionList[_highwayCodeViewModel.number-1].descriptionBangla) : "") : "") : "",
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),

            Padding(
              padding: _highwayCodeViewModel.isRoadSign ? EdgeInsets.only(left: 5.12 * SizeConfig.widthSizeMultiplier, right: 5.12 * SizeConfig.widthSizeMultiplier) :
              EdgeInsets.only(right: 2.56 * SizeConfig.widthSizeMultiplier),
              child: ListView.builder(
                itemCount: _highwayCodeViewModel.contentList[_highwayCodeViewModel.number-1].list.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.all(.25 * SizeConfig.heightSizeMultiplier),
                itemBuilder: (BuildContext context, int index) {

                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Visibility(
                        visible: !_highwayCodeViewModel.isRoadSign,
                        child: Expanded(
                          flex: 1,
                          child: Container(
                            child: CircleAvatar(
                              backgroundColor: Colors.blue.shade700,
                              radius: 5.12 * SizeConfig.imageSizeMultiplier,
                              child: Text(_questionViewModel.languageID == Constants.questionAnswerLanguageIdList[0] ?
                              _highwayCodeViewModel.contentList[_highwayCodeViewModel.number-1].list[index].id.toString() :
                              _highwayCodeViewModel.contentList[_highwayCodeViewModel.number-1].list[index].idBangla,
                              textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 6,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            Visibility(
                              visible: _highwayCodeViewModel.contentList[_highwayCodeViewModel.number-1].list[index].content != "",
                              child: Flexible(
                                child: Container(
                                  child: Text(mounted ? (_questionViewModel.languageID == Constants.questionAnswerLanguageIdList[0] ?
                                  _highwayCodeViewModel.contentList[_highwayCodeViewModel.number-1].list[index].content :
                                  _highwayCodeViewModel.contentList[_highwayCodeViewModel.number-1].list[index].contentBangla) : "",
                                    textAlign: TextAlign.justify,
                                    style: GoogleFonts.poppins(
                                      textStyle: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: _highwayCodeViewModel.contentList[_highwayCodeViewModel.number-1].list[index].content != "" ? 2.5 * SizeConfig.heightSizeMultiplier : 0,),

                            Visibility(
                              visible: _highwayCodeViewModel.contentList[_highwayCodeViewModel.number-1].list[index].hasImage,
                              child: Flexible(
                                child: mounted ? (_highwayCodeViewModel.contentList[_highwayCodeViewModel.number-1].list[index].hasImage ?
                                (_highwayCodeViewModel.contentList[_highwayCodeViewModel.number-1].list[index].rule == "" ? GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    width: double.infinity,
                                    height: 25 * SizeConfig.heightSizeMultiplier,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      image: DecorationImage(image: MemoryImage(_highwayCodeViewModel.contentList[_highwayCodeViewModel.number-1].list[index].image),
                                        fit: BoxFit.contain
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Provider.of<SettingsViewModel>(context, listen: false).playSound();
                                    _showFullImage(_highwayCodeViewModel.contentList[_highwayCodeViewModel.number-1].list[index].image);
                                  },
                                ) : Container(
                                  child: Column(
                                    children: <Widget>[

                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        child: Container(
                                          width: double.infinity,
                                          height: 25 * SizeConfig.heightSizeMultiplier,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            image: DecorationImage(image: MemoryImage(_highwayCodeViewModel.contentList[_highwayCodeViewModel.number-1].list[index].image),
                                                fit: BoxFit.fill
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          Provider.of<SettingsViewModel>(context, listen: false).playSound();
                                          _showFullImage(_highwayCodeViewModel.contentList[_highwayCodeViewModel.number-1].list[index].image);
                                        },
                                      ),

                                      Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        padding: EdgeInsets.all(.625 * SizeConfig.heightSizeMultiplier),
                                        color: Colors.red,
                                        child: Text(_questionViewModel.languageID == Constants.questionAnswerLanguageIdList[0] ?
                                        _highwayCodeViewModel.contentList[_highwayCodeViewModel.number-1].list[index].rule :
                                        _highwayCodeViewModel.contentList[_highwayCodeViewModel.number-1].list[index].ruleBangla,
                                          textAlign: TextAlign.justify,
                                          style: GoogleFonts.poppins(
                                            textStyle: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )) : Container()) : Container(),
                              ),
                            ),

                            SizedBox(height: _highwayCodeViewModel.contentList[_highwayCodeViewModel.number-1].list[index].hasImage ? 2.5 * SizeConfig.heightSizeMultiplier : 0,),

                            Visibility(
                              visible: _highwayCodeViewModel.contentList[_highwayCodeViewModel.number-1].list[index].endContent != "",
                              child: Flexible(
                                child: Container(
                                  child: Text(mounted ? (_questionViewModel.languageID == Constants.questionAnswerLanguageIdList[0] ?
                                  _highwayCodeViewModel.contentList[_highwayCodeViewModel.number-1].list[index].endContent :
                                  _highwayCodeViewModel.contentList[_highwayCodeViewModel.number-1].list[index].endContentBangla) : "",
                                    textAlign: TextAlign.justify,
                                    style: GoogleFonts.poppins(
                                      textStyle: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: _highwayCodeViewModel.contentList[_highwayCodeViewModel.number-1].list[index].endContent != "" ? 2.5 * SizeConfig.heightSizeMultiplier : 0,),

                            Visibility(
                              visible: _highwayCodeViewModel.contentList[_highwayCodeViewModel.number-1].list[index].law != "",
                              child: Flexible(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(mounted ? (_questionViewModel.languageID == Constants.questionAnswerLanguageIdList[0] ?
                                  _highwayCodeViewModel.contentList[_highwayCodeViewModel.number-1].list[index].law :
                                  _highwayCodeViewModel.contentList[_highwayCodeViewModel.number-1].list[index].lawBangla) : "",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.poppins(
                                      textStyle: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.deepOrange[400], fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: _highwayCodeViewModel.contentList[_highwayCodeViewModel.number-1].list[index].law != "" ? 3.75 * SizeConfig.heightSizeMultiplier : 0,),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            SizedBox(height: 2.5 * SizeConfig.heightSizeMultiplier,)
          ],
        ) : Container(child: Center(child: CircularProgressIndicator(),),),
      ),
    );
  }



  Align _footer() {

    return Align(
      child: Container(
        color: Color(0xFF4682B4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            Expanded(
              flex: 1,
              child: Visibility(
                visible: mounted ? _highwayCodeViewModel.number > 1 : false,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.only(left: 3.84 * SizeConfig.widthSizeMultiplier),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.arrow_back_ios, size: 8.97 * SizeConfig.imageSizeMultiplier, color: Colors.black,),
                    ),
                  ),
                  onTap: () {

                    if(_highwayCodeViewModel.number > 1) {

                      Provider.of<SettingsViewModel>(context, listen: false).playSound();
                      _highwayCodeViewModel.previousPage(_highwayCodeInterface);
                    }
                    else {

                      return null;
                    }
                  }
                ),
              ),
            ),

            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.center,
                child: Text(mounted ? (_settingsViewModel.isEnglish ? _highwayCodeViewModel.number.toString() : _highwayCodeViewModel.totalContentNumber) +
                    AppLocalization.of(context).getTranslatedValue("of") + (_settingsViewModel.isEnglish ? _highwayCodeViewModel.contentList.length.toString() :
                _highwayCodeViewModel.stringNumber) : "",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 1,
              child: Visibility(
                visible: mounted ? _highwayCodeViewModel.number < _highwayCodeViewModel.contentList.length : false,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.only(right: 3.84 * SizeConfig.widthSizeMultiplier),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.arrow_forward_ios, size: 8.97 * SizeConfig.imageSizeMultiplier, color: Colors.black,
                      ),
                    ),
                  ),
                  onTap: () {

                    if(_highwayCodeViewModel.number < _highwayCodeViewModel.contentList.length) {

                      Provider.of<SettingsViewModel>(context, listen: false).playSound();
                      _highwayCodeViewModel.nextPage(_highwayCodeInterface);
                    }
                    else {

                      return null;
                    }
                  }
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  void _showFullImage(Uint8List image) async {
    Navigator.of(context).pushNamed(RouteManager.HIGHWAY_CODE_FULL_IMAGE_PAGE_ROUTE, arguments: image);
  }



  void _onBackPressed() {
    Navigator.pop(context);
  }



  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  void scrollToTop() {

    if(mounted) {
      _scrollController.animateTo(0, curve: Curves.easeInOut, duration: const Duration(milliseconds: 200),
      );
    }
  }


  @override
  void showHighwayContents() {
  }


  @override
  void showRoadSignContents(int categoryIndex, {int subCategoryIndex}) {
  }
}