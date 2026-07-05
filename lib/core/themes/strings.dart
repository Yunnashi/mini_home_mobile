import 'package:easy_localization/easy_localization.dart';

class AppStrings {
  static final AppStrings _instance = AppStrings._internal();

  factory AppStrings() {
    return _instance;
  }

  AppStrings._internal() {
    // initialization logic
  }

  //-------------------Commons - labels-------------------
  static String get lblEmail => "commons.labels.email".tr();

  static String get lblPassword => "commons.labels.password".tr();

  static String get lblTerms => "commons.labels.terms".tr();

  static String get lblPrivacyPolicy => "commons.labels.privacy_policy".tr();

  static String get chargingResultTimeTitle =>
      "commons.labels.charging_result_time".tr();

  static String get chargingResultKwhTitle =>
      "commons.labels.charging_result_kwh".tr();

  static String get connectingResultTimeTitle =>
      "commons.labels.connecting_result_time".tr();

  //-------------------Commons - actions -------------------
  static String get ok => "OK";

  static String get save => "commons.actions.save".tr();

  static String get txtBtnChange => "commons.actions.change".tr();

  static String get close => "commons.actions.close".tr();

  static String get retry => "commons.actions.retry".tr();

  static String get cancel => "commons.actions.cancel".tr();

  static String get delete => "commons.actions.delete".tr();

  static String get txtToSingUp => "commons.actions.to_registration".tr();

  //-------------------Commons - Unit-------------------
  static String get about => "commons.units.about".tr();

  static String get minute => "commons.units.minute".tr();

  static String get minuteLongText => "commons.units.minute_long_text".tr();

  static String formatDouble(double value) =>
      value == 0 ? '-' : "${value % 1 == 0 ? value.toInt() : value}";

  static String timeCharging(int hour, int minute, int second) =>
      "commons.formats.charging_time".tr(namedArgs: {
        "hour": hour.toString(),
        "minute": minute.toString().padLeft(2, '0'),
        "second": second.toString().padLeft(2, '0'),
      });
  //-------------------Commons - input validations-------------------
  static String messageMinLengthError(String fieldTitle, int minLength) =>
      "commons.validations.min_length".tr(namedArgs: {
        "field": fieldTitle,
        "min": "$minLength",
      });

  static String messageMaxLengthError(String fieldTitle, int maxLength) =>
      "commons.validations.max_length".tr(namedArgs: {
        "field": fieldTitle,
        "max": "$maxLength",
      });

  static String get messageRequired => "commons.validations.required".tr();

  static String messageIncorrectRelatedValue(String fieldTitle) =>
      "commons.validations.not_match".tr(namedArgs: {
        "field": fieldTitle,
      });

  static String get emailInputError =>
      "commons.validations.email_invalid_format".tr();

  //-------------------Commons - errors-------------------
  static String get error => "commons.errors.error".tr();

  // Network Errors
  static String get noSignalWarningMessage => "commons.errors.no_signal".tr();

  static String get errorBadResponse => "commons.errors.bad_response".tr();

  static String get errorAuthorization => "commons.errors.authorization".tr();

  static String get errorServer => "commons.errors.server".tr();

  static String get errorNetwork => "commons.errors.network".tr();

  // Others
  static String get unknownError => "commons.errors.unknown".tr();

  //-------------------Commons - permissions-------------------
  static String get permissionErrorTitle =>
      "commons.permissions.error_title".tr();

  static String get cameraPermissionMessage =>
      "commons.permissions.camera_permission_message".tr();

  static String get settings => "commons.permissions.open_settings".tr();

  //-------------------Commons - placeholders-------------------
  static String get emailHint => "sample@example.com";

  static String get passwordPrerequisite =>
      "commons.placeholders.password".tr();

  //-------------------Commons - update app-------------------
  static String get updateDialogTitle => "commons.update_app.dialog_title".tr();

  static String get updateDialogMessage =>
      "commons.update_app.dialog_message".tr();

  static String get update => "commons.update_app.update".tr();

  static String get passUpdate => "commons.update_app.pass".tr();

