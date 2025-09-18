import 'package:contact_list/data/models/call_model.dart';

abstract class CallEvent {}

class LoadCalls extends CallEvent {}

class DeleteCall extends CallEvent {
  final Call call;
  DeleteCall(this.call);
}
