class DateFormatter {
  DateFormatter(this._dateTime);
  late final DateTime _dateTime;

  String formatAsDayname() {
    var dayName = '';

    switch (_dateTime.weekday) {
      case DateTime.saturday:
        dayName += 'Zaterdag';
        break;
      case DateTime.sunday:
        dayName += 'Zondag';
        break;
      case DateTime.monday:
        dayName += 'Maandag';
        break;
      case DateTime.tuesday:
        dayName += 'Dinsdag';
        break;
      case DateTime.wednesday:
        dayName += 'Woensdag';
        break;
      case DateTime.thursday:
        dayName += 'Donderdag';
        break;
      case DateTime.friday:
        dayName += 'Vrijdag';
        break;
    }

    return dayName;
  }
}
