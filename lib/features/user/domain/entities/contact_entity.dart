import 'dart:typed_data';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactEntity {
  final String? id;
  final String? displayName;
  final Uint8List? photo;
  final Uint8List? thumbnail;
  final Name? name;
  final List<Phone>? phones;
  final List<Email>? emails;
  final List<Address>? addresses;
  final List<Organization>? organizations;
  final List<Website>? websites;
 
  ContactEntity(
      {this.id,
        this.displayName,
        this.photo,
        this.thumbnail,
        this.name,
        this.phones,
        this.emails,
        this.addresses,
        this.organizations,
        this.websites,
      });
}
