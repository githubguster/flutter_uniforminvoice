
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as document;
import 'package:html/parser.dart' as parser;

import '../models/award.dart';

class InvoiceRestful {
  static const String _uri = 'https://www.etax.nat.gov.tw/etw-main/ETW183W2_';
  
  static Future<Awards> get(int year, int month) async {
    month = month % 2 == 0 ? month - 1 : month;
    String url = '$_uri$year${month.toString().padLeft(2, "0")}';
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Utf8Decoder decoder = const Utf8Decoder();
      String title = '';
      List<Award> awards = <Award>[];
      String body = decoder.convert(response.bodyBytes);
      document.Document html = parser.parse(body);
      document.Element? table = html.getElementById('tenMillionsTable');
      table?.getElementsByTagName('tr').forEach((tr) {
        List<document.Element> ths = tr.getElementsByTagName('th');
        List<document.Element> tds = tr.getElementsByTagName('td div div');
        if (tds.isEmpty) {
          tds = tr.getElementsByTagName('td');
        }
        String th = ths.isNotEmpty ? ths[0].innerHtml.trim() : '';
        String td = tds.isNotEmpty ? tds[0].innerHtml.trim() : '';
        if (th == '年月份') {
          title = td;
        } else if (th == '特別獎') {
          awards.add(Award(td, AwardType.special));
        } else if (th == '特獎') {
          awards.add(Award(td, AwardType.grand));
        } else if (th == '頭獎') {
          for (var td in tds) {
            String number = td.innerHtml.trim();
            awards.add(Award(number, AwardType.first));
          }
        }
      });
      return Awards(title, awards);
    } else {
      throw Exception('Failed to load invoice');
    }
  }
}
