import 'package:clipboard/clipboard.dart';
import 'package:flapp_widget/theme.dart';
import 'package:flapp_widget/styles/ui_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../constants.dart';
import '../../../i18n/app_localizations.dart';
import '../../../models/user.dart';
import '../../../services/api_client.dart';
import '../../../view_models/user_view_model.dart';

class AuthorisationArea extends ConsumerWidget {
  const AuthorisationArea({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(asyncUserProvider);
    return user.when(data: (user){
      return Center(
        child: Column(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AuthorizationWidget(user: user,),
            if (user.state == UserStates.unknown)
              Text('*${AppLocalizations.of(context)!.memoContent}',
              style: customTextStyle(MaterialTheme.lightScheme().onSurface,
                  screenWidth > 700 ? 17.0 : 15.0, 'Light'),
              textAlign: TextAlign.justify,),
            const SizedBox(height: 15,),
            const UserActions(),
          ],
        ),
      );
    }, error: (e,s){return const Text('User Provider Error');},
        loading: (){return const SizedBox.shrink();});
  }
}

class UserActions extends StatelessWidget {
  const UserActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      mainAxisSize: MainAxisSize.min,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: (){},
            child: Text(AppLocalizations.of(context)!.personalAreaLabel,
              style: customTextStyle(MaterialTheme.lightScheme().onSurface,
                  screenWidth > 1100 ? 17.0 : 15.0, 'Light'),
              textAlign: TextAlign.center,),
          ),
        ),
        Icon(CupertinoIcons.circle_fill, size: 8,
          color: MaterialTheme.lightScheme().onSurface,),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: (){},
            child: Text(AppLocalizations.of(context)!.helpButton,
              style: customTextStyle(MaterialTheme.lightScheme().onSurface,
                  screenWidth > 1100 ? 17.0 : 15.0, 'Light'),
              textAlign: TextAlign.center,),
          ),
        ),
      ],
    );
  }
}

class AuthorizationWidget extends ConsumerStatefulWidget {
  const AuthorizationWidget({super.key, required this.user});
  final User user;

  @override
  ConsumerState<AuthorizationWidget> createState() => _AuthorizationWidgetState();
}

class _AuthorizationWidgetState extends ConsumerState<AuthorizationWidget> {
  final TextEditingController _emailEditingController = TextEditingController();
  String? _errorText() {
    final text = _emailEditingController.value.text;
    if (text.isEmpty) {return AppLocalizations.of(context)!.emailMessage2;}
    if (!emailRegExp.hasMatch(text)) {
      return AppLocalizations.of(context)!.emailMessage;}
    return null;
  }

  void _getEmailToShow(){
    if (widget.user.state == UserStates.authorized ||
        widget.user.state == UserStates.processing){
      _emailEditingController.text = widget.user.email;
    }
    if (widget.user.state == UserStates.unknown){
      _emailEditingController.text = '';
    }
  }

  void _startAuthorization(WidgetRef ref){
    String email = _emailEditingController.value.text.replaceAll(" ", "");
    if (_errorText() == null && widget.user.state == UserStates.unknown){
      UserAPI.bindEmail(ref, email.trim()); // todo привести к нижнему регистру
    }
    _emailEditingController.text = _emailEditingController.value.text.replaceAll(" ", "");
  }

  void _resetUser(){
    _emailEditingController.text = '';
    ref.read(asyncUserProvider.notifier).clearUser();
  }

  @override
  void dispose() {
    _emailEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {_getEmailToShow();});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: screenWidth > 700 ? 16 : 8,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            SizedBox(
                width: screenWidth > 700 ? 280.0 : 230.0,
                child: ValueListenableBuilder(
                    valueListenable: _emailEditingController,
                    builder: (context, TextEditingValue value, __) {
                      return TextField(
                        onEditingComplete: (){
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        controller: _emailEditingController,
                        decoration: outlinedField(context, 'Email*', null)
                            .copyWith(errorText: _errorText()),);
                    }
                )
            ),
            if (widget.user.state == UserStates.unknown) SizedBox(
                height: 50.0,
                child: FilledButton(
                    style: roundedBorderStyle(),
                    onPressed: (){_startAuthorization(ref);},
                    child: MediaQuery.of(context).size.width > 700
                        ? Text(AppLocalizations.of(context)!.submitButton,
                      style: customTextStyle(MaterialTheme.lightScheme().onPrimary, 16, 'Light'),)
                        : Icon(Icons.arrow_forward, size: 22, color: MaterialTheme.lightScheme().onPrimary,)
                )
            ),
            if (MediaQuery.of(context).size.width > 700)
            if (widget.user.state == UserStates.authorized)
              SizedBox(
                height: 50.0,
                child: FilledButton(
                    style: roundedBorderStyle(),
                    onPressed: (){_resetUser();},
                    child: Text(AppLocalizations.of(context)!.updateButton,
                              style: customTextStyle(Colors.white, 16, 'Light'),)
                )
            )
          ],
        ),
        if (MediaQuery.of(context).size.width < 700)
          if (widget.user.state == UserStates.authorized)
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: (){ _resetUser();},
              child: Text(AppLocalizations.of(context)!.setAnotherEmail,
                  style: customTextStyle(MaterialTheme.lightScheme().onSurface,
                      16, 'Regular')), ),
          ),
        if (widget.user.state == UserStates.processing)
          OtpWidget(callback: _resetUser, user: widget.user,)
      ],
    );
  }
}

