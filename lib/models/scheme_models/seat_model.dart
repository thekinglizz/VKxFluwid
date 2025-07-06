import 'dart:math';

class BIL24SeatObj{
  BIL24SeatObj({required this.coordinates, required this.seatId,
    required this.sector, required this.row, required this.number,
  required this.categoryId});

  final Point coordinates;
  final int seatId;
  final String sector;
  final String row;
  final String number;
  final int categoryId;

  get x {return coordinates.x;}
  get y {return coordinates.y;}

  @override
  String toString() {
    return 'BIL24SeatObj{coordinates: $coordinates, seatId: $seatId, '
        'sector: $sector, row: $row, number: $number}';
  }
}