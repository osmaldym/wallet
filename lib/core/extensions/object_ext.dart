extension ObjectExt on Object? {
  bool intToBool() => this != null ? this! as int > 0 : false;
  int boolToInt() => this != null ? (this! as bool ? 1 : 0) : 0;

  bool toBool() {
    if (this == null) return false;
    else if (this is bool) return this as bool;
    else if (this is num) return (this! as num) > 0;
    else if (this is String) return (this as String).isEmpty;
    return true;
  }
}