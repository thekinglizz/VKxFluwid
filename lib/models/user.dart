enum UserStates {unknown, processing, authorized}

class User{
  final int totalSeatsInReserve;
  final int userId;
  final String sessionId;
  final String email;
  final UserStates state;

  const User({
    required this.totalSeatsInReserve,
    required this.userId,
    required this.sessionId,
    required this.email,
    required this.state
  });

  User copyWith({
    int? totalSeatsInReserve,
    int? userId,
    String? sessionId,
    String? email,
    UserStates? state,
  }) {
    return User(
      totalSeatsInReserve: totalSeatsInReserve ?? this.totalSeatsInReserve,
      userId: userId ?? this.userId,
      sessionId: sessionId ?? this.sessionId,
      email: email ?? this.email,
      state: state ?? this.state,
    );
  }

  @override
  String toString() {
    return 'User{totalSeatsInReserve: $totalSeatsInReserve, userId: $userId, sessionId: $sessionId, email: $email, state: $state}';
  }
}