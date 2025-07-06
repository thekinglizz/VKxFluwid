import 'package:flapp_widget/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

TextStyle customTextStyle(Color? color, double? size, String family) {
  return TextStyle(
    fontFamily: 'RobotoCondensed$family',
    color: color ?? Colors.black,
    fontSize: size,
    wordSpacing: 2.0,
    letterSpacing: 0.9
  );
}

TextStyle agreementTextStyle(Color? color, double? size, String family) {
  return TextStyle(
    fontFamily: 'RobotoCondensed$family',
    color: color ?? Colors.black,
    fontSize: size,
    wordSpacing: 2.0,
    letterSpacing: 0.9,
    //decoration: TextDecoration.underline,
    //decorationThickness: 1,
    //decorationColor: const Color(0xFF3D5AA9)
  );
}

InputDecoration underlinedField(BuildContext context, String hint, double? size,
    Color background){
  return InputDecoration(
    hintText: hint,
    fillColor:background,
    filled: true,
    hintStyle: customTextStyle(MaterialTheme.lightScheme().outline, size, 'Regular'),
    contentPadding: const EdgeInsets.all(8.0),
    border: UnderlineInputBorder(
      borderSide: BorderSide(color: MaterialTheme.lightScheme().primaryContainer, width: 1.5),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: MaterialTheme.lightScheme().primaryContainer, width: 1.5),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: MaterialTheme.lightScheme().primaryContainer, width: 1.5),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: MaterialTheme.lightScheme().primaryContainer, width: 1.5),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: MaterialTheme.lightScheme().primaryContainer, width: 1.5),
    ),
    errorStyle: TextStyle(color: MaterialTheme.lightScheme().onSurfaceVariant),

  );
}

InputDecoration outlinedField(BuildContext context, String hint, double? size){
  return InputDecoration(
      hintText: hint,
      fillColor: Colors.white,
      filled: true,
      hintStyle: customTextStyle(MaterialTheme.lightScheme().outline, size, 'Regular'),
      contentPadding: const EdgeInsets.all(8.0),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: MaterialTheme.lightScheme().outline, width: 1.5),
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: MaterialTheme.lightScheme().outline, width: 1.5),
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: MaterialTheme.lightScheme().outline, width: 1.5),
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: MaterialTheme.lightScheme().outline, width: 1.5),
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: MaterialTheme.lightScheme().outline, width: 1.5),
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      ),
      errorStyle: TextStyle(color: MaterialTheme.lightScheme().outline),

  );
}

InputDecoration promoOutlinedField(BuildContext context, String hint,
    double? size, Function(String) callback, String index){
  return InputDecoration(
    suffixIcon: GestureDetector(
      onTap: (){callback(index);},
      child: const MouseRegion(cursor: SystemMouseCursors.click,
          child: Icon(CupertinoIcons.delete_simple, size: 20,)),
    ),
    hintText: hint,
    hintStyle: customTextStyle(MaterialTheme.lightScheme().primary, size, 'Regular'),
    // contentPadding: EdgeInsets.zero,
    contentPadding: const EdgeInsets.all(10.0),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: MaterialTheme.lightScheme().primary, width: 1.5),
      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: MaterialTheme.lightScheme().primary, width: 1.5),
      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: MaterialTheme.lightScheme().primary, width: 1.5),
      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: MaterialTheme.lightScheme().primary, width: 1.5),
      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: MaterialTheme.lightScheme().primary, width: 1.5),
      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
    ),
    errorStyle: TextStyle(color: MaterialTheme.lightScheme().primary),

  );
}

InputDecoration underlineField(BuildContext context, String hint){
  return InputDecoration(
    hintText: hint,
    hintStyle: customTextStyle(MaterialTheme.lightScheme().onSurfaceVariant, null, 'Regular'),
  );
}

ButtonStyle roundedBorderStyle(){
  return FilledButton.styleFrom(
    backgroundColor: MaterialTheme.lightScheme().primary,
    disabledBackgroundColor: lighten(const Color(0xFF3D5AA9), .25),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  );
}

ButtonStyle payStyle(){
  return FilledButton.styleFrom(
    backgroundColor: MaterialTheme.lightScheme().primary,
    disabledBackgroundColor: lighten(MaterialTheme.lightScheme().primary, .25),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  );
}

ButtonStyle customRoundedBorderStyle(Color buttonColor){
  return FilledButton.styleFrom(
    disabledBackgroundColor: buttonColor,
    backgroundColor: buttonColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  );
}

ButtonStyle customOutlinedRoundedBorderStyle(Color buttonColor){
  return OutlinedButton.styleFrom(
      overlayColor: MaterialTheme.lightScheme().primaryFixed,
    side: BorderSide(width: 1.5, color: buttonColor),
    backgroundColor: MaterialTheme.lightScheme().surfaceContainer,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  );
}