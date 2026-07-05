import 'package:mini_home/core/themes/strings.dart';
import 'package:version/version.dart';

enum FwUpdateStatus {
  unknown,
  latest,
  updateAvailable,
  updating;

  String get label {
    switch (this) {
      case FwUpdateStatus.updateAvailable:
        return AppStrings.fwUpdateStatusUpdateAvailable;
      case FwUpdateStatus.updating:
        return AppStrings.fwUpdateStatusUpdating;
      default:
        return "";
    }
  }

  String get shortLabel {
    switch (this) {
      case FwUpdateStatus.updateAvailable:
        return AppStrings.fwUpdateStatusUpdateAvailableShort;
      case FwUpdateStatus.updating:
        return AppStrings.fwUpdateStatusUpdatingShort;
      default:
        return "";
    }
  }

  /// マイナーバージョン・パッチも含めて「最新かどうか」を判定する。
  static FwUpdateStatus fromFwVersion(
      String? currentVersion, String latestVersion,
      [bool? isUpdating]) {
    if (currentVersion == null) {
      return FwUpdateStatus.unknown;
    }

    final currentNorm = _getFormattedVersion(currentVersion);
    final latestNorm = _normalizeVersionString(latestVersion);
    if (currentNorm.isEmpty) return FwUpdateStatus.unknown;

    final currentParsed = _tryParseVersion(currentNorm);
    final latestParsed = _tryParseVersion(latestNorm);

    if (currentParsed != null && latestParsed != null) {
      // セマンティック比較: 現在 >= 最新 なら latest、そうでなければ updateAvailable
      if (currentParsed >= latestParsed) return FwUpdateStatus.latest;
      if (isUpdating == true) return FwUpdateStatus.updating;
      return FwUpdateStatus.updateAvailable;
    }

    // パースできない場合は従来どおり文字列一致で判定
    if (currentNorm == latestNorm) return FwUpdateStatus.latest;
    if (isUpdating == true) return FwUpdateStatus.updating;
    return FwUpdateStatus.updateAvailable;
  }

  /// ファームウェアバージョンから "v" プレフィックスと "-dirty" を除去した整形済み文字列を返す
  static String _getFormattedVersion(String? version) {
    if (version == null) return '';
    return _normalizeVersionString(version);
  }

  static String _normalizeVersionString(String v) {
    return v.replaceAll('-dirty', '').replaceFirst(RegExp(r'^v'), '').trim();
  }

  static Version? _tryParseVersion(String v) {
    if (v.isEmpty) return null;
    try {
      return Version.parse(v);
    } catch (_) {
      return null;
    }
  }
}
