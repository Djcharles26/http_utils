library http_request_utils;

import 'package:http_request_utils/models/body_exception.dart';

export 'package:http_request_utils/models/body_exception.dart' show BodyException;
export 'package:http_request_utils/models/http_exception.dart' show HttpException;
export 'package:http_request_utils/models/http_exception.dart' show Code;
export 'package:http_request_utils/models/http_exception.dart' show Reason;

dynamic jsonField <T>(dynamic json, List<String> field, {bool nullable = true, T? defaultValue}) {
  dynamic retval = json;
  try {
    for (String f in field){
      retval = retval [f];
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
      fieldName: field.join ("-"), 
      failedType: T, 
      currentType: retval.runtimeType
    );  
  } catch (error) {
    throw BodyException(type: BodyExceptionType.undefined, fieldName: field.join ("-"));
  }
}