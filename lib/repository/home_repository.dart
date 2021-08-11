import 'package:ukbangladrivingtest/utils/local_memory.dart';

class HomeRepository {

  LocalMemory _localMemory;

  Future<bool> shouldShowTheoryTestAlert() async {

    _localMemory = LocalMemory();
    bool status = await _localMemory.shouldShowTheoryTestAlert();

    return status;
  }
}