import 'package:contact_list/core/config/languages.dart';
import 'package:contact_list/core/utils/format_string.dart';
import 'package:contact_list/presentation/screens/contact/add_contact_bottom_sheet.dart';
import 'package:contact_list/presentation/screens/contact/contact_detail_screen.dart';
import 'package:contact_list/presentation/screens/contact/skeleton/contact_skeleton.dart';
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
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

                  child: Icon(Icons.sort, color: Colors.white),
                ),

                Expanded(
                  child: Text(
                    localizations.translate('nav_bar.contacts'),
                    style:
                        (theme.textTheme.titleLarge ??
                                theme.textTheme.headlineSmall)
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                    textAlign: TextAlign.center,
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    showAddContactSheet(context);
                  },
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),

            SizedBox(height: 16),

            Container(
              height: 42,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: BlocBuilder<ContactBloc, ContactState>(
                builder: (context, state) {
                  return TextField(
                    controller: _searchBarController,
                    style: TextStyle(color: theme.textTheme.bodyLarge!.color),
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
                      hintStyle: TextStyle(color: theme.hintColor),
                      prefixIcon: Icon(
                        Icons.search,
                        color: theme.iconTheme.color,
                      ),
                      border: InputBorder.none,
                    ),
                  );
                },
              ),
            ),
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
