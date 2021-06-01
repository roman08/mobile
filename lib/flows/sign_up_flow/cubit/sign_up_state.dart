part of 'sign_up_cubit.dart';

const DEFAULT_DIAL_CODE = '+52';

enum SignUpStep {
  credentials,
  verification,
  idDocuments,
  residence,
  signature,
}

class SignUpState extends Equatable {
  final EmailInput email;
  final PasswordInput password;
  final PasswordConfirmInput confirmPassword;
  final String dialCode;
  final PhoneInput phone;
  final FormzStatus status;
  final SignUpErrors backendErrors;
  final String languageCode;
  final bool termsAndConditionsAccepted;
  final bool isCorporate;
  final String idFrontPath;
  final String idBackPath;
  final String selfiePath;
  final String proofOfResidencePath;
  final SignUpStep step;
  final Uint8List termsAndConditionsDocument;
  final String signatureLink;
  final String signatureError;
  final String idDocumentsErrorCode;
  final String proofOfResidenceErrorCode;
  final String setVoucherPath;

  const SignUpState({
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
    this.confirmPassword = const PasswordConfirmInput.pure(),
    this.dialCode = DEFAULT_DIAL_CODE,
    this.phone = const PhoneInput.pure(),
    this.status = FormzStatus.pure,
    this.backendErrors = const SignUpErrors(),
    this.languageCode,
    this.isCorporate,
    this.idFrontPath,
    this.idBackPath,
    this.selfiePath,
    this.proofOfResidencePath,
    this.step = SignUpStep.credentials,
    this.termsAndConditionsDocument,
    this.termsAndConditionsAccepted = false,
    this.signatureLink,
    this.signatureError,
    this.idDocumentsErrorCode,
    this.proofOfResidenceErrorCode,
    this.setVoucherPath,
  });

  @override
  List<Object> get props => [
        email,
        password,
        confirmPassword,
        dialCode,
        phone,
        status,
        backendErrors,
        languageCode,
        isCorporate,
        idFrontPath,
        idBackPath,
        selfiePath,
        proofOfResidencePath,
        step,
        termsAndConditionsDocument,
        termsAndConditionsAccepted,
        signatureLink,
        signatureError,
        idDocumentsErrorCode,
    proofOfResidenceErrorCode,
    setVoucherPath
      ];

  String get phoneNumber => '$dialCode${phone.value}'.trim();

  SignUpState copyWith({
    EmailInput email,
    PasswordInput password,
    PasswordConfirmInput confirmPassword,
    String dialCode,
    PhoneInput phone,
    FormzStatus status,
    SignUpErrors backendErrors,
    String languageCode,
    bool isCorporate,
    String idFrontPath,
    String idBackPath,
    String selfiePath,
    String proofOfResidencePath,
    SignUpStep step,
    Uint8List termsAndConditions,
    bool termsAndConditionsAccepted,
    String signatureLink,
    String signatureError,
    String idDocumentsErrorCode,
    String proofOfResidenceErrorCode,
    String setVoucherPath,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      dialCode: dialCode ?? this.dialCode,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      backendErrors: backendErrors ?? this.backendErrors,
      languageCode: languageCode ?? this.languageCode,
      isCorporate: isCorporate ?? this.isCorporate,
      idFrontPath: idFrontPath ?? this.idFrontPath,
      idBackPath: idBackPath ?? this.idBackPath,
      selfiePath: selfiePath ?? this.selfiePath,
      proofOfResidencePath: proofOfResidencePath ?? this.proofOfResidencePath,
      step: step ?? this.step,
      termsAndConditionsDocument: termsAndConditions ?? this.termsAndConditionsDocument,
      termsAndConditionsAccepted: termsAndConditionsAccepted ?? this.termsAndConditionsAccepted,
      signatureLink: signatureLink,
      signatureError: signatureError,
      idDocumentsErrorCode: idDocumentsErrorCode,
      proofOfResidenceErrorCode: proofOfResidenceErrorCode,
      setVoucherPath: setVoucherPath ?? this.setVoucherPath
    );
  }

  @override
  String toString() {
    return 'SignUpState{email: $email, password: $password, confirmPassword: $confirmPassword, '
        'dialCode: $dialCode, phone: $phone, status: $status, backendErrors: $backendErrors, '
        'idFrontPath: $idFrontPath, idBackPath: $idBackPath, selfiePath: $selfiePath, '
        'proofOfResidencePath: $proofOfResidencePath, step: $step, '
        'termsAndConditionsAccepted: $termsAndConditionsAccepted, signatureLink: $signatureLink, '
        'signatureError: $signatureError, idDocumentsErrorCode: $idDocumentsErrorCode, '
        'proofOfResidenceErrorCode: $proofOfResidenceErrorCode, '
        'setVoucherPath: $setVoucherPath}';
  }
}
