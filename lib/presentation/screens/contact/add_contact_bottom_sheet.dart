import 'package:contact_list/core/config/languages.dart';
import 'package:contact_list/data/models/contact_model.dart';
import 'package:contact_list/logic/contact/contact_bloc.dart';
import 'package:contact_list/logic/contact/contact_event.dart';
import 'package:contact_list/presentation/widgets/avatar_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showAddContactSheet(BuildContext context) {
  var localizations = AppLocalizations.of(context)!;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final numberPhoneController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.8,
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        localizations.translate(
                          'contact_screen.add_contact.cancel',
                        ),
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      localizations.translate(
                        'contact_screen.add_contact.title',
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<ContactBloc>().add(
                          CreateContact(
                            Contact(
                              name:
                                  '${firstNameController.value.text} ${lastNameController.value.text}',
                              phone: numberPhoneController.value.text,
                              lastSeen: DateTime.now(),
                              isMuted: false,
                            ),
                          ),
                        );

                        Navigator.pop(context);
                      },
                      child: Text(
                        localizations.translate(
                          'contact_screen.add_contact.create',
                        ),
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Avatar + Name fields
                Row(
                  children: [
                    AvatarPicker(),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: [
                          TextField(
                            controller: firstNameController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: localizations.translate(
                                'contact_screen.add_contact.first_name',
                              ),
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                          Divider(color: Colors.grey),
                          TextField(
                            controller: lastNameController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: localizations.translate(
                                'contact_screen.add_contact.last_name',
                              ),
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.grey),

                // Phone field
                Row(
                  children: [
                    Icon(Icons.remove_circle, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      localizations.translate(
                        'contact_screen.add_contact.option1',
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: numberPhoneController,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "+84",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.grey),

                // Add phone btn
                Row(
                  children: [
                    Icon(Icons.add_circle, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      '${localizations.translate('contact_screen.add_contact.add_more')} (developing)',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
