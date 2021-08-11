
import 'package:flutter/material.dart';
import 'package:ukbangladrivingtest/resources/images.dart';

class Constants {

  static const String playStoreUrl = "https://play.google.com/store/apps";
  static const String appStoreUrl = "https://www.apple.com/app-store/";

  static const List<int> userTypeIdList = [11, 25, 43];
  static const List<String> userTypeList = ['Car Driver', 'Motorcyclist', 'ADI Instructor'];

  static const List<int> countryCodeList = [101, 202];
  static const List<String> countryList = ['Great Britain', 'Northern Ireland'];
  static const List<String> countryBanglaList = ['গ্রেট ব্রিটেন', 'উত্তর আয়ারল্যান্ড'];
  static const List<String> countryListShortForm = ['GB', 'NI'];
  static const List<String> countryFlagList = [Images.greatBritainFlag, Images.northernIrelandFlag];

  static const List<int> numberOfQuestionsIdList = [1, 2, 3, 4, 5, 6];
  static const List<String> numberOfQuestionsList = ['10 questions', '20 questions', '30 questions', '40 questions', '50 questions', 'All questions'];
  static const List<String> numberOfQuestionsBanglaList = ['১০ টি প্রশ্ন', '২০ টি প্রশ্ন', '৩০ টি প্রশ্ন', '৪০ টি প্রশ্ন', '৫০ টি প্রশ্ন', 'সব প্রশ্ন'];

  static const List<int> questionTypeIdList = [1, 2, 3, 4];
  static const List<String> questionTypeList = ['All questions', 'Previously answered incorrectly', 'Questions not yet seen', 'Favourite questions'];
  static const List<String> questionTypeBanglaList = ['সব প্রশ্ন', 'পূর্বে ভুল উত্তর দেওয়া', 'এখনও না দেখা প্রশ্ন', 'প্রিয় প্রশ্ন'];

  static const List<int> questionAnswerLanguageIdList = [1, 2];

  static const List<int> progressTypeList = [1, 2];

  static const List<String> englishNumeric = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
  static const List<String> banglaNumeric = ["০", "১", "২", "৩", "৪", "৫", "৬", "৭", "৮", "৯"];

  static const List<String> categories = ['All Categories', 'Alertness', 'Attitude', 'Documents', 'Hazard Awareness', 'Road and Traffic Signs', 'Incidents, Accidents and Emergencies',
    'Other Type of Vehicle', 'Vehicle Handling', 'Motorway Rules', 'Rules of the Road', 'Safety Margins', 'Safety and Your Vehicle', 'Vulnerable Road Users', 'Vehicle Loading'];

  static const List<String> categoriesBangla = ['সব বিভাগ', 'সতর্কতা', 'মনোভাব', 'নথি', 'বিপদ সচেতনতা', 'রাস্তা ও ট্র্যাফিকের চিহ্ন', 'ঘটনা, দুর্ঘটনা ও জরুরী অবস্থা',
    'অন্যান্য ধরণের যানবাহন', 'যানবাহন পরিচালনা', 'মোটরওয়ে বিধি', 'রাস্তার আইন', 'সুরক্ষা মার্জিন', 'সুরক্ষা এবং আপনার যানবাহন', 'ক্ষতিগ্রস্থ রোড ব্যবহারকারীরা', 'যানবাহন লোডিং'];

  static const int testDuration = 3420;


  static const List<String> highwayCodeCategoryList = ["Rules for pedestrians", "Rules for users of powered wheelchairs and powered mobility scooters",
    "Rules about animals", "Rules for cyclists", "Rules for motorcyclists", "Rules for drivers and motorcyclists", "General rules, techniques and advice for all drivers and riders",
    "Using the road", "Road users requiring extra care", "Driving in adverse weather conditions", "Waiting and parking", "Motorways", "Breakdowns and incidents",
    "Road works, level crossings and tramways"];

  static const List<String> highwayCodeCategoryListBangla = ["পথচারীদের জন্য নিয়ম", "চালিত হুইলচেয়ার এবং চালিত গতিশীলতা স্কুটার ব্যবহারকারীদের জন্য নিয়ম",
    "প্রাণী সম্পর্কে নিয়ম", "সাইক্লিস্টদের নিয়ম", "মোটরসাইকেল চালকদের নিয়ম", "ড্রাইভার এবং মোটরসাইকেল চালকদের নিয়ম", "সমস্ত ড্রাইভার এবং রাইডারদের জন্য সাধারণ নিয়ম, কৌশল এবং পরামর্শ",
    "রাস্তা ব্যবহার করা", "অতিরিক্ত যত্নের প্রয়োজন রাস্তা ব্যবহারকারীদের", "প্রতিকূল আবহাওয়ায় গাড়ি চালানো", "অপেক্ষা এবং পার্কিং", "মোটরওয়েজ", "ভাঙ্গন এবং ঘটনা",
    "রাস্তার কাজ, লেভেল ক্রসিং এবং ট্রামওয়ে"];

