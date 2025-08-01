import 'dart:async';

import 'package:flapp_widget/constants.dart';
import 'package:flapp_widget/view_models/action_view_model.dart';
import 'package:flapp_widget/view_models/scheme_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../services/api_client.dart';
import '../services/user_repository.dart';

/*class UserState extends AsyncNotifier<User>{
  late User tempUser;

  @override
  FutureOr<User> build() async{
    UserRepository userRepo = UserRepository();
    final loadedUserFromRepo = await userRepo.loadValue();
    late final dynamic seatsInReserve;
    tempUser = const User(userId: 0, sessionId: '', email: '',
        state: UserStates.unknown, totalSeatsInReserve: 0);
    if (loadedUserFromRepo.userId > 0 && loadedUserFromRepo.sessionId != ''){
      seatsInReserve = await UserAPI.getUserInfo(loadedUserFromRepo);
      if (seatsInReserve is int){
        final email = await UserAPI.getUserEmail(loadedUserFromRepo);
        tempUser = User(userId: loadedUserFromRepo.userId, sessionId: loadedUserFromRepo.sessionId,
            email: email, state: UserStates.authorized, totalSeatsInReserve: seatsInReserve);
      } else {
        userRepo.deleteUser();
        tempUser = const User(userId: 0, sessionId: '', email: '',
            state: UserStates.unknown, totalSeatsInReserve: 0);
      }
    }
    if (loadedUserFromRepo.userId == 0 && loadedUserFromRepo.sessionId != '' && loadedUserFromRepo.email !=''){
      tempUser = User(userId: 0, sessionId: loadedUserFromRepo.sessionId,
          email: loadedUserFromRepo.email, state: UserStates.processing, totalSeatsInReserve: 0);
    }
    return tempUser;
  }

  saveUser(User newUser) async{
    UserRepository userRepo = UserRepository();
    final seatsInReserve = await UserAPI.getUserInfo(newUser);
    userRepo.saveUser(newUser);
    userRepo.deleteEmail();

    final st = ref.read(asyncActionProvider).value!.selectedActionEvent!.schemeType;
    if (st == SchemeType.assignedSeats || st == SchemeType.mixed){
      ref.invalidate(asyncSchemeProvider);
    }

    state = AsyncValue.data(state.value!.copyWith(userId: newUser.userId, totalSeatsInReserve: seatsInReserve,
        sessionId: newUser.sessionId, email: newUser.email, state: newUser.state),);
  }

  saveSynthUser(User synthUser){
    UserRepository userRepo = UserRepository();
    userRepo.saveUser(synthUser);
    state = AsyncValue.data(state.value!.copyWith(userId: synthUser.userId,
        sessionId: synthUser.sessionId, email: synthUser.email, state: synthUser.state),);
  }

  clearUser(){
    UserRepository userRepo = UserRepository();
    userRepo.deleteUser();

    final st = ref.read(asyncActionProvider).value!.selectedActionEvent!.schemeType;
    if (st == SchemeType.assignedSeats || st == SchemeType.mixed){
      ref.invalidate(asyncSchemeProvider);
    }

    state = AsyncValue.data(state.value!.copyWith(userId: 0,
        sessionId: '', email: '', totalSeatsInReserve: 0, state: UserStates.unknown),);
  }

  incrementTotalSeatsInReserve() async{
    state = AsyncValue.data(state.value!
        .copyWith(totalSeatsInReserve: state.value!.totalSeatsInReserve + 1, ));
  }

  decrementTotalSeatsInReserve(){
    state = AsyncValue.data(state.value!
        .copyWith(totalSeatsInReserve: state.value!.totalSeatsInReserve - 1),);
  }

  clearTotalSeatsInReserve(){
    state = AsyncValue.data(state.value!.copyWith(totalSeatsInReserve: 0),);
  }

  setTotalSeatsInReserve(int seatsCount){
    state = AsyncValue.data(state.value!.copyWith(totalSeatsInReserve: seatsCount),);
  }

  Future<bool> isUserRegistered(){
    UserRepository userRepo = UserRepository();
    return userRepo.isUserRegistered();
  }
}

final asyncUserProvider = AsyncNotifierProvider<UserState, User>(() {
  return UserState();
});*/

class UserState extends AsyncNotifier<User> {
  late User tempUser;