class OtpWidget extends ConsumerStatefulWidget {
  const OtpWidget({super.key, required this.callback, required this.user});
  final VoidCallback callback;
  final User user;

  @override
  ConsumerState<OtpWidget> createState() => _OtpWidgetState();
}

class _OtpWidgetState extends ConsumerState<OtpWidget> {
  final TextEditingController _otpEditingController = TextEditingController();
  bool _hasError = false;

  void _endAuthorization(WidgetRef ref) async{
    if (_otpEditingController.value.text.length != 6) {
      _hasError = true;
      setState(() {});
    } else {
      final user = await UserAPI.confirmEmail(_otpEditingController.value.text, widget.user);
      if (user is User) {
        ref.read(asyncUserProvider.notifier).saveUser(user);
        _hasError = false;
      } else {
        _hasError = true;setState(() {});
      }
      _otpEditingController.text = '';
      /*UserAPI.confirmEmail(_otpEditingController.value.text, widget.user)
          .then((value) {
        if (value is User) {
          ref.read(asyncUserProvider.notifier).saveUser(value);
          _hasError = false;
        } else {_hasError = true;setState(() {});}
      });*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        Text(AppLocalizations.of(context)!.confirmMemo,
          style: customTextStyle(MaterialTheme.lightScheme()
              .onSurface, 16, 'Regular'),
          textAlign: TextAlign.center,),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          //mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 320.0,
              height: 70.0,
              child: PinCodeTextField(
                appContext: context,
                length: 6,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(15),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.white,
                  activeColor: MaterialTheme.lightScheme().primary,
                  inactiveFillColor: Colors.white,
                  selectedFillColor: MaterialTheme.lightScheme().inversePrimary,
                  selectedColor: MaterialTheme.lightScheme().inversePrimary,
                  inactiveColor: MaterialTheme.lightScheme().primary,
                ),
                cursorColor: MaterialTheme.lightScheme().primary,
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                autoDisposeControllers: true,
                controller: _otpEditingController,
                keyboardType: TextInputType.number,
                boxShadows: const [
                  BoxShadow(offset: Offset(0, 1), color: Colors.black12,
                    blurRadius: 10,)],
                onCompleted: (v) {},
                onChanged: (value) {setState(() {});},
                beforeTextPaste: (text) {return true;},
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            const SizedBox(width: 5.0,),
            if (screenWidth > 700) IconButton(onPressed: () async {
              isNumeric(string) => num.tryParse(string) != null;
              final pasteResult = await FlutterClipboard.paste();
              if (isNumeric(pasteResult)){
                _otpEditingController.text = pasteResult;
                _hasError = false;
              } else {
                _hasError = true;
              }
              setState(() {});
             },
                padding: EdgeInsets.zero,
                icon: Icon(Icons.paste_rounded, size: 30,
                  color:MaterialTheme.lightScheme().onSurface,))
          ],
        ),
        if (_hasError) Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
          child: Text(AppLocalizations.of(context)!.codeMessage,
            style: customTextStyle(MaterialTheme.lightScheme().error, 16, 'Light'),),
        ),
        SizedBox(
          height: 50.0,
          width: 110.0,
          child: FilledButton(
            style: roundedBorderStyle(),
            onPressed: () {_endAuthorization(ref);},
            child: Text(AppLocalizations.of(context)!.submitCodeButton,
              style: customTextStyle(Colors.white, 16, 'Light'),),
          ),
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: (){widget.callback();},
            child: Text(AppLocalizations.of(context)!.setAnotherEmail,
                style: customTextStyle(MaterialTheme.lightScheme().onSurface,
                    18, 'Regular')), ),
        )
      ],
    );
  }
}