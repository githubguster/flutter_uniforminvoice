import 'package:flutter/material.dart';

import 'package:flutter_zxing/flutter_zxing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter ZXing-C++ Example'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ZXingReaderWidget(
                isShowScannerOverlay: false,
                isMultiScan: true,
                onMultiScan: (List<CodeResult> results) {
                  for (var element in results) {
                    debugPrint('Value: ${element.text}');
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}