  @override
  FutureOr<User> build() async {
    UserRepository userRepo = UserRepository();
    final loadedUserFromRepo = await userRepo.loadValue();
    late final dynamic seatsInReserve;
    tempUser = const User(
        userId: 0,
        sessionId: '',
        email: '',
        state: UserStates.unknown,
        totalSeatsInReserve: 0);

    // Если пользователь сохранен в localstorage
    if (loadedUserFromRepo.userId > 0 && loadedUserFromRepo.sessionId != '') {
      seatsInReserve = await UserAPI.getUserInfo(loadedUserFromRepo);
      if (seatsInReserve is int) {
        tempUser = User(
            userId: loadedUserFromRepo.userId,
            sessionId: loadedUserFromRepo.sessionId,
            email: '',
            state: UserStates.authorized,
            totalSeatsInReserve: seatsInReserve);
      } else {
        userRepo.deleteUser();
        tempUser = const User(
            userId: 0,
            sessionId: '',
            email: '',
            state: UserStates.unknown,
            totalSeatsInReserve: 0);
      }
    }

    // Если пользователя нет в localStorage получаем его из post msg?
    if (loadedUserFromRepo.userId == 0 && loadedUserFromRepo.sessionId == '') {
      //захардкоденный пользователь
      int uid = 48713;
      String sid = '77032562936e8750e79232e13209aec5';
      User hardCodedUser = User(
          totalSeatsInReserve: 0,
          userId: uid,
          sessionId: sid,
          email: '',
          state: UserStates.unknown);
      seatsInReserve = await UserAPI.getUserInfo(hardCodedUser);

      if (seatsInReserve is int) {
        tempUser = User(
          userId: hardCodedUser.userId,
          sessionId: hardCodedUser.sessionId,
          email: '',
          state: UserStates.authorized,
          totalSeatsInReserve: seatsInReserve,
        );
        saveUser(tempUser);
      }
    }

    return tempUser;
  }

  saveUser(User newUser) async {
    UserRepository userRepo = UserRepository();
    userRepo.saveUser(newUser);

    //userRepo.deleteEmail();
    //final seatsInReserve = await UserAPI.getUserInfo(newUser);
    //final st = ref.read(asyncActionProvider).value!.selectedActionEvent!.schemeType;
    //if (st == SchemeType.assignedSeats || st == SchemeType.mixed){ref.invalidate(asyncSchemeProvider);}
    //state = AsyncValue.data(state.value!.copyWith(userId: newUser.userId, totalSeatsInReserve: seatsInReserve, sessionId: newUser.sessionId, email: newUser.email, state: newUser.state),);
  }

  saveSynthUser(User synthUser) {
    UserRepository userRepo = UserRepository();
    userRepo.saveUser(synthUser);
    state = AsyncValue.data(
      state.value!.copyWith(
          userId: synthUser.userId,
          sessionId: synthUser.sessionId,
          email: synthUser.email,
          state: synthUser.state),
    );
  } //убрать

  clearUser() {
    UserRepository userRepo = UserRepository();
    userRepo.deleteUser();

    final st =
        ref.read(asyncActionProvider).value!.selectedActionEvent!.schemeType;
    if (st == SchemeType.assignedSeats || st == SchemeType.mixed) {
      ref.invalidate(asyncSchemeProvider);
    }

    state = AsyncValue.data(
      state.value!.copyWith(
          userId: 0,
          sessionId: '',
          email: '',
          totalSeatsInReserve: 0,
          state: UserStates.unknown),
    );
  }

  incrementTotalSeatsInReserve() async {
    state = AsyncValue.data(state.value!.copyWith(
      totalSeatsInReserve: state.value!.totalSeatsInReserve + 1,
    ));
  }

  decrementTotalSeatsInReserve() {
    state = AsyncValue.data(
      state.value!
          .copyWith(totalSeatsInReserve: state.value!.totalSeatsInReserve - 1),
    );
  }

  clearTotalSeatsInReserve() {
    state = AsyncValue.data(
      state.value!.copyWith(totalSeatsInReserve: 0),
    );
  }

  setTotalSeatsInReserve(int seatsCount) {
    state = AsyncValue.data(
      state.value!.copyWith(totalSeatsInReserve: seatsCount),
    );
  }

  Future<bool> isUserRegistered() {
    UserRepository userRepo = UserRepository();
    return userRepo.isUserRegistered();
  }
}

final asyncUserProvider = AsyncNotifierProvider<UserState, User>(() {
  return UserState();
});
