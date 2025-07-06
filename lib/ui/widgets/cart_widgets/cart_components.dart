import 'package:flapp_widget/ui/widgets/cart_widgets/promo_code_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wave_divider/wave_divider.dart';

import '../../../constants.dart';
import '../../../i18n/app_localizations.dart';
import '../../../models/cart_models/visitor_data.dart';
import '../../../theme.dart';
import '../../../models/cart_models/cart.dart';
import '../../../models/user.dart';
import '../../../styles/ui_styles.dart';
import '../../../view_models/cart_view_model.dart';
import '../../../view_models/user_view_model.dart';
import '../../screens/payment_screen.dart';

void launchAgreementURL() async =>
    await canLaunchUrl(Uri.parse(agreement)) ?
    await launchUrl(Uri.parse(agreement)) :
    throw 'Could not launch$agreement';

class OrderInfo extends ConsumerStatefulWidget {
  const OrderInfo({Key? key, required this.totalSum, required this.totalServiceCharge,
    required this.currency, required this.aList}) : super(key: key);
  final double totalServiceCharge;
  final double totalSum;
  final String currency;
  final List<ActionCard> aList;

  @override
  ConsumerState<OrderInfo> createState() => _OrderInfoState();
}

class _OrderInfoState extends ConsumerState<OrderInfo> {
  bool _isChecked = false;
  double _sum = 0;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    if (agreement == null){_isChecked = true;}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _sum = widget.totalSum + widget.totalServiceCharge;
    bool isDesktop = MediaQuery.of(context).size.width >= 1100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: <Widget>[
        //Раздел дополнительных полей ввода (фио, телефон, промо коды)
        _RequiredFields(
          fullName: widget.aList.any((element) => element.itemWrapper.fullNameRequired),
          phone: widget.aList.any((element) => element.itemWrapper.phoneRequired),
          nameController: _nameController, phoneController: _phoneController,),
        //Promo codes
        if (promo == "on") Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            spacing: 16,
            children: [
              Text(AppLocalizations.of(context)!.promoHintLabel, textAlign: TextAlign.justify,
                style: customTextStyle(MaterialTheme.lightScheme().onSurfaceVariant,
                    13, 'Regular'),),
              const PromoCodeForm(),
            ],
          ),
        ),
        Column(
          children: [
            //Сервисный сбор
            Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget> [
                Text('${AppLocalizations.of(context)!.serviceCharge}: ',
                  style: customTextStyle(null, 18.0, 'Light'),
                ),
                Text('${widget.totalServiceCharge} ${widget.currency}',
                  style: customTextStyle(null, 20.0, 'Regular'),)
              ],
            ),
            //Цена
            Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget> [
                Text('${AppLocalizations.of(context)!.totalSum}: ',
                  style: customTextStyle(null, 18.0, 'Light'),),
                Text('$_sum ${widget.currency}', style: customTextStyle(Colors.green, 20.0, 'Regular'))
              ],
            ),
          ],
        ),
        WaveDivider(color: MaterialTheme.lightScheme().tertiary, thickness: 1,),
        //Раздел с соглашением
        if (agreement != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 5,
            children: <Widget> [
              Checkbox(
                side: BorderSide(color: MaterialTheme.lightScheme().onSurfaceVariant, width: 1.5),
                activeColor: MaterialTheme.lightScheme().primary,
                checkColor: Colors.white,
                onChanged:(bool? value) {
                  setState(() {_isChecked = value!;});
                }, value: _isChecked,
              ),
              Expanded(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                      onTap:(){launchUrl(Uri.parse(agreement), webOnlyWindowName: '_blank');},
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            text: AppLocalizations.of(context)!.agreementStart,
                            style: agreementTextStyle(MaterialTheme.lightScheme().onSurfaceVariant, 16, 'Regular',),
                            children: [
                              TextSpan(text: AppLocalizations.of(context)!.agreementEnd,
                                style: agreementTextStyle(Colors.lightBlue, 16, 'Light',)
                                    .copyWith(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),)
                            ]
                        ),
                      )),
                ),
              ),
            ],
          ),
        //Кнопки покупки и отмены
        Row(
          children: <Widget>[
            if (screenWidth > 900) const Spacer(),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: [
                  SizedBox(
                      height: 45.0,
                      child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            User? user = ref.read(asyncUserProvider).value;
                            ref.read(asyncCartProvider.notifier).deleteAllSeats(0, user!, context);
                          },
                          icon: Icon(CupertinoIcons.delete_simple, size: 40,
                            color: MaterialTheme.lightScheme().onSurfaceVariant,)//Text(AppLocalizations.of(context)!.clearAllButton, style: customTextStyle(Colors.white, isDesktop ? 20.0 : 18.0, 'Regular'),),
                      )
                  ),
                  Expanded(
                    child: SizedBox(
                        height: 45.0,
                        child: FilledButton(style: payStyle(),
                          onPressed: _isChecked ? () async {
                            await startPayment(context);
                          } : null,
                          child: Text(AppLocalizations.of(context)!.payButton,
                            style: customTextStyle(Colors.white, isDesktop ? 24.0 : 22.0, 'Regular'),),
                        )
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],);
  }

  Future<void> startPayment(BuildContext context) async {
    final vdList = ref.read(asyncCartProvider.select((cvm)=>cvm.value?.vdList));
    final cart = ref.read(asyncCartProvider).value?.numberOfTickets;
    final cvm = ref.read(asyncCartProvider).value;

    if (vdList is List || cvm!.bList.any((ciw)=>ciw.visitorBirthdateRequired || ciw.visitorDocRequired)){
      if (vdList is List && vdList!.length == cart){
        payment(context, vdList);
      } else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => UserDialog(userMessage:
          AppLocalizations.of(context)!.vdHint, redirectFlag: false),
        );
      }
    } else {payment(context, null);}
  }

  Future<void> payment(BuildContext context, List<VisitorData>? vdList) async {
    final user = ref.read(asyncUserProvider).value!;
    final opener = await Navigator.push(context,
      MaterialPageRoute(builder: (context) =>
          PaymentScreen([_nameController.text, _phoneController.text, vdList])),);
    if (opener is String){
      if (context.mounted){
        showDialog<String>(
          context: context,
          builder: (BuildContext context) =>
              UserDialog(userMessage: opener, redirectFlag: false),
        );
      }
    }
    ref.read(asyncCartProvider.notifier).clearCart(user);
  }
}

