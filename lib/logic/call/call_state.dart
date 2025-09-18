import 'package:contact_list/data/models/call_model.dart';

abstract class CallState {}

class CallInitial extends CallState {}

class CallLoading extends CallState {}

class CallLoaded extends CallState {
  final List<Call> calls;
  CallLoaded(this.calls);
}

class CallError extends CallState {
  final String message;
  CallError(this.message);
}
