import '../providers/user_data.dart';

class Utilities {
  ///takes enum and return String
  static String toUsefulString(dynamic enumValue) {
    return enumValue.toString().split('.').last;
  }

  static UserTimeFilter toUsefulEnum(String enumAsString) {
    var temp = UserTimeFilter.values.firstWhere((value) {
      return value.toString().contains(enumAsString);
    });
    return temp;
  }
}
