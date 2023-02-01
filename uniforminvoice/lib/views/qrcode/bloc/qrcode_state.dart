part of 'qrcode_bloc.dart';

abstract class QRCodeState extends Equatable {
  const QRCodeState();
}

class DecodeState extends QRCodeState {
  const DecodeState({required this.date, required this.award});

  @override
  List<Object?> get props => [date, award];

  final String date;
  final Award? award;
}