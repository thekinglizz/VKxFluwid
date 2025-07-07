// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get nameLabel => 'Имя';

  @override
  String get surnameLabel => 'Фамилия';

  @override
  String get middleNameLabel => 'Отчество';

  @override
  String get bdLabel => 'Дата рождения';

  @override
  String get serialLabel => 'Серия документа';

  @override
  String get numberLabel => 'Номер документа';

  @override
  String get vdButtonLabel => 'Данные посетителя';

  @override
  String get vdHint => 'Заполните данные посетителя для каждого билета';

  @override
  String get ofertaLabel => 'Публичная оферта';

  @override
  String get fanIdHint => '*Введите номер ПК болельщика, телефон или email';

  @override
  String get promoHintLabel =>
      'Укажите один или несколько промокодов, и нажмите \"Добавить\". Добавленные промокоды применяются автоматически. Посмотреть промокоды можно в личном кабинете.';

  @override
  String get organizerLabel => 'Устроитель';

  @override
  String get buyLabel => 'Купить';

  @override
  String get priceLabel => 'Стоимость';

  @override
  String get ticketsLabel => 'Билеты';

  @override
  String get emptyGA => 'Доступных к продаже билетов в данный момент нет';

  @override
  String get uriConfigurationError =>
      'Укажите обязательные url-параметры: frontendId, token, zone, cityId, id...';

  @override
  String get applyPromoCode => 'Добавить';

  @override
  String get promoCodeHint => 'Поле не заполнено';

  @override
  String get accessCodeMsg => 'Поле КДП не заполнено';

  @override
  String get errorCodeMsg => 'КДП задан неверно';

  @override
  String get stageLabel => 'Сцена';

  @override
  String get personalAccountLabel => 'Перейти в личный кабинет';

  @override
  String get authRedirectLabel => 'Подтвердить';

  @override
  String get numberOfTickets => 'шт.';

  @override
  String get goToCartLabel => 'Перейти в корзину';

  @override
  String get selectSeatsLabel => 'Выбор мест на схеме';

  @override
  String get categoryLabel => 'Категория';

  @override
  String get sector => 'Сектор';

  @override
  String get row => 'Ряд';

  @override
  String get number => 'Место';

  @override
  String get userSeatsLabel => ' Мои места';

  @override
  String get personalAreaLabel => 'Личный кабинет';

  @override
  String get basketLabel => 'Корзина';

  @override
  String get submitButton => 'Подтвердить';

  @override
  String get updateButton => 'Сменить почту';

  @override
  String get submitCodeButton => 'Далее';

  @override
  String get helpButton => 'Помощь';

  @override
  String get tariff => 'Тариф: ';

  @override
  String get fromLabel => 'от';

  @override
  String get code => 'Проверочный код';

  @override
  String get availability => 'Доступно: ';

  @override
  String get emptyBasketMessage => 'Корзина пуста';

  @override
  String get authBasketMessage => 'Пользователь не авторизован';

  @override
  String get setAnotherEmail => 'Сменить почту';

  @override
  String get emailMessage => 'Email задан неверно';

  @override
  String get emailMessage1 => 'Email уже задан';

  @override
  String get emailMessage2 => 'Пользователь не авторизован';

  @override
  String get emailSuccess => 'Email успешно подтвержден';

  @override
  String get codeMessage => 'Проверочный код задан неверно';

  @override
  String get hint1 => '*Входные билеты бронируются при переходе в корзину';

  @override
  String get hint2 => ' не при выборе билетов';

  @override
  String get hint3 => ' (с помощью кнопки +),';

  @override
  String get hint4 => ' а при переходе в корзину';

  @override
  String get hint5 => '. Пожалуйста, учитывайте это при покупке.';

  @override
  String get mHint1 => 'Резервирование происходит';

  @override
  String get serviceCharge => 'Сервисный сбор';

  @override
  String get totalSum => 'Сумма заказа';

  @override
  String get payButton => 'Оплатить';

  @override
  String get clearAllButton => 'Очистить';

  @override
  String get agreementStart => 'Я прочитал(a) и принимаю условия ';

  @override
  String get agreementEnd => 'пользовательского соглашения';

  @override
  String get phoneLabel => 'Телефон';

  @override
  String get initialsLabel => 'Ф.И. покупателя';

  @override
  String get birthLabel => 'Дата рождения посетителя';

  @override
  String get documentLabel => 'Документ посетителя';

  @override
  String get promoLabel => 'Промо код';

  @override
  String get successPromoCodeMessage => 'применён';

  @override
  String get successPromoCodesMessage => 'применены';

  @override
  String get failPromoCodeMessage => 'не применён';

  @override
  String get failPromoCodesMessage => 'не применены';

  @override
  String get existPromoCodeMessage => 'уже применён';

  @override
  String get existPromoCodesMessage => 'уже применены';

  @override
  String get memoContent =>
      'Перед покупкой, подтвердите свой адрес email с помощью проверочного кода (придет на указанный адрес)';

  @override
  String get confirmMemo => 'Введите проверочный код из письма';

  @override
  String get fullNameError => 'Пожалуйста, укажите имя и фамилию';

  @override
  String get phoneError => 'Заполните поле Телефон';

  @override
  String get promoHint => 'Поле для промо кодов не заполнено';

  @override
  String get validMobileHint => 'Номер задан неверно';

  @override
  String get createOrderError => 'Ошибка создания заказа';
}
