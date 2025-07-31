import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flapp_widget/constants.dart';
import 'package:flapp_widget/models/composited_category.dart';
import 'package:flapp_widget/styles/ui_styles.dart';
import 'package:flapp_widget/ui/widgets/ga_widgets/tariff_menu.dart';
import 'package:flapp_widget/view_models/ga_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../i18n/app_localizations.dart';
import '../../../models/user.dart';
import '../../../theme.dart';
import '../../../view_models/user_view_model.dart';

void increaseCategoryHelper(WidgetRef ref, BuildContext context,
    int categoryPriceId, Tariff? tariff){
  //print(categoryPriceId);
  //print(tariff);
  final user = ref.read(asyncUserProvider).value;
  if (user?.state == UserStates.authorized){
    if (tariff == null){
      ref.read(categoriesProvider.notifier).increaseCategory(categoryPriceId, null);
    }
    if (tariff is Tariff){
      ref.read(categoriesProvider.notifier).increaseCategory(categoryPriceId, tariff);
    }
  } else {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) =>
          UserDialog(userMessage: AppLocalizations.of(context)!.emailMessage2,
              redirectFlag: screenWidth < 1100 ? true : false),);
  }
}

void decreaseCategoryHelper(WidgetRef ref, BuildContext context,
    int categoryPriceId, Tariff? tariff){
  final user = ref.read(asyncUserProvider).value;
  if (user?.state == UserStates.authorized){
    if (tariff == null){
      ref.read(categoriesProvider.notifier).decreaseCategory(categoryPriceId, null);
    }
    if (tariff is Tariff){
      ref.read(categoriesProvider.notifier).decreaseCategory(categoryPriceId, tariff);
    }
  } else {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) =>
          UserDialog(userMessage: AppLocalizations.of(context)!.emailMessage2,
              redirectFlag: screenWidth < 1100 ? true : false),);
  }
}

class CategoryCard extends ConsumerWidget {
  const CategoryCard({super.key, required this.category, required this.currency,
    required this.actionEventId});
  final CompositedCategory category;
  final String currency;
  final int actionEventId;

  @override
  Widget build(BuildContext context, ref) {
    ref.watch(categoriesProvider);
    return MediaQuery.of(context).size.width >= 700
        ? DesktopCategoryCard(category: category, currency: currency, actionEventId: actionEventId,)
        : MobileCategoryCard(category: category, currency: currency,);
  }
}

class DesktopCategoryCard extends ConsumerStatefulWidget {
  const DesktopCategoryCard({super.key, required this.category, required this.currency,
  required this.actionEventId});
  final CompositedCategory category;
  final String currency;
  final int actionEventId;

  @override
  ConsumerState<DesktopCategoryCard> createState() => _DesktopCategoryState();
}

class _DesktopCategoryState extends ConsumerState<DesktopCategoryCard> {
  late ValueNotifier<int> selectedTariffId;

