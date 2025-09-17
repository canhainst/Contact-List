abstract class ContactEvent {}

class LoadContacts extends ContactEvent {}

class SortContactsWithQuery extends ContactEvent {
  final String sortBy;
  final String query;
  SortContactsWithQuery({required this.sortBy, required this.query});
}
