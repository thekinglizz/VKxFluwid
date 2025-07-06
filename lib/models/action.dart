import 'package:flapp_widget/models/venue.dart';
import 'package:json_annotation/json_annotation.dart';

part 'action.g.dart';

@JsonSerializable(explicitToJson: true)
class Action {
  final int actionId;
  final int cityId;
  final String age;
  final bool kdp;
  final String legalOwnerName;
  final String actionName;
  final String fullActionName;
  final String smallPosterUrl;
  final String bigPosterUrl;
  final String description;
  final List<Venue> venueList;

  Action(this.actionId, this.cityId, this.age, this.kdp, this.legalOwnerName,
      this.actionName, this.fullActionName, this.smallPosterUrl, this.bigPosterUrl,
      this.description, this.venueList);

  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);
  Map<String, dynamic> toJson() => _$ActionToJson(this);

  @override
  String toString() {
    return 'Action{actionId: $actionId, cityId: $cityId, kdp: $kdp, '
        'actionName: $actionName, fullActionName: $fullActionName, '
        'smallPosterUrl: $smallPosterUrl, venueList: $venueList}';
  }
}

class ActionInfo{
  final int actionId;
  final int cityId;
  final int minSum;
  final String actionName;
  final String cityName;
  final String fullActionName;
  final String smallPosterUrl;
  final String bigPosterUrl;
  final String firstEventDate;
  final String lastEventDate;
  final String? actionEventTime;
  final Map venueMap;

  ActionInfo(
    this.actionId,
    this.cityId,
    this.minSum,
    this.cityName,
    this.actionName,
    this.fullActionName,
    this.smallPosterUrl,
    this.bigPosterUrl,
    this.firstEventDate,
    this.lastEventDate,
    this.actionEventTime,
    this.venueMap
  );

  ActionInfo.fromJson(Map<String, dynamic> json)
      : actionId = json['actionId'] as int,
        cityId = json['cityId'] as int,
        minSum = json['minSum'] as int,
        venueMap = json['venueMap'] as Map,
        cityName = json['cityName'] as String,
        actionName = json['actionName'] as String,
        fullActionName = json['fullActionName'] as String,
        smallPosterUrl = json['smallPosterUrl'] as String,
        bigPosterUrl = json['bigPosterUrl'] as String,
        firstEventDate = json['firstEventDate'] as String,
        lastEventDate = json['lastEventDate'] as String,
        actionEventTime = json['actionEventTime'] as String?;

  @override
  String toString() {
    return 'ActionInfo{actionId: $actionId, actionName: $actionName}';
  }
}