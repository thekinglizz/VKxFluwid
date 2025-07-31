import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../i18n/app_localizations.dart';
import '../../../models/scheme_models/category_price_model.dart';
import '../../../models/scheme_models/seat_model.dart';
import '../../../models/user.dart';
import '../../../theme.dart';
import '../../../styles/ui_styles.dart';
import '../../../view_models/scheme_view_model.dart';
import '../../../view_models/user_view_model.dart';

void reserveSeatHelper(BuildContext context, WidgetRef ref,
    Seat seat, int? tariffId, double? expectedPrice, String? fanId) {
  final user = ref.read(asyncUserProvider).value;
  if (tariffId == null){
    ref.read(asyncSchemeProvider.notifier).reserveSeat(seat, user!, context, fanId);
  }
  if (tariffId is int){
    ref.read(asyncSchemeProvider.notifier).reserveSeatWithTariff(seat, user!,
        context, tariffId, expectedPrice!, fanId);
  }
}

dynamic unreserveSeatHelper(WidgetRef ref, Seat seat, double? expectedPrice){
  User? user = ref.read(asyncUserProvider).value;
  ref.read(asyncSchemeProvider.notifier).unreserveSeat(seat, user!, expectedPrice);
}

Future<void> startTariffReservation(BuildContext context, WidgetRef ref, Seat seat,
    MapEntry<int, double> tariffEntry, bool fanIdRequired) async {
  if (fanIdRequired){
    if (context.mounted){
      await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Center(
                child: SizedBox(
                  width: 350,
                  child: Card
                    (child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FanIdInputMenuItem(seat: seat, tariffEntry: tariffEntry,),
                  )),
                ),
              ),
            );
          });
    }
  } else {
    reserveSeatHelper(context, ref, seat, tariffEntry.key, tariffEntry.value, null);
  }
}

class Seat {
  const Seat({required this.bil24seatObj, required this.radius, required this.available,
    required this.category});

  final BIL24SeatObj bil24seatObj;
  final CategoryPriceObj category;
  final double radius;
  final bool available;

  @override
  String toString() {
    return 'Seat{bil24seatObj: $bil24seatObj}';
  }
}

class TariffMenuItem extends StatelessWidget {
  const TariffMenuItem({super.key, required this.tariffName, required this.isSelected,
    required this.isDeleteButton});
  final String tariffName;
  final bool isSelected;
  final bool isDeleteButton;

  @override
  Widget build(BuildContext context) {
    return isDeleteButton ? Container(
      height: 45.0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: MaterialTheme.lightScheme().primary,
      ),
      child: const Center(child: Icon(CupertinoIcons.delete, color: Colors.white, size: 24,),),
    ) :
    Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: Colors.grey),
        color: Colors.white,
      ),
      child: ListTile(
        mouseCursor: MouseCursor.defer,
        leading: isSelected ? Icon(Icons.check, color: MaterialTheme.lightScheme().primary,) : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        title: Text(
            tariffName,
            style: isSelected
                ? customTextStyle(MaterialTheme.lightScheme().onSurface, 14, 'Regular')
                .copyWith(fontWeight: FontWeight.bold)
                : customTextStyle(MaterialTheme.lightScheme().onSurface, 14, 'Regular')
        ),
      ),
    );
  }
}

class FanIdInputMenuItem extends ConsumerStatefulWidget {
  const FanIdInputMenuItem({super.key, required this.seat, required this.tariffEntry});
  final Seat seat;
  final MapEntry<int, double>? tariffEntry;

  @override
  ConsumerState<FanIdInputMenuItem> createState() => _FanIdInputMenuItemState();
}

class _FanIdInputMenuItemState extends ConsumerState<FanIdInputMenuItem> {
  final _fanIdController = TextEditingController();
  bool waiting = false;

  void _startReservation() async{
    String fanIdText = _fanIdController.text.replaceAll(' ', '');
    final user = ref.read(asyncUserProvider).value;
    if (fanIdText.length < 300){
      waiting = true;
      setState(() {});
      if (widget.tariffEntry is MapEntry){
        await ref.read(asyncSchemeProvider.notifier)
            .reserveSeatWithTariff(widget.seat, user!, context,
            widget.tariffEntry!.key, widget.tariffEntry!.value, fanIdText);
      } else {
        await ref.read(asyncSchemeProvider.notifier)
            .reserveSeat(widget.seat, user!, context, fanIdText);
      }
      _endReservation();
    }
    _fanIdController.clear();
  }

