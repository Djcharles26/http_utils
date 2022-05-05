

import 'package:http_request_utils/body_utils.dart';

class RequestData {
  String id;
  String name;
  String number;
  String integer;
  Map<String, dynamic> shortMap;
  DateTime date;

  RequestData ({
    required this.id,
    required this.name,
    required this.number,
    required this.integer,
    required this.shortMap,
    required this.date
  });

  factory RequestData.fromJson (dynamic json) {
    return RequestData(
      id: jsonField<String> (json, ["_id", "\$oid"], nullable: false),
      name: jsonField<String> (json, ["name",],  nullable: false),
      number: jsonField<num> (json, ["number"],  nullable: false),
      integer: jsonField<int> (json, ["integer",],  nullable: false),
      shortMap: jsonField<dynamic> (json, ["short_map",],  nullable: false),
      date: DateTime.fromMillisecondsSinceEpoch(
        jsonField<int> (json, ["date", "\$date"]),
      )
    );
  }
}