class ActionCard extends StatelessWidget {
  const ActionCard({super.key, required this.itemWrapper});
  final CartItemWrapper itemWrapper;

  @override
  Widget build(BuildContext context) {
    return screenWidth > 900
        ? DesktopActionCard(itemWrapper: itemWrapper)
        : MobileActionCard(itemWrapper: itemWrapper);
  }
}

class DesktopActionCard extends StatelessWidget {
  const DesktopActionCard({super.key, required this.itemWrapper});
  final CartItemWrapper itemWrapper;

  @override
  Widget build(BuildContext context) {
    List<_TicketTile> getItemList(){
      List<_TicketTile> resultList = [];
      for (var item in itemWrapper.itemList){
        resultList.add(_TicketTile([itemWrapper.visitorDocRequired,
          itemWrapper.visitorBirthdateRequired], item: item,)); //doc, bd
      }
      return resultList;
    }
    return getItemList().isNotEmpty ? Container(
      decoration: BoxDecoration(
        color: darken(const Color(0xfff2f3f5), 0.07),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 16,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 5,
                  children: [
                    Flexible(
                      child: Text(
                        itemWrapper.actionName,
                        textAlign: TextAlign.justify,
                        style: customTextStyle(MaterialTheme.lightScheme().onSurface, 18.0, 'Regular'),
                      ),
                    ),
                    Row(
                      spacing: 5,
                      children: [
                        Icon(Icons.location_on_outlined, size: 18,
                            color: MaterialTheme.lightScheme().onSurfaceVariant),
                        Flexible(
                          child: Text(
                            itemWrapper.venueName,
                            textAlign: TextAlign.justify,
                            style: customTextStyle(MaterialTheme.lightScheme().onSurface, 16.0, 'Light'),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ] + getItemList(),
            ),
          ),
        ],
      ),
    ) : const SizedBox.shrink();
  }
}

class MobileActionCard extends StatelessWidget {
  const MobileActionCard({super.key, required this.itemWrapper});
  final CartItemWrapper itemWrapper;

