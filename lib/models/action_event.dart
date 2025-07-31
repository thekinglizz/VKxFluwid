import 'package:flapp_widget/models/category.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import '../constants.dart';
part 'action_event.g.dart';

@JsonSerializable(explicitToJson: true)
class ActionEvent{
  final int actionEventId;
  final String day;
  final String time;
  final String currency;
  final bool fullNameRequired;
  final bool phoneRequired;
  final bool fanIdRequired;
  final String? placementUrl;
  final List<dynamic> tariffPlanList;
  final List<CategoryLimit> categoryLimitList;

  get monthDay{
    DateTime inputDate = inputFormat.parse('$day $time');
    return DateFormat(' d MMMM', Intl.shortLocale(Intl.defaultLocale!))
        .format(inputDate).toTitleCase();
  }

  get weekDay{
    DateTime inputDate = inputFormat.parse('$day $time');
    return DateFormat('EE', Intl.shortLocale(Intl.defaultLocale!))
        .format(inputDate).toTitleCase();
  }

  get date{
    var inputDate = inputFormat.parse('$day $time');
    return DateFormat(' d MMMM EE ', Intl.shortLocale(Intl.defaultLocale!))
        .format(inputDate).toTitleCase() + time;
  }

  get vkDate{
    var inputDate = inputFormat.parse('$day $time');
    return DateFormat('EEE, dd MMMM,', Intl.shortLocale(Intl.defaultLocale!))
        .format(inputDate).toTitleCase();
  }

  SchemeType get schemeType{
    if (placementUrl == null && categoryLimitList.isNotEmpty){
      return SchemeType.generalAdmission;
    }
    if (placementUrl != null && categoryLimitList.isEmpty){
      return SchemeType.assignedSeats;
    }
    if (placementUrl != null && categoryLimitList.isNotEmpty){
      return SchemeType.mixed;
    }
    return SchemeType.undefined;
  }

  ActionEvent(this.actionEventId, this.day, this.time, this.currency,
      this.placementUrl, this.tariffPlanList, this.categoryLimitList,
      this.fullNameRequired, this.phoneRequired, this.fanIdRequired);

  factory ActionEvent.fromJson(Map<String, dynamic> json) => _$ActionEventFromJson(json);
  Map<String, dynamic> toJson() => _$ActionEventToJson(this);

  @override
  String toString() {
    return 'ActionEvent{actionEventId: $actionEventId, day: $day, time: $time, '
        'currency: $currency, fullNameRequired: $fullNameRequired, '
        'phoneRequired: $phoneRequired, fanIdRequired: $fanIdRequired placementUrl: $placementUrl, '
        'tariffPlanList: $tariffPlanList, categoryLimitList: $categoryLimitList}';
  }
}