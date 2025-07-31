import 'dart:math';

import 'package:flapp_widget/models/scheme_models/category_price_model.dart';
import 'package:flapp_widget/services/svg_renderer/svg_parser.dart';
import 'package:flapp_widget/ui/widgets/scheme_widgets/seat_widget.dart';
import 'package:flapp_widget/view_models/action_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:vector_math/vector_math_64.dart' show Quad;

import '../../../constants.dart';
import '../../../i18n/app_localizations.dart';
import '../../../models/user.dart';
import '../../../theme.dart';
import '../../../view_models/user_view_model.dart';
import 'universal_painter.dart';
import '../../../view_models/scheme_view_model.dart';

// Виджет отображающий схему
class SchemeViewer extends ConsumerStatefulWidget {
  const SchemeViewer({super.key, required this.siData,
    required this.size, required this.sectorList, required this.schemeCoef});
  final List<SectorScaffold> sectorList;
  final SVGInformation siData;
  final Point size;
  final double schemeCoef;
  static const double _minScale = 0.5;
  static const double _maxScale = 100.0;

  @override
  ConsumerState<SchemeViewer> createState() => _SchemeViewerState();
}

class _SchemeViewerState extends ConsumerState<SchemeViewer> {
  List<SectorScaffold> _onScreenSectors = [];
  List<Seat> _selectedSeatList = [];
  CategoryPriceObj? _cf;
  double _currentZoom = 1.0;
  final ValueNotifier<bool> _needToRepaint = ValueNotifier(false);
  final _viewTransformationController = TransformationController();

  bool _showSeats(){
    if (hull == 'off'){
      return true;
    }
    late final int capacity;
    if (screenWidth > 700){
      capacity = 7000;
    } else {
      capacity = 5000;
    }
    final totalSum = widget.sectorList.fold(0, (sum, sector) => sum + sector.capacity);
    return totalSum / _currentZoom <= capacity;
  }

  bool _seatIsTapped(Point squareTopLeft, double sideLength, Point point) {
    if (point.x <= squareTopLeft.x || point.x >= squareTopLeft.x + sideLength) {
      return false;
    }
    if (point.y <= squareTopLeft.y || point.y >= squareTopLeft.y + sideLength) {
      return false;
    }
    return true;
  }

  void _updateSelectedSeatList(){
    _cf = ref.read(asyncSchemeProvider.select((svm)=> svm.value?.categoryPriceFilter));
    List<Seat> objList = ref.read(asyncSchemeProvider.select((svm) => svm.value!.selectedSeats));
    List<Seat> result = [];
    for (var sector in widget.sectorList){
      for (var seat in sector.seatList){
        if (objList.contains(seat)){
          result.add(seat);
        }
      }
    }
    _selectedSeatList = result;
    _needToRepaint.value = true;
  }

  void _tapOnSeat(TapUpDetails details) {
    Point userPoint = Point(details.localPosition.dx,
        details.localPosition.dy);
    final cf = ref.read(asyncSchemeProvider).value!.categoryPriceFilter;
    for (var sector in widget.sectorList){
      for (var seat in sector.seatList){
        if ((seat.available && cf== null) || (seat.available && seat.category == cf)){
          final r = sector.seatList.first.radius;
          if (_seatIsTapped(Point(seat.bil24seatObj.x-r,seat.bil24seatObj.y-r),
              r*2, userPoint)){
            _reservationProcess(details, seat, context);
          }
        }
      }
    }
  }

