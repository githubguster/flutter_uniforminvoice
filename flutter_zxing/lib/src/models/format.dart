// Format Enumerates barcode formats known to this package.
enum Format {
  none,
  aztec, // Aztec (2D)
  codabar, // Codabar (1D)
  code39, // Code39 (1D)
  code93, // Code93 (1D)
  code128, // Code128 (1D)
  dataBar, // GS1 DataBar
  dataBarExpanded, // GS1 DataBar Expanded
  dataMatrix, // DataMatrix (2D)
  ean8, // EAN-8 (1D)
  ean13, // EAN-13 (1D)
  itf, // ITF (Interleaved Two of Five) (1D)
  maxiCode, // MaxiCode (2D)
  pdf417, // PDF417 (1D) or (2D)
  qrCode, // QR Code (2D)
  upca, // UPC-A (1D)
  upce, // UPC-E (1D)
  microQRCode, // Micro QR Code (2D)
  oneDCodes,
  twoDCodes,
  any,
}

abstract class _Format {
  static const int none = 0;
  static const int aztec = 1 << 0;
  static const int codabar = 1 << 1;
  static const int code39 = 1 << 2;
  static const int code93 = 1 << 3;
  static const int code128 = 1 << 4;
  static const int dataBar = 1 << 5;
  static const int dataBarExpanded = 1 << 6;
  static const int dataMatrix = 1 << 7;
  static const int ean8 = 1 << 8;
  static const int ean13 = 1 << 9;
  static const int itf = 1 << 10;
  static const int maxiCode = 1 << 11;
  static const int pdf417 = 1 << 12;
  static const int qrCode = 1 << 13;
  static const int upca = 1 << 14;
  static const int upce = 1 << 15;
  static const int microQRCode = 1 << 16;

  static const int oneDCodes = codabar |
      code39 |
      code93 |
      code128 |
      ean8 |
      ean13 |
      itf |
      dataBar |
      dataBarExpanded |
      upca |
      upce;
  static const int twoDCodes =
      aztec | dataMatrix | maxiCode | pdf417 | qrCode | microQRCode;
  static const int any = oneDCodes | twoDCodes;
}

final Map<Format, String> _barcodeNames = <Format, String>{
  Format.none: 'None',
  Format.aztec: 'Aztec',
  Format.codabar: 'CodaBar',
  Format.code39: 'Code39',
  Format.code93: 'Code93',
  Format.code128: 'Code128',
  Format.dataBar: 'DataBar',
  Format.dataBarExpanded: 'DataBarExpanded',
  Format.dataMatrix: 'DataMatrix',
  Format.ean8: 'EAN8',
  Format.ean13: 'EAN13',
  Format.itf: 'ITF',
  Format.maxiCode: 'MaxiCode',
  Format.pdf417: 'PDF417',
  Format.qrCode: 'QR Code',
  Format.upca: 'UPCA',
  Format.upce: 'UPCE',
  Format.microQRCode: 'Micro QRCode',
  Format.oneDCodes: 'OneD',
  Format.twoDCodes: 'TwoD',
  Format.any: 'Any',
};

final Map<Format, int> _barcodeValues = <Format, int>{
  Format.none: _Format.none,
  Format.aztec: _Format.aztec,
  Format.codabar: _Format.codabar,
  Format.code39: _Format.code39,
  Format.code93: _Format.code93,
  Format.code128: _Format.code128,
  Format.dataBar: _Format.dataBar,
  Format.dataBarExpanded: _Format.dataBarExpanded,
  Format.dataMatrix: _Format.dataMatrix,
  Format.ean8: _Format.ean8,
  Format.ean13: _Format.ean13,
  Format.itf: _Format.itf,
  Format.maxiCode: _Format.maxiCode,
  Format.pdf417: _Format.pdf417,
  Format.qrCode: _Format.qrCode,
  Format.upca: _Format.upca,
  Format.upce: _Format.upce,
  Format.microQRCode: _Format.microQRCode,
  Format.oneDCodes: _Format.oneDCodes,
  Format.twoDCodes: _Format.twoDCodes,
  Format.any: _Format.any,
};

