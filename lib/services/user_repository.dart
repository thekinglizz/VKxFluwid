import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class UserRepository{
  final sharedPreferences = SharedPreferences.getInstance();

  Future<User> loadValue() async {
    final userId = (await sharedPreferences).getInt('userId') ?? 0;
    final sessionId = (await sharedPreferences).getString('sessionId') ?? '';
    final email = (await sharedPreferences).getString('email') ?? '';

    return User(userId: userId, sessionId: sessionId, email: email,
        state: UserStates.unknown, totalSeatsInReserve: 0);
  }

  Future<void> saveUser(User user) async {
    (await sharedPreferences).setInt('userId', user.userId);
    (await sharedPreferences).setString('sessionId', user.sessionId);
    (await sharedPreferences).setString('email', user.email);
  }

  Future<void> deleteUser() async {
    //SharedPreferences preferences = await SharedPreferences.getInstance();
    (await sharedPreferences).clear();
  }

  Future<void> deleteEmail() async {
    //SharedPreferences preferences = await SharedPreferences.getInstance();
    (await sharedPreferences).remove('email');
  }

  Future<bool> isUserRegistered() async {
    User user = await loadValue();
    return user.sessionId != '' && user.userId != 0;
  }
}