  static const List<List<String>> highwayCodeSubCategoryList = [["General guidance", "Crossing the road", "Crossings", "Situations needing extra care"],
    ["Powered wheelchairs and mobility scooters", "On pavements", "On the road"], ["Horse-drawn vehicles", "Horse riders", "Other animals"], ["Overview", "Road junctions",
    "Roundabouts", "Crossing the road", "You and your bicycle"], ["General guidance", "Motorcycle licence requirements"], ["Vehicle condition", "Fitness to drive",
    "Alcohol and drugs", "Before setting off", "Vehicle towing and loading", "Seat belts and child restraints"], ["Overview", "Signals", "Other stopping procedures",
    "Lighting requirements", "Control of the vehicle", "Lines and lane markings on the road", "Multi-lane carriageways", "General advice"], ["General rules",
    "Overtaking", "Road junctions", "Roundabouts"], ["Overview", "Pedestrians", "Motorcyclists and cyclists"], ["Overview", "Wet weather", "Icy and snowy weather"],
    ["Waiting and parking", "Parking"], ["General", "Motorway signals", "Joining the motorway", "On the motorway"], ["Breakdowns", "Additional rules for motorways",
    "Obstructions"], ["Road works", "Additional  rules for high-speed roads"]];

  static const List<List<String>> highwayCodeSubCategoryListBangla = [["সাধারণ নির্দেশিকা", "রাস্তা পার হচ্ছে", "পারাপার", "অতিরিক্ত যত্নের প্রয়োজন পরিস্থিতি"],
    ["চালিত হুইলচেয়ার এবং গতিশীলতা স্কুটার", "ফুটপাতে", "পথে"], ["ঘোড়া টানা যানবাহন", "ঘোড়সওয়ার", "অন্যান্য প্রাণী"], ["ওভারভিউ", "রোড জংশন",
      "চতুর্দিকে", "রাস্তা পার হচ্ছে", "আপনি এবং আপনার সাইকেল"], ["সাধারণ নির্দেশিকা", "মোটরসাইকেলের লাইসেন্সের প্রয়োজনীয়তা"], ["যানবাহনের অবস্থা", "ফিটনেস ড্রাইভ",
      "অ্যালকোহল এবং ড্রাগ", "রওনা দেওয়ার আগে", "যানবাহন তোয়ালে ও লোড হচ্ছে", "আসন বেল্ট এবং শিশু নিয়ন্ত্রণ"], ["ওভারভিউ", "সিগন্যাল", "অন্যান্য থামার পদ্ধতি",
      "আলোর প্রয়োজনীয়তা", "যানবাহন নিয়ন্ত্রণ", "রাস্তায় লাইন এবং লেনের চিহ্নগুলি", "মাল্টি-লেন ক্যারিজওয়ে", "সাধারণ উপদেশ"], ["সাধারণ রুল",
      "ওভারটেকিং", "রোড জংশন", "চতুর্দিকে"], ["ওভারভিউ", "পথচারী", "মোটরসাইকেল চালক এবং সাইকেল চালক"], ["ওভারভিউ", "আর্দ্র আবহাওয়া", "বরফ এবং তুষারময় আবহাওয়া"],
    ["অপেক্ষা এবং পার্কিং", "পার্কিং"], ["সাধারণ", "মোটরওয়ে সংকেত", "মোটরওয়েতে যোগ দিচ্ছেন", "মোটরওয়েতে"], ["ভাঙ্গন", "মোটরওয়েগুলির জন্য অতিরিক্ত নিয়ম",
      "বাধা"], ["রাস্তার কাজ", "উচ্চ গতির রাস্তাগুলির জন্য অতিরিক্ত নিয়ম"]];



  static const List<String> roadSignCategoryList = ["Direction signs on roads and motorways", "Information signs",
    "Light signals controlling traffic", "Road markings", "Road signs giving orders", "Road works signs", "Signals by authorised persons",
    "Signals to other road users", "Vehicle markings", "Warning signs"];

