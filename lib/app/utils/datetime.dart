import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getFormatDate(DateTime date) {
  return '${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

String getFormatTime(TimeOfDay time) {
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

String getFormatDateTime(DateTime date) {
  return date.toString().substring(0, 19);
}

String getWeekdayDisplayName(BuildContext context, int weekday) {
  switch (weekday) {
    case 1:
      return AppLocalizations.of(context)!.weekday_1;
    case 2:
      return AppLocalizations.of(context)!.weekday_2;
    case 3:
      return AppLocalizations.of(context)!.weekday_3;
    case 4:
      return AppLocalizations.of(context)!.weekday_4;
    case 5:
      return AppLocalizations.of(context)!.weekday_5;
    case 6:
      return AppLocalizations.of(context)!.weekday_6;
    case 7:
      return AppLocalizations.of(context)!.weekday_7;
    default:
      throw ArgumentError('Invalid weekday: $weekday');
  }
}

String getWeekdayMinDisplayName(BuildContext context, int weekday) {
  switch (weekday) {
    case 1:
      return AppLocalizations.of(context)!.weekday_min_1;
    case 2:
      return AppLocalizations.of(context)!.weekday_min_2;
    case 3:
      return AppLocalizations.of(context)!.weekday_min_3;
    case 4:
      return AppLocalizations.of(context)!.weekday_min_4;
    case 5:
      return AppLocalizations.of(context)!.weekday_min_5;
    case 6:
      return AppLocalizations.of(context)!.weekday_min_6;
    case 7:
      return AppLocalizations.of(context)!.weekday_min_7;
    default:
      throw ArgumentError('Invalid weekday: $weekday');
  }
}

String getCacheFormatDate(DateTime date) {
  final num = date.year * 10000 + date.month * 100 + date.day;
  return '$num';
}

(int, int)? getTimeFromString(String str) {
  final time = str.split(':');
  final hour = int.tryParse(time[0]);
  final minute = int.tryParse(time[1]);
  if (hour == null || minute == null) return null;
  return (hour, minute);
}
