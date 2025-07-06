import 'package:json_annotation/json_annotation.dart';

import 'action_event.dart';
part 'venue.g.dart';

@JsonSerializable(explicitToJson: true)
class Venue {
  final int venueId;
  final String venueName;
  final String address;
  final List<ActionEvent> actionEventList;

  Venue(this.venueId, this.venueName, this.actionEventList, this.address);

  factory Venue.fromJson(Map<String, dynamic> json) => _$VenueFromJson(json);
  Map<String, dynamic> toJson() => _$VenueToJson(this);

  @override
  String toString() {
    return 'Venue{venueId: $venueId, venueName: $venueName, '
        'actionEventList: $actionEventList}';
  }
}