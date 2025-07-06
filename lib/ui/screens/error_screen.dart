import 'package:flapp_widget/styles/ui_styles.dart';
import 'package:flutter/material.dart';

String croppedString(String message){
  if (message.length > 200){
    return message.substring(0, 200);
  }
  return message;
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Image(image: AssetImage('images/detective.png'), height: 230, width: 230,),
              SelectableText(croppedString(error), textAlign: TextAlign.justify,
                  style: customTextStyle(Colors.black, 20, 'Regular')),
            ],
          ),
        ),
      ),
    );
  }
}