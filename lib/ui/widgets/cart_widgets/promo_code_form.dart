import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../i18n/app_localizations.dart';
import '../../../theme.dart';
import '../../../services/api_client.dart';
import '../../../services/user_repository.dart';
import '../../../styles/ui_styles.dart';
import '../../../view_models/cart_view_model.dart';
import '../dry_intrinsic_height.dart';

var uuid = const Uuid();

class PromoCodeController{
  final String controllerId;
  final TextEditingController controller;

  const PromoCodeController({required this.controller, required this.controllerId,});
}

class PromoCodeInputObj {
  final String inputId;
  final PromoCodeInputWidget promoCodeInputWidget;

  const PromoCodeInputObj({required this.inputId, required this.promoCodeInputWidget,});
}

class PromoCodeInputWidget extends StatefulWidget {
  const PromoCodeInputWidget({Key? key, required this.controller,
    required this.removePromoField, required this.index,}) : super(key: key);
  final String index;
  final TextEditingController controller;
  final void Function(String) removePromoField;

  @override
  State<PromoCodeInputWidget> createState() => PromoCodeInputWidgetState();
}

class PromoCodeInputWidgetState extends State<PromoCodeInputWidget> {
  @override
  Widget build(BuildContext context) {
    return DryIntrinsicWidth(
      child: SizedBox(
        height: 35.0,
        width: 150,
        child: TextFormField(
          controller: widget.controller,
          decoration: promoOutlinedField(context,
            AppLocalizations.of(context)!.promoLabel, 14,
              widget.removePromoField, widget.index,),),)
    );
  }
}

class _AddPromoCodeButton extends StatefulWidget {
  const _AddPromoCodeButton({Key? key, required this.callback}) : super(key: key);
  final VoidCallback callback;

  @override
  State<_AddPromoCodeButton> createState() => _AddPromoCodeButtonState();
}

class _AddPromoCodeButtonState extends State<_AddPromoCodeButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.0,
      width: 30.0,
      child: IconButton(onPressed: widget.callback,
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(backgroundColor: Colors.white,),
        icon: Icon(Icons.add, color: MaterialTheme.lightScheme().primary,),
      ),
    );
  }
}

class _ApplyButton extends ConsumerStatefulWidget {
  const _ApplyButton({Key? key, required this.promoList,
    required this.callback}) : super(key: key);
  final List<TextEditingController> promoList;
  final VoidCallback callback;

  @override
  ConsumerState<_ApplyButton> createState() => _ApplyButtonState();
}

class _ApplyButtonState extends ConsumerState<_ApplyButton> {
  dynamic promoCodeResponse = '';
  Color getResponseColor()=> Colors.black54;

  _getPromoCodeResponseText(List<dynamic> result){
    switch (result.first.toString()){
      case '1':
        return '${result.last} ${AppLocalizations.of(context)!.successPromoCodeMessage}';
      case '11':
        return '${result.last} ${AppLocalizations.of(context)!.successPromoCodesMessage}';
      case '-1':
        return '${result.last} ${AppLocalizations.of(context)!.failPromoCodeMessage}';
      case '-11':
        return '${result.last} ${AppLocalizations.of(context)!.failPromoCodesMessage}';
      case '2':
        return '${result.last} ${AppLocalizations.of(context)!.existPromoCodeMessage}';
      case '22':
        return '${result.last.toString()} ${AppLocalizations.of(context)!.existPromoCodesMessage}';
      default:
        return result.first;
    }
  }

  _applyPromoCodes() async{
    var user = await UserRepository().loadValue();
    List<String> promoCodes = widget.promoList.map((element)=>element.text).toList();
    promoCodes.removeWhere((element)=>element=="");
    await CartAPI.addPromoCodes(user, promoCodes).then((result){
      promoCodeResponse = _getPromoCodeResponseText(result);
      Timer(const Duration(seconds: 5), () {promoCodeResponse=""; setState(() {});});
      ref.read(asyncCartProvider.notifier).updateCart(user);
    });
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 35.0,
          child: FilledButton(onPressed: (){_applyPromoCodes();},
              style: customRoundedBorderStyle(MaterialTheme.lightScheme().primary),
              child: Text(AppLocalizations.of(context)!.applyPromoCode, style:
              customTextStyle(Colors.white, 16, 'Regular'))),
        ),
        const SizedBox(width: 15.0,),
        Flexible(
          child: SizedBox(
              width: 300,
              child: Text(promoCodeResponse,
                style: customTextStyle(getResponseColor(), 16, 'Regular'),)),
        )
      ],
    );
  }
}

class PromoCodeForm extends StatefulWidget {
  const PromoCodeForm({super.key});

  @override
  State<PromoCodeForm> createState() => _PromoCodeFormState();
}

class _PromoCodeFormState extends State<PromoCodeForm> {
  List<Widget> wrapChildren = [];
  final List<PromoCodeInputObj> promoCodeInputList = [];
  final List<PromoCodeController> promoControllerList = [];
  late String currentIndex;

  _initializePromoCodeForm(){
    currentIndex = uuid.v4();
    promoControllerList.add(PromoCodeController(
        controller: TextEditingController(), controllerId: currentIndex));
    promoCodeInputList.add(PromoCodeInputObj(inputId: currentIndex,
        promoCodeInputWidget: PromoCodeInputWidget(
          index: currentIndex, controller: promoControllerList
            .firstWhere((element)=> element.controllerId == currentIndex).controller,
          removePromoField: _removePromoField,)));
    wrapChildren.addAll(promoCodeInputList.map((e) => e.promoCodeInputWidget).toList());
    currentIndex = uuid.v4();
  }

  _addPromoField() {
    if (promoControllerList.length < 10) {
      wrapChildren.clear();
      promoControllerList.add(PromoCodeController(
          controller: TextEditingController(), controllerId: currentIndex));
      promoCodeInputList.add(PromoCodeInputObj(inputId: currentIndex,
          promoCodeInputWidget: PromoCodeInputWidget(
            index: currentIndex, controller: promoControllerList
              .firstWhere((element)=> element.controllerId == currentIndex).controller,
            removePromoField: _removePromoField,)));

      wrapChildren.addAll(promoCodeInputList.map((e) => e.promoCodeInputWidget).toList());
      currentIndex = uuid.v4();
      setState(() {});
    }
  }

  _removePromoField(String index) {
    promoControllerList.firstWhere((element)=>element.controllerId == index).controller.dispose();
    promoControllerList.removeWhere((element)=>element.controllerId == index);
    promoCodeInputList.removeWhere((element)=>element.inputId == index);
    wrapChildren.clear();
    wrapChildren.addAll(promoCodeInputList.map((e) => e.promoCodeInputWidget).toList());
    currentIndex = uuid.v4();
    setState(() {});
  }

  _clearPromoCodes(){
    for (var element in promoControllerList){
      element.controller.dispose();
    }
    promoControllerList.clear();
    promoCodeInputList.clear();
    wrapChildren.clear();
    _initializePromoCodeForm();
    setState(() {});
  }

  @override
  void initState() {
    _initializePromoCodeForm();
    super.initState();
  }

  @override
  void dispose() {
    for (var element in promoControllerList){
      element.controller.dispose();
    }
    promoControllerList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Wrap(
            runSpacing: 10.0,
            spacing: 5.0,
            children: wrapChildren + [_AddPromoCodeButton(callback: _addPromoField,)]
        ),
        Align(alignment: Alignment.topLeft,
            child: _ApplyButton(
              callback: _clearPromoCodes,
              promoList: promoControllerList.map((e) => e.controller).toList(),)),
      ],
    );
  }
}