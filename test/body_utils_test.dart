import 'package:flutter_test/flutter_test.dart';
import 'package:http_request_utils/body_utils.dart';

class TestClass {
  String id;
  int integer;
  String name;
  String lastname;

  TestClass({
    required this.id,
    required this.integer,
    required this.name,
    required this.lastname
  });

  factory TestClass.fromJson (dynamic json) {
    return TestClass (
      id: jsonField<String> (json, ["_id", "\$oid"], nullable: false),
      integer: jsonField<int> (json, ["integer"],  nullable: false),
      name: jsonField<String> (json, ["name"],  nullable: false),
      lastname: jsonField<String> (json, ["lastname",],  nullable: false),
    );
  }
}

class TestListClass {
  int index;
  String text;

  TestListClass({
    required this.index,
    required this.text
  });

  factory TestListClass.fromJson (dynamic json) {
    return TestListClass (
      index: jsonField<int> (json, ["index"],  nullable: false),
      text: jsonField<String> (json, ["text"], nullable: false)
    );
  }
}

void main() {
  final json = {
    "_id": {
      "\$oid": "123"
    },
    "stringList": ["Hello", "World"],
    "badClass": {
      "_id": {
        "\$oid": "456"
      },
      "integer": 4,
      "name": null,
      "lastname": "Marin"
    },
    "organization": null,
    "integer": 15,
    "number": 0.45,
    "name": "Juan",
    "lastname": "Lara",
    "nullValue": null,
    "nonNullValue": null,
    "classList": [
      {
        "index": 0,
        "text": "Hola"
      },
      {
        "index": 1,
        "text": "Hello"
      },
      {
        "index": 2,
        "text": "Hallo"
      }
    ]
  };

  test('Check for a json with all files as correct types', () {
    expect(jsonField<String> (json, ["name",],  nullable: false), "Juan");
    expect(jsonField<int> (json, ["integer",],  nullable: false), 15);
    expect(jsonField<num> (json, ["number",],  nullable: false), 0.45);
    expect(jsonField<String> (json, ["_id", "\$oid"], nullable: false), "123");
    expect(jsonField<String> (json, ["nullValue",]), null);
    expect(jsonField<String> (json, ["organization", "\$oid"], defaultValue: "Is null"), "Is null");
    expect (() => jsonField<String> (json, ["jsonBody"],  nullable: false), throwsA(isA<BodyException>()));
  });

  test('Check for list json fields', () {
    expect (jsonListField<String>(json, ["stringList"], nullable: false), <String>["Hello", "World"]);
    expect (jsonListField<String>(json, ["string_list"]), null);
    expect (jsonListField<TestListClass>(json, ["classList"], map: TestListClass.fromJson), isA<List<TestListClass>> ());
  });

  test('Check for list json fields with incorrect field types', () {
    expect (() => jsonListField<int> (json, ["stringList"], nullable: false), throwsA (isA<BodyException> ()));
  });

  test ('Check for class json fields', () {
    expect (jsonClassField<TestClass>(json, [], TestClass.fromJson, nullable: false), isA<TestClass> ());
    expect (jsonClassField<TestClass>(json, ["badClass"], TestClass.fromJson, nullOnException: true, nullable: true), null);
    expect (jsonClassField<TestClass>(json, ["object"], (item) => TestClass.fromJson (item)), null);
  });

  test ('Check for class json fields with incorrect field type', () {
    expect (() => jsonClassField<TestListClass> (json, [], TestListClass.fromJson, nullable: false), throwsA(isA<BodyException> ()));
    expect (() => jsonClassField<TestClass> (json, [], TestClass.fromJson, nullOnException: true, nullable: false), throwsA (isA<AssertionError> ()));
  });

  test ("Check for exceptions with incorrect file types", () {
    expect (() => jsonField<int> (json, ["name"],  nullable: false), throwsA (isA<BodyException>()));
    expect (() => jsonField<String> (json, ["_id"],  nullable: false), throwsA (isA<BodyException> ()));
    expect (() => jsonField<int> (json, ["number"],  nullable: false), throwsA (isA<BodyException> ()));
  });

  test ("Check for exceptions with null values", () {
    expect (() => jsonField<String> (json, ["nullValue"], nullable: false), throwsA (isA<BodyException> ()));
    expect (() => jsonField<String> (json, ["organization", "\$oid"], nullable: false), throwsA (isA<BodyException> ()));
  });
}
