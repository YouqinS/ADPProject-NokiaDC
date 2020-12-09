import 'package:flutter_test/flutter_test.dart';
import 'package:RasPiFinder/models/rasps.dart';

void main() {
  test('Rasp object is created successfully', () {
    final rasp = Rasp(
        address: 'address 1',
        finder: {
          'email': 'finder@foo.bar',
          'username': 'finder@foo.bar',
          'phoneNumber': '123456'
        },
        modelNumber: '123ABC',
        user: {
          'email': 'user@foo.bar',
          'username': 'user1',
          'phoneNumber': '234567'
        },
        owner: {
          'email': 'owner@foo.bar',
          'username': 'owner1',
          'phoneNumber': '345678'
        },
        software: 'software1',
        other: '');
    expect(rasp.address, 'address 1');
    expect(rasp.finder['email'], 'finder@foo.bar');
    expect(rasp.user['username'], 'user1');
    expect(rasp.owner['phoneNumber'], '345678');
    expect(rasp.modelNumber, '123ABC');
    expect(rasp.other, '');
  });
  test('Values string should all users info', () {
    final rasp = Rasp(
        address: 'address 1',
        finder: {
          'email': 'finder@foo.bar',
          'username': 'finder@foo.bar',
          'phoneNumber': '123456'
        },
        modelNumber: '123ABC',
        user: {
          'email': 'user@foo.bar',
          'username': 'user1',
          'phoneNumber': '234567'
        },
        owner: {
          'email': 'owner@foo.bar',
          'username': 'owner1',
          'phoneNumber': '345678'
        },
        software: 'software1',
        other: 'other1');
    String userString = rasp.getValuesString();
    expect(userString,
        'address 1software1123abcfinder@foo.barfinder@foo.bar123456user@foo.baruser1234567owner@foo.barowner1345678other1');
  });

  test('values string with partial info', () {
    final rasp = Rasp(
        address: 'address 1',
        finder: {
          'email': 'finder@foo.bar',
          'username': 'finder@foo.bar',
          'phoneNumber': '123456'
        },
        modelNumber: '123ABC',
        software: '',
        other: '');
    String userString = rasp.getValuesString();
    expect(userString, 'address 1123abcfinder@foo.barfinder@foo.bar123456');
  });
}
