import 'package:flapp_widget/constants.dart';
import 'package:flapp_widget/services/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../i18n/app_localizations.dart';
import '../../../styles/ui_styles.dart';

class AccessCodeInput extends StatefulWidget {
  const AccessCodeInput({super.key});

  @override
  State<AccessCodeInput> createState() => _AccessCodeInputState();
}

class _AccessCodeInputState extends State<AccessCodeInput> {
  final _accessCodeController = TextEditingController();
  int accessCode = 0;

  @override
  void dispose() {
    _accessCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 120,
          height: 40,
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: outlinedField(context, '', null),
            textAlign: TextAlign.center, controller:  _accessCodeController,
            onChanged: (value){
            if (value != ''){
              accessCode = int.parse(value); //print(accessCode);
            } else {
              accessCode = 0;
            }},),
        ),
        SizedBox(
            height: 40,
            child: FilledButton(
                style: roundedBorderStyle(),
                onPressed: ()async{
                  if (accessCode > 0){
                    await ActionAPI.checkKDP(accessCode).then((value){
                      if (value == false){
                        if (context.mounted){
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                UserDialog(userMessage: AppLocalizations.of(context)!.errorCodeMsg,
                                    redirectFlag: screenWidth < 1100 ? true : false),);
                        }
                      }
                    });}},
                child: const Icon(Icons.arrow_forward, size: 22, color: Colors.white,)
            )
        )
      ],
    );
  }
}
