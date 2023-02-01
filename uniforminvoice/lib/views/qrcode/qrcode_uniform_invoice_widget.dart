import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter_zxing/flutter_zxing.dart';

import '../../../module/module.dart';
import 'bloc/qrcode_bloc.dart';

typedef LotteryCallback = void Function(String date, Award award);

class QRCodeUniformInvoiceWidget extends StatelessWidget {
  const QRCodeUniformInvoiceWidget({super.key, this.onLottery});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) => QRCodeBloc(context: context))
      ],
      child: _QRCodeUniformInvoiceAction(onLottery: onLottery),
    );
  }

  final LotteryCallback? onLottery;
}

class _QRCodeUniformInvoiceAction extends StatelessWidget {
  const _QRCodeUniformInvoiceAction({super.key, this.onLottery});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QRCodeBloc, QRCodeState>(
      builder: (context, state) {
        if (state is DecodeState) {
          if (state.award != null) {
            Award award = state.award!;
            Fluttertoast.showToast(
                msg: award.type.name,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            onLottery?.call(state.date, award);
          }
        }
        return Expanded(
            child: ZXingReaderWidget(
                isShowScannerOverlay: false,
                isShowGallery: false,
                isMultiScan: true,
                onMultiScan: (List<CodeResult> results) {
                  context.read<QRCodeBloc>().add(DecodeEvent(results: results));
                }));
      },
    );
  }

  final LotteryCallback? onLottery;
}
