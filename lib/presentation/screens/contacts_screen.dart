import 'package:contact_list/core/config/languages.dart';
import 'package:contact_list/core/utils/format_string.dart';
import 'package:contact_list/presentation/screens/contact_detail_screen.dart';
import 'package:contact_list/presentation/widgets/skeleton/contact_skeleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_list/logic/contact/contact_bloc.dart';
import 'package:contact_list/logic/contact/contact_state.dart';
import 'package:contact_list/logic/contact/contact_event.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final _searchBarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ContactBloc>().add(LoadContacts());
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) => CupertinoActionSheet(
                        title: Text(
                          localizations.translate('contact_screen.sort.title'),
                        ),
                        actions: <CupertinoActionSheetAction>[
                          CupertinoActionSheetAction(
                            onPressed: () {
                              final query = _searchBarController.value.text;

                              final bloc = context.read<ContactBloc>();

                              bloc.add(
                                SortContactsWithQuery(
                                  sortBy: 'name',
                                  query: query,
                                ),
                              );
                              Navigator.pop(context);
                            },
                            child: Text(
                              localizations.translate(
                                'contact_screen.sort.byName',
                              ),
                            ),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () {
                              final query = _searchBarController.value.text;

                              final bloc = context.read<ContactBloc>();

                              bloc.add(
                                SortContactsWithQuery(
                                  sortBy: 'lastSeen',
                                  query: query,
                                ),
                              );
                              Navigator.pop(context);
                            },
                            child: Text(
                              localizations.translate(
                                'contact_screen.sort.byLastSeen',
                              ),
                            ),
                          ),
                        ],

                        cancelButton: CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(localizations.translate('dialog.cancel')),
                        ),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(40, 40),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    "Sort",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Expanded(
                  child: Text(
                    "Contacts",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                GestureDetector(
                  onTap: () {},
                  child: SizedBox(
                    width: 40,
                    child: Icon(Icons.add, color: Colors.black),
                  ),
                ),
              ],
            ),

            Container(
              height: 42,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: BlocBuilder<ContactBloc, ContactState>(
                builder: (context, state) {
                  return TextField(
                    controller: _searchBarController,
                    onChanged: (value) {
                      final currentSort = state is ContactLoaded
                          ? state.sortState
                          : 'lastSeen';

                      context.read<ContactBloc>().add(
                        SortContactsWithQuery(
                          sortBy: currentSort,
                          query: value,
                        ),
                      );
                    },
                    decoration: InputDecoration(
                      hintText: localizations.translate(
                        'contact_screen.search',
                      ),
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 10),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        elevation: 1,
        toolbarHeight: 100,
      ),

      body: Column(
        children: [
          // Search bar
          Expanded(
            child: BlocBuilder<ContactBloc, ContactState>(
              builder: (context, state) {
                if (state is ContactLoading) {
                  return ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) => const ContactSkeleton(),
                  );
                } else if (state is ContactLoaded) {
                  final contacts = state.contacts;

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ContactBloc>().add(LoadContacts());
                    },
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        final isOnline =
                            DateTime.now()
                                .difference(contact.lastSeen)
                                .inMinutes ==
                            0;

                        return Slidable(
                          key: Key(contact.phone),
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            extentRatio: 0.25,
                            children: [
                              SlidableAction(
                                onPressed: (ctx) {
                                  context.read<ContactBloc>().add(
                                    DeleteContact(contact),
                                  );
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blueGrey,
                              backgroundImage: contact.avatarUrl != null
                                  ? NetworkImage(contact.avatarUrl!)
                                  : null,
                              child: contact.avatarUrl == null
                                  ? Text(
                                      contact.name[0].toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                            ),
                            title: Text(
                              contact.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              formatLastSeen(context, contact.lastSeen),
                              style: TextStyle(
                                color: isOnline ? Colors.green : Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ContactDetailScreen(contact: contact),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                } else if (state is ContactError) {
                  return Center(child: Text(state.message));
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
