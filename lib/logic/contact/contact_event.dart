import 'package:contact_list/data/models/contact_model.dart';

abstract class ContactEvent {}

class LoadContacts extends ContactEvent {}

class SortContactsWithQuery extends ContactEvent {
  final String sortBy;
  final String query;
  SortContactsWithQuery({required this.sortBy, required this.query});
}

class DeleteContact extends ContactEvent {
  final Contact contact;
  DeleteContact(this.contact);
}
