import 'package:flapp_widget/constants.dart';
import 'package:flapp_widget/styles/ui_styles.dart';
import 'package:flutter/material.dart';

import '../../../models/composited_category.dart';
import '../../../theme.dart';

class TariffChoicerNew extends StatefulWidget {
  const TariffChoicerNew({super.key, required this.tariffList, required this.selectedTariffId});
  final List<Tariff> tariffList;
  final ValueNotifier<int> selectedTariffId;
  @override
  State<TariffChoicerNew> createState() => _TariffChoicerNewState();
}

class _TariffChoicerNewState extends State<TariffChoicerNew> {
  String selectedTariff = '';
  List<MenuItemButton> tList = [];

  @override
  void initState() {
    // Устанавливаем первый выбранный тариф и его цену
    if (screenWidth < 900){
      selectedTariff = widget.tariffList.first.name;
    } else {
      selectedTariff = 'Тариф: ${widget.tariffList.first.name}';
    }
    // Заполняем данные других тарифов
    for (var tariff in widget.tariffList){
      tList.add(MenuItemButton(
        style: FilledButton.styleFrom(overlayColor: MaterialTheme.lightScheme().onSecondaryFixedVariant),
        child: Text(tariff.name,
          style: customTextStyle(MaterialTheme.lightScheme().onSurfaceVariant, screenWidth > 1100
              ? 20.0 : 16.0, 'Regular')),
        onPressed: (){
          selectedTariff = tariff.name;
          widget.selectedTariffId.value = tariff.id;
          setState(() {});
        },));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      style: MenuStyle(
       shadowColor: WidgetStateProperty.all(MaterialTheme.lightScheme().secondaryFixed),
      surfaceTintColor: WidgetStateProperty.all(MaterialTheme.lightScheme().surface),),
      menuChildren: tList,
      builder: (BuildContext context, MenuController controller, Widget? child) {
        return SizedBox(
          height: screenWidth > 900 ? 40 : null,
          width: screenWidth > 900 ? 300 : null,
          child: OutlinedButton(
            style:  customOutlinedRoundedBorderStyle(MaterialTheme.lightScheme().secondary),
                //: customRoundedBorderStyle(MaterialTheme.lightScheme().onSecondary),
            onPressed: () {
              if (controller.isOpen) {controller.close();}
              else {controller.open();}
            },
            child: Row(
              children: [
                Flexible(child: Center(
                  child: Text(selectedTariff, maxLines: 1,
                      textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,
                      style: customTextStyle(MaterialTheme.lightScheme().secondary,
                          screenWidth > 1100 ? 18.0 : 14, 'Regular')),
                )),
                Icon(Icons.arrow_drop_down_sharp,
                  color: MaterialTheme.lightScheme().secondary, size: 22.0,)
              ],
            ),
          ),
        );
      },
    );
  }
}