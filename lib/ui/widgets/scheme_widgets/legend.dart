import 'dart:math';

import 'package:flapp_widget/view_models/scheme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../i18n/app_localizations.dart';
import '../../../models/scheme_models/category_price_model.dart';
import '../../../theme.dart';

class CategoryInfoWidget extends ConsumerWidget {
  const CategoryInfoWidget({super.key, required this.categoryPrice, required this.currency});
  final CategoryPriceObj categoryPrice;
  final String currency;

  @override
  Widget build(BuildContext context, ref) {
    final cf = ref.watch(asyncSchemeProvider.select((svm)=>svm.value!.categoryPriceFilter));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: (){
            if (cf == categoryPrice){
              ref.read(asyncSchemeProvider.notifier).filterCategories(null);
            } else{
              ref.read(asyncSchemeProvider.notifier).filterCategories(categoryPrice);
            }
          },
          child: Opacity(
            opacity: (cf == categoryPrice || cf == null) ? 1.0 : 0.5,
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade200, width: 1.0),
                borderRadius: BorderRadius.circular(20,),),
              elevation: 0.0,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 15.0,
                      width: 15.0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: categoryPrice.color,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5.0,),
                    categoryPrice.tariffIdMap.isNotEmpty ?
                    Text('${AppLocalizations.of(context)!.fromLabel} '
                        '${categoryPrice.tariffIdMap.values.reduce(min)} $currency',
                      style: const TextStyle(color: Colors.black),)
                        : Text(' ${categoryPrice.price} $currency',
                      style: const TextStyle(color: Colors.black),)
                  ],),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UserSelectionLegend extends StatelessWidget {
  const UserSelectionLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade200, width: 1.0),
          borderRadius: BorderRadius.circular(20,),),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16,8,16,8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.radio_button_checked_outlined, color: MaterialTheme.lightScheme().primary,),
              const SizedBox(width: 5.0,),
              Text(AppLocalizations.of(context)!.userSeatsLabel,
                style: const TextStyle(color: Colors.black),)
            ],),
        ),
      ),
    );
  }
}