  //-------------------<Settings>-------------------
  //-------------------Account Settings Screen-------------------
  static String get accountSettingsTitle =>
      "settings.account_settings.title".tr();

  //-------------------WithDrawal Screen-------------------
  static String get withdraw => "settings.withdrawal.withdraw".tr();

  static String get withdrawalTitle => "settings.withdrawal.title".tr();

  static String get contentWithdraw =>
      "settings.withdrawal.confirm_withdraw".tr();

  static String get confirmWithdraw =>
      "settings.withdrawal.confirm_withdraw_final".tr();

  static String get successWithdrawal =>
      "settings.withdrawal.withdraw_success_dialog.title".tr();

  static String get contentSuccessWithdrawal =>
      "settings.withdrawal.withdraw_success_dialog.content".tr();

  //-------------------Charging History Screen(Usages)-------------------
  static String get chargingHistory => "settings.charging_history.title".tr();

  static String get usagesFetchError =>
      "settings.charging_history.fetch_error".tr();

  static String get chargingHistoryTitle =>
      "settings.charging_history.title".tr();

  //-------------------Others-------------------
  static String get lblLicensesInfo => "settings.others.licenses".tr();

  static String get lblFaq => "settings.others.faq".tr();

  static String get inquiryTitle => "settings.others.inquiry.title".tr();

  static String get callFailureMessage =>
      "settings.others.inquiry.call_failure".tr();

  //-------------------SignOut-------------------
  static String get signout => "settings.signout.signout".tr();

  static String get confirmSignout => "settings.signout.confirm".tr();

  static String get signoutComplete => "settings.signout.complete".tr();

  //-------------------SignIn Screen-------------------
  static String get messageDialogLoginSuccess =>
      "settings.signin.dialog_success".tr();

  static String get titleDialogLoginError =>
      "settings.signin.dialog_title_signin_error".tr();

  static String get titleSignIn => "settings.signin.title".tr();

  //-------------------SignUp Screen-------------------
  static String get titleSignUp => "settings.signup.title".tr();

  static String get lblPasswordConfirm =>
      "settings.signup.password_confirm".tr();

  static String get txtToSingIn => "settings.signup.to_signin".tr();

  static String get txtBtnSingUp => "settings.signup.submit".tr();

  static String get lblPrivacy2 => "settings.signup.privacy_and".tr();

  static String get lblPrivacy4 => "settings.signup.privacy_note".tr();

  static String get titleDialogRegisterError =>
      "settings.signup.dialog_error".tr();

  static String get titleDialogRegisterSuccess =>
      "settings.signup.dialog_success_title".tr();

  static String get msgDialogRegisterSuccess =>
      "settings.signup.dialog_success_message".tr();

  //-------------------Reset Password Screen-------------------
  static String get toPasswordReset => "password_reset.to_password_reset".tr();

  static String get passwordResetTitle => "password_reset.title".tr();

  static String get passwordResetDescription =>
      "password_reset.description".tr();

  static String get passwordResetDescription2 =>
      "password_reset.description2".tr();

  static String get passwordResetSendButton =>
      "password_reset.send_button".tr();

  static String get titleDialogPasswordResetSuccess =>
      "password_reset.success_dialog.title".tr();

  static String get messageDialogPasswordResetSuccess =>
      "password_reset.success_dialog.message".tr();

  //-------------------Password Change Screen-------------------
  static String get passwordChangeTitle => "password_change.title".tr();

  static String get lblCurrentPassword =>
      "password_change.current_password".tr();

  static String get lblNewPassword => "password_change.new_password".tr();

  static String get lblConfirmNewPassword =>
      "password_change.confirm_password".tr();

  static String get messageToastChangePasswordSuccess =>
      "password_change.success_message".tr();

  //-------------------Welcome Screen-------------------
  static String get welcomeTitle => "welcome.title".tr();

  static String get welcomeDescription => "welcome.description".tr();

  static String get welcomeLoginButton => "welcome.login_button".tr();

  static String get welcomeRegisterButton => "welcome.register_button".tr();

