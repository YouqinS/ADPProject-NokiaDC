import 'package:RasPiFinder/screens/auth/Validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validator tests',(){

    group('Username test',(){
      test('Invalid name returns error string', () {
        var result = Validator.validateUsername('Joh');
        expect(result, 'Min length: 4');
      });
      test('Valid name returns null', () {
        var result = Validator.validateUsername('John');
        expect(result, null);
      });
    });

    group('Email tests',(){
      test('Invalid email returns error string', () {
        var result = Validator.validateEmailInput('abc123');
        expect(result, 'Invalid email');
      });
      test('Valid email returns null', () {
        var result = Validator.validateEmailInput('aa@aa.fi');
        expect(result, null);
      });
    });

    group('Phone number tests', () {
      test('Empty phone number returns error string', () {
        var result = Validator.validatePhoneInput('');
        expect(result, 'Invalid phone number!');
      });
      test('Phone number contains 6-digits or less returns error string', () {
        var result = Validator.validatePhoneInput('123456');
        expect(result, 'Min length: 7');
      });
      test('Valid phone number returns null', () {
        var result = Validator.validatePhoneInput('123456789');
        expect(result, null);
      });
    });

    group('Password tests', (){
      test('Empty password returns error string', () {
        var result = Validator.validatePasswdInput('');
        expect(result, 'Password empty');
    });
      test('Valid password returns null', () {
        var result = Validator.validatePasswdInput('Qw12345!#');
        expect(result, null);
      });
    });
  });
}

