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
        break;
      case DateTime.sunday:
        dayName += AppLocalizations.of(_context)!.programSunday;
        break;
      case DateTime.monday:
        dayName += AppLocalizations.of(_context)!.programMonday;
        break;
      case DateTime.tuesday:
        dayName += AppLocalizations.of(_context)!.programTuesday;
        break;
      case DateTime.wednesday:
        dayName += AppLocalizations.of(_context)!.programWednesday;
        break;
      case DateTime.thursday:
        dayName += AppLocalizations.of(_context)!.programThursday;
        break;
      case DateTime.friday:
        dayName += AppLocalizations.of(_context)!.programFriday;
        break;
    }

    return dayName;
  }
}
