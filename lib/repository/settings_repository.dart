import 'package:ukbangladrivingtest/utils/local_memory.dart';

class SettingsRepository {

  LocalMemory _localMemory;

  Future<bool> getSoundStatus() async {

    _localMemory = LocalMemory();
    bool status = await _localMemory.getSoundStatus();

    return status;
  }

  void setSoundStatus(bool value) async {

    _localMemory = LocalMemory();
    _localMemory.setSoundStatus(value);
  }
}