  void _reservationProcess(TapUpDetails details, Seat seat, BuildContext context) {
    final fanIdRequired = ref.read(asyncActionProvider).value!.selectedActionEvent!.fanIdRequired;
    final user = ref.read(asyncUserProvider).value;
    if (user?.state == UserStates.authorized){
      //если место без тарифов и требуется фанайди
      if (seat.category.tariffIdMap.isEmpty && fanIdRequired){
        final selectedSeats = ref.read(asyncSchemeProvider).value!.selectedSeats;
        if (MediaQuery.of(context).size.width > 700){
          showAdditionalMenu(details, buildFanIdInputMenu(seat, ref), fanIdRequired, context);
        } else {
          mobileShowAdditionalMenu(selectedSeats, seat, details, fanIdRequired, context, ref);
        }
      }

      //если место с тарифом, требование фанайди не играет роли
      if (seat.category.tariffIdMap.isNotEmpty){
        showAdditionalMenu(details, buildTariffMenu(seat, fanIdRequired, ref, context),
            fanIdRequired, context);
      }

      //если место без тарифов и не требуется фанайди
      if (seat.category.tariffIdMap.isEmpty && !fanIdRequired){
        if (!ref.read(asyncSchemeProvider)
            .value!.selectedSeats.contains(seat)){
          reserveSeatHelper(context, ref, seat, null, null, null);
        } else {
          unreserveSeatHelper(ref, seat, null);
        }
      }
    }
    else {
      showDialog<String>(context: context,
        builder: (BuildContext context) =>
            UserDialog(userMessage: AppLocalizations.of(context)!.emailMessage2,
                redirectFlag: screenWidth < 1100 ? true : false),);
    }
  }

