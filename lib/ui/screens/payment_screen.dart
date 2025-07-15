import 'dart:async';

import 'package:flapp_widget/view_models/action_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/user.dart';
import '../../services/api_client.dart';
import '../../view_models/user_view_model.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen(this.reqFieldsData, {super.key});
  // TODO dynamic to order details object
  final List<dynamic> reqFieldsData;

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  late Future<dynamic> paymentUrl;
  late User? user;

  Future configUrl(Uri link) async{
    //если эквайринг тиксгира то перенаправление на апи2
    if (link.origin.contains('tixgear.com')){
      Uri backupLink = Uri.parse('https://api2.bil24.pro:${link.port}${link.path}?${link.query}');
      launchUrl(backupLink, webOnlyWindowName: '_self');
    } else {
      launchUrl(link, webOnlyWindowName: '_self');
    }
  }

  @override
  void initState() {
    user = ref.read(asyncUserProvider).value;
    paymentUrl = CartAPI.createOrder(user!, widget.reqFieldsData);
    //Future.delayed(const Duration(seconds: 2),() => Uri.parse('https://api.bil24.pro'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: paymentUrl,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data! is Uri){
            configUrl(snapshot.data!);
            ref.invalidate(asyncActionProvider);
            Future.delayed(const Duration(seconds: 2),
                    () =>  WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }));
          }
          else{
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context, snapshot.data);
            });
          }
        } else if (snapshot.hasError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context, snapshot.data);
          });
        }
        return Scaffold(
          body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              )),
        );
      },
    );
  }
}
