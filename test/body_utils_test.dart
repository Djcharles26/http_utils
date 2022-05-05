import 'package:flutter_test/flutter_test.dart';
import 'package:http_request_utils/body_utils.dart';

void main() {
  final json = {
    "_id": {
      "\$oid": "123"
    },
    "integer": 15,
    "number": 0.45,
    "name": "Juan",
    "lastname": "Lara",
    "nullValue": null,
    "nonNullValue": null
  };
  test('Check for a json with all files as correct types', () {
    expect(jsonField<String> (json, ["name",],  nullable: false), "Juan");
    expect(jsonField<int> (json, ["integer",],  nullable: false), 15);
    expect(jsonField<num> (json, ["number",],  nullable: false), 0.45);
    expect(jsonField<String> (json, ["_id", "\$oid"], nullable: false), "123");
    expect(jsonField<String> (json, ["nullValue",]), null);
    expect (() => jsonField<String> (json, ["jsonBody"],  nullable: false), throwsA(isA<BodyException>()));
  });

  test ("Check for exceptions with incorrect file types", () {
    expect (() => jsonField<int> (json, ["name"],  nullable: false), throwsA (isA<BodyException>()));
    expect (() => jsonField<String> (json, ["_id"],  nullable: false), throwsA (isA<BodyException> ()));
    expect (() => jsonField<int> (json, ["number"],  nullable: false), throwsA (isA<BodyException> ()));
  });

  test ("Check for exceptions with null values", () {
    expect (() => jsonField<String> (json, ["nullValue"], nullable: false), throwsA (isA<BodyException> ()));
  });
}
