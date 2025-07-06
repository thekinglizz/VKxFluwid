// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      categoryPriceId: (json['categoryPriceId'] as num).toInt(),
      categoryPriceName: json['categoryPriceName'] as String,
      availability: (json['availability'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      tariffIdMap: (json['tariffIdMap'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(int.parse(k), (e as num).toDouble()),
      ),
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'categoryPriceId': instance.categoryPriceId,
      'categoryPriceName': instance.categoryPriceName,
      'availability': instance.availability,
      'price': instance.price,
      'tariffIdMap':
          instance.tariffIdMap?.map((k, e) => MapEntry(k.toString(), e)),
    };

CategoryLimit _$CategoryLimitFromJson(Map<String, dynamic> json) =>
    CategoryLimit(
      remainder: (json['remainder'] as num?)?.toInt(),
      categoryList: (json['categoryList'] as List<dynamic>)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoryLimitToJson(CategoryLimit instance) =>
    <String, dynamic>{
      'remainder': instance.remainder,
      'categoryList': instance.categoryList.map((e) => e.toJson()).toList(),
    };
