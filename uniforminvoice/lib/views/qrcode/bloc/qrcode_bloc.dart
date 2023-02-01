import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_zxing/flutter_zxing.dart';

import '../../../module/module.dart';

part 'qrcode_event.dart';
part 'qrcode_state.dart';

class QRCodeBloc extends Bloc<QRCodeEvent, QRCodeState> {
  QRCodeBloc({required this.context})
      : super(const DecodeState(date: '', award: null)) {
    on<DecodeEvent>(_qrcodeDecode);
  }

  Future<void> _qrcodeDecode(
      DecodeEvent event, Emitter<QRCodeState> emit) async {
    for (var result in event.results) {
      UniformInvoice? uniformInvoice = UniformInvoice.decode(result.text);
      if (uniformInvoice != null) {
        if (oldNumber != uniformInvoice.number) {
          oldNumber = uniformInvoice.number;
          Awards awards = await uniformInvoice.get();
          emit(DecodeState(
              date: uniformInvoice.date, award: uniformInvoice.check(awards)));
        }
      }
    }
  }

  final BuildContext context;
  String? oldNumber;
}
