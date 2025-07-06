import 'package:flapp_widget/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../styles/ui_styles.dart';

class FailScreen extends StatelessWidget {
  const FailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 100.0,),
            const Image(image: AssetImage('images/fail.png'), height: 120,),
            const SizedBox(height: 50.0,),
            if (Intl.shortLocale(Intl.defaultLocale!) == 'ru')
              SelectableText('Платеж не выполнен. Списание средств не произведено.',
              style: customTextStyle(Colors.black, 20, 'Regular'),
                textAlign: TextAlign.center),
            const SizedBox(height: 20.0,),
            if (Intl.shortLocale(Intl.defaultLocale!) == 'en' || Intl.defaultLocale == null)
              SelectableText('Sorry, your payment failed. No charges were made.',
              style: customTextStyle(Colors.black, 20, 'Regular'),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100.0,),
            const Image(image: AssetImage('images/success.png'), height: 120,),
            const SizedBox(height: 50.0,),
            if (Intl.shortLocale(Intl.defaultLocale!) == 'ru')
              SelectableText('Платеж завершен. Если оплата прошла успешно, то билеты отправлены на указанную почту.',
              style: customTextStyle(Colors.black, 20, 'Regular'),
              textAlign: TextAlign.center,),
            const SizedBox(height: 20.0,),
            if (Intl.shortLocale(Intl.defaultLocale!) == 'en' || Intl.defaultLocale == null)
              SelectableText('The payment is completed. If the payment was successful, the tickets will be sent to the specified email address..',
                style: customTextStyle(Colors.black, 20, 'Regular'),
                textAlign: TextAlign.center),
            const SizedBox(height: 30.0,),
            /*if (magicSuccessUrl == "test" || magicSuccessUrl == "real")
            SizedBox(
              height: 45.0,
              child: FilledButton(
                  style:ButtonStyle(
                    shape: WidgetStateProperty
                        .all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0))),),
                  onPressed: () async{await _launchPA();},
                  child: const Text('Перейти в личный кабинет',
                    style: TextStyle(fontSize: 18, color: Colors.white),)),
            ),*/
          ],
        ),
      ),
    );
  }
}

_launchPA() {
  if (magicSuccessUrl == "test"){
    launchUrl(Uri.parse('https://my.bil24.pro/tz'));
  }
  if (magicSuccessUrl == "real"){
    launchUrl(Uri.parse('https://my.bil24.pro/'));
  }
}