  static const List<String> roadSignCategoryListBangla = ["রাস্তা এবং মোটরওয়েতে দিক নির্দেশনা", "তথ্য সংকেত",
    "হালকা সংকেত ট্র্যাফিক নিয়ন্ত্রণ করে", "রাস্তা চিহ্নিতকরণ", "আদেশ প্রদানের রাস্তা সংকেত", "রাস্তার কাজ সংকেত", "অনুমোদিত ব্যক্তিদের দ্বারা সংকেত",
    "অন্যান্য রাস্তা ব্যবহারকারীদের জন্য সংকেত", "যানবাহন চিহ্নিতকরণ", "সতর্ক সংকেত"];

  static const List<List<String>> roadSignSubCategoryList = [["Signs on motorways - blue backgrounds", "Signs on primary routes - green backgrounds​",
    "Signs on non-primary and local routes - black borders"], ["All rectangular"], ["Traffic light signals", "Flashing red lights", "​Motorway signals", "Lane control signals"],
    ["Across the carriageway", "Along the carriageway", "Along the edge of the carriageway", "Loading restrictions on roads other than Red Routes", "Other road markings"],
    [], [], ["​Police officers", "​To beckon traffic on", "Arm signals to persons controlling traffic",
      "Driver and Vehicle Standards Agency officers and traffic officers", "School crossing patrols"], ["Direction indicator signals", "Brake light signals", "Reversing light signals",
      "Arm signals"], ["Large goods vehicle rear markings", "Hazard warning plates", "Diamond symbols indicating other risks include:", "Projections markers", "Other"], []];

  static const List<List<String>> roadSignSubCategoryListBangla = [["মোটরওয়েতে চিহ্ন - নীল পটভূমি", "প্রাথমিক রুটে চিহ্ন - সবুজ পটভূমি​",
    "প্রাথমিক ও স্থানীয় রুটে চিহ্নগুলি - কালো সীমানা"], ["সমস্ত আয়তক্ষেত্রাকার"], ["ট্র্যাফিক লাইট সংকেত", "ফ্ল্যাশিং রেড লাইট", "​মোটরওয়ে সংকেত", "লেন নিয়ন্ত্রণ সংকেত"],
    ["ক্যারাজওয়ে পেরিয়ে", "ক্যারিজওয়ে বরাবর", "ক্যারিজওয়ের ধারে", "রেড রুটগুলি ছাড়া অন্য রাস্তায় লোডিং সীমাবদ্ধতা", "অন্যান্য রাস্তা চিহ্নিতকরণ"],
    [], [], ["পুলিশ কর্মকর্তা", "​ট্র্যাফিক চালু করতে", "ট্র্যাফিক নিয়ন্ত্রণকারী ব্যক্তিদের কাছে আর্ম সিগন্যাল",
      "ড্রাইভার এবং যানবাহন স্ট্যান্ডার্ড এজেন্সি অফিসার এবং ট্র্যাফিক অফিসার", "স্কুল ক্রসিং টহল"], ["দিক নির্দেশক সংকেত", "ব্রেক আলোর সংকেত", "বিপরীত আলো সংকেত",
      "বাহু সিগন্যাল"], ["বড় পণ্যবাহী গাড়ির পিছনের চিহ্নগুলি", "বিপত্তি সতর্কতা প্লেট", "অন্যান্য ঝুঁকির ইঙ্গিতকারী ডায়মন্ডের প্রতীকগুলির মধ্যে রয়েছে:", "প্রজেকশন চিহ্নিতকারী", "অন্যান্য"], []];



  static const List<String> annexCategoryList = ["You and your bicycle", "Motorcycle licence requirements", "Motor vehicle documentation and learner driver requirements",
    "The road user and the law", "Penalties", "Vehicle maintenance, safety and security", "First aid on the road", "Safety Code for new drivers"];

  static const List<String> annexCategoryListBangla = ["আপনি এবং আপনার সাইকেল", "মোটরসাইকেলের লাইসেন্সের প্রয়োজনীয়তা", "মোটর গাড়ির ডকুমেন্টেশন এবং শিক্ষার্থীর ড্রাইভারের প্রয়োজনীয়তা",
    "রাস্তা ব্যবহারকারী এবং আইন", "জরিমানা", "যানবাহন রক্ষণাবেক্ষণ, সুরক্ষা এবং সুরক্ষা", "রাস্তায় প্রাথমিক চিকিত্সা", "নতুন ড্রাইভারদের জন্য সুরক্ষা কোড"];
}