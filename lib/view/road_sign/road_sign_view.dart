import 'dart:typed_data';

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
import 'package:ukbangladrivingtest/widgets/road_sign_full_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class RoadSignView extends StatefulWidget {

  final RoadSignConstructor _constructor;

  RoadSignView(this._constructor);

  @override
  _RoadSignViewState createState() => _RoadSignViewState();
}


class _RoadSignViewState extends State<RoadSignView> implements HighwayCodeInterface {

  HighwayCodeViewModel _highwayCodeViewModel;
  QuestionViewModel _questionViewModel;

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
              flex: 6,
              child: _header()
          ),

          Expanded(
              flex: 20,
              child: Container(
                color: Colors.white,
                child: mounted ? (_highwayCodeViewModel.filteredRoadSignList.list.length > 0 ? _contentView() :
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
              child: _highwayCodeViewModel.filteredRoadSignList.list.length > 0 ? _footer() : Container(color: Colors.white,),
          ),
        ],
      ),
    );
  }



  Container _header() {

    return Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 2.5 * SizeConfig.heightSizeMultiplier),
        color: Colors.lightBlue[400],
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.normal),
                    ),
                    children: <TextSpan> [

                      TextSpan(text: _highwayCodeViewModel.filteredRoadSignList.list.length > 0 ? (_questionViewModel.languageID == Constants.questionAnswerLanguageIdList[0] ?
                      Constants.roadSignCategoryList[_highwayCodeViewModel.filteredRoadSignList.list[_highwayCodeViewModel.number-1].categoryID - 1] :
                      Constants.roadSignCategoryListBangla[_highwayCodeViewModel.filteredRoadSignList.list[_highwayCodeViewModel.number-1].categoryID - 1]) :
                      (_questionViewModel.languageID == Constants.questionAnswerLanguageIdList[0] ?
                      Constants.roadSignCategoryList[widget._constructor.categoryIndex] :
                      Constants.roadSignCategoryListBangla[widget._constructor.categoryIndex])),

                      TextSpan(text: _highwayCodeViewModel.filteredRoadSignList.list.length > 0 ?
                      (_highwayCodeViewModel.filteredRoadSignList.list[_highwayCodeViewModel.number-1].subCategoryID == 0 ? "" : " > ") :
                      (widget._constructor.subCategoryIndex == null ? "" : " > "),
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),

                      TextSpan(text: _highwayCodeViewModel.filteredRoadSignList.list.length > 0 ?
                      (_highwayCodeViewModel.filteredRoadSignList.list[_highwayCodeViewModel.number-1].subCategoryID == 0 ? "" :
                      _questionViewModel.languageID == Constants.questionAnswerLanguageIdList[0] ?
                      Constants.roadSignSubCategoryList[_highwayCodeViewModel.filteredRoadSignList.list[_highwayCodeViewModel.number-1].categoryID - 1]
                      [_highwayCodeViewModel.filteredRoadSignList.list[_highwayCodeViewModel.number-1].subCategoryID - 1] :
                      Constants.roadSignSubCategoryListBangla[_highwayCodeViewModel.filteredRoadSignList.list[_highwayCodeViewModel.number-1].categoryID - 1]
                      [_highwayCodeViewModel.filteredRoadSignList.list[_highwayCodeViewModel.number-1].subCategoryID - 1]) :
                      (widget._constructor.subCategoryIndex == null ? "" :
                      _questionViewModel.languageID == Constants.questionAnswerLanguageIdList[0] ?
                      Constants.roadSignSubCategoryList[widget._constructor.categoryIndex][widget._constructor.subCategoryIndex] :
                      Constants.roadSignSubCategoryListBangla[widget._constructor.categoryIndex][widget._constructor.subCategoryIndex])),
                    ]
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
              padding: EdgeInsets.only(left: 7.69 * SizeConfig.widthSizeMultiplier, right: 7.69 * SizeConfig.widthSizeMultiplier),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  SizedBox(height: 6.25 * SizeConfig.heightSizeMultiplier),

                  Visibility(
                    visible: _highwayCodeViewModel.filteredRoadSignList.list[_highwayCodeViewModel.number-1].content != "",
                    child: Flexible(
                      child: Container(
                        child: Text(mounted ? (_questionViewModel.languageID == Constants.questionAnswerLanguageIdList[0] ?
                        _highwayCodeViewModel.filteredRoadSignList.list[_highwayCodeViewModel.number-1].content :
                        _highwayCodeViewModel.filteredRoadSignList.list[_highwayCodeViewModel.number-1].contentBangla) : "",
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: _highwayCodeViewModel.filteredRoadSignList.list[_highwayCodeViewModel.number-1].content != "" ? 2.5 * SizeConfig.heightSizeMultiplier : 0,),

                  Visibility(
                    visible: _highwayCodeViewModel.filteredRoadSignList.list[_highwayCodeViewModel.number-1].hasImage,
                    child: Flexible(
                      child: mounted ? (_highwayCodeViewModel.filteredRoadSignList.list[_highwayCodeViewModel.number-1].hasImage ?
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: double.infinity,
                          height: 25 * SizeConfig.heightSizeMultiplier,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            image: DecorationImage(image: MemoryImage(_highwayCodeViewModel.filteredRoadSignList.list[_highwayCodeViewModel.number-1].image),
                                fit: BoxFit.contain
                            ),
                          ),
                        ),
                        onTap: () {
                          Provider.of<SettingsViewModel>(context, listen: false).playSound();
                          _showFullImage(_highwayCodeViewModel.filteredRoadSignList.list[_highwayCodeViewModel.number-1].image);
                        },
                      ) : Container()) : Container(),
                    ),
                  ),

                  SizedBox(height: _highwayCodeViewModel.filteredRoadSignList.list[_highwayCodeViewModel.number-1].hasImage ? 2.5 * SizeConfig.heightSizeMultiplier : 0,),

                  Visibility(
                    visible: _highwayCodeViewModel.filteredRoadSignList.list[_highwayCodeViewModel.number-1].endContent != "",
                    child: Flexible(
                      child: Container(
                        child: Text(mounted ? (_questionViewModel.languageID == Constants.questionAnswerLanguageIdList[0] ?
                        _highwayCodeViewModel.filteredRoadSignList.list[_highwayCodeViewModel.number-1].endContent :
                        _highwayCodeViewModel.filteredRoadSignList.list[_highwayCodeViewModel.number-1].endContentBangla) : "",
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.lightBlue[400],
        child: Row(
          mainAxisSize: MainAxisSize.max,
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
              child: GestureDetector(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    child: Icon(Icons.favorite, size: 8.97 * SizeConfig.imageSizeMultiplier,
                      color: _highwayCodeViewModel.filteredRoadSignList.list[_highwayCodeViewModel.number-1].isMarkedFavourite ? Colors.green[600] : Colors.black,),
                  ),
                ),
                onTap: () {
                  Provider.of<SettingsViewModel>(context, listen: false).playSound();
                  _highwayCodeViewModel.onFavPressed();
                },
              ),
            ),

            Expanded(
              flex: 1,
              child: Visibility(
                visible: mounted ? _highwayCodeViewModel.number < _highwayCodeViewModel.filteredRoadSignList.list.length : false,
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

                      if(_highwayCodeViewModel.number < _highwayCodeViewModel.filteredRoadSignList.list.length) {

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

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {

          return StatefulBuilder(
              builder: (context, StateSetter setState) {

                return RoadSignFullView(image);
              }
          );
        }
    );
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