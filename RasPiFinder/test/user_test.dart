import 'package:test/test.dart';
import 'package:RasPiFinder/models/user.dart';

void main() {
  test('User object is created successfully', () {
    final user = UserData(
        email: 'foo@bar.com',
        phoneNumber: '123456',
        uid: 'unique123',
        username: 'foo.bar');

    expect(user.email, 'foo@bar.com');
    expect(user.phoneNumber, '123456');
    expect(user.uid, 'unique123');
    expect(user.username, 'foo.bar');
  });
}