  //-------------------Device Status-------------------
  static String get deviceStatusDisconnected =>
      "device.status.disconnected".tr();
  static String get deviceStatusConnected => "device.status.connected".tr();
  static String get deviceStatusCharging => "device.status.charging".tr();
  static String get deviceStatusChargingStopped =>
      "device.status.charging_stopped".tr();
  static String get deviceStatusError => "device.status.error".tr();
  static String get deviceStatusUnknown => "device.status.unknown".tr();
  static String get deviceStatusOtaInProgress =>
      "device.status.ota_in_progress".tr();
  static String get deviceStatusOffline => "device.status.offline".tr();
  //-------------------Fw Update Status-------------------
  static String get fwUpdateStatusUpdateAvailable =>
      "device.fw_update_status.update_available".tr();
  static String get fwUpdateStatusUpdating =>
      "device.fw_update_status.updating".tr();
  static String get fwUpdateStatusUpdateAvailableShort =>
      "device.fw_update_status.update_available_short".tr();
  static String get fwUpdateStatusUpdatingShort =>
      "device.fw_update_status.updating_short".tr();

  // -------------------Device List Screen-------------------
  static String get device => "device_list.device".tr();

  static String get settingPower => "device_list.setting_power".tr();

  static String get temperature => "device_list.temperature".tr();

  static String temperatureToText(double temp) => "${formatDouble(temp)} °C";

  static String get deviceListFetchError => "device_list.fetch_error".tr();

  static String get noDeviceDescription =>
      "device_list.no_device.description".tr();

  static String get noDeviceAddDevice =>
      "device_list.no_device.add_device".tr();

  static String get addDevice => "device_list.add_device".tr();

  //-------------------Device Detail Screen-------------------
  static String get deviceDetailTitle => "device_detail.title".tr();

  static String get deviceDetailFetchError => "device_detail.fetch_error".tr();

  static String get deviceDetailUpdateError =>
      "device_detail.update_error".tr();

  static String get deviceIsOfflineError =>
      "device_detail.is_offline_error".tr();

  static String get deviceInfo => "device_detail.device_info".tr();

  static String get deviceId => "device_detail.device_id".tr();

  static String get deviceNicknameTitle =>
      "device_detail.device_nickname_title".tr();

  static String get deviceNickname => "device_detail.device_nickname".tr();

  static String get deviceNicknameShort =>
      "device_detail.device_nickname_short".tr();

  static String get deviceNicknamePlaceholder =>
      "device_detail.device_nickname_placeholder".tr();

  static String get deviceSettingsTitle => "device_detail.settings_title".tr();

  static String get deviceFwVersionLabel => "device_detail.fw_version".tr();

  static String get deviceSettingRebootLabel =>
      "device_settings.reboot.label".tr();

  static String get deviceSettingDoReboot =>
      "device_settings.reboot.do_reboot".tr();

  static String get deviceSettingRebootSuccess =>
      "device_settings.reboot.success".tr();

  static String get bleSearchFailed => "ble.search_failed".tr();

  static String get bleBluetoothOff => "ble.bluetooth_off".tr();

  static String get blePermissionDenied => "ble.permission_denied".tr();

  static String get bleInvalidDeviceId => "ble.invalid_device_id".tr();

  static String get deviceStatus => "device_detail.device_status".tr();

  static String get deviceTemperature => "device_detail.temperature".tr();

  static String get deviceDetailChangeChargingAmpere =>
      "device_detail.change_charging_ampere".tr();

  static String get deviceDetailChangeChargingAmpereTitle =>
      "device_detail.change_charging_ampere_title".tr();

  static String get deviceDetailChangeChargingAmpereNote =>
      "device_detail.change_charging_ampere_note".tr();

  static String get deviceDetailLatestUsage =>
      "device_detail.latest_usage".tr();

  static String get deviceDetailPendingChanges =>
      "device_detail.pending_changes".tr();

  static String get deviceDetailMoreUsage => "device_detail.more_usage".tr();

  static String get deviceDetailChargingSchedule =>
      "device_detail.charging_schedule".tr();

  static String get deviceDetailChargingScheduleDescription =>
      "device_detail.charging_schedule_description".tr();

  static String get deviceStatusHelpTitle =>
      "device_detail.status_help_title".tr();

  static String get deviceStatusHelpContentDisconnected =>
      "device_detail.status_help_content_disconnected".tr();