  @override
  void initState() {
    if (widget.category is CompositedTariffCategory){
      int initialId = (widget.category as CompositedTariffCategory).tariffsSelection.keys.first.id;
      selectedTariffId = ValueNotifier(initialId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String cName = widget.category.categoryPriceName!;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 110.0,),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 4,
              child: Card.filled(
                  elevation: 0.0,
                  margin: const EdgeInsets.all(0),
                  color: Colors.white,
                  child: Padding(padding: const EdgeInsets.all(16.0),
                    child: Row(
                      spacing: 15,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: DefaultSelectionStyle(
                            mouseCursor: SystemMouseCursors.basic,
                            child: SelectableRegion(
                              selectionControls: materialTextSelectionControls,
                              child: Column(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    child: Text(cName,
                                      overflow: TextOverflow.fade, textAlign: TextAlign.left,
                                      style: customTextStyle(MaterialTheme.lightScheme().onSurface,
                                          18, 'Regular'),),
                                  ),
                                  // Меню тарифов
                                  if(widget.category is CompositedTariffCategory)
                                    TariffChoicerNew(
                                      tariffList:(widget.category as CompositedTariffCategory)
                                          .tariffsSelection.keys.toList(),
                                      selectedTariffId: selectedTariffId,),
                                  //Количество доступных билетов
                                  available == "off" ? const SizedBox.shrink() :
                                  Flexible(
                                    child: Text(AppLocalizations.of(context)!.availability
                                        + widget.category.available().toString(),
                                        style: customTextStyle(MaterialTheme
                                            .lightScheme().onSurface, 18, 'Light')),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        //Цена либо категории либо выбранного тарифа
                        widget.category is CompositedTariffCategory
                            ? ValueListenableBuilder(
                            valueListenable: selectedTariffId,
                            builder: (BuildContext context, int value, Widget? child) {
                              return Text('${(widget.category as CompositedTariffCategory)
                                  .tariffsSelection.keys.firstWhere((t)=>t.id == value).price}'
                                  ' ${widget.currency}',
                                style: customTextStyle(MaterialTheme.lightScheme()
                                    .onSurface, 22, 'Regular'),);})
                            : Text('${widget.category.price} ${widget.currency}',
                          style: customTextStyle(MaterialTheme.lightScheme()
                              .onSurface, 22, 'Regular'),),
                      ],
                    ),
                  )
              ),
            ),
            SizedBox(
              height: 1.0,
              child: DottedLine(
                lineLength: 100.0,//double.infinity,
                dashLength: 6,
                dashGapLength: 5,
                lineThickness: 1.3,
                dashGapColor:  MaterialTheme.lightScheme().surface,//Colors.white,
                direction: Axis.vertical,
                dashColor: Colors.grey,),
            ),
            Flexible(
              child: Card.filled(
                  elevation: 0.0,
                  margin: const EdgeInsets.all(0),
                  color: Colors.white,
                  child: //Зона выбора категорий
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        //Уменьшить количество билетов категории
                        Container(
                          height: 30.0,
                          width: 30.0,
                          decoration: BoxDecoration(
                            color: darken(const Color(0xfff2f3f5)),
                            borderRadius: BorderRadius.circular(20),),
                          child: IconButton(
                              iconSize: 20,
                              padding: EdgeInsets.zero,
                              onPressed: (){
                            if(widget.category is CompositedTariffCategory){
                              final tariff = (widget.category as CompositedTariffCategory)
                                  .tariffsSelection.keys.firstWhere((t)=>t.id == selectedTariffId.value);
                              decreaseCategoryHelper(ref, context, widget.category.categoryPriceId!, tariff);
                            } else {
                              decreaseCategoryHelper(ref, context, widget.category.categoryPriceId!, null);
                            }
                          }, icon: Icon(Icons.remove,
                              color: darken(Color(0xfff2f3f5), 0.5))),
                        ),
                        //Выбранное количество билетов категории или ее тарифа
                        widget.category is CompositedTariffCategory
                            ? ValueListenableBuilder(
                            valueListenable: selectedTariffId,
                            builder: (BuildContext context, int value, Widget? child) {
                              final tariff = (widget.category as CompositedTariffCategory)
                                  .tariffsSelection.keys.firstWhere((t)=>t.id == value);
                              return Text((widget.category as CompositedTariffCategory) //(cvm[widget.actionEventId]!.firstWhere((c)=>c.categoryPriceId == widget.category.categoryPriceId) as CompositedTariffCategory)
                                  .tariffsSelection[tariff]!.toString(),
                                style: customTextStyle(MaterialTheme.lightScheme().onSurface,
                                    24, 'Light'),);
                            }
                        )
                            : Text(widget.category.selected.toString(),
                          style: customTextStyle(MaterialTheme.lightScheme()
                              .onSurface, 24, 'Light'),),
                        //Увеличить количество билетов категории
                        Container(
                          height: 30.0,
                          width: 30.0,
                          decoration: BoxDecoration(
                            color:MaterialTheme.lightScheme().primary,
                            borderRadius: BorderRadius.circular(20),),
                          child: IconButton(
                              iconSize: 20,
                              padding: EdgeInsets.zero,
                              onPressed: (){
                            if(widget.category is CompositedTariffCategory){
                              final tariff = (widget.category as CompositedTariffCategory)
                                  .tariffsSelection.keys.firstWhere((t)=>t.id == selectedTariffId.value);
                              increaseCategoryHelper(ref, context, widget.category.categoryPriceId!, tariff);
                            } else {
                              increaseCategoryHelper(ref, context, widget.category.categoryPriceId!, null);
                            }
                          }, icon: Icon(Icons.add, color: MaterialTheme.lightScheme().onPrimary,)),
                        ),
                      ],
                    ),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MobileCategoryCard extends ConsumerStatefulWidget {
  const MobileCategoryCard({super.key, required this.category, required this.currency});
  final CompositedCategory category;
  final String currency;

  @override
  ConsumerState<MobileCategoryCard> createState() => _MobileCategoryState();
}

class _MobileCategoryState extends ConsumerState<MobileCategoryCard> {
  late ValueNotifier<int> selectedTariffId;

  @override
  void initState() {
    if (widget.category is CompositedTariffCategory){
      int initialId = (widget.category as CompositedTariffCategory).tariffsSelection.keys.first.id;
      selectedTariffId = ValueNotifier(initialId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String cName = widget.category.categoryPriceName!;
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
      child: ClipPath(
        clipper: const CouponClipper(curvePosition: 55,
          curveAxis: Axis.horizontal, curveRadius: 25,),
        child: Card.filled(
          elevation: 0.0,
          margin: EdgeInsets.zero,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Text(cName, textAlign: TextAlign.justify,
                  style: customTextStyle(MaterialTheme.lightScheme().onSurface, 17, 'Light')
                      .copyWith(fontWeight:FontWeight.bold),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 16,
                  children: [
                    //Меню тарифов
                    if(widget.category is CompositedTariffCategory)
                      Expanded(child: TariffChoicerNew(
                          tariffList:(widget.category as CompositedTariffCategory)
                              .tariffsSelection.keys.toList(),
                          selectedTariffId: selectedTariffId,)) else const Spacer(),
                    Row(
                      spacing: 16,
                      children: [
                        //Цена либо категории либо выбранного тарифа
                        widget.category is CompositedTariffCategory
                            ? ValueListenableBuilder(
                            valueListenable: selectedTariffId,
                            builder: (BuildContext context, int value, Widget? child) {
                              return Text('${(widget.category as CompositedTariffCategory)
                                  .tariffsSelection.keys.firstWhere((t)=>t.id == value).price}'
                                  ' ${widget.currency}',
                                style: customTextStyle(MaterialTheme.lightScheme()
                                    .onSurface, 18, 'Regular'),);
                            }
                        )
                            : Text('${widget.category.price} ${widget.currency}',
                          style: customTextStyle(MaterialTheme.lightScheme()
                              .onSurface, 18, 'Regular'),),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Container(
                            color: Colors.white,
                            child: Row(
                              spacing: 8,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //Уменьшить количество билетов категории
                                Container(
                                  height: 30.0,
                                  width: 30.0,
                                  decoration: BoxDecoration(
                                    color: darken(const Color(0xfff2f3f5)),
                                    borderRadius: BorderRadius.circular(20),),
                                  child: IconButton(
                                      iconSize: 20,
                                      padding: EdgeInsets.zero,
                                      onPressed: (){
                                    if(widget.category is CompositedTariffCategory){
                                      final tariff = (widget.category as CompositedTariffCategory)
                                          .tariffsSelection.keys.firstWhere((t)=>t.id == selectedTariffId.value);
                                      decreaseCategoryHelper(ref, context, widget.category.categoryPriceId!, tariff);
                                    } else {
                                      decreaseCategoryHelper(ref, context, widget.category.categoryPriceId!, null);
                                    }
                                  },
                                      icon: Icon(Icons.remove,
                                      color: MaterialTheme.lightScheme().onSurface)),
                                ),
                                //Выбранное количество билетов категории или ее тарифа
                                widget.category is CompositedTariffCategory
                                    ? ValueListenableBuilder(
                                    valueListenable: selectedTariffId,
                                    builder: (BuildContext context, int value, Widget? child) {
                                      final tariff = (widget.category as CompositedTariffCategory)
                                          .tariffsSelection.keys.firstWhere((t)=>t.id == value);
                                      return Text((widget.category as CompositedTariffCategory)
                                          .tariffsSelection[tariff]!.toString(),
                                        style: customTextStyle(MaterialTheme.lightScheme().onSurface,
                                            20, 'Light'),);
                                    }
                                )
                                    : Text(widget.category.selected.toString(),
                                  style: customTextStyle(MaterialTheme.lightScheme()
                                      .onSurface, 20, 'Light'),),
                                //Увеличить количество билетов категории
                                Container(
                                  height: 30.0,
                                  width: 30.0,
                                  decoration: BoxDecoration(
                                    color:MaterialTheme.lightScheme().primary,
                                    borderRadius: BorderRadius.circular(20),),
                                  child: IconButton(
                                      iconSize: 20,
                                      padding: EdgeInsets.zero,
                                      onPressed: (){
                                    if(widget.category is CompositedTariffCategory){
                                      final tariff = (widget.category as CompositedTariffCategory)
                                          .tariffsSelection.keys.firstWhere((t)=>t.id == selectedTariffId.value);
                                      increaseCategoryHelper(ref, context, widget.category.categoryPriceId!, tariff);
                                    } else {
                                      increaseCategoryHelper(ref, context, widget.category.categoryPriceId!, null);
                                    }
                                  },
                                      icon: Icon(Icons.add, color: MaterialTheme.lightScheme().onPrimary,)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                //Количество доступных билетов
                available == "off" ? const SizedBox.shrink() :
                Text(AppLocalizations.of(context)!.availability  + widget.category.available().toString(),
                    style: customTextStyle(MaterialTheme.lightScheme().onSecondaryContainer, 16, 'Light')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
