import 'dart:async';
import 'package:flutter_database/flutter_database.dart';

enum UniformInvoiceType {
  special,
  grand,
  jackpot,
}

extension UniformInvoiceTypeExtension on UniformInvoiceType {
  static const Map<UniformInvoiceType, int> _valuesMap =
      <UniformInvoiceType, int>{
    UniformInvoiceType.special: 0,
    UniformInvoiceType.grand: 1,
    UniformInvoiceType.jackpot: 2,
  };

  static const Map<int, UniformInvoiceType> types = <int, UniformInvoiceType>{
    0: UniformInvoiceType.special,
    1: UniformInvoiceType.grand,
    2: UniformInvoiceType.jackpot,
  };

  int get value => _valuesMap[this] ?? 0;
}

class UniformInvoice {
  UniformInvoice(this._date, this._type, this._number);
  int get date => _date;
  UniformInvoiceType get type => _type;
  int get number => _number;

  final int _date;
  final UniformInvoiceType _type;
  final int _number;
}

class UniformInvoiceDB extends DataBaseManagementDB {
  static const String TABLE = 'Uniform_Invoice_DB';
  static const String DATE = 'uniform_invoice_date';
  static const String TYPE = 'uniform_invoice_type';
  static const String NUMBER = 'uniform_invoice_number';
  static const String CREATE_TABLE = '$DATE INT,'
      '$TYPE INT,'
      '$NUMBER BIGINT,'
      'UNIQUE ($DATE, $TYPE, $NUMBER)';

  static Version version = Version(1, 0, 0);

  UniformInvoiceDB(String path) : super(path);
  UniformInvoiceDB.create(FllutterDataBase db) : super.create(db);

  Future<int> add(UniformInvoice uniformInvoice) =>
      db.insert(TABLE, <String, Object?>{
        DATE: uniformInvoice.date,
        TYPE: uniformInvoice.type.value,
        NUMBER: uniformInvoice.number,
      });

  Future<List<UniformInvoice>?> get(int date,
      {DataBaseReaderCallback? callBack}) async {
    List<Map<String, Object?>>? reader = await db.select(
        TABLE, [DATE, TYPE, NUMBER],
        where: '$DATE = ?', arguments: [date]);

    return Future.value(reader != null && reader.isNotEmpty
        ? reader.map((value) {
            UniformInvoice uniformInvoice = UniformInvoice(
                value[DATE] as int,
                UniformInvoiceTypeExtension.types[value[TYPE] as int]!,
                value[NUMBER] as int);
            callBack!(uniformInvoice);
            return uniformInvoice;
          }).toList()
        : null);
  }

  Future<int> delete(int minDate) =>
      db.delete(TABLE, where: '$DATE <= ?', arguments: [minDate]);

  @override
  DataBaseManagement getTableInfo() => DataBaseManagement(TABLE, version);

  @override
  Future<void> createTable() => db.createTable(TABLE, CREATE_TABLE);

  @override
  Future<void> updateTable(Version version) {
    switch (version.toString()) {
      case '1.0.0':
        break;
    }
    return Future.value();
  }
}
