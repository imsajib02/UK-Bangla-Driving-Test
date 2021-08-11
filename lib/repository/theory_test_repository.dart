import 'package:ukbangladrivingtest/utils/local_memory.dart';

class TheoryTestRepository {

  LocalMemory _localMemory;

  Future<bool> getPassGuaranteeModeStatus() async {

    _localMemory = LocalMemory();
    bool status = await _localMemory.getPassGuaranteeStatus();

    return status;
  }
}