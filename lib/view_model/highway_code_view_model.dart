import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/interace/basic_view_model.dart';
import 'package:ukbangladrivingtest/interace/highway_code_interface.dart';
import 'package:ukbangladrivingtest/model/highway_code.dart';
import 'package:ukbangladrivingtest/model/road_sign_category_description.dart';
import 'package:ukbangladrivingtest/repository/highway_code_repository.dart';
import 'package:ukbangladrivingtest/utils/constants.dart';


class HighwayCodeViewModel extends ChangeNotifier implements BasicViewModel {

  bool isDisposed = true;
  bool isFetched = false;
  bool isRoadSign = false;

  int number = 0;
  int selectedIndex = 0;

  String totalContentNumber = "";
  String stringNumber = "";

  List<String> allCategoryList = List();
  List<String> allCategoryListBangla = List();

  List<String> subCategoryList = List();
  List<String> subCategoryListBangla = List();

  List<HighWayCodeList> contentList = List();

  HighWayCodeList roadSignList = HighWayCodeList(list: List());
  HighWayCodeList favRoadSignList = HighWayCodeList(list: List());
  HighWayCodeList filteredRoadSignList = HighWayCodeList(list: List());

  RoadSignDescription categoryDescription = RoadSignDescription();

  List<RoadSignDescription> subCategoryDescriptionList = List();



  void getHighwayCodeCategoryList() {

    if(!isDisposed) {

      if(!isFetched) {

        isFetched = true;

        for(int i=0; i<Constants.highwayCodeCategoryList.length; i++) {

          allCategoryList.add(Constants.highwayCodeCategoryList[i]);
          allCategoryListBangla.add(Constants.highwayCodeCategoryListBangla[i]);
        }

        for(int i=0; i<Constants.annexCategoryList.length; i++) {

          allCategoryList.add(Constants.annexCategoryList[i]);
          allCategoryListBangla.add(Constants.annexCategoryListBangla[i]);
        }

        for(int i=0; i<Constants.roadSignCategoryList.length; i++) {

          allCategoryList.add(Constants.roadSignCategoryList[i]);
          allCategoryListBangla.add(Constants.roadSignCategoryListBangla[i]);
        }
      }

      //notifyListeners();
    }
  }



  Future<void> getHighwayCodeDetails(int index, HighwayCodeInterface interface) async {

    if(!isDisposed) {

      selectedIndex = index;

      contentList.clear();
      subCategoryList.clear();
      subCategoryListBangla.clear();
      subCategoryDescriptionList.clear();

      if((index + 1) <= Constants.highwayCodeCategoryList.length) {

        isRoadSign = false;

        if(Constants.highwayCodeSubCategoryList[index].length > 0) {

          for(int i=0; i<Constants.highwayCodeSubCategoryList[index].length; i++) {

            subCategoryList.add(Constants.highwayCodeSubCategoryList[index][i]);
            subCategoryListBangla.add(Constants.highwayCodeSubCategoryListBangla[index][i]);

            HighWayCodeList highWayCodeList = await HighwayCodeRepository().getHighwaySubCategoryData(index + 1, i + 1);
            contentList.add(highWayCodeList);
          }
        }
        else {

          HighWayCodeList highWayCodeList = await HighwayCodeRepository().getHighwayCategoryData(index + 1);
          contentList.add(highWayCodeList);
        }
      }
      else {

        if((index + 1) <= Constants.highwayCodeCategoryList.length + Constants.annexCategoryList.length) {

          isRoadSign = false;

          HighWayCodeList highWayCodeList = await HighwayCodeRepository().getHighwayCategoryData(index + 1);
          contentList.add(highWayCodeList);
        }
        else {

          if((index + 1) <= Constants.highwayCodeCategoryList.length + Constants.annexCategoryList.length + Constants.roadSignCategoryList.length) {

            isRoadSign = true;

            if(Constants.roadSignSubCategoryList[index - (Constants.highwayCodeCategoryList.length + Constants.annexCategoryList.length)].length > 0) {

              categoryDescription = await HighwayCodeRepository().getRoadSignCategoryDescription((index + 1) -
                  (Constants.highwayCodeCategoryList.length + Constants.annexCategoryList.length));

              for(int i=0; i<Constants.roadSignSubCategoryList[index - (Constants.highwayCodeCategoryList.length + Constants.annexCategoryList.length)].length; i++) {

                subCategoryList.add(Constants.roadSignSubCategoryList[index - (Constants.highwayCodeCategoryList.length + Constants.annexCategoryList.length)][i]);
                subCategoryListBangla.add(Constants.roadSignSubCategoryListBangla[index - (Constants.highwayCodeCategoryList.length + Constants.annexCategoryList.length)][i]);

                HighWayCodeList highWayCodeList = await HighwayCodeRepository().getRoadSignSubCategoryData((index + 1) -
                    (Constants.highwayCodeCategoryList.length + Constants.annexCategoryList.length), i + 1);

                contentList.add(highWayCodeList);

                RoadSignDescription subCategoryDescription = await HighwayCodeRepository().getRoadSignSubCategoryDescription((index + 1) -
                    (Constants.highwayCodeCategoryList.length + Constants.annexCategoryList.length), i + 1);

                subCategoryDescriptionList.add(subCategoryDescription);
              }
            }
            else {

              HighWayCodeList highWayCodeList = await HighwayCodeRepository().getRoadSignCategoryData((index + 1) -
                  (Constants.highwayCodeCategoryList.length + Constants.annexCategoryList.length));

              contentList.add(highWayCodeList);

              categoryDescription = await HighwayCodeRepository().getRoadSignCategoryDescription((index + 1) -
                  (Constants.highwayCodeCategoryList.length + Constants.annexCategoryList.length));
            }
          }
        }
      }

      number = 1;

      stringNumber = await _translateNumber(number);
      totalContentNumber = await _translateNumber(contentList.length);

      interface.showHighwayContents();
      notifyListeners();
    }
  }



