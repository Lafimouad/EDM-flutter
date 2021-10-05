import 'dart:convert';

import 'package:flutter_auth/userPass.dart';

class Document {
  int id;
  int size;
  String fileName;
  String fileTitle;
  String fileOwner;
  String fileFormat;
  String createdBy;
  DateTime createdDate;
  DateTime lastModifiedDate;
  User1 user;
  Document({
     this.id,
     this.size,
     this.fileName,
     this.fileTitle,
     this.fileOwner,
     this.fileFormat,
     this.createdBy,
     this.createdDate,
     this.lastModifiedDate,
     this.user,
  });

  Document copyWith({
    int id,
    int size,
    String fileName,
    String fileTitle,
    String fileOwner,
    String fileFormat,
    String createdBy,
    DateTime createdDate,
    DateTime lastModifiedDate,
    User1 user,
  }) {
    return Document(
      id: id ?? this.id,
      size: size ?? this.size,
      fileName: fileName ?? this.fileName,
      fileTitle: fileTitle ?? this.fileTitle,
      fileOwner: fileOwner ?? this.fileOwner,
      fileFormat: fileFormat ?? this.fileFormat,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'size': size,
      'fileName': fileName,
      'fileTitle': fileTitle,
      'fileOwner': fileOwner,
      'fileFormat': fileFormat,
      'createdBy': createdBy,
      'createdDate': createdDate.millisecondsSinceEpoch,
      'lastModifiedDate': lastModifiedDate.millisecondsSinceEpoch,
      'user': user.toMap(),
    };
  }

  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      id: map['id'],
      size: map['size'],
      fileName: map['fileName'],
      fileTitle: map['fileTitle'],
      fileOwner: map['fileOwner'],
      fileFormat: map['fileFormat'],
      createdBy: map['createdBy'],
      createdDate: DateTime.fromMillisecondsSinceEpoch(map['createdDate']),
      lastModifiedDate: DateTime.fromMillisecondsSinceEpoch(map['lastModifiedDate']),
      user: User1.fromMap(map['user']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Document.fromJson(String source) => Document.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Document(id: $id, size: $size, fileName: $fileName, fileTitle: $fileTitle, fileOwner: $fileOwner, fileFormat: $fileFormat, createdBy: $createdBy, createdDate: $createdDate, lastModifiedDate: $lastModifiedDate, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Document &&
      other.id == id &&
      other.size == size &&
      other.fileName == fileName &&
      other.fileTitle == fileTitle &&
      other.fileOwner == fileOwner &&
      other.fileFormat == fileFormat &&
      other.createdBy == createdBy &&
      other.createdDate == createdDate &&
      other.lastModifiedDate == lastModifiedDate &&
      other.user == user;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      size.hashCode ^
      fileName.hashCode ^
      fileTitle.hashCode ^
      fileOwner.hashCode ^
      fileFormat.hashCode ^
      createdBy.hashCode ^
      createdDate.hashCode ^
      lastModifiedDate.hashCode ^
      user.hashCode;
  }
}
