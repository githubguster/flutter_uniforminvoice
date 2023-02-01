part of 'flutter_database.dart';

class DataBaseManagement {
  DataBaseManagement(this._name, this._version);
  String get name => _name;
  Version get version => _version;

  @override
  bool operator ==(covariant DataBaseManagement other) =>
      other.name == name && other.version == version;

  @override
  int get hashCode => name.hashCode;

  final String _name;
  final Version _version;
}

typedef DataBaseReaderCallback = void Function(Object object);

abstract class DataBaseManagementDB {
  static const String TABLE = 'Sys_DB_Management';
  static const String NAME = 'management_name';
  static const String VERSION = 'management_version';
  static const String CREATE_TABLE = '$NAME NVARCHAR(256),'
      '$VERSION NVARCHAR(64),'
      'UNIQUE ($NAME)';
  static Version version = Version(1, 0, 0);

  static List<DataBaseManagement?> _managements = [];

  DataBaseManagementDB(String path, {bool readOnly = false}) {
    db = FllutterDataBase(path);
    _isAutoClose = true;
    _init(isOpen: true, readOnly: readOnly);
  }

  DataBaseManagementDB.create(this.db) {
    _isAutoClose = false;
    _init(isOpen: false);
  }

  void dispose() async {
    if (_isAutoClose) {
      await db.close();
    }
  }

  void _init({required bool isOpen, bool readOnly = false}) async {
    {
      if (isOpen) {
        await db.open();
      }
      DataBaseManagement? management = _managements
          .firstWhere((element) => element?.name == TABLE, orElse: () => null);
      if (management == null) {
        management = await _get(TABLE);
        if (management == null) {
          db.createTable(TABLE, CREATE_TABLE);
          management = DataBaseManagement(TABLE, version);
          _add(management);
        }
        _managements.add(management);
      }
    }
    {
      DataBaseManagement? management = _managements.firstWhere(
          (element) => element?.name == getTableInfo().name,
          orElse: () => null);
      if (management == null) {
        management = await _get(getTableInfo().name);
        if (management == null) {
          await createTable();
          management = getTableInfo();
          _add(management);
        }
        _managements.add(management);
      }
      if (management.version != getTableInfo().version) {
        await updateTable(management.version);
        _managements.remove(management);
        management = getTableInfo();
        _managements.add(management);
        _update(management);
      }
    }
  }

  Future<int> _add(DataBaseManagement management) =>
      db.insert(management.name, <String, Object?>{
        VERSION: management.version,
      });

  Future<int> _update(DataBaseManagement management) => db.update(
      management.name,
      <String, Object?>{
        VERSION: management.version,
      },
      where: '$NAME = ?',
      arguments: [management.name]);

  Future<int> _delete(DataBaseManagement management) =>
      db.delete(TABLE, where: '$NAME = ?', arguments: [management.name]);

  Future<DataBaseManagement?> _get(String name) async {
    List<Map<String, Object?>>? reader = await db.select(name, [NAME, VERSION],
        where: '$NAME = ?', arguments: [name]);
    return Future.value(reader != null && reader.length == 1
        ? DataBaseManagement(
            reader[0][NAME] as String, reader[0][VERSION] as Version)
        : null);
  }

  Future<void> drop() => _delete(getTableInfo());

  DataBaseManagement getTableInfo();
  Future<void> createTable();
  Future<void> updateTable(Version version);

  @protected
  late final FllutterDataBase db;

  late final bool _isAutoClose;
}
