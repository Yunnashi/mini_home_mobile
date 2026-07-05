// ignore_for_file: constant_identifier_names
enum ApiErrors {
  invalid_token('GL_AU_01'),
  email_unconfirmed('US_DE_CR_01');

  const ApiErrors(this.errorCode);

  final String errorCode;
}