  static String get deviceStatusHelpContentConnected =>
      "device_detail.status_help_content_connected".tr();

  static String get deviceStatusHelpContentChargingStopped =>
      "device_detail.status_help_content_charging_stopped".tr();

  static String get deviceStatusHelpContentCharging =>
      "device_detail.status_help_content_charging".tr();

  static String get deviceStatusHelpContentError =>
      "device_detail.status_help_content_error".tr();

  static String get deviceStatusHelpContentOtaInProgress =>
      "device_detail.status_help_content_ota_in_progress".tr();

  static String get deviceStatusHelpContentOffline =>
      "device_detail.status_help_content_offline".tr();

  //-------------------FW Update-------------------
  static String get fwUpdateDialogTitle =>
      "device_detail.fw_update.dialog.title".tr();

  static String get fwUpdateDialogContent =>
      "device_detail.fw_update.dialog.content".tr();

  static String get fwUpdateDialogCaution =>
      "device_detail.fw_update.dialog.caution".tr();

  static String get fwUpdateDialogButton =>
      "device_detail.fw_update.dialog.button".tr();

  static String get fwUpdateTimeout => "device_detail.fw_update.timeout".tr();

  static String get fwUpdateSuccess => "device_detail.fw_update.success".tr();

  //-------------------Usage History-------------------
  static String get usageHistoryTitle => "usage_history.title".tr();

  static String usageHistoryMonthGroup(String month) =>
      "usage_history.month_group".tr(namedArgs: {"month": month});

  static String get usageHistoryEmpty => "usage_history.empty".tr();

  // -------------------User Group Screen-------------------
  static String get myHome => "user_group.my_home".tr();

  //-------------------QR Code Scanner Screen-------------------
  static String get readQr => "qr_code_scan.read_qr".tr();

  static String get chargingPreparingQrNote => "qr_code_scan.note".tr();

  static String get readQrDescription => "qr_code_scan.description".tr();

  static String flashSwitch(String state) => "qr_code_scan.flash_$state".tr();

  static String get deviceIdError => "qr_code_scan.device_id_error".tr();

  static String get resendConfirmationEmailButton =>
      "qr_code_scan.resend_confirmation_email".tr();

  //-------------------Schedule-------------------
  static String get daily => "schedule.frequency.daily".tr();

  static String get weekday => "schedule.frequency.weekday".tr();

  static String get nextDay => "schedule.frequency.next_day".tr();

  static String get everyWeek => "schedule.frequency.every_week".tr();

  static String get scheduleTitle => "schedule.title".tr();

  static String get scheduleCreateTitle => "schedule.create_title".tr();

  static String get scheduleEditTitle => "schedule.edit_title".tr();

  static String get startTime => "schedule.start_time".tr();

  static String get endTime => "schedule.end_time".tr();

  static String get repeatEveryday => "schedule.repeat_everyday".tr();

  static String get switchWeekday => "schedule.switch_weekday".tr();

  static String get scheduleSaveSuccess => "schedule.save_success".tr();

  static String get scheduleSaveError => "schedule.save_error".tr();

  static String get scheduleDeleteSuccess => "schedule.delete_success".tr();

  static String get scheduleDeleteError => "schedule.delete_error".tr();

  static String get scheduleDeleteConfirmTitle =>
      "schedule.delete_confirm_title".tr();

  static String get scheduleDeleteConfirmMessage =>
      "schedule.delete_confirm_message".tr();

  static String get scheduleTimeRangeError =>
      "schedule.validations.time_range_error".tr();

  static String get scheduleWeekdayRequiredError =>
      "schedule.validations.weekday_required_error".tr();

  // 曜日
  static String get sunday => "schedule.weekdays.sun".tr();
  static String get monday => "schedule.weekdays.mon".tr();
  static String get tuesday => "schedule.weekdays.tue".tr();
  static String get wednesday => "schedule.weekdays.wed".tr();
  static String get thursday => "schedule.weekdays.thu".tr();
  static String get friday => "schedule.weekdays.fri".tr();
  static String get saturday => "schedule.weekdays.sat".tr();
}
