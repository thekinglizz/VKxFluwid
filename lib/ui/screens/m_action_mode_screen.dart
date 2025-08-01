import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flapp_widget/ui/screens/error_screen.dart';

import '../../constants.dart';
import '../../i18n/app_localizations.dart';
import '../../theme.dart';
import '../../models/venue.dart';
import '../../styles/ui_styles.dart';
import '../../view_models/action_view_model.dart';
import '../../view_models/scheme_view_model.dart';
import '../../view_models/user_view_model.dart';
import '../widgets/scheme_widgets/scheme_widget.dart';
import '../widgets/scheme_widgets/seat_widget.dart';

class MobileSchemeScreen extends ConsumerWidget {
  const MobileSchemeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    Venue venue = ref.watch(asyncActionProvider
        .select((avm) => avm.value!.selectedVenue));
    var actionEventDate = ref.watch(asyncActionProvider
        .select((avm) => avm.value!.selectedActionEvent?.date));
    String name = ref.watch(asyncActionProvider
        .select((avm) => avm.value!.actionExt.actionName));
    final scheme = ref.watch(asyncSchemeProvider);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MaterialTheme.lightScheme().surfaceContainerLowest,
        surfaceTintColor: MaterialTheme.lightScheme().surfaceContainerLowest,
        toolbarHeight: 132,
        centerTitle: true,
        bottom:  PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Material(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start, spacing: 5,
                children: [
                  Text(name, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: customTextStyle(MaterialTheme.lightScheme().primary, 18.0, 'Regular')),
                  Row(
                    spacing: 5,
                    children: [
                      Icon(CupertinoIcons.calendar, size: 16,
                          color: MaterialTheme.lightScheme().onSurface),
                      Flexible(
                        child: Text(actionEventDate, maxLines: 1,
                            style: customTextStyle(MaterialTheme.lightScheme().onSurface, 16.0, 'Regular')),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      Icon(CupertinoIcons.location_solid, size: 16,
                          color: MaterialTheme.lightScheme().onSurface),
                      Flexible(
                        child: Text(venue.venueName, maxLines: 1,
                            style: customTextStyle(MaterialTheme.lightScheme().onSurface, 16.0, 'Regular')
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5,)
                ],
              ),
            ),
          ),
        ),
        leading: IconButton(onPressed: () {Navigator.pop(context);},
          icon: Icon(CupertinoIcons.arrow_left, size: 30, color: MaterialTheme.lightScheme().primary,),),
      ),
      body: scheme.when(
          data: (data){return MobileSchemeArea(data: data);},
          error: (error, trace){return ErrorScreen(error: error.toString(),);},
          loading: (){return const SizedBox.shrink();}),
      bottomSheet: scheme.when(
          data: (data){
            if (scheme.isRefreshing){
              return SizedBox(
                  width: screenWidth,
                  child: const Center(child: CircularProgressIndicator()));
            }
            return data.selectedSeats.isNotEmpty ? FluwidBottomSheet(data: data) : null;},
          error: (error, trace){return ErrorScreen(error: error.toString(),);},
          loading: (){return ColoredBox(
              color: Colors.white,
              child: Center(child: CircularProgressIndicator(
                color: MaterialTheme.lightScheme().primary,
              ),));}
      ),
    );
  }
}

class MobileSchemeArea extends ConsumerWidget {
  const MobileSchemeArea({super.key, required this.data,});
  final SchemeViewModel data;

  @override
  Widget build(BuildContext context, ref) {
    final ScrollController scrollController = ScrollController();
    return Stack(
      children: [
        //Схема
        SchemeViewer(size: data.schemeData.ivSize, sectorList: data.schemeData.sectorList,
          schemeCoef: data.schemeData.schemeCoef, siData: data.schemeData.siData,),
        //Категории
        Positioned(
          top: 24,
          left: 1,
          right: 1,
          child: SizedBox(
            height : 50.0,
            child: ListView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              children: data.schemeData.categoryInfoWidgetList,
            ),
          ),
        )
      ],
    );
  }
}

class FluwidBottomSheet extends ConsumerWidget {
  const FluwidBottomSheet({super.key, required this.data});
  final SchemeViewModel data;

