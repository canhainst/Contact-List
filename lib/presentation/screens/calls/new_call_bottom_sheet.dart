import 'package:contact_list/core/utils/format_string.dart';
import 'package:contact_list/data/models/contact_model.dart';
import 'package:contact_list/presentation/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_list/core/config/languages.dart';
import 'package:contact_list/logic/contact/contact_bloc.dart';
import 'package:contact_list/logic/contact/contact_event.dart';
import 'package:contact_list/logic/contact/contact_state.dart';

void showNewCallBottomSheet(BuildContext context) {
  final searchBarController = TextEditingController();
  var localizations = AppLocalizations.of(context)!;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      final height = MediaQuery.of(context).size.height * 0.9;
      return SizedBox(
        height: height,
        child: _NewCallContent(
          searchBarController: searchBarController,
          localizations: localizations,
        ),
      );
    },
  ).whenComplete(() {
    context.read<ContactBloc>().add(LoadContacts());
  });
}

class _NewCallContent extends StatefulWidget {
  final TextEditingController searchBarController;
  final AppLocalizations localizations;

  const _NewCallContent({
    required this.searchBarController,
    required this.localizations,
  });

  @override
  State<_NewCallContent> createState() => _NewCallContentState();
}

class _NewCallContentState extends State<_NewCallContent> {
  final Set<int> _selectedCalls = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  widget.localizations.translate("calls_screen.new_call.close"),
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                widget.localizations.translate("calls_screen.new_call.title"),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Spacer(),
              const SizedBox(width: 50),
            ],
          ),
        ),

        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: BlocBuilder<ContactBloc, ContactState>(
              builder: (context, state) {
                return TextField(
                  controller: widget.searchBarController,
                  onChanged: (value) {
                    context.read<ContactBloc>().add(
                      SortContactsWithQuery(sortBy: 'name', query: value),
                    );
                  },
                  decoration: InputDecoration(
                    hintText: widget.localizations.translate(
                      'contact_screen.search',
                    ),
                    prefixIcon: const Icon(Icons.search),
                    border: InputBorder.none,
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 16),

        const Divider(height: 1),

        Expanded(
          child: BlocBuilder<ContactBloc, ContactState>(
            builder: (context, state) {
              if (state is ContactLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ContactError) {
                return Center(child: Text(state.message));
              } else if (state is ContactLoaded) {
                final contacts = state.contacts;
                return ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    final isSelected = _selectedCalls.contains(index);

                    return ContactTile(
                      contact: contact,
                      isSelected: isSelected,
                      onChanged: (val) {
                        setState(() {
                          val
                              ? _selectedCalls.add(index)
                              : _selectedCalls.remove(index);
                        });
                      },
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _selectedCalls.isNotEmpty
              ? Column(
                  children: [
                    BlocBuilder<ContactBloc, ContactState>(
                      builder: (context, state) {
                        if (state is! ContactLoaded) {
                          return const SizedBox.shrink();
                        }

                        final contacts = state.contacts;
                        String buttonText;
                        if (_selectedCalls.length == 1) {
                          final firstIndex = _selectedCalls.first;
                          buttonText =
                              "${widget.localizations.translate('calls_screen.new_call.call')} ${contacts[firstIndex].name}";
                        } else {
                          buttonText = widget.localizations.translate(
                            'calls_screen.new_call.calls',
                            args: {'num': _selectedCalls.length.toString()},
                          );
                        }

                        return AppButton(
                          text: buttonText,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class ContactTile extends StatelessWidget {
  final Contact contact;
  final bool isSelected;
  final ValueChanged<bool> onChanged;
  const ContactTile({
    super.key,
    required this.contact,
    required this.isSelected,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            shape: const CircleBorder(),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: isSelected,
            onChanged: (val) {
              if (val != null) onChanged(val);
            },
          ),
          CircleAvatar(
            backgroundColor: Colors.blueGrey,
            backgroundImage: contact.avatarUrl != null
                ? NetworkImage(contact.avatarUrl!)
                : null,
            child: contact.avatarUrl == null
                ? Text(
                    contact.name[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  )
                : null,
          ),
        ],
      ),
      title: Text(contact.name),
      subtitle: Text(
        formatLastSeen(context, contact.lastSeen),
        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
      ),
      onTap: () {
        onChanged(!isSelected);
      },
    );
  }
}