  Future<String> _translateNumber(int number) async {

    String inBangla = "";

    for(int i=0; i<number.toString().length; i++) {

      for(int j=0; j<Constants.englishNumeric.length; j++) {

        if(number.toString()[i] == Constants.englishNumeric[j]) {

          inBangla = inBangla + Constants.banglaNumeric[j];
          break;
        }
      }
    }

    return inBangla;
  }



  Future<void> getRoadSigns() async {

    if(!isDisposed) {

      if(roadSignList.list.length == 0) {

        roadSignList = await HighwayCodeRepository().getAllRoadSignData();
        getFavRoadSigns();

        notifyListeners();
      }
    }
  }



  Future<void> getFavRoadSigns() async {

    if(!isDisposed) {

      favRoadSignList.list.clear();

      for(int i=0; i<roadSignList.list.length; i++) {

        if(roadSignList.list[i].isMarkedFavourite) {

          favRoadSignList.list.add(roadSignList.list[i]);
        }
      }

      notifyListeners();
    }
  }



  Future<void> filterRoadSigns(int categoryIndex, HighwayCodeInterface interface, {int subCategoryIndex}) async {

    if(!isDisposed) {

      filteredRoadSignList.list.clear();

      if(subCategoryIndex == null) {

        for(int i=0; i<roadSignList.list.length; i++) {

          if(roadSignList.list[i].categoryID == (categoryIndex + 1)) {

            filteredRoadSignList.list.add(roadSignList.list[i]);
          }
        }
      }
      else {

        for(int i=0; i<roadSignList.list.length; i++) {

          if(roadSignList.list[i].categoryID == (categoryIndex + 1) && roadSignList.list[i].subCategoryID == (subCategoryIndex + 1)) {

            filteredRoadSignList.list.add(roadSignList.list[i]);
          }
        }
      }

      number = 1;

      stringNumber = await _translateNumber(number);

      interface.showRoadSignContents(categoryIndex, subCategoryIndex: subCategoryIndex);
      notifyListeners();
    }
  }



  Future<void> onRoadSignSelected(int index, HighwayCodeInterface interface, bool isFavPage) async {

    if(!isDisposed) {

      if(isFavPage) {

        filteredRoadSignList.list.clear();
        filteredRoadSignList.list = filteredRoadSignList.list + favRoadSignList.list;
      }
      else {

        filteredRoadSignList.list.clear();
        filteredRoadSignList.list = filteredRoadSignList.list + roadSignList.list;
      }

      number = index + 1;

      stringNumber = await _translateNumber(number);

      interface.showRoadSignContents(index);
      notifyListeners();
    }
  }



  void onFavPressed() {

    if(!isDisposed) {

      filteredRoadSignList.list[number-1].isMarkedFavourite = !filteredRoadSignList.list[number-1].isMarkedFavourite;

      HighwayCodeRepository().setFavouriteStatus(filteredRoadSignList.list[number-1]);


      for(int i=0; i<roadSignList.list.length; i++) {

        if(roadSignList.list[i].id == filteredRoadSignList.list[number-1].id) {

          roadSignList.list[i].isMarkedFavourite = filteredRoadSignList.list[number-1].isMarkedFavourite;
          break;
        }
      }


      getFavRoadSigns();

      notifyListeners();
    }
  }



  Future<void> nextPage(HighwayCodeInterface interface) async {

    if(!isDisposed) {

      number = number + 1;

      stringNumber = await _translateNumber(number);

      notifyListeners();
      interface.scrollToTop();
    }
  }



  Future<void> previousPage(HighwayCodeInterface interface) async {

    if(!isDisposed) {

      number = number - 1;

      stringNumber = await _translateNumber(number);

      notifyListeners();
      interface.scrollToTop();
    }
  }



  Future<void> resetModel() async {

    isDisposed = true;
    isFetched = false;
    isRoadSign = false;

    number = 0;
    selectedIndex = 0;

    totalContentNumber = "";
    stringNumber = "";

    allCategoryList.clear();
    allCategoryListBangla.clear();
    subCategoryList.clear();
    subCategoryListBangla.clear();
    contentList.clear();
    roadSignList.list.clear();
    favRoadSignList.list.clear();
    filteredRoadSignList.list.clear();
    subCategoryDescriptionList.clear();

    categoryDescription = RoadSignDescription();

    if(!isDisposed) {
      notifyListeners();
    }
  }



  @override
  void removeDisposedStatus() {

    if(isDisposed) {
      isDisposed = false;
    }

    //notifyListeners();
  }
}