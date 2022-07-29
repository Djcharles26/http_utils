class HttpException implements Exception {
  String message;
  String? submessage;
  String? route;
  Code code;
  Reason? reason;
  int status;

  HttpException(this.message, {this.submessage, this.route, this.code= Code.request, this.reason, this.status = -1});



  @override
  String toString() {
    String retval = "";
    if (route != null) {
      retval = "Route: $route\n";
    }
    retval += message + (submessage ?? "") +
      "\n${reasonToString(reason??Reason.confirm)}";
    return retval;
      
  }

  String reasonToString(Reason reason){
    switch(reason){
      case Reason.name:
        return "Reason Name";
      case Reason.username:
        return "Reason Username";
      case Reason.email:
        return "Reason Email";
      case Reason.password:
        return "Reason Password";
      case Reason.confirm:
        return "Reason Confirm";
      default:
        return "Unkwown reason";
    }
  }

  String codeToString(Code code){
    switch(code){
      case Code.user:
        return "Code User";
      case Code.unauthorized:
        return "Code Unauthorized";
      case Code.request:
        return "Code Request";
      case Code.system:
        return "Code System";
      case Code.db:
        return "Code DB";
      default:
        return "Unkown Code";
    }
  }
}

enum Reason {
  server,
  name,
  username,
  email,
  password,
  confirm,
  notFound,
  missingValues,
  cancelled
}

enum Code {
  user,
  unauthorized,
  request,
  system,
  db,
}