  void _endReservation(){
    waiting = false;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _fanIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!waiting) {
      return Column(
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${AppLocalizations.of(context)!.sector} '
            '${widget.seat.bil24seatObj.sector} - '
            '${AppLocalizations.of(context)!.row} '
            '${widget.seat.bil24seatObj.row}'
            ' - ${AppLocalizations.of(context)!.number} '
            '${widget.seat.bil24seatObj.number}',
          style: customTextStyle(MaterialTheme.lightScheme().onSurface, 14, 'Regular'),),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 5,
          children: [
            Expanded(
              child: TextField(
                  onEditingComplete: (){FocusScope.of(context).requestFocus(FocusNode());},
                  controller: _fanIdController,
                  decoration: outlinedField(context, 'FanId*', null)),
            ),
            SizedBox(
              height: 50,
              child: FilledButton(
                  style: roundedBorderStyle(),
                  onPressed: (){_startReservation();},
                  child: Icon(
                    Icons.arrow_forward, size: 20,
                    color: MaterialTheme.lightScheme().onPrimary,)
              ),
            )
          ],
        ),
        Text(AppLocalizations.of(context)!.fanIdHint,
          style: customTextStyle(MaterialTheme.lightScheme().onSurface, 14, 'Regular'),),
      ],
    );
    } else {
      return ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 100, minWidth: 350),
          child: Center(child: CircularProgressIndicator(color: MaterialTheme.lightScheme().primary,)));
    }
  }
}

Future<dynamic> showAdditionalMenu(TapUpDetails details, List<PopupMenuItem> tList,
    bool fanIdRequired, BuildContext context) {
  return showMenu(
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: MaterialTheme.lightScheme().primary, width: 1.5)
      ),
      elevation: 3.0,
      context: context,
      constraints: fanIdRequired ? const BoxConstraints(maxWidth: 350, minWidth: 150) : null,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        MediaQuery.of(context).size.width - details.globalPosition.dx,
        MediaQuery.of(context).size.height - details.globalPosition.dy,
      ),
      items: tList
  );
}

void mobileShowAdditionalMenu(List<Seat> selectedSeats, Seat seat,
    TapUpDetails details, bool fanIdRequired, BuildContext context, WidgetRef ref) {
  if (selectedSeats.contains(seat)){
    showAdditionalMenu(details, buildFanIdInputMenu(seat, ref), fanIdRequired, context);
  } else {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Center(
              child: SizedBox(
                width: 350, child: Card(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FanIdInputMenuItem(seat: seat, tariffEntry: null,)
                  )),
              ),
            ),
          );
        });
  }
}

List<PopupMenuItem> buildTariffMenu(Seat seat, bool fanIdRequired, WidgetRef ref,
    BuildContext context){
  final String currency = ref.read(asyncSchemeProvider).value!.schemeData.currency;
  final Map<Seat, int> selectedTariffSeats = ref.read(asyncSchemeProvider).value!.selectedTariffSeats;
  final List<Seat> selectedSeats = ref.read(asyncSchemeProvider).value!.selectedSeats;
  List<PopupMenuItem> tariffItemList = [];

  //заполняем тарифы для места, отмечаем выбранный
  for (var entry in seat.category.tariffIdMap.entries){
    String name = ref.read(asyncSchemeProvider).value!.schemeData.tariffPlanList
        .firstWhere((test)=>test['tariffPlanId'] == entry.key)['tariffPlanName'];
    if (selectedTariffSeats[seat] == entry.key){
        tariffItemList.insert(0, PopupMenuItem(
            enabled: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: TariffMenuItem(tariffName: '$name: ${entry.value} $currency',
                isSelected: selectedTariffSeats[seat] == entry.key,
                isDeleteButton: false,),
            )));
      } else {
        tariffItemList.add(PopupMenuItem(
            onTap: () {startTariffReservation(context, ref, seat, entry, fanIdRequired);},
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: TariffMenuItem(tariffName: '$name: ${entry.value} $currency',
                isSelected: selectedTariffSeats[seat] == entry.key,
                isDeleteButton: false,),
            )));
      }
  }

  //удаляем выбор тарифов если место уже выбрано но информации о выбранном тарифе нет, добавляем кнопку удаления
  if (selectedSeats.contains(seat)){
    if (selectedTariffSeats.isEmpty || !selectedTariffSeats.containsKey(seat)){
      tariffItemList.clear();
    }
    tariffItemList.add(PopupMenuItem(
        onTap: (){
          unreserveSeatHelper(ref, seat, seat.category
            .tariffIdMap[selectedTariffSeats[seat]]);
          },
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: TariffMenuItem(tariffName: '', isSelected: false, isDeleteButton: true,),
        )));
    }

  return tariffItemList;
}

List<PopupMenuItem> buildFanIdInputMenu(Seat seat, WidgetRef ref){
  final selectedSeats = ref.read(asyncSchemeProvider).value!.selectedSeats;
  if (selectedSeats.contains(seat)) {
    return [PopupMenuItem(
        onTap: (){unreserveSeatHelper(ref, seat, null);},
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: TariffMenuItem(tariffName: '', isSelected: false, isDeleteButton: true,),
        ))];
  }

  return [PopupMenuItem(onTap: (){}, child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: FanIdInputMenuItem(seat: seat, tariffEntry: null),
      ))
  ];
}
