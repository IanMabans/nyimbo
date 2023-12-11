import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class HymnsRecord extends FirestoreRecord {
  HymnsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "number" field.
  String? _number;
  String get number => _number ?? '';
  bool hasNumber() => _number != null;

  void _initializeFields() {
    _title = snapshotData['title'] as String?;
    _number = snapshotData['number'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Hymns');

  static Stream<HymnsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => HymnsRecord.fromSnapshot(s));

  static Future<HymnsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => HymnsRecord.fromSnapshot(s));

  static HymnsRecord fromSnapshot(DocumentSnapshot snapshot) => HymnsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static HymnsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      HymnsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'HymnsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is HymnsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createHymnsRecordData({
  String? title,
  String? number,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'title': title,
      'number': number,
    }.withoutNulls,
  );

  return firestoreData;
}

class HymnsRecordDocumentEquality implements Equality<HymnsRecord> {
  const HymnsRecordDocumentEquality();

  @override
  bool equals(HymnsRecord? e1, HymnsRecord? e2) {
    return e1?.title == e2?.title && e1?.number == e2?.number;
  }

  @override
  int hash(HymnsRecord? e) => const ListEquality().hash([e?.title, e?.number]);

  @override
  bool isValidKey(Object? o) => o is HymnsRecord;
}
