
import 'package:do_an_ck/controller/onboarding/onboard_controller.dart';
import 'package:get/get.dart';

class Onboardbinding extends Bindings{
  @override
  void dependencies() {
    Get.put(OnboardController());
  }
}