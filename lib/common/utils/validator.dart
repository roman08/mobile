class Validator {

    static final Validator _instance = Validator._privateConstructor();

    Validator._privateConstructor();

    factory Validator() {
        return _instance;
    }

    static final RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    static final RegExp passwordRegExp = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!"#$%&\()*+,-./:;<=>?@[\]^_{|}~' r"']).{8,}$",
    );

    bool isValidEmail(String email) {
        return emailRegExp.hasMatch(email);
    }

    bool isValidPassword(String password) {
        return passwordRegExp.hasMatch(password);
    }
}
