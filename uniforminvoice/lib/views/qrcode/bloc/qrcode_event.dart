part of 'qrcode_bloc.dart';

abstract class QRCodeEvent extends Equatable {
  const QRCodeEvent();
}

class DecodeEvent extends QRCodeEvent {
  const DecodeEvent({required this.results});

  @override
  List<Object> get props => [results];

  final List<CodeResult> results;
}
