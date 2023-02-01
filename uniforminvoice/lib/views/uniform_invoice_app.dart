import 'package:flutter/material.dart';

import 'qrcode/qrcode_uniform_invoice_widget.dart';

class UniformInvoiceApp extends StatelessWidget {
  const UniformInvoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Uninform Invoice'),
        ),
        body: Column(
          children: const <Widget>[
            Expanded(
              child: QRCodeUniformInvoiceWidget(),
            )
          ],
        ),
      ),
    );
  }
}
