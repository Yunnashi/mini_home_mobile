class DataUtils {
  static dynamic sanitizeParameters(dynamic data) {
    // マスキングしたいキーワードたち
    const sensitiveKeys = ["password", "token"];

    if (data is Map<String, dynamic>) {
      return data.map((key, value) {
        if (sensitiveKeys.contains(key)) {
          return MapEntry(key, "********");
        } else {
          return MapEntry(key, sanitizeParameters(value));
        }
      });
    } else {
      return data;
    }
  }
}