  @override
  Widget build(BuildContext context) {
    List<_TicketTile> getItemList(){
      List<_TicketTile> resultList = [];
      for (var item in itemWrapper.itemList){
        resultList.add(_TicketTile([itemWrapper.visitorDocRequired,
          itemWrapper.visitorBirthdateRequired], item: item));
      }
      return resultList;
    }
    return getItemList().isNotEmpty ? Container(
      decoration: BoxDecoration(color: darken(const Color(0xfff2f3f5), 0.07),),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start ,
            children: <Widget>[
              const SizedBox.shrink(),
              Text(
                itemWrapper.actionName,
                textAlign: TextAlign.justify,
                style: customTextStyle(MaterialTheme.lightScheme().onSurface, 18.0, 'Regular'),
              ),
              Row(
                spacing: 3,
                children: [
                  Icon(Icons.location_on_outlined, size: 16, color: MaterialTheme.lightScheme().onSurfaceVariant),
                  Flexible(
                      child: Text(itemWrapper.venueName, textAlign: TextAlign.justify,
                        style: customTextStyle(MaterialTheme.lightScheme().onSurface, 16.0, 'Light'),)
                  ),
                ],
              ),] + getItemList()
        ),
      ),
    ) : const SizedBox.shrink();
  }
}

class _TicketTile extends ConsumerStatefulWidget {
  const _TicketTile(this.vdRequired, {Key? key,  required this.item}) : super(key: key);
  final CartItem item;
  final List<bool>? vdRequired;

  @override
  ConsumerState<_TicketTile> createState() => _TicketTileState();
}

class _TicketTileState extends ConsumerState<_TicketTile> {
  bool isGeneralAdmission(CartItem item){
    if ((item.sector != null) || (item.row != null) || (item.number != null)){
      return false;
    }
    else if ((item.sector == null) || (item.row == null) || (item.number == null)){
      return true;
    }
    else {return false;}
  }
  bool _showVDFields = false;

  @override
  Widget build(BuildContext context) {
    final vdList = ref.read(asyncCartProvider.select((cvm)=>cvm.value!.vdList));
    return Stack(
      children: [
        Card.filled(
            color: Colors.white,
            elevation: 0.0,
            margin: EdgeInsets.zero,
            surfaceTintColor: Colors.white,
            child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  spacing: 15,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    //название категории или места
                    if (!isGeneralAdmission(widget.item))
                      Text('${widget.item.sector} - ${AppLocalizations.of(context)!.row}: '
                          '${widget.item.row} - ''${AppLocalizations.of(context)!.number}: '
                          '${widget.item.number}',
                        style: customTextStyle(null, 16.0, 'Regular'),)
                    else Text(widget.item.categoryPriceName, style: customTextStyle(null, 16.0, 'Regular'),),
                    //тариф и причины скидки
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (widget.item.tariffName != null)
                          Text(AppLocalizations.of(context)!.tariff +
                              widget.item.tariffName!,
                              style: customTextStyle(MaterialTheme.lightScheme().tertiary, 16.0, 'Regular'),
                              textAlign: TextAlign.left),
                        widget.item.discountReason
                            != null ? Flexible(
                          child: Text('${widget.item.discountReason}', style:
                          customTextStyle(MaterialTheme.lightScheme().primary, 16.0, 'Regular'),),
                        ) : const SizedBox.shrink(),
                      ],
                    ),
                    //дата и стоимость
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (!date.toString().contains('off'))
                            Row(
                              spacing: 5,
                              children: [
                                Icon(CupertinoIcons.calendar, size: 16,
                                    color: MaterialTheme.lightScheme().onSurfaceVariant),
                                Text('${widget.item.day} ${widget.item.time}',
                                  style: customTextStyle(null, 16.0, 'Regular'),),
                              ],
                            ),
                          Text('${AppLocalizations.of(context)!.priceLabel}: ${widget.item.price} ${widget.item.currency}' ,
                            style: customTextStyle(null, 16.0, 'Light').copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,),
                        ],
                      ),
                    ),
                    if (widget.vdRequired!.any((element)=>element == true))
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 5,
                        children: [
                          SizedBox(
                              height: 30,
                              child: FloatingActionButton.extended(
                                extendedIconLabelSpacing: 0,
                                backgroundColor: MaterialTheme.lightScheme().tertiary,
                                onPressed: (){
                                  _showVDFields = !_showVDFields;
                                  setState(() {});
                                }, label: Center(
                                child: Row(
                                  children: [
                                    Text( AppLocalizations.of(context)!.vdButtonLabel,
                                      style: customTextStyle(MaterialTheme.lightScheme().onTertiary, 16, 'Regular'),),
                                    Icon(Icons.arrow_drop_down, size: 20,
                                      color: MaterialTheme.lightScheme().onTertiary,),
                                  ],
                                ),
                              ),)),
                          if ((vdList ?? []).any((element)=>element.seatId == widget.item.seatId))
                            const Icon(CupertinoIcons.doc_checkmark_fill, color: Colors.green, size: 18,)
                        ],
                      ),
                    if (_showVDFields)
                      _VisitorDataFields(vdList: widget.vdRequired!,
                        seatId: widget.item.seatId,
                        callback: (){_showVDFields = false;setState(() {});},)
                  ],
                )
            )
        ),
        Positioned(top:0, right: 0,child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(CupertinoIcons.delete_simple, size: 20,
              color: MaterialTheme.lightScheme().onSurfaceVariant,),
            onPressed: () {
              User? user = ref.read(asyncUserProvider).value;
              ref.read(asyncCartProvider.notifier).deleteSeat(widget.item.seatId,
                  widget.item.categoryPriceId, user!, context);
              //setState(() {});
            }
        ),),
      ],
    );
  }
}