final Map<Format, double> _barcodeRatios = <Format, double>{
  Format.aztec: 3.0 / 3.0, // recommended ratio: 3:3 (square)
  Format.codabar: 3.0 / 1.0, // recommended ratio: 3:1
  Format.code39: 3.0 / 1.0, // recommended ratio: 3:1
  Format.code93: 3.0 / 1.0, // recommended ratio: 3:1
  Format.code128: 2.0 / 1.0, // recommended ratio: 2:1
  Format.dataBar: 3.0 / 1.0, // recommended ratio: 3:1
  Format.dataBarExpanded: 1.0 / 1.0, // recommended ratio: 1:1 (square)
  Format.dataMatrix: 3.0 / 3.0, // recommended ratio: 3:3 (square)
  Format.ean8: 3.0 / 1.0, // recommended ratio: 3:1
  Format.ean13: 3.0 / 1.0, // recommended ratio: 3:1
  Format.itf: 3.0 / 1.0, // recommended ratio: 3:1
  Format.maxiCode: 3.0 / 3.0, // recommended ratio: 3:3 (square)
  Format.pdf417: 3.0 / 1.0, // recommended ratio: 3:1
  Format.qrCode: 3.0 / 3.0, // recommended ratio: 3:3 (square)
  Format.upca: 3.0 / 1.0, // recommended ratio: 3:1
  Format.upce: 1.0 / 1.0, // recommended ratio: 1:1 (square)
  Format.microQRCode: 3.0 / 3.0, // recommended ratio: 3:3 (square)
};

final Map<Format, int> _barcodeMaxTextLengths = <Format, int>{
  Format.aztec: 3832,
  Format.codabar: 20,
  Format.code39: 43,
  Format.code93: 47,
  Format.code128: 2046,
  Format.dataBar: 74,
  Format.dataBarExpanded: 4107,
  Format.dataMatrix: 2335,
  Format.ean8: 8,
  Format.ean13: 13,
  Format.itf: 20,
  Format.maxiCode: 30,
  Format.pdf417: 2953,
  Format.qrCode: 7089,
  Format.upca: 12,
  Format.upce: 8,
  Format.microQRCode: 4296,
};

extension CodeFormat on Format {
  String get name => _barcodeNames[this] ?? 'Unknown';
  int get value => _barcodeValues[this] ?? 0;
  double get ratio => _barcodeRatios[this] ?? 1.0;
  int get maxTextLength => _barcodeMaxTextLengths[this] ?? 0;
  bool get isSupportedEccLevel => eccSupported.contains(this);

  static final List<Format> eccSupported = <Format>[
    Format.qrCode,
    Format.microQRCode,
  ];

  static final Map<int, Format> formats = <int, Format>{
    _Format.none: Format.none,
    _Format.aztec: Format.aztec,
    _Format.codabar: Format.codabar,
    _Format.code39: Format.code39,
    _Format.code93: Format.code93,
    _Format.code128: Format.code128,
    _Format.dataBar: Format.dataBar,
    _Format.dataBarExpanded: Format.dataBarExpanded,
    _Format.dataMatrix: Format.dataMatrix,
    _Format.ean8: Format.ean8,
    _Format.ean13: Format.ean13,
    _Format.itf: Format.itf,
    _Format.maxiCode: Format.maxiCode,
    _Format.pdf417: Format.pdf417,
    _Format.qrCode: Format.qrCode,
    _Format.upca: Format.upca,
    _Format.upce: Format.upce,
    _Format.microQRCode: Format.microQRCode,
    _Format.oneDCodes: Format.oneDCodes,
    _Format.twoDCodes: Format.twoDCodes,
    _Format.any: Format.any,
  };
}

enum EccLevel {
  low, // Low error correction level. Can withstand up to 7% damage.
  medium, // Medium error correction level. Can withstand up to 15% damage.
  quartile, // Quartile error correction level. Can withstand up to 25% damage.
  high, // High error correction level. Can withstand up to 30% damage.
}

extension CodeEccLevel on EccLevel {
  static const Map<EccLevel, int> _valuesMap = <EccLevel, int>{
    EccLevel.low: 2,
    EccLevel.medium: 4,
    EccLevel.quartile: 6,
    EccLevel.high: 8,
  };

  int get value => _valuesMap[this] ?? 0;
}
