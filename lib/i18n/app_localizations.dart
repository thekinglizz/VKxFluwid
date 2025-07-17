import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'i18n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @surnameLabel.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get surnameLabel;

  /// No description provided for @middleNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Middle name'**
  String get middleNameLabel;

  /// No description provided for @bdLabel.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get bdLabel;

  /// No description provided for @serialLabel.
  ///
  /// In en, this message translates to:
  /// **'Serial number'**
  String get serialLabel;

  /// No description provided for @numberLabel.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get numberLabel;

  /// No description provided for @vdButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Visitor details'**
  String get vdButtonLabel;

  /// No description provided for @vdHint.
  ///
  /// In en, this message translates to:
  /// **'Fill in the visitor details for each ticket'**
  String get vdHint;

  /// No description provided for @ofertaLabel.
  ///
  /// In en, this message translates to:
  /// **'Offer'**
  String get ofertaLabel;

  /// No description provided for @fanIdHint.
  ///
  /// In en, this message translates to:
  /// **'*Please add fanId, phone or email'**
  String get fanIdHint;

  /// No description provided for @promoHintLabel.
  ///
  /// In en, this message translates to:
  /// **'Specify one or more promo codes, and click Add. The added promo codes are applied automatically. You can view promo codes in your personal account.'**
  String get promoHintLabel;

  /// No description provided for @organizerLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get organizerLabel;

  /// No description provided for @buyLabel.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buyLabel;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceLabel;

  /// No description provided for @ticketsLabel.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get ticketsLabel;

  /// No description provided for @emptyGA.
  ///
  /// In en, this message translates to:
  /// **'No available general admission tickets'**
  String get emptyGA;

  /// No description provided for @uriConfigurationError.
  ///
  /// In en, this message translates to:
  /// **'Check the required query parameters: frontendId, token, zone, cityId, id...'**
  String get uriConfigurationError;

  /// No description provided for @applyPromoCode.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get applyPromoCode;

  /// No description provided for @promoCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Field is empty'**
  String get promoCodeHint;

  /// No description provided for @accessCodeMsg.
  ///
  /// In en, this message translates to:
  /// **'Access Code is no set'**
  String get accessCodeMsg;

  /// No description provided for @errorCodeMsg.
  ///
  /// In en, this message translates to:
  /// **'AccessCode is incorrect'**
  String get errorCodeMsg;

  /// No description provided for @stageLabel.
  ///
  /// In en, this message translates to:
  /// **'Stage'**
  String get stageLabel;

  /// No description provided for @personalAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Ticket\'s buyer account'**
  String get personalAccountLabel;

  /// No description provided for @authRedirectLabel.
  ///
  /// In en, this message translates to:
  /// **'Verify email'**
  String get authRedirectLabel;

  /// No description provided for @numberOfTickets.
  ///
  /// In en, this message translates to:
  /// **'tickets'**
  String get numberOfTickets;

  /// No description provided for @goToCartLabel.
  ///
  /// In en, this message translates to:
  /// **'Go to Cart'**
  String get goToCartLabel;

  /// No description provided for @selectSeatsLabel.
  ///
  /// In en, this message translates to:
  /// **'Go to seating plan'**
  String get selectSeatsLabel;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @sector.
  ///
  /// In en, this message translates to:
  /// **'Sector'**
  String get sector;

  /// No description provided for @row.
  ///
  /// In en, this message translates to:
  /// **'Row'**
  String get row;

  /// No description provided for @number.
  ///
  /// In en, this message translates to:
  /// **'Seat'**
  String get number;

  /// No description provided for @userSeatsLabel.
  ///
  /// In en, this message translates to:
  /// **' My seats'**
  String get userSeatsLabel;

  /// No description provided for @personalAreaLabel.
  ///
  /// In en, this message translates to:
  /// **'Personal account'**
  String get personalAreaLabel;

  /// No description provided for @basketLabel.
  ///
  /// In en, this message translates to:
  /// **''**
  String get basketLabel;

  /// No description provided for @submitButton.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get submitButton;

  /// No description provided for @updateButton.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get updateButton;

  /// No description provided for @submitCodeButton.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitCodeButton;

  /// No description provided for @helpButton.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get helpButton;

  /// No description provided for @tariff.
  ///
  /// In en, this message translates to:
  /// **'Tariff: '**
  String get tariff;

  /// No description provided for @fromLabel.
  ///
  /// In en, this message translates to:
  /// **'from'**
  String get fromLabel;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get code;

  /// No description provided for @availability.
  ///
  /// In en, this message translates to:
  /// **'Tickets available: '**
  String get availability;

  /// No description provided for @emptyBasketMessage.
  ///
  /// In en, this message translates to:
  /// **'Shopping cart is empty'**
  String get emptyBasketMessage;

  /// No description provided for @authBasketMessage.
  ///
  /// In en, this message translates to:
  /// **'Verify your email and select a ticket'**
  String get authBasketMessage;

  /// No description provided for @setAnotherEmail.
  ///
  /// In en, this message translates to:
  /// **'Change email'**
  String get setAnotherEmail;

  /// No description provided for @emailMessage.
  ///
  /// In en, this message translates to:
  /// **'To purchase tickets please verify your email'**
  String get emailMessage;

  /// No description provided for @emailMessage1.
  ///
  /// In en, this message translates to:
  /// **'E-mail is verified'**
  String get emailMessage1;

  /// No description provided for @emailMessage2.
  ///
  /// In en, this message translates to:
  /// **'To purchase tickets please verify your email'**
  String get emailMessage2;

  /// No description provided for @emailSuccess.
  ///
  /// In en, this message translates to:
  /// **'Email is verified'**
  String get emailSuccess;

  /// No description provided for @codeMessage.
  ///
  /// In en, this message translates to:
  /// **'Code is incorrect'**
  String get codeMessage;

  /// No description provided for @hint1.
  ///
  /// In en, this message translates to:
  /// **'Please note that general admission\'s reservations are confirmed when you proceed to the shopping cart'**
  String get hint1;

  /// No description provided for @hint2.
  ///
  /// In en, this message translates to:
  /// **' not at the point of selecting tickets'**
  String get hint2;

  /// No description provided for @hint3.
  ///
  /// In en, this message translates to:
  /// **' using the + button.'**
  String get hint3;

  /// No description provided for @hint4.
  ///
  /// In en, this message translates to:
  /// **' Kindly keep this in mind when making your purchase.'**
  String get hint4;

  /// No description provided for @hint5.
  ///
  /// In en, this message translates to:
  /// **' Please, remember this when buying.'**
  String get hint5;

  /// No description provided for @mHint1.
  ///
  /// In en, this message translates to:
  /// **'Reservations are confirmed when you proceed to the shopping cart'**
  String get mHint1;

  /// No description provided for @serviceCharge.
  ///
  /// In en, this message translates to:
  /// **'Service charge'**
  String get serviceCharge;

  /// No description provided for @totalSum.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalSum;

  /// No description provided for @payButton.
  ///
  /// In en, this message translates to:
  /// **'PAY'**
  String get payButton;

  /// No description provided for @clearAllButton.
  ///
  /// In en, this message translates to:
  /// **'CLEAR ALL'**
  String get clearAllButton;

  /// No description provided for @agreementStart.
  ///
  /// In en, this message translates to:
  /// **'I\'ve read and accept the terms of   '**
  String get agreementStart;

  /// No description provided for @agreementEnd.
  ///
  /// In en, this message translates to:
  /// **'the user agreement'**
  String get agreementEnd;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @initialsLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get initialsLabel;

  /// No description provided for @birthLabel.
  ///
  /// In en, this message translates to:
  /// **'Visitor\'s birthdate'**
  String get birthLabel;

  /// No description provided for @documentLabel.
  ///
  /// In en, this message translates to:
  /// **'Visitor\'s document'**
  String get documentLabel;

  /// No description provided for @promoLabel.
  ///
  /// In en, this message translates to:
  /// **'Promo codes'**
  String get promoLabel;

  /// No description provided for @successPromoCodeMessage.
  ///
  /// In en, this message translates to:
  /// **'Promo code is added'**
  String get successPromoCodeMessage;

  /// No description provided for @successPromoCodesMessage.
  ///
  /// In en, this message translates to:
  /// **'Promo codes are added'**
  String get successPromoCodesMessage;

  /// No description provided for @failPromoCodeMessage.
  ///
  /// In en, this message translates to:
  /// **'Promo code isn\'t added'**
  String get failPromoCodeMessage;

  /// No description provided for @failPromoCodesMessage.
  ///
  /// In en, this message translates to:
  /// **'Promo codes aren\'t added'**
  String get failPromoCodesMessage;

  /// No description provided for @existPromoCodeMessage.
  ///
  /// In en, this message translates to:
  /// **'already exist'**
  String get existPromoCodeMessage;

  /// No description provided for @existPromoCodesMessage.
  ///
  /// In en, this message translates to:
  /// **'already exists'**
  String get existPromoCodesMessage;

  /// No description provided for @memoContent.
  ///
  /// In en, this message translates to:
  /// **'Prior to ticket selection please verify your email. You will receive a verification code to your email.'**
  String get memoContent;

  /// No description provided for @confirmMemo.
  ///
  /// In en, this message translates to:
  /// **'Please, check your email for the verification code.'**
  String get confirmMemo;

  /// No description provided for @fullNameError.
  ///
  /// In en, this message translates to:
  /// **'Please, enter your name with last name'**
  String get fullNameError;

  /// No description provided for @phoneError.
  ///
  /// In en, this message translates to:
  /// **'Please, enter your phone'**
  String get phoneError;

  /// No description provided for @promoHint.
  ///
  /// In en, this message translates to:
  /// **'Please, enter promo code'**
  String get promoHint;

  /// No description provided for @validMobileHint.
  ///
  /// In en, this message translates to:
  /// **'Phone number is incorrect'**
  String get validMobileHint;

  /// No description provided for @createOrderError.
  ///
  /// In en, this message translates to:
  /// **'Create order error'**
  String get createOrderError;

  /// No description provided for @closeWidgetMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel your purchase? The reservation will be cancelled.'**
  String get closeWidgetMessage;

  /// No description provided for @closeWidgetYesButton.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get closeWidgetYesButton;

  /// No description provided for @closeWidgetNoButton.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get closeWidgetNoButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