class _RequiredFields extends StatefulWidget {
  const _RequiredFields({Key? key, required this.fullName, required this.phone,
    required this.nameController, required this.phoneController}) : super(key: key);
  final bool fullName;
  final bool phone;
  final TextEditingController nameController;
  final TextEditingController phoneController;

  @override
  State<_RequiredFields> createState() => _RequiredFieldsState();
}

class _RequiredFieldsState extends State<_RequiredFields> {
  @override
  void dispose() {
    widget.nameController.dispose();
    widget.phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        widget.fullName
            ? TextFormField(
          decoration: underlineField(context, AppLocalizations.of(context)!.initialsLabel),
          keyboardType: TextInputType.text,
          controller: widget.nameController,)
            : const SizedBox.shrink(),
        widget.phone
            ? TextFormField(
          decoration: underlineField(context, AppLocalizations.of(context)!.phoneLabel),
          controller: widget.phoneController,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,\\+]+')),],)
            : const SizedBox.shrink(),
      ],
    );
  }
}

class _VisitorDataFields extends ConsumerStatefulWidget {
  const _VisitorDataFields({super.key, required this.vdList, required this.seatId, required this.callback});
  final List<bool> vdList;
  final int seatId;
  final VoidCallback callback;

  @override
  ConsumerState<_VisitorDataFields> createState() => _VisitorDataFieldsState();
}

