import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:flapp_widget/models/composited_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants.dart';
import '../../../i18n/app_localizations.dart';
import '../../../theme.dart';
import '../../../models/action_event.dart';
import '../../../models/user.dart';
import '../../../services/api_client.dart';
import '../../../styles/ui_styles.dart';
import '../../../view_models/ga_view_model.dart';
import '../../../view_models/user_view_model.dart';
import '../../screens/cart_screen.dart';
import '../../screens/acton_mode_screen.dart';

Widget buildBodyEventData(ActionEvent actionEvent, BuildContext context, String venueName, String actionAge){
  switch (actionEvent.schemeType){
    case SchemeType.generalAdmission:
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: GeneralAdmissionArea(actionEvent: actionEvent,),
      );
    case SchemeType.assignedSeats || SchemeType.mixed:
      return Column(
        spacing: 16,
        children: [
          if (actionEvent.schemeType == SchemeType.assignedSeats && date !="off")
            Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
            child: Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(actionEvent.vkDate,
                  style: customTextStyle(MaterialTheme.lightScheme().onSurfaceVariant, 14, 'Regular'),),
                Text(actionEvent.time,
                  style: customTextStyle(MaterialTheme.lightScheme().onSurfaceVariant, 14, 'Regular'),),
                Text("•",
                  style: customTextStyle(MaterialTheme.lightScheme().onSurfaceVariant, 14, 'Regular'),),
                Flexible(
                  child: Text(venueName, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: customTextStyle(MaterialTheme.lightScheme().onSurfaceVariant, 14, 'Regular'),),
                ),
                Text("•",
                  style: customTextStyle(MaterialTheme.lightScheme().onSurfaceVariant, 14, 'Regular'),),
                Text(actionAge,
                  style: customTextStyle(MaterialTheme.lightScheme().onSurfaceVariant, 14, 'Regular'),),
              ],
            ),
          ),
          const SchemeArea(),
        ],
      );
    default:
      return SizedBox(
        width: 800,
        child: Center(
          child: Text(AppLocalizations.of(context)!.emptyGA,
            style: customTextStyle(MaterialTheme.lightScheme().onSurface, 20, 'Light'), ),
        ),
      );
  }
}

Future buildShowModalCart(BuildContext context){
  return showModal(
    context: context,
    configuration: const FadeScaleTransitionConfiguration(
        reverseTransitionDuration: Duration(milliseconds: 300),
        transitionDuration: Duration(milliseconds: 300)),
    builder:  (BuildContext context) {
      if (MediaQuery.of(context).size.width <= 700) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
      if (MediaQuery.of(context).size.width >= 700) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Center(
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: ScrollController(),
                  child: const Card(
                      color: Color(0xfff2f3f5),
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),),
                      child: Padding(
                        padding: EdgeInsets.all(18.0),
                        child: CartBuilder(),
                      )),
                ),
                Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                        onTap: (){Navigator.pop(context);},
                        child: Icon(CupertinoIcons.clear_thick_circled, size: 26,
                          color: MaterialTheme.lightScheme().tertiary,)),
                  ),),
              ],
            ),
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    }
  );
}

//Билдеры контента корзины с резервированием входных мест
class CartBuilder extends ConsumerWidget {
  const CartBuilder({super.key});

  @override
  Widget build(BuildContext context, ref) {
    var userModel = ref.read(asyncUserProvider.notifier).isUserRegistered();
    return FutureBuilder(future: userModel, builder: (context, snapshot){
      if (snapshot.data != null && snapshot.data == false){
        return EmptyCartContent(userMsg: AppLocalizations.of(context)!.emptyBasketMessage,);
      }
      if (snapshot.data != null && snapshot.data == true){
        return ReservationBuilder(user: ref.read(asyncUserProvider).value!);
      }
      return const SizedBox.shrink();
    });
  }
}

class ReservationBuilder extends ConsumerWidget {
  const ReservationBuilder({super.key, required this.user});
  final User user;

  Future<String> reserveGeneralAdmission(Map<int, List<CompositedCategory>> map,
      User user, WidgetRef ref) async{
    dynamic response = await CartAPI.reserveGeneralAdmission(map, user);
    if (response == null){
      ref.read(categoriesProvider.notifier).clearUserSelection();
      return 'reserved';
    } else {
      return response;
    }
  }

  @override
  Widget build(BuildContext context, ref) {
    var map = ref.read(categoriesProvider);
    return FutureBuilder(
        future: reserveGeneralAdmission(map, user, ref),
        builder: (context, snapshot){
          if (snapshot.data != null){
            if (snapshot.data == "reserved"){
              if (context.mounted) return const PreBuildCartWidget();
            }
            if (snapshot.data is String){
              if (context.mounted) {
                return Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Text(snapshot.data as String,
                  textAlign: TextAlign.justify,
                  style: customTextStyle(null, 18, 'Regular'),),
                );
              }
            }
          }
          return SizedBox(
            height: 200.0,
            width: 200.0,
            child: Center(
              child : CircularProgressIndicator(
                color: MaterialTheme.lightScheme().primary,
              ),
            ),
          );
        });
  }
}

///////////////////////deprecated builders//////////////////////////////////////

Widget renderMultipleEventData(BuildContext context, DateTime date,
    Map<String, List<dynamic>> dateMap){
  List<Widget> widgetList = [];

  if (screenWidth > 900){
    for (var element in dateMap.values){
      if (element.last.toString().contains(date.toString().substring(0,10))){
        //print(element.last.toString().contains(date.toString().substring(0,10)));
        for (var actionEvent in element.first){
          if (actionEvent.schemeType == SchemeType.generalAdmission){
            widgetList.add(const Column(
              children: [
                //renderEventData(actionEvent, context),
                SizedBox(height: 10.0,)
              ],
            ));
          }
        }
      }
    }
  } else{
    for (var element in dateMap.values){
      if (element.last.toString().contains(date.toString().substring(0,10))){
        for (var actionEvent in element.first){
          if (actionEvent.schemeType == SchemeType.generalAdmission){
            widgetList.add(const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //renderEventDataOnMobile(actionEvent, context),
                SizedBox(height: 30.0,)
              ],
            ));
          }
        }
      }
    }
  }
  return Column(mainAxisSize: MainAxisSize.min, children: widgetList,);
}
