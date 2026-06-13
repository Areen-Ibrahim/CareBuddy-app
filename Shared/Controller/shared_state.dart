part of 'shared_cubit.dart';

abstract class SharedStates {}

class SharedInitialState extends SharedStates {}

class ToggleLanguageState extends SharedStates {}

class SignInState extends SharedStates {
  final ApiRequestStatus status;
  SignInState({required this.status});
}

class SendPasswordResetEmailState extends SharedStates {
  final ApiRequestStatus status;
  SendPasswordResetEmailState({required this.status});
}
