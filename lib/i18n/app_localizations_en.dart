// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get nameLabel => 'Name';

  @override
  String get surnameLabel => 'Surname';

  @override
  String get middleNameLabel => 'Middle name';

  @override
  String get bdLabel => 'Birthday';

  @override
  String get serialLabel => 'Serial number';

  @override
  String get numberLabel => 'Number';

  @override
  String get vdButtonLabel => 'Visitor details';

  @override
  String get vdHint => 'Fill in the visitor details for each ticket';

  @override
  String get ofertaLabel => 'Offer';

  @override
  String get fanIdHint => '*Please add fanId, phone or email';

  @override
  String get promoHintLabel =>
      'Specify one or more promo codes, and click Add. The added promo codes are applied automatically. You can view promo codes in your personal account.';

  @override
  String get organizerLabel => 'Owner';

  @override
  String get buyLabel => 'Buy';

  @override
  String get priceLabel => 'Price';

  @override
  String get ticketsLabel => 'Tickets';

  @override
  String get emptyGA => 'No available general admission tickets';

  @override
  String get uriConfigurationError =>
      'Check the required query parameters: frontendId, token, zone, cityId, id...';

  @override
  String get applyPromoCode => 'Add';

  @override
  String get promoCodeHint => 'Field is empty';

  @override
  String get accessCodeMsg => 'Access Code is no set';

  @override
  String get errorCodeMsg => 'AccessCode is incorrect';

  @override
  String get stageLabel => 'Stage';

  @override
  String get personalAccountLabel => 'Ticket\'s buyer account';

  @override
  String get authRedirectLabel => 'Verify email';

  @override
  String get numberOfTickets => 'tickets';

  @override
  String get goToCartLabel => 'Go to Cart';

  @override
  String get selectSeatsLabel => 'Go to seating plan';

  @override
  String get categoryLabel => 'Category';

  @override
  String get sector => 'Sector';

  @override
  String get row => 'Row';

  @override
  String get number => 'Seat';

  @override
  String get userSeatsLabel => ' My seats';

  @override
  String get personalAreaLabel => 'Personal account';

  @override
  String get basketLabel => '';

  @override
  String get submitButton => 'Verify';

  @override
  String get updateButton => 'Change Email';

  @override
  String get submitCodeButton => 'Submit';

  @override
  String get helpButton => 'Help';

  @override
  String get tariff => 'Tariff: ';

  @override
  String get fromLabel => 'from';

  @override
  String get code => 'Verification code';

  @override
  String get availability => 'Tickets available: ';

  @override
  String get emptyBasketMessage => 'Shopping cart is empty';

  @override
  String get authBasketMessage => 'Verify your email and select a ticket';

  @override
  String get setAnotherEmail => 'Change email';

  @override
  String get emailMessage => 'To purchase tickets please verify your email';

  @override
  String get emailMessage1 => 'E-mail is verified';

  @override
  String get emailMessage2 => 'To purchase tickets please verify your email';

  @override
  String get emailSuccess => 'Email is verified';

  @override
  String get codeMessage => 'Code is incorrect';

  @override
  String get hint1 =>
      'Please note that general admission\'s reservations are confirmed when you proceed to the shopping cart';

  @override
  String get hint2 => ' not at the point of selecting tickets';

  @override
  String get hint3 => ' using the + button.';

  @override
  String get hint4 => ' Kindly keep this in mind when making your purchase.';

  @override
  String get hint5 => ' Please, remember this when buying.';

  @override
  String get mHint1 =>
      'Reservations are confirmed when you proceed to the shopping cart';

  @override
  String get serviceCharge => 'Service charge';

  @override
  String get totalSum => 'Total';

  @override
  String get payButton => 'PAY';

  @override
  String get clearAllButton => 'CLEAR ALL';

  @override
  String get agreementStart => 'I\'ve read and accept the terms of   ';

  @override
  String get agreementEnd => 'the user agreement';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get initialsLabel => 'Full name';

  @override
  String get birthLabel => 'Visitor\'s birthdate';

  @override
  String get documentLabel => 'Visitor\'s document';

  @override
  String get promoLabel => 'Promo codes';

  @override
  String get successPromoCodeMessage => 'Promo code is added';

  @override
  String get successPromoCodesMessage => 'Promo codes are added';

  @override
  String get failPromoCodeMessage => 'Promo code isn\'t added';

  @override
  String get failPromoCodesMessage => 'Promo codes aren\'t added';

  @override
  String get existPromoCodeMessage => 'already exist';

  @override
  String get existPromoCodesMessage => 'already exists';

  @override
  String get memoContent =>
      'Prior to ticket selection please verify your email. You will receive a verification code to your email.';

  @override
  String get confirmMemo =>
      'Please, check your email for the verification code.';

  @override
  String get fullNameError => 'Please, enter your name with last name';

  @override
  String get phoneError => 'Please, enter your phone';

  @override
  String get promoHint => 'Please, enter promo code';

  @override
  String get validMobileHint => 'Phone number is incorrect';

  @override
  String get createOrderError => 'Create order error';

  @override
  String get closeWidgetMessage =>
      'Are you sure you want to cancel your purchase? The reservation will be cancelled.';

  @override
  String get closeWidgetYesButton => 'Yes';

  @override
  String get closeWidgetNoButton => 'No';
}
