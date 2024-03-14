import 'package:get/get.dart';

class Dimensions {
  // height = 834.28
  static double screenHeight = Get.context!.height;
  // width = 411.42
  static double screenWidth = Get.context!.width;

  // Dynamic heights
  static double height5 = screenHeight / 166.85;
  static double height10 = screenHeight / 83.42;
  static double height30 = screenHeight / 27.8;
  static double height40 = screenHeight / 20.85;
  static double gameScreenHeight1 = Dimensions.screenHeight / 4.88;
  static double gameScreenHeight2 =
      Dimensions.screenHeight - (Dimensions.screenHeight / 2.44);

  // Dynamic widths
  static double width5 = screenWidth / 82.28;
  static double width10 = screenWidth / 41.14;
  static double width30 = screenWidth / 13.71;

  // Border size
  static double border30 = screenHeight / 27.8;

  // Icon size
  static double icon180 = screenHeight / 4.634;

  // Radius
  static double radius5 = screenHeight / 166.85;
  static double radius12 = screenHeight / 69.52;

  // Font size
  static double fontSize14 = screenHeight / 59.59;

  // Loading SpinKitCircle size
  static double loadingCircle100 = screenHeight / 8.34;
}
