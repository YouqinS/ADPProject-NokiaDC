import 'package:flutter_test/flutter_test.dart';
import 'package:RasPiFinder/onboarding/sharedPreferences.dart';

void main() {
  test('SF should be able to add integer value', () async {
    MSharedPreferences.instance.addIntToSF('test', []);
    int testSFValue = await MSharedPreferences.instance.getIntValue('test');
    int intSFValue = await MSharedPreferences.instance.getIntValue('intValue');

    expect(testSFValue, null);
    expect(intSFValue, 123);
  });

  test('SF should be able to add bool value', () async {
    MSharedPreferences.instance.setBooleanValue('foo', false);
    bool testSFValue =
        await MSharedPreferences.instance.getBooleanValue('test');
    bool fooSFValue = await MSharedPreferences.instance.getBooleanValue('foo');

    expect(testSFValue, false);
    expect(fooSFValue, false);
  });
}