  @override
  dispose() {
    _viewTransformationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _onScreenSectors = widget.sectorList;
    final siWidth = (widget.siData.schemeSize.width * widget.schemeCoef)/2;
    final siHeight = (widget.siData.schemeSize.height * widget.schemeCoef)/2.5;
    if (screenWidth > 700){_viewTransformationController.value.translate(450-siWidth, 350-siHeight);}
    else {_viewTransformationController.value.translate(screenWidth/2-siWidth, (screenHeight*0.7)/2-siHeight);}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _updateSelectedSeatList();
    return MouseRegion(
      onEnter: (pointerEvent) {
        physics.value = const NeverScrollableScrollPhysics();
      },
      onExit: (pointerEvent) {
        physics.value = const AlwaysScrollableScrollPhysics();
      },
      onHover: (s) {},
      child: LayoutBuilder(
        builder: (context, constraints){
          return Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                child: Container(
                  width: widget.size.x.toDouble(),
                  height: widget.size.y.toDouble(),
                  decoration: const BoxDecoration(color: Color(0xffF2F3F5),),
                  child: InteractiveViewer.builder(
                    clipBehavior: Clip.hardEdge,
                    transformationController: _viewTransformationController,
                    boundaryMargin: const EdgeInsets.all(double.infinity),
                    maxScale: SchemeViewer._maxScale,
                    minScale: SchemeViewer._minScale,
                    panAxis: PanAxis.free,
                    scaleFactor: 200.0,
                    onInteractionUpdate: (details){
                      _currentZoom = _viewTransformationController
                          .value.getMaxScaleOnAxis();
                    },
                    builder: (BuildContext context, Quad viewport) {
                      if (_showSeats()){
                        _needToRepaint.value = false;
                      }
                      return RepaintBoundary(
                        child: MouseRegion(
                          cursor: !_showSeats() ? SystemMouseCursors.click : SystemMouseCursors.basic,
                          child: GestureDetector(
                            onTapUp: (details){
                              if (_showSeats()){
                                _tapOnSeat(details);
                              }
                              if (!_showSeats()){
                                late double deviceScale;
                                if (screenWidth > 700){
                                  deviceScale = 12;
                                } else {
                                  deviceScale = 20;
                                }
                                final newX = details.localPosition.dx - details.localPosition.dx * deviceScale;
                                final newY =  details.localPosition.dy - details.localPosition.dy * deviceScale;
                                _viewTransformationController.value = Matrix4.identity()
                                  ..translate(newX, newY)
                                  ..scale(deviceScale);
                                _currentZoom = _viewTransformationController
                                    .value.getMaxScaleOnAxis();
                                setState(() {});
                              }
                            },
                            child: Stack(
                              children: [
                                if (decorations != "off")
                                  SizedBox(
                                      width: widget.siData.schemeSize.width * widget.schemeCoef,
                                      height: widget.siData.schemeSize.height * widget.schemeCoef,
                                      child: ScalableImageWidget(
                                        si:widget.siData.scalableImage,
                                        isComplex: true,
                                      )
                                  ),
                                IndexedStack(
                                  index: _showSeats() ? 0 : 1,
                                  children: [
                                    CustomPaint(
                                        size: Size(widget.size.x.toDouble(), widget.size.y.toDouble()),
                                        painter: _showSeats() ? UniversalPainter(
                                          sectorList: _onScreenSectors,
                                          mode: PaintingMode.seatsLayout,
                                          selectedSeats: _selectedSeatList,
                                          categoryFilter: _cf,
                                          needToRepaint: _needToRepaint,
                                        ) : null
                                    ),
                                    CustomPaint(
                                        size: Size(widget.size.x.toDouble(), widget.size.y.toDouble()),
                                        painter: UniversalPainter(
                                          sectorList: widget.sectorList,
                                          mode: PaintingMode.sectorHull,
                                          selectedSeats: [],
                                          needToRepaint: ValueNotifier(false),
                                        )
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ) ,
                      );
                    },
                  ),
                ),
              ),
              buildPositioned(context)
            ],
          );
        },
      ),
    );
  }

  Positioned buildPositioned(BuildContext context) {
    return Positioned(
      top: screenWidth > 700 ? 256.0 : screenWidth/2,
      right: 24.0,
      child: Column(
        spacing: 12,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  border: Border.all(color: Colors.grey.shade300, width: 0.5)
              ),
              child: IconButton(
                  onPressed: () {
                    late dynamic x;
                    _currentZoom = _viewTransformationController
                        .value.getMaxScaleOnAxis();
                    if (screenWidth > 1100) {
                      x = const Offset(450, 350);
                    } else {
                      x = Offset(screenWidth / 2, screenWidth / 2);
                    }
                    final offset1 = _viewTransformationController.toScene(x);
                    _viewTransformationController.value.scale(1.5);
                    final offset2 = _viewTransformationController.toScene(x);
                    final dx = offset1.dx - offset2.dx;
                    final dy = offset1.dy - offset2.dy;
                    _viewTransformationController.value.translate(-dx, -dy);
                    setState(() {});
                  },
                  icon: Icon(Icons.add, size: 30.0,
                    color: MaterialTheme.lightScheme().onSurface,)),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  border: Border.all(color: Colors.grey.shade300, width: 0.5)
              ),
              child: IconButton(onPressed: () {
                late dynamic x;
                _currentZoom = _viewTransformationController
                    .value.getMaxScaleOnAxis();
                if (screenWidth > 1100) {
                  x = const Offset(450, 350);
                } else {
                  x = Offset(screenWidth / 2, screenWidth / 2);
                }
                final offset1 = _viewTransformationController.toScene(x);
                _viewTransformationController.value.scale(.5);
                final offset2 = _viewTransformationController.toScene(x);
                final dx = offset1.dx - offset2.dx;
                final dy = offset1.dy - offset2.dy;
                _viewTransformationController.value.translate(-dx, -dy);
                setState(() {});
              },
                  icon: Icon(Icons.remove, size: 30.0,
                    color: MaterialTheme.lightScheme().onSurface,)),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                border: Border.all(color: Colors.grey.shade300, width: 0.5),
                color: Colors.white,
              ),
              child: IconButton(onPressed: () {
                _currentZoom = 1.0;
                _viewTransformationController.value =
                    Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
                final siWidth = (widget.siData.schemeSize.width * widget.schemeCoef)/2;
                final siHeight = (widget.siData.schemeSize.height * widget.schemeCoef)/2.5;
                if (screenWidth > 700){
                  _viewTransformationController.value
                      .translate(450-siWidth, 350-siHeight);
                }
                else {
                  _viewTransformationController.value
                      .translate(screenWidth/2-siWidth, (screenHeight*0.7)/2-siHeight);
                }
              },
                  icon: Icon(Icons.center_focus_strong, size: 28.0,
                    color: MaterialTheme.lightScheme().onSurface,)),
            ),
          ),
        ],
      ),
    );
  }
}

/*
* if(screenWidth < 700) Positioned(top:20, right: 20, child:  ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Opacity(
                  opacity: 0.7,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: const Icon(Icons.pinch_outlined, size: 25, color: Colors.white),
                  ),
                ),
              )),*/