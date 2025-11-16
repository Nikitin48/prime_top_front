part of 'auth_cubit.dart';

enum AuthStatus { unauthenticated, loading, authenticated, failure }

class AuthState extends Equatable {
  const AuthState._({
    required this.status,
    this.user,
    this.errorMessage,
  });

  const AuthState.unauthenticated() : this._(status: AuthStatus.unauthenticated);
  const AuthState.authenticated(User user) : this._(status: AuthStatus.authenticated, user: user);

  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return AuthState._(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}


