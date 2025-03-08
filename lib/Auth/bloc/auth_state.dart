part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

abstract class AuthActionState extends AuthState{}

class AuthError extends AuthActionState {
  final String error;
  AuthError({required this.error});
}