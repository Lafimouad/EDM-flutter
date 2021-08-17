import 'dart:convert';

import 'package:flutter/material.dart';

class Role {
  String name;
  String description;
  Role({
    @required this.name,
    this.description,
  });

  Role copyWith({
    String name,
    String description,
  }) {
    return Role(
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
    };
  }

  factory Role.fromMap(Map<String, String> map) {
    return Role(
      name: map['name'],
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Role.fromJson(dynamic source) => Role.fromMap(json.decode(source));

  @override
  String toString() => 'Role(name: $name, description: $description)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Role &&
      other.name == name &&
      other.description == description;
  }

  @override
  int get hashCode => name.hashCode ^ description.hashCode;
}
