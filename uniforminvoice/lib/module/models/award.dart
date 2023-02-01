enum AwardType {
  none,
  special,
  grand,
  first,
  second,
  third,
  fourth,
  fifth,
  sixth
}

Map<AwardType, String> _awardName = {
  AwardType.none: '摃龜',
  AwardType.special: '特別獎',
  AwardType.grand: '特獎',
  AwardType.first: '頭獎',
  AwardType.second: '二獎',
  AwardType.third: '三獎',
  AwardType.fourth: '四獎',
  AwardType.fifth: '五獎',
  AwardType.sixth: '六獎',
};

extension AwardTypeExtension on AwardType {
  String get name => _awardName[this] ?? 'Unknown';
}

class Award {
  final String _number;
  final AwardType _type;

  String get number => _number;
  AwardType get type => _type;
  const Award(this._number, this._type);
}

class Awards {
  final String _title;
  final List<Award> _awards;

  String get title => _title;
  List<Award> get awards => _awards;
  const Awards(this._title, this._awards);
}
