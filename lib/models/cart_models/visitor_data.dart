class VisitorData{
  final int seatId;
  final String? name;
  final String? surname;
  final String? middleName;
  final int? documentType;
  final String? documentSeries;
  final String? documentNumber;
  final String? birthdate;

  const VisitorData({
    required this.seatId,
    required this.name,
    required this.surname,
    required this.middleName,
    required this.documentType,
    required this.documentSeries,
    required this.documentNumber,
    required this.birthdate,
  });

  @override
  String toString() {
    return 'VisitorData{seatId: $seatId, name: $name, surname: $surname,'
        ' middleName: $middleName, documentType: $documentType, '
        'documentSeries: $documentSeries, documentNumber: $documentNumber, '
        'birthdate: $birthdate}';
  }


  Map<String, dynamic> toJson() {
    return {
      'seatId': seatId,
      'name': name,
      'surname': surname,
      'middleName': middleName,
      'documentType': documentType,
      'documentSeries': documentSeries,
      'documentNumber': documentNumber,
      'birthdate': birthdate,
    };
  }
}

const Map<int, String> documentTypeMap = {
  1 : 'Паспорт РФ',
  2 : 'Заграничный паспорт',
  3 : 'Временное удостоверение личности',
  4 : 'Военный билет военнослужащих и курсантов',
  5 : 'Удостоверение личности военнослужащего',
  6 : 'Иностранный документ',
  7 : 'Дипломатический паспорт',
  8 : 'Служебный паспорт',
  9 : 'Свидетельство о возвращении из стран СНГ',
  10 : 'Справка о следовании иностранного гр-на (лица без гр-ва) в дип. представительство',
  11 : 'Вид на жительство РФ',
  12 : 'Удостоверение беженца',
  13 : 'Свидетельство беженца',
  14 : 'Свидетельство о рождении',
  15 : 'Разрешение на временное проживание',
  16 : 'Водительское удостоверение',
  17 : 'Карта москвича',
  18 : 'Свидетельство пенсионера',
  19 : 'Банковская карта',
  20 : 'Студенческий билет',
};

const Map<int, bool> documentSerialNumberRequiredMap = {
  1 : true,
  2 : false,
  3 : false,
  4 : true,
  5 : false,
  6 : false,
  7 : false,
  8 : false,
  9 : false,
  10 : false,
  11 : false,
  12 : false,
  13 : false,
  14 : true,
  15 : false,
  16 : false,
  17 : false,
  18 : false,
  19 : false,
  20 : false,
};