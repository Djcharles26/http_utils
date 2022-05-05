

enum BodyExceptionType {
  none,
  isNull,
  isNotType,
  undefined
}

extension BodyExceptionTypeExt on BodyExceptionType {
  String get name {
    switch (this) {
      case BodyExceptionType.none:
        return "None exception ";
      case BodyExceptionType.isNull:
        return "Item is null";
      case BodyExceptionType.isNotType:
        return "Item is not correct type";
      case BodyExceptionType.undefined:
        return "Item had an unkwnown error";
    }
  }
}

class BodyException implements Exception {
  String fieldName;
  BodyExceptionType type;
  dynamic failedType;
  dynamic currentType;

  BodyException( {required this.type, required this.fieldName, this.failedType, this.currentType});

  @override
  String toString() {
    String base = "${type.name}: $fieldName";
    if (failedType != null) {
      base += "\nFailed Type: $failedType / Current Type: $currentType";
    }
    return base;
    // return super.toString(); // Instance of BodyException
  }
}