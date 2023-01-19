library http_request_utils;

import 'dart:async';

import 'package:http_request_utils/models/body_exception.dart';

export 'package:http_request_utils/models/body_exception.dart' show BodyException;
export 'package:http_request_utils/models/http_exception.dart' show HttpException;
export 'package:http_request_utils/models/http_exception.dart' show Code;
export 'package:http_request_utils/models/http_exception.dart' show Reason;

dynamic jsonField <T>(dynamic json, List<String> field, {bool nullable = true, T? defaultValue, bool printUnknownException = false}) {
  dynamic retval = json;
  try {
    for (String f in field){
      retval = retval [f];
      if (retval == null && nullable) {
        break;
      }
    }
    if (retval == null) {
      if (!nullable) {
        throw BodyException (type: BodyExceptionType.isNull, fieldName: field.join("-"));
      } else {
        return defaultValue;
      }
    } else {
      assert (retval is T);
    }

    return retval;
  } on BodyException {
    rethrow;
  } on AssertionError catch (_) {
    throw BodyException(
      type: BodyExceptionType.isNotType, 
      fieldName: field.join ("-"), 
      failedType: T, 
      currentType: retval.runtimeType
    );  
  } on NoSuchMethodError catch (_) {
    throw BodyException(
      type: BodyExceptionType.isNull, 
      fieldName: field.join ("_"), 
      failedType: T, 
      currentType: retval.runtimeType
    );  
  } catch (error, bt) {
    if (printUnknownException) {
      Completer ().completeError(error, bt);
    }
    throw BodyException(
      type: BodyExceptionType.undefined, 
      fieldName: field.join ("_")
    );
  }
}

dynamic jsonListField<T> (
  dynamic json, List<String> field, 
  {
    T Function (dynamic)? map, 
    bool nullable = true, 
    bool skipExceptions = false,
    List<T>? defaultValue,
    bool printUnknownException = false
  }
) {
  List<T>? retval;
  Iterable? list = jsonField<dynamic> (json, field,  nullable: nullable);
  if (list != null) {
    retval = [];
    int i = 0;
    for (dynamic item in list) {
      try {
        if (map != null) {
          try {
            retval.add (
              map (item)
            );
            i++;
          } on BodyException catch (error) {
            throw BodyException(
              type: error.type, 
              fieldName: field.join ("-") + "[" + error.fieldName + "]",
              currentType: error.currentType,
              failedType: error.failedType,
              index: i
            );
          } catch (error, bt) {
            if (printUnknownException) {
              Completer ().completeError(error, bt);
            }
            throw BodyException(
              type: BodyExceptionType.undefined, 
              fieldName: field.join ("-"),
              index: i
            );
          }
        } else {
          try {
            assert (item is T);
            retval.add (item);
          } on AssertionError {
            throw BodyException(
              type: BodyExceptionType.isNotType, 
              fieldName: field.join ("-"), 
              failedType: T, 
              currentType: retval.runtimeType,
              index: i
            );  
          }
        }
      } on BodyException {
        if (!skipExceptions) {
          rethrow;
        }
      }
    }
  }

  return retval ?? defaultValue;
}

dynamic jsonClassField<T> (
  dynamic json, List<String> field, T? Function (dynamic) fromJson, 
  {bool nullable = true, bool skipException = false, T? defaultValue, bool printUnknownException = false}
) {
  assert (
    (
      nullable && ( skipException || !skipException )
    )
    || (!nullable && !skipException)
  );

  T? retval;

  try {

    dynamic body = jsonField<dynamic> (json, field,  nullable: nullable);

    if (body != null) {
      try {
        retval = fromJson (body);

        if (retval == null && !nullable) {
          throw NoSuchMethodError;
        }
      } on BodyException {
        rethrow;
      } on NoSuchMethodError catch (_) {
        throw BodyException(
          type: BodyExceptionType.isNull, 
          fieldName: field.join ("_"), 
          failedType: T, 
          currentType: retval.runtimeType
        );  
      } catch (error, bt) {
        if (printUnknownException) {
          Completer().completeError(error, bt);
        }
        throw BodyException(
          type: BodyExceptionType.undefined, 
          fieldName: field.join ("_"),
        );
      }
    }

  } on BodyException {
    if (!skipException) {
      rethrow;
    }
  }

  return retval ?? defaultValue;
}