class _VisitorDataFieldsState extends ConsumerState<_VisitorDataFields> {
  Map<int, String> _selectedDocument = {};
  late VisitorData _vd;
  VisitorData? tempVd;
  final ScrollController _sc = ScrollController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _bdController = TextEditingController();
  final TextEditingController _seriesController = TextEditingController();
  final TextEditingController _documentNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.vdList.first) {_selectedDocument = {1: 'Паспорт РФ'};}
    final vdList = ref.read(asyncCartProvider.select((cvm)=>cvm.value!.vdList));
    fillVisitorData(vdList);
  }

  @override
  Widget build(BuildContext context) {
    final vdList = ref.read(asyncCartProvider.select((cvm)=>cvm.value!.vdList));
    return Card(
      color: Colors.grey.shade50,
      child: Padding(
        padding: EdgeInsets.all(screenWidth > 700 ? 16.0 : 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            screenWidth > 700 ? Row(
              spacing: 5,
              children: [
                Expanded(
                  child: TextField(
                    onEditingComplete: (){
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    controller: _surnameController,
                    cursorColor: MaterialTheme.lightScheme().onSurfaceVariant,
                    decoration: underlinedField(context, AppLocalizations.of(context)!.surnameLabel, 14, Colors.grey.shade50),
                  ),
                ),
                Expanded(
                  child: TextField(
                    onEditingComplete: (){
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    controller: _nameController,
                    cursorColor: MaterialTheme.lightScheme().onSurfaceVariant,
                    decoration: underlinedField(context, AppLocalizations.of(context)!.nameLabel, 14, Colors.grey.shade50),
                  ),
                ),
                Expanded(
                  child: TextField(
                    onEditingComplete: (){
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    controller: _middleNameController,
                    cursorColor: MaterialTheme.lightScheme().onSurfaceVariant,
                    decoration: underlinedField(context, AppLocalizations.of(context)!.middleNameLabel, 14, Colors.grey.shade50),
                  ),
                ),
              ],
            )
                : Wrap(
              spacing: 5,
              children: [
                TextField(
                  onEditingComplete: (){
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  controller: _surnameController,
                  cursorColor: MaterialTheme.lightScheme().onSurfaceVariant,
                  decoration: underlinedField(context, AppLocalizations.of(context)!.surnameLabel, 14, Colors.grey.shade50),
                ),
                TextField(
                  onEditingComplete: (){
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  controller: _nameController,
                  cursorColor: MaterialTheme.lightScheme().onSurfaceVariant,
                  decoration: underlinedField(context, AppLocalizations.of(context)!.nameLabel, 14, Colors.grey.shade50),
                ),
                TextField(
                  onEditingComplete: (){
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  controller: _middleNameController,
                  cursorColor: MaterialTheme.lightScheme().onSurfaceVariant,
                  decoration: underlinedField(context, AppLocalizations.of(context)!.middleNameLabel, 14, Colors.grey.shade50),
                ),
              ],
            ),
            if (widget.vdList.last)
              Column(
                spacing: 8,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onEditingComplete: (){
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    controller: _bdController,
                    cursorColor: MaterialTheme.lightScheme().onSurfaceVariant,
                    decoration: underlinedField(context, AppLocalizations.of(context)!.birthLabel, 14, Colors.grey.shade50),
                  )
                ],
              ),
            if (widget.vdList.first)
              Column(
                spacing: 8,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      spacing: 5,
                      children: [
                        Flexible(
                          child: MenuAnchor(
                            crossAxisUnconstrained: false,
                            menuChildren: [
                              ConstrainedBox(constraints: const BoxConstraints(maxHeight: 300),
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  controller: _sc,
                                  child: SingleChildScrollView(
                                    controller: _sc,
                                    child: Column(
                                      spacing: 3,
                                      children: List<Widget>.generate(
                                          documentTypeMap.values.length,
                                              (int index) {
                                            return SizedBox(
                                              width: 300,
                                              child: MenuItemButton(
                                                onPressed: (){
                                                  _selectedDocument = Map.fromEntries([documentTypeMap.entries.toList()[index]]);
                                                  _documentNumberController.text = '';
                                                  _seriesController.text = '';
                                                  setState((){});
                                                },
                                                child: Text(documentTypeMap.values.toList()[index],
                                                    style: customTextStyle(MaterialTheme.lightScheme().onSurfaceVariant, screenWidth > 1100
                                                        ? 14.0 : 12.0, 'Regular')),
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                ),)
                            ],
                            builder: (BuildContext context, MenuController controller, Widget? child) {
                              return FilledButton(
                                style: customOutlinedRoundedBorderStyle(MaterialTheme.lightScheme().secondary),
                                onPressed: () {
                                  if (controller.isOpen) {controller.close();}
                                  else {controller.open();}
                                },
                                child: Row(
                                  children: [
                                    Flexible(child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(_selectedDocument.values.first, maxLines: 1,
                                            textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,
                                            style: customTextStyle(MaterialTheme.lightScheme().secondary,
                                                13, 'Regular')),
                                      ),
                                    )),
                                    Icon(Icons.arrow_drop_down_sharp,
                                      color: MaterialTheme.lightScheme().secondary, size: 18.0,)
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        if (documentSerialNumberRequiredMap[_selectedDocument.keys.first] == true) Expanded(
                          child: TextField(
                            onEditingComplete: (){
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                            controller: _seriesController,
                            cursorColor: MaterialTheme.lightScheme().onSurfaceVariant,
                            decoration: underlinedField(context,  AppLocalizations.of(context)!.serialLabel, 14, Colors.grey.shade50),
                          ),
                        )
                      ],
                    ),
                  ),
                  TextField(
                    onEditingComplete: (){
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    controller: _documentNumberController,
                    cursorColor: MaterialTheme.lightScheme().onSurfaceVariant,
                    decoration: underlinedField(context,  AppLocalizations.of(context)!.numberLabel, 14, Colors.grey.shade50),
                  )
                ],
              ),
            const SizedBox.shrink(),
            Align(
                alignment: Alignment.centerRight,
                child: Row(
                  spacing: 8,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if ((vdList ?? []).any((element)=>element.seatId == widget.seatId))
                      FilledButton(
                          onPressed: (){
                            ref.read(asyncCartProvider.notifier).clearVisitorData(widget.seatId);
                            widget.callback();
                          },
                          style: roundedBorderStyle(),
                          child: const Icon(CupertinoIcons.delete, color: Colors.white, size: 20,)),
                    FilledButton(
                        onPressed: (){
                          saveVisitorData(ref);
                          widget.callback();},
                        style: roundedBorderStyle(),
                        child: Text('OK',
                          style: customTextStyle(Colors.white, 14, 'Regular'),)),
                  ],
                )
            )
          ],
        ),
      ),
    );
  }

  void fillVisitorData(List<VisitorData>? vdList) {
    if (vdList is List && vdList!.any((element)=> element.seatId == widget.seatId)){
      tempVd = vdList[vdList.indexWhere((element)=> element.seatId == widget.seatId)];
      _nameController.text = tempVd!.name ?? '';
      _surnameController.text = tempVd!.surname ?? '';
      _middleNameController.text = tempVd!.middleName ?? '';

      if (tempVd?.birthdate is String){
        _bdController.text = tempVd!.birthdate!;
      }
      if (tempVd?.documentSeries is String){
        _seriesController.text = tempVd!.documentSeries!;
      }
      if (tempVd?.documentType is int){
        _selectedDocument = Map
            .fromEntries([documentTypeMap.entries.toList()[tempVd!.documentType!-1]]);
      }
      if (tempVd?.documentNumber is String){
        _documentNumberController.text = tempVd!.documentNumber!;
      }
    }
  }

  void saveVisitorData(WidgetRef ref){
    final String name = _nameController.text.trim();
    final String surname = _surnameController.text.trim();
    final String middleName = _middleNameController.text.trim();
    final String series = _seriesController.text.trim();
    final String number = _documentNumberController.text.trim();
    final String bd = _bdController.text.trim();

    _vd = VisitorData(
        seatId: widget.seatId,
        name: name,
        surname: surname,
        middleName: middleName,
        birthdate: bd,
        documentType: _selectedDocument.isNotEmpty ? _selectedDocument.keys.first : null,
        documentSeries: series,
        documentNumber: number);

    // print(jsonEncode(_vd.toJson()..removeWhere((key, value) => value == '' || value == null)));

    if (name != '' && surname != ''){
      if (widget.vdList.every((element)=>element)){
        if (bd !='' && (_selectedDocument.isNotEmpty && number !='')){
          ref.read(asyncCartProvider.notifier).addVisitorData(_vd);
        }
        return;
      }

      if (widget.vdList.first){
        if (_selectedDocument.isNotEmpty && number !=''){
          ref.read(asyncCartProvider.notifier).addVisitorData(_vd);
        }
      }

      if (widget.vdList.last){
        if (bd !=''){
          ref.read(asyncCartProvider.notifier).addVisitorData(_vd);
        }
      }
    }
    _nameController.clear();
    _surnameController.clear();
    _middleNameController.clear();
    _seriesController.clear();
    _documentNumberController.clear();
    _bdController.clear();
  }
}
