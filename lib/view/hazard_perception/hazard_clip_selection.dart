import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/interace/no_connection_interface.dart';
import 'package:ukbangladrivingtest/localization/app_localization.dart';
import 'package:ukbangladrivingtest/route/route_manager.dart';
import 'package:ukbangladrivingtest/utils/size_config.dart';
import 'package:ukbangladrivingtest/view_model/hazard_practise_view_model.dart';
import 'package:ukbangladrivingtest/view_model/settings_view_model.dart';
import 'package:ukbangladrivingtest/widgets/no_connection.dart';
import 'package:ukbangladrivingtest/widgets/score_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class HazardClipSelection extends StatefulWidget {

  @override
  _HazardClipSelectionState createState() => _HazardClipSelectionState();
}


class _HazardClipSelectionState extends State<HazardClipSelection> implements NoConnectionInterface {

  HazardPractiseViewModel _hazardPractiseViewModel;
  NoConnectionInterface _hazardPractiseInterface;

  int _currentIndex = 0;


  @override
  void initState() {

    _hazardPractiseInterface = this;
    super.initState();
  }


  @override
  void didChangeDependencies() {

    _hazardPractiseViewModel = Provider.of<HazardPractiseViewModel>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {

      _hazardPractiseViewModel.removeDisposedStatus();
      _hazardPractiseViewModel.getHazardVideos(_hazardPractiseInterface);
    });

    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: <Widget>[

            _loadingView(),

            NoConnection(_hazardPractiseInterface),

            _mainContent(),
          ],
        ),
      ),
    );
  }


  Container _mainContent() {

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          Expanded(
            flex: 2,
            child: _header(),
          ),

          Expanded(
            flex: 7,
            child: _clipView(),
          ),
        ],
      ),
    );
  }


  Container _header() {

    return Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 2.7 * SizeConfig.heightSizeMultiplier),
        color: Colors.black,
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
                  radius: 3.85 * SizeConfig.imageSizeMultiplier,
                  child: Icon(Icons.arrow_back, color: Colors.black,),
                ),
                onTap: () {
                  Provider.of<SettingsViewModel>(context, listen: false).playSound();
                  Navigator.pop(context);
                },
              ),
            ),

            Expanded(
              flex: 5,
              child: Text(AppLocalization.of(context).getTranslatedValue("select_a_clip"),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: Container(),
            ),
          ],
        )
    );
  }


  Container _clipView() {

    return Container(
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return;
        },
        child: mounted ? SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: EdgeInsets.only(left: 5.12 * SizeConfig.widthSizeMultiplier, right: 5.12 * SizeConfig.widthSizeMultiplier),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _hazardPractiseViewModel.thumbnails.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5 * SizeConfig.widthSizeMultiplier,
                    mainAxisSpacing: 5 * SizeConfig.heightSizeMultiplier,
                  ),
                  itemBuilder: (BuildContext context, int index) {

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        height: 25 * SizeConfig.heightSizeMultiplier,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[

                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: MemoryImage(_hazardPractiseViewModel.thumbnails[index]), fit: BoxFit.fill),
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.center,
                                color: Colors.black,
                                child: IconTheme(
                                  data: IconThemeData(size: 5.64 * SizeConfig.widthSizeMultiplier),
                                  child: ScoreBar(_hazardPractiseViewModel.storedHazardClips.clipList[index].score),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Provider.of<SettingsViewModel>(context, listen: false).playSound();
                        _hazardPractiseViewModel.onVideoSelected(index, _hazardPractiseInterface);
                      },
                    );
                  },
                ),

                SizedBox(height: 5 * SizeConfig.heightSizeMultiplier),
              ],
            ),
          ),
        ) : Container(),
      ),
    );
  }


  Container _loadingView() {

    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          CircularProgressIndicator(),

          SizedBox(height: 5 * SizeConfig.heightSizeMultiplier),

          Text(AppLocalization.of(context).getTranslatedValue("loading_clips"),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }


  @override
  void dispose() {
    _hazardPractiseViewModel.resetModel();
    super.dispose();
  }


  @override
  void onNoConnection() {

    if(mounted) {
      setState(() {
        _currentIndex = 1;
      });
    }
  }


  @override
  void tryAgain() {

    setState(() {
      _currentIndex = 0;
    });

    _hazardPractiseViewModel.getHazardVideos(_hazardPractiseInterface);
  }


  @override
  void showContent() {

    setState(() {
      _currentIndex = 2;
    });
  }


  @override
  void openVideo(String url) {

    Navigator.of(context).pushNamed(RouteManager.VIDEO_PRACTISE_VIEW_PAGE_ROUTE, arguments: url);
  }
}