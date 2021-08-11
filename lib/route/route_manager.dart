import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/model/QuestionView.dart';
import 'package:ukbangladrivingtest/model/road_sign_constructor_model.dart';
import 'package:ukbangladrivingtest/model/test_result_page_model.dart';
import 'package:ukbangladrivingtest/view/hazard_perception/clip_review.dart';
import 'package:ukbangladrivingtest/view/hazard_perception/hazard_clip_selection.dart';
import 'package:ukbangladrivingtest/view/theory_test/chapter_selection.dart';
import 'package:ukbangladrivingtest/view/theory_test/theory_answering_choice.dart';
import 'package:ukbangladrivingtest/view/road_sign/fav_road_signs.dart';
import 'package:ukbangladrivingtest/view/theory_test/favourite_theory_questions.dart';
import 'package:ukbangladrivingtest/view/hazard_perception/hazard_introduction.dart';
import 'package:ukbangladrivingtest/view/hazard_perception/hazard_perception_home.dart';
import 'package:ukbangladrivingtest/view/highway_code/highway_code_detail.dart';
import 'package:ukbangladrivingtest/view/highway_code/highway_code_category.dart';
import 'package:ukbangladrivingtest/view/theory_test/theory_mock_test.dart';
import 'package:ukbangladrivingtest/view/theory_test/theory_progress_monitor.dart';
import 'package:ukbangladrivingtest/view/theory_test/theory_category.dart';
import 'package:ukbangladrivingtest/view/theory_test/theory_practise.dart';
import 'package:ukbangladrivingtest/view/theory_test/theory_question_search.dart';
import 'package:ukbangladrivingtest/view/theory_test/theory_question_view.dart';
import 'package:ukbangladrivingtest/view/road_sign/road_sign_category.dart';
import 'package:ukbangladrivingtest/view/road_sign/road_sign_sub_category.dart';
import 'package:ukbangladrivingtest/view/road_sign/road_sign_view.dart';
import 'package:ukbangladrivingtest/view/road_sign/road_signs_home.dart';
import 'package:ukbangladrivingtest/view/general_settings.dart';
import 'package:ukbangladrivingtest/view/splash_screen.dart';
import 'package:ukbangladrivingtest/view/home_page.dart';
import 'package:ukbangladrivingtest/view/theory_test/theory_test_result.dart';
import 'package:ukbangladrivingtest/view/theory_test/theory_mock_intro.dart';
import 'package:ukbangladrivingtest/view/theory_test/theory_test_home.dart';
import 'package:ukbangladrivingtest/view/theory_test/theory_test_alert.dart';
import 'package:ukbangladrivingtest/view/road_sign/find_road_sign.dart';
import 'package:ukbangladrivingtest/widgets/highway_code_full_image.dart';
import 'package:ukbangladrivingtest/widgets/progress_answer_review.dart';
import 'package:ukbangladrivingtest/view/hazard_perception/video_practise_view.dart';


class RouteManager {

  static const String SPLASH_SCREEN_ROUTE = "splashScreen";
  static const String HOME_PAGE_ROUTE = "homePage";
  static const String WARNING_PAGE_ROUTE = "warningPage";
  static const String THEORY_TEST_PAGE_ROUTE = "theoryTestPage";
  static const String SETTINGS_PAGE_ROUTE = "settingsPage";
  static const String QUESTION_CATEGORY_SELECTION_PAGE_ROUTE = "questionCategorySelectionPage";
  static const String ANSWERING_CHOICE_PAGE_ROUTE = "answeringChoicePage";
  static const String QUESTION_VIEW_PAGE_ROUTE = "questionViewPage";
  static const String HAZARD_PERCEPTION_PAGE_ROUTE = "hazardPerceptionPage";
  static const String TEST_RESULT_PAGE_ROUTE = "testResultPage";
  static const String PROGRESS_MONITOR_PAGE_ROUTE = "progressMonitorPage";
  static const String HAZARD_INTRODUCTION_PAGE_ROUTE = "hazardIntroductionPage";
  static const String QUESTION_SEARCH_PAGE_ROUTE = "questionSearchPage";
  static const String QUESTION_SEARCH_VIEW_ROUTE = "questionSearchViewPage";
  static const String FAV_QUESTION_VIEW_ROUTE = "favQuestionViewPage";
  static const String MOCK_TEST_INTRO_ROUTE = "mockTestIntroPage";
  static const String MOCK_TEST_QUESTION_VIEW_ROUTE = "mockTestQuestionViewPage";
  static const String ROAD_SIGNS_PAGE_ROUTE = "roadSignsPage";
  static const String HIGHWAY_CODE_PAGE_ROUTE = "highwayCodePage";
  static const String HIGHWAY_CODE_DETAILS_PAGE_ROUTE = "highwayCodeDetailsPage";
  static const String ROAD_SIGN_CATEGORY_PAGE_ROUTE = "roadSignCategoryPage";
  static const String ROAD_SIGN_SUB_CATEGORY_PAGE_ROUTE = "roadSignSubCategoryPage";
  static const String ROAD_SIGN_VIEW_PAGE_ROUTE = "roadSignViewPage";
  static const String FIND_ROAD_SIGN_PAGE_ROUTE = "roadSignFindPage";
  static const String FAV_ROAD_SIGN_PAGE_ROUTE = "roadSignFavPage";
  static const String PROGRESS_ANSWER_REVIEW_PAGE_ROUTE = "progressAnswerReviewPage";
  static const String HAZARD_PRACTISE_PAGE_ROUTE = "hazardPractisePage";
  static const String VIDEO_PRACTISE_VIEW_PAGE_ROUTE = "videoPractiseViewPage";
  static const String CLIP_REVIEW_PAGE_ROUTE = "clipReviewPage";
  static const String HIGHWAY_CODE_FULL_IMAGE_PAGE_ROUTE = "highwayCodeFullImagePage";
  static const String CHAPTER_SELECTION = "chapterSelectionPage";

  static Route<dynamic> generate(RouteSettings settings) {

    final args = settings.arguments;

    switch(settings.name) {

      case SPLASH_SCREEN_ROUTE:
      return MaterialPageRoute(builder: (_) => SplashScreen());

      case HOME_PAGE_ROUTE:
        return MaterialPageRoute(builder: (_) => HomePage());

      case WARNING_PAGE_ROUTE:
        return MaterialPageRoute(builder: (_) => ThoeryTestAlert());

      case THEORY_TEST_PAGE_ROUTE:
        return MaterialPageRoute(builder: (_) => TheoryTestHome());

      case SETTINGS_PAGE_ROUTE:
        return MaterialPageRoute(builder: (_) => GeneralSettings());

      case QUESTION_CATEGORY_SELECTION_PAGE_ROUTE :
        return MaterialPageRoute(builder: (_) => TheoryCategory());

      case ANSWERING_CHOICE_PAGE_ROUTE :
        return MaterialPageRoute(builder: (_) => TheoryAnsweringChoice(args as List<bool>));

      case QUESTION_VIEW_PAGE_ROUTE :
        return MaterialPageRoute(builder: (_) => TheoryPractise(args as List<bool>));

      case HAZARD_PERCEPTION_PAGE_ROUTE :
        return MaterialPageRoute(builder: (_) => HazardPerceptionHome());

      case TEST_RESULT_PAGE_ROUTE :
        return MaterialPageRoute(builder: (_) => TheoryTestResult(args as TestResultPageModel));

      case PROGRESS_MONITOR_PAGE_ROUTE :
        return MaterialPageRoute(builder: (_) => TheoryProgressMonitor());

      case HAZARD_INTRODUCTION_PAGE_ROUTE :
        return MaterialPageRoute(builder: (_) => HazardIntroduction());

      case QUESTION_SEARCH_PAGE_ROUTE :
        return MaterialPageRoute(builder: (_) => TheoryQuestionSearch());

      case QUESTION_SEARCH_VIEW_ROUTE :
        return MaterialPageRoute(builder: (_) => TheoryQuestionView(args as QuestionView));

      case FAV_QUESTION_VIEW_ROUTE :
        return MaterialPageRoute(builder: (_) => FavouriteTheoryQuestions());

      case MOCK_TEST_INTRO_ROUTE :
        return MaterialPageRoute(builder: (_) => TheoryMockIntro());

      case MOCK_TEST_QUESTION_VIEW_ROUTE :
        return MaterialPageRoute(builder: (_) => TheoryMockTest());

      case ROAD_SIGNS_PAGE_ROUTE :
        return MaterialPageRoute(builder: (_) => RoadSignsHome());

      case HIGHWAY_CODE_PAGE_ROUTE :
        return MaterialPageRoute(builder: (_) => HighwayCodeCategory());

      case HIGHWAY_CODE_DETAILS_PAGE_ROUTE :
        return MaterialPageRoute(builder: (_) => HighwayCodeDetail());

      case ROAD_SIGN_CATEGORY_PAGE_ROUTE :
        return MaterialPageRoute(builder: (_) => RoadSignCategory());

      case ROAD_SIGN_SUB_CATEGORY_PAGE_ROUTE :
        return MaterialPageRoute(builder: (_) => RoadSignSubCategory(args as int));

      case ROAD_SIGN_VIEW_PAGE_ROUTE :
        return MaterialPageRoute(builder: (_) => RoadSignView(args as RoadSignConstructor));

      case FIND_ROAD_SIGN_PAGE_ROUTE :
        return MaterialPageRoute(builder: (_) => FindRoadSign());

      case FAV_ROAD_SIGN_PAGE_ROUTE :
        return MaterialPageRoute(builder: (_) => FavRoadSigns());

      case PROGRESS_ANSWER_REVIEW_PAGE_ROUTE :
        return MaterialPageRoute(builder: (_) => ProgressAnswerReview(args as int));

      case HAZARD_PRACTISE_PAGE_ROUTE :
        return MaterialPageRoute(builder: (_) => HazardClipSelection());

      case VIDEO_PRACTISE_VIEW_PAGE_ROUTE :
        return MaterialPageRoute(builder: (_) => VideoPractiseView(args as String));

      case CLIP_REVIEW_PAGE_ROUTE :
        return MaterialPageRoute(builder: (_) => CipReview(args as String));

      case HIGHWAY_CODE_FULL_IMAGE_PAGE_ROUTE :
        return MaterialPageRoute(builder: (_) => FullImageView(args as Uint8List));

      case CHAPTER_SELECTION :
        return MaterialPageRoute(builder: (_) => ChapterSelection());

      default:
        return MaterialPageRoute(builder: (_) => Scaffold(body: SafeArea(child: Center(child: Text("Route Error")))));
    }
  }
}