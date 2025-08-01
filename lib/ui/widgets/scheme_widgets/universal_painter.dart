import 'dart:math';

import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../models/scheme_models/category_price_model.dart';
import 'seat_widget.dart';

enum PaintingMode {sectorHull, seatsLayout, decoration, test}

class SectorScaffold{
  const SectorScaffold({required this.capacity, required this.sectorName, required this.size,
    required this.centerOffset, required this.convexHullPoints, required this.seatList,
  });

  final int capacity;
  final String sectorName;
  final Size size;
  final Offset centerOffset;
  final List<Offset> convexHullPoints;
  final List<Seat> seatList;
  @override
  String toString() {
    return 'SectorScaffold{availableSeats: $capacity, sectorName: $sectorName}';
  }
}

class UniversalPainter extends CustomPainter{
  const UniversalPainter({required this.sectorList, required this.mode,
  required this.selectedSeats, this.categoryFilter,
    required this.needToRepaint}): super(repaint: needToRepaint);
  final List<SectorScaffold> sectorList;
  final List<Seat> selectedSeats;
  final CategoryPriceObj? categoryFilter;
  final PaintingMode mode;
  final ValueNotifier<bool> needToRepaint;

  void drawSectorNames(SectorScaffold sector, Canvas canvas) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: sector.sectorName,
        style: TextStyle(color: const Color(0xff2e4c85),
            fontSize: screenWidth > 900 ? 8 : 5,
            fontFamily: 'RobotoCondensedRegular'),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout(minWidth: sector.size.width);
    if (sector.size.width >= sector.size.height){
      textPainter.paint(
        canvas,
        Offset(
          sector.centerOffset.dx - textPainter.width/2,
          sector.centerOffset.dy - textPainter.height/2,
        ),
      );
    } else {
      canvas.save();
      canvas.translate(sector.centerOffset.dx , sector.centerOffset.dy);
      canvas.rotate(pi/2);
      canvas.translate(-sector.centerOffset.dx , -sector.centerOffset.dy);
      textPainter.paint(
        canvas,
        Offset(
          sector.centerOffset.dx - textPainter.width/2,
          sector.centerOffset.dy - textPainter.height/2,
        ),
      );
      canvas.restore();
    }
  }

  void drawSectorHull(Canvas canvas, Size size){
    for (var sector in sectorList){
      List<Offset> points = sector.convexHullPoints;
      Paint paint = Paint()
        ..color = sector.seatList.any((seat)=>seat.available)
            ? const Color(0xffa1beff) : Colors.grey.shade300
        ..style = schemeStyle == "stroke" ? PaintingStyle.stroke : PaintingStyle.fill
        ..strokeWidth = 1.0
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round;

      Paint basepaint = Paint()..color = Colors.white;

      Path path = Path();
      path.addPolygon(points.map((e) => Offset(e.dx.toDouble(), e.dy.toDouble())).toList(), true);
      if (schemeStyle == "stroke") canvas.drawPath(path, basepaint);
      canvas.drawPath(path, paint);
      path.close();

      if (sector.capacity > 100) {
        if (sectorName != 'off' && sector.seatList.any((seat)=>seat.available)){
          drawSectorNames(sector, canvas);
        }
      }
    }
  }

  void drawSeatLayout(Canvas canvas, Size size){
    for (var sector in sectorList) {
      double localRadius = sector.seatList.first.radius;
      double stroke = 0.3;
      if (localRadius < 5) {stroke = 0.05;}
      for (var i = 0; i < sector.seatList.length; i++) {
        Color seatColor;
        if (sector.seatList[i].available) {
          if (categoryFilter is CategoryPriceObj){
            if (sector.seatList[i].category == categoryFilter){
              seatColor = sector.seatList[i].category.color;
            } else {
              seatColor = Colors.grey;
            }
          }
          else {
            seatColor = sector.seatList[i].category.color;
          }
        }
        else {seatColor = Colors.grey;}

        if (seatMode == "theatre"){
          final icon = ((sector.seatList[i].available && categoryFilter == null)
              || (sector.seatList[i].available && sector.seatList[i].category == categoryFilter))
              ? Icons.chair : Icons.chair_outlined;
          TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
          textPainter.text = TextSpan(text: String.fromCharCode(icon.codePoint),
              style: TextStyle(
                  fontSize: sectorList.first.seatList.first.radius*2,
                  fontFamily: icon.fontFamily, color: seatColor));
          textPainter.layout();
          textPainter.paint(canvas, Offset(sector.seatList[i].bil24seatObj.x-localRadius,
              sector.seatList[i].bil24seatObj.y-localRadius));
        } else {
          canvas.drawCircle(Offset(sector.seatList[i].bil24seatObj.x,
              sector.seatList[i].bil24seatObj.y), sector.seatList[i].available ? localRadius : localRadius*0.3, Paint()
            ..color = seatColor
            ..style = PaintingStyle.fill
            ..strokeWidth = stroke);
        }
      }
    }

    if(selectedSeats.isNotEmpty){
      for (var seat in selectedSeats){
        drawSelectedSeats(canvas, seat.bil24seatObj.coordinates, seat.radius);
      }
    }
  }

  void drawSelectedSeats(Canvas canvas, Point coordinates, double radius){
    canvas.drawCircle(Offset(coordinates.x.toDouble(),
        coordinates.y.toDouble()), radius*1.4, Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill);

    canvas.drawCircle(Offset(coordinates.x.toDouble(),
        coordinates.y.toDouble()), radius*0.8, Paint()
      ..color = const Color(0xff007fff)
      ..style = PaintingStyle.fill);

    canvas.drawCircle(Offset(coordinates.x.toDouble(),
        coordinates.y.toDouble()), radius*1.4, Paint()
      ..color = const Color(0xff007fff)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius*0.3);
  }

  @override
  void paint(Canvas canvas, Size size) {
    switch (mode){
      case PaintingMode.seatsLayout:
        drawSeatLayout(canvas, size);
      case PaintingMode.sectorHull:
        drawSectorHull(canvas, size);
      default: break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}