import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DateFormatter {
  DateFormatter(this._dateTime, this._context);
  late final DateTime _dateTime;
  late final BuildContext _context;

  String formatAsDayname() {
    var dayName = '';

    switch (_dateTime.weekday) {
      case DateTime.saturday:
        dayName += AppLocalizations.of(_context)!.programSaturday;
      case DateTime.sunday:
        dayName += AppLocalizations.of(_context)!.programSunday;
      case DateTime.monday:
        dayName += AppLocalizations.of(_context)!.programMonday;
      case DateTime.tuesday:
        dayName += AppLocalizations.of(_context)!.programTuesday;
      case DateTime.wednesday:
        dayName += AppLocalizations.of(_context)!.programWednesday;
      case DateTime.thursday:
        dayName += AppLocalizations.of(_context)!.programThursday;
      case DateTime.friday:
        dayName += AppLocalizations.of(_context)!.programFriday;
    }

    return dayName;
  }
}