  @override
  Widget build(BuildContext context, ref) {
    ScrollController controller = ScrollController();
    List<ReservedCard> reservedList = [];
    reservedList = data.selectedSeats.map((e) => ReservedCard(seatInfo: e,
      currency: data.schemeData.currency, seatWithTariffs: data.selectedTariffSeats,)).toList();
    return BottomSheet(
      onClosing: () {},
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(topRight: Radius.circular(12),
              topLeft: Radius.circular(12)),
          child: Container(
            height: 150,
            color: darken(const Color(0xfff2f3f5), 0.05),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                spacing: 8,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  if (!data.selectedTariffSeats.keys
                      .any((seat)=> seat.category.tariffIdMap.isNotEmpty))
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text('${data.selectedSeats.length} '
                          '${AppLocalizations.of(context)!.numberOfTickets}: '
                          '${totalSum.value} ${data.schemeData.currency}',
                          style: customTextStyle(MaterialTheme.lightScheme().onSurface,
                              14.0, 'Regular').copyWith(fontWeight: FontWeight.w800)
                      )
                  ),
                  SizedBox(height: 55,
                      width: MediaQuery.of(context).size.width,
                      child: ListView(
                        controller: controller,
                        scrollDirection: Axis.horizontal,
                        children: reservedList,
                      )
                  ),
                  SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    child: FilledButton(
                      style: customRoundedBorderStyle(MaterialTheme.lightScheme().primary),
                      child: Text(AppLocalizations.of(context)!.buyLabel,
                          style: customTextStyle(Colors.white, 16.0, 'Regular')),
                      onPressed: () {
                        if (context.mounted){
                          ref.read(asyncUserProvider.notifier).isUserRegistered()
                              .then((value) {
                            if (value) {
                              if (context.mounted){
                                Navigator.of(context).pop();
                                tabIndex.value = 1;
                              }
                            }
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ReservedCard extends ConsumerWidget {
  const ReservedCard({super.key, required this.seatInfo, required this.currency,
  required this.seatWithTariffs});
  final Seat seatInfo;
  final String currency;
  final Map<Seat, int> seatWithTariffs;

  @override
  Widget build(BuildContext context, ref) {
    double getPrice(Seat seatInfo){
      if (seatWithTariffs.containsKey(seatInfo)){
        return seatInfo.category.tariffIdMap[seatWithTariffs[seatInfo]] as double;
      } else {return seatInfo.category.price;}
    }
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 133.0),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: MaterialTheme.lightScheme().outlineVariant, width: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  spacing: 2,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /*Flexible(
                      child: Text("${AppLocalizations.of(context)!.sector}: ${seatInfo.bil24seatObj.sector}",
                          style: customTextStyle(MaterialTheme.lightScheme().onSurface, 12, 'Regular')),
                    ),*/

                    Flexible(
                      child: Text(' ${seatInfo.bil24seatObj.row} ${AppLocalizations.of(context)!.row.toLowerCase()}, '
                          '${seatInfo.bil24seatObj.number} ${AppLocalizations.of(context)!.number.toLowerCase()}',
                        style: customTextStyle(MaterialTheme.lightScheme().onSurface, 12, 'Regular')
                            .copyWith(fontWeight: FontWeight.bold),),
                    ),
                    if ((seatWithTariffs.isNotEmpty && seatWithTariffs.containsKey(seatInfo))
                        || seatInfo.category.tariffIdMap.isEmpty)
                      Row(
                        spacing: 8,
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              color: seatInfo.category.color,
                              borderRadius: BorderRadius.circular(50.0),
                            ),),
                          Text('${getPrice(seatInfo)} $currency',
                              style: customTextStyle(MaterialTheme
                                  .lightScheme().onSurfaceVariant, 12, 'Regular')),
                        ],
                      ),
                  ],
                ),
                const SizedBox(width: 5,),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                      onTap: (){
                        if (ref.read(asyncSchemeProvider).value!.selectedTariffSeats.containsKey(seatInfo)){
                          unreserveSeatHelper(ref, seatInfo,
                              seatInfo.category.tariffIdMap[ref.read(asyncSchemeProvider)
                                .value!.selectedTariffSeats[seatInfo]]);
                      } else {unreserveSeatHelper(ref, seatInfo, null);}},
                      child: Icon(Icons.close_rounded, size: 14,
                        color: MaterialTheme.lightScheme().outline,)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
