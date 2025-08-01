import 'package:flapp_widget/constants.dart';
import 'package:flapp_widget/models/cart_models/cart.dart';
import 'package:flapp_widget/view_models/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../i18n/app_localizations.dart';
import '../../models/user.dart';
import '../../theme.dart';
import '../../styles/ui_styles.dart';
import '../../view_models/cart_view_model.dart';
import '../widgets/cart_widgets/cart_components.dart';
import 'error_screen.dart';

class PreBuildCartWidget extends ConsumerStatefulWidget {
  const PreBuildCartWidget({super.key});

  @override
  ConsumerState<PreBuildCartWidget> createState() => _PreBuildCartWidgetState();
}

class _PreBuildCartWidgetState extends ConsumerState<PreBuildCartWidget> {
  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(asyncCartProvider);
    return cart.when(
        data: (data){
          return data.bList.isEmpty ?
          EmptyCartContent(userMsg: AppLocalizations.of(context)!.emptyBasketMessage,) :
          MediaQuery.of(context).size.width >= 700
              ? CartWidget(cartOrder: data)
              : MobileCartWidget(cartOrder: data);
        },
        error: (error, trace){
          String subTrace = "";
          trace.toString().length > 500
              ? subTrace = trace.toString().substring(0,500)
              : subTrace = trace.toString();
          return  SizedBox(height:50,
              child: ErrorScreen(error: "$actionError\n$error\n$subTrace"));
        },
        loading: (){
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

class CartWidget extends ConsumerStatefulWidget {
  const CartWidget({super.key, required this.cartOrder,});
  final CartOrder cartOrder;

  @override
  ConsumerState<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends ConsumerState<CartWidget> {
  final List<ActionCard> _actionList = [];
  final ScrollController _scrollController = ScrollController();
  late OrderInfo _orderInfo;

  void _prepareActionList(){
    _actionList.clear();
    for (var action in widget.cartOrder.bList){
      _actionList.add(ActionCard(itemWrapper: action));
    }
    _orderInfo = OrderInfo(
      totalSum: widget.cartOrder.totalSum,
      currency: widget.cartOrder.currency,
      totalServiceCharge: widget.cartOrder.totalServiceCharge,
      aList: _actionList,);
  }

  @override
  Widget build(BuildContext context) {
    _prepareActionList();
    bool getTotalNumOfReservedTickets(){
      var totalTickets = 0;
      if (widget.cartOrder.bList
          .any((ciw)=>ciw.visitorBirthdateRequired || ciw.visitorDocRequired)){
        for (var e in _actionList){
          totalTickets += e.itemWrapper.itemList.length;
        }
        return totalTickets > 2;
      }
      if (_actionList.length < 3){
        for (var e in _actionList){
          totalTickets += e.itemWrapper.itemList.length;
        }
        return totalTickets > 5;
      } else {
        return true;
      }
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IntrinsicHeight(
            child: Wrap(
              //crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500,),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        //border:  Border.all(color: MaterialTheme.lightScheme().outlineVariant, width: 1.2),
                        borderRadius: BorderRadius.circular(20),),
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8,
                          children: [
                            Card.filled(
                              color: const Color(0xfff2f3f5),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(16.0, 8, 16,8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 5,
                                  children: [
                                    Icon(CupertinoIcons.time, color: MaterialTheme.lightScheme().onSurface, size: 28,),
                                    TimerCountdown(
                                      colonsTextStyle: customTextStyle(MaterialTheme.lightScheme().onSurface, 30, 'Regular'),
                                      timeTextStyle: customTextStyle(MaterialTheme.lightScheme().onSurface, 30, 'Regular'),
                                      spacerWidth: 5.0,
                                      enableDescriptions: false,
                                      format: CountDownTimerFormat.minutesSeconds,
                                      endTime: DateTime.now().add(Duration(seconds: widget.cartOrder.time,),),
                                      onEnd: () {
                                        ref.read(asyncCartProvider.notifier)
                                            .clearCart(ref.read(asyncUserProvider).value as User);
                                        Navigator.pop(context);},
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            DefaultSelectionStyle(
                              mouseCursor: SystemMouseCursors.basic,
                              child: SelectableRegion(
                                  selectionControls: materialTextSelectionControls,
                                  child: _orderInfo),
                            ),
                          ],
                        ),
                      )),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Stack(
                    children: [
                      DefaultSelectionStyle(
                        mouseCursor: SystemMouseCursors.basic,
                        child: SelectableRegion(
                          selectionControls: materialTextSelectionControls,
                          child: Container(
                            decoration: BoxDecoration(color: darken(const Color(0xfff2f3f5), 0.07),
                              borderRadius: BorderRadius.circular(20),),
                            margin: EdgeInsets.zero,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(minWidth: 500, maxHeight: 700),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                child: ScrollConfiguration(
                                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                                  child: SingleChildScrollView(
                                    controller: _scrollController,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: getTotalNumOfReservedTickets() ? 12 : 0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: _actionList,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (getTotalNumOfReservedTickets()) Positioned(
                          bottom: 8,
                          right: 8,
                          child: SizedBox(
                            height: 40, width: 40,
                            child: FloatingActionButton(
                                backgroundColor: MaterialTheme.lightScheme().tertiaryContainer,
                                child: Icon(Icons.arrow_downward_rounded, color: MaterialTheme.lightScheme().onTertiaryContainer,),
                                onPressed: (){
                                  _scrollController.animateTo(_scrollController.offset + 200,
                                      duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                                }),
                          )
                      ),
                      if (getTotalNumOfReservedTickets()) Positioned(
                          top: 8,
                          right: 8,
                          child: SizedBox(
                            height: 40, width: 40,
                            child: FloatingActionButton(
                                backgroundColor: MaterialTheme.lightScheme().tertiaryContainer,
                                child: Icon(Icons.arrow_upward_outlined, color: MaterialTheme.lightScheme().onTertiaryContainer,),
                                onPressed: (){
                                  _scrollController.animateTo(_scrollController.offset - 200,
                                      duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                                }),
                          )
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
          //Image(image: AssetImage('images/long_kassir_logo.jpg',), width: 400, height: 80, fit: BoxFit.cover,),
        ]
      ),
    );
  }
}

class MobileCartWidget extends StatefulWidget {
  const MobileCartWidget({super.key,  required this.cartOrder,});
  final CartOrder cartOrder;

  @override
  State<MobileCartWidget> createState() => _MobileCartWidgetState();
}

class _MobileCartWidgetState extends State<MobileCartWidget> with TickerProviderStateMixin{
  final List<ActionCard> _actionList = [];
  final ScrollController _scrollController = ScrollController();
  late OrderInfo _orderInfo;
  void _prepareActionList(){
    _actionList.clear();
    for (var action in widget.cartOrder.bList){
      _actionList.add(ActionCard(itemWrapper: action));
    }
    _orderInfo = OrderInfo(
      totalSum: widget.cartOrder.totalSum,
      currency: widget.cartOrder.currency,
      totalServiceCharge: widget.cartOrder.totalServiceCharge,
      aList: _actionList,);
  }

  @override
  Widget build(BuildContext context) {
    _prepareActionList();
    return Scaffold(
      backgroundColor: const Color(0xfff2f3f5),
      appBar: AppBar(
        shadowColor: Theme.of(context).colorScheme.shadow,
        backgroundColor: const Color(0xfff2f3f5),
        surfaceTintColor: MaterialTheme.lightScheme().surfaceContainerLowest,
        toolbarHeight: 80,
        centerTitle: true,
        titleSpacing: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 5,
          children: [
            Icon(CupertinoIcons.time, color: MaterialTheme.lightScheme().primary, size: 28,),
            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                return TimerCountdown(
                  colonsTextStyle: customTextStyle(MaterialTheme.lightScheme().primary, 30, 'Regular'),
                  timeTextStyle: customTextStyle(MaterialTheme.lightScheme().primary, 30, 'Regular'),
                  spacerWidth: 5.0,
                  enableDescriptions: false,
                  format: CountDownTimerFormat.minutesSeconds,
                  endTime: DateTime.now().add(Duration(seconds: widget.cartOrder.time,),),
                  onEnd: () {ref.read(asyncCartProvider.notifier)
                      .clearCart(ref.read(asyncUserProvider).value as User);},
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 8,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 1.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _orderInfo,
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.zero,
                  elevation: 1.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _actionList,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
