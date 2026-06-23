import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:safe_haven/models/contact.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrustedContacts extends StatefulWidget {
  const TrustedContacts({super.key});

  @override
  State<TrustedContacts> createState() => _TrustedContactsState();
}

class _TrustedContactsState extends State<TrustedContacts> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  List<Contact> contacts = [];
  final _editNameController = TextEditingController();
  final _editPhoneController = TextEditingController();
  int editIndex = -1;

  @override
  void initState() {
    super.initState();
    readData().then((value) {
      setState(() {
        contacts = value;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> saveData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> l = [];
    for (var c in contacts) {
      l.add(jsonEncode(c.toJson()));
    }
    //Alternative Approach
    // contacts.asMap().entries.map((v) {
    //   l.add(jsonEncode(v.value.toJson()));
    // });
    print(l);
    await prefs.setStringList("Contacts List", l);
  }

  Future<List<Contact>> readData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> contactsList = prefs.getStringList("Contacts List") ?? [];
    print(contactsList);
    List<Contact> contactObjectList = [];

    for (String s in contactsList) {
      contactObjectList.add(Contact.fromJson(jsonDecode(s)));
    }
    return contactObjectList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Trusted Contacts")),
      body: Center(
        child: Padding(
          padding: EdgeInsetsGeometry.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 250,
                            child: TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Name",
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: 250,
                            child: TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Phone Number",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () async {
                        if (contacts.length < 3) {
                          setState(() {
                            contacts.add(
                              Contact(
                                name: _nameController.text,
                                phoneNo: _phoneController.text,
                              ),
                            );
                            _nameController.clear();
                            _phoneController.clear();
                          });
                          await saveData();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Can't enter more than three trusted contacts!",
                              ),
                            ),
                          );
                        }
                      },
                      child: Text("Add"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),

              Expanded(
                child: ListView(
                  children: contacts.asMap().entries.map((contact) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            editIndex == contact.key
                                ? SizedBox(
                                    width: 200,
                                    height: 60,
                                    child: TextField(
                                      controller: _editNameController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  )
                                : Text("Name: ${contact.value.name}"),

                            editIndex == contact.key
                                ? SizedBox(
                                    height: 60,
                                    width: 200,
                                    child: TextField(
                                      controller: _editPhoneController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  )
                                : Text(
                                    "Phone Number: ${contact.value.phoneNo}",
                                  ),
                          ],
                        ),
                        SizedBox(height: 80),
                        editIndex != contact.key
                            ? TextButton(
                                onPressed: () async {
                                  setState(() {
                                    editIndex = contact.key;
                                    _editNameController.text =
                                        contact.value.name;
                                    _editPhoneController.text =
                                        contact.value.phoneNo;
                                  });
                                  await saveData();
                                },
                                child: Text("Edit"),
                              )
                            : TextButton(
                                onPressed: () {
                                  setState(() {
                                    contact.value.name =
                                        _editNameController.text;
                                    contact.value.phoneNo =
                                        _editPhoneController.text;
                                    editIndex = -1;
                                  });
                                  saveData();
                                },
                                child: Text("Save"),
                              ),
                        SizedBox(width: 10),
                        TextButton(
                          onPressed: () async {
                            setState(() {
                              contacts.remove(contact.value);
                            });
                            await saveData();
                          },
                          child: Text("Delete"),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
