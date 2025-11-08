import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/contact.dart';

// Simple in-memory storage service for contacts
// This uses local storage since Supabase is not connected
class ContactService {
  static final List<Contact> _contacts = [];

  // Get all contacts
  Future<List<Contact>> getContacts() async {
    // Simulate async operation
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(_contacts);
  }

  // Add a new contact
  Future<void> addContact(Contact contact) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _contacts.add(contact);
    if (kDebugMode) {
      print('Contact added: ${contact.name}');
    }
  }

  // Update an existing contact
  Future<void> updateContact(Contact contact) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _contacts.indexWhere((c) => c.id == contact.id);
    if (index != -1) {
      _contacts[index] = contact;
      if (kDebugMode) {
        print('Contact updated: ${contact.name}');
      }
    }
  }

  // Delete a contact
  Future<void> deleteContact(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _contacts.removeWhere((c) => c.id == id);
    if (kDebugMode) {
      print('Contact deleted: $id');
    }
  }

  // Search contacts by name
  Future<List<Contact>> searchContacts(String query) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _contacts
        .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
