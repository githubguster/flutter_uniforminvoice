import '../database/uniform_invoice_db.dart' as uniform_invoice_db;
import '../restful/uniform_invoice_restful.dart' as uniform_invoice_restful;
import '../models/award.dart';

class UniformInvoice {
  final String _date;
  final String _number;

  String get date => _date;
  int get year => int.parse(_date.substring(0, 3));
  int get month => int.parse(_date.substring(3, 5));
  int get day => int.parse(_date.substring(5, 7));
  String get number => _number;

  UniformInvoice(this._date, this._number);

  static UniformInvoice? decode(String? code) {
    if (code!.length > 17) {
      return UniformInvoice(code.substring(10, 17), code.substring(0, 10));
    }
    return null;
  }

  Future<Awards> get() async {
    String title = '$year${month % 2 == 0 ? month - 1 : month}';
    Awards awards = Awards(title, []);
    DateTime minDate = DateTime.now().add(const Duration(days: -180));

    uniform_invoice_db.UniformInvoiceDB db =
        uniform_invoice_db.UniformInvoiceDB('uniform_invoice.db');
    db.delete(int.parse(
        '${minDate.year - 1911}${minDate.month.toString().padLeft(2, "0")}'));
    db.get(int.parse(title), callBack: (uniformInvoice) {
      if (uniformInvoice is uniform_invoice_db.UniformInvoice) {
        String number = '${uniformInvoice.number}';
        AwardType type = uniformInvoice.type ==
                uniform_invoice_db.UniformInvoiceType.special
            ? AwardType.special
            : uniformInvoice.type == uniform_invoice_db.UniformInvoiceType.grand
                ? AwardType.grand
                : AwardType.first;
        awards.awards.add(Award(
          number,
          type,
        ));
      }
    });
    if (awards.awards.isEmpty) {
      int day = int.parse(title);
      awards = await uniform_invoice_restful.InvoiceRestful.get(year, month);
      for (var award in awards.awards) {
        uniform_invoice_db.UniformInvoiceType type =
            award.type == AwardType.special
                ? uniform_invoice_db.UniformInvoiceType.special
                : award.type == AwardType.grand
                    ? uniform_invoice_db.UniformInvoiceType.grand
                    : uniform_invoice_db.UniformInvoiceType.jackpot;
        int number = int.parse(award.number);
        db.add(uniform_invoice_db.UniformInvoice(
          day,
          type,
          number,
        ));
      }
    }
    db.dispose();
    return awards;
  }

  Award? check(Awards awards) {
    String number = '';
    AwardType type = AwardType.none;
    if (awards.awards.isNotEmpty) {
      for (var award in awards.awards) {
        switch (award.type) {
          case AwardType.special:
            if (this.number == award.number) {
              number = award.number;
              type = AwardType.special;
            }
            break;
          case AwardType.grand:
            if (this.number == award.number) {
              number = award.number;
              type = AwardType.grand;
            }
            break;
          case AwardType.first:
            if (this.number.substring(2, 10) == award.number) {
              number = award.number;
              type = AwardType.first;
            } else if (this.number.substring(3, 10) ==
                award.number.substring(1, 8)) {
              number = award.number;
              type = AwardType.second;
            } else if (this.number.substring(4, 10) ==
                award.number.substring(2, 8)) {
              number = award.number;
              type = AwardType.third;
            } else if (this.number.substring(5, 10) ==
                award.number.substring(3, 8)) {
              number = award.number;
              type = AwardType.fourth;
            } else if (this.number.substring(6, 10) ==
                award.number.substring(4, 8)) {
              number = award.number;
              type = AwardType.fifth;
            } else if (this.number.substring(7, 10) ==
                award.number.substring(5, 8)) {
              number = award.number;
              type = AwardType.sixth;
            }
            break;
          default:
            break;
        }
        if (type != AwardType.none) {
          break;
        }
      }
      return Award(number, type);
    }
    return null;
  }
}
