import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:flutter_auth/document.dart';

class Folder {
  String parentFolder;
  List<Document> files;
  Folder({
     this.parentFolder,
     this.files,
  });

  Folder copyWith({
    String parentFolder,
    List<Document> files,
  }) {
    return Folder(
      parentFolder: parentFolder ?? this.parentFolder,
      files: files ?? this.files,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'parentFolder': parentFolder,
      'files': files?.map((x) => x.toMap())?.toList(),
    };
  }

  factory Folder.fromMap(Map<String, dynamic> map) {
    return Folder(
      parentFolder: map['parentFolder'],
      files: List<Document>.from(map['files']?.map((x) => Document.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Folder.fromJson(String source) => Folder.fromMap(json.decode(source));

  @override
  String toString() => 'Folder(parentFolder: $parentFolder, files: $files)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Folder &&
      other.parentFolder == parentFolder &&
      listEquals(other.files, files);
  }

  @override
  int get hashCode => parentFolder.hashCode ^ files.hashCode;
}
