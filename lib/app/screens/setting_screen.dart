import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/daily_provider.dart';
import '../providers/language_provider.dart';
import '../providers/setting_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/list_wheel_picker.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final languageOptions = [
    SettingOption(value: 'en', label: 'English'),
    SettingOption(value: 'zh', label: '简体中文'),
  ];

  final patternOptions =
      SettingProvider.datePatterns.map((e) => SettingOption(value: e)).toList();

  @override
  Widget build(BuildContext context) {
    final dailyProvider = context.watch<DailyProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final languageProvider = context.watch<LanguageProvider>();
    final settingProvider = context.watch<SettingProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 8,
            children: [
              Card(
                child: _buildStringItem(
                  title: AppLocalizations.of(context)!.setting_language,
                  setting: languageProvider.languageCode,
                  options: languageOptions,
                  onChanged: (value) {
                    context.read<LanguageProvider>().changeLanguage(
                      Locale(value),
                    );
                  },
                ),
              ),
              Card(
                child: _buildStringItem(
                  title: AppLocalizations.of(context)!.setting_themeMode,
                  setting: themeProvider.modeName,
                  options: [
                    SettingOption(
                      value: ThemeMode.dark.name,
                      label:
                          AppLocalizations.of(context)!.setting_themeMode_dark,
                    ),
                    SettingOption(
                      value: ThemeMode.light.name,
                      label:
                          AppLocalizations.of(context)!.setting_themeMode_light,
                    ),
                    SettingOption(
                      value: ThemeMode.system.name,
                      label:
                          AppLocalizations.of(
                            context,
                          )!.setting_themeMode_system,
                    ),
                  ],
                  onChanged: (value) {
                    context.read<ThemeProvider>().changeMode(value);
                  },
                ),
              ),
              Card(
                child: Column(
                  children: [
                    _buildStringItem(
                      title: AppLocalizations.of(context)!.setting_pattern,
                      setting: settingProvider.datePattern,
                      options: patternOptions,
                      getLabel:
                          (value) => DateFormat(
                            value,
                            languageProvider.languageCode,
                          ).format(dailyProvider.today),
                      onChanged: (value) {
                        context.read<SettingProvider>().changeDatePattern(
                          value,
                        );
                      },
                    ),
                    _buildIntItem(
                      title: AppLocalizations.of(context)!.setting_minCount,
                      setting: settingProvider.minCount,
                      min: 1,
                      max: 30,
                      onChanged: (value) {
                        context.read<SettingProvider>().changeMinCount(value);
                      },
                    ),
                  ],
                ),
              ),
              Card(
                child: _buildItem(
                  title: AppLocalizations.of(context)!.setting_defTime,
                  value: '08:00',
                  readonly: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem({
    required String title,
    required String value,
    void Function()? onTap,
    bool readonly = false,
  }) {
    return ListTile(
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          if (!readonly) const SizedBox(width: 4),
          if (!readonly) const Icon(Icons.arrow_forward_ios, size: 14),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildStringItem({
    required String title,
    String? setting,
    required List<SettingOption> options,
    SettingOptionLabelCallback? getLabel,
    void Function(String value)? onChanged,
  }) {
    String value = '';
    if (setting != null) {
      value =
          getLabel != null
              ? getLabel(setting)
              : options.firstWhere((e) => e.value == setting).label!;
    }
    return _buildItem(
      title: title,
      value: value,
      onTap: () async {
        final result = await _showBottomModal(options, getLabel);
        if (onChanged != null && result != null) onChanged(result);
      },
    );
  }

  Future<String?> _showBottomModal(
    List<SettingOption> options,
    SettingOptionLabelCallback? getLabel,
  ) async {
    return await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(top: 16, bottom: 8),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  options.map((item) {
                    String label = item.value;
                    if (item.label != null) {
                      label = item.label!;
                    } else if (getLabel != null) {
                      label = getLabel(item.value);
                    }
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pop(item.value);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(spacing: 8, children: [Text(label)]),
                      ),
                    );
                  }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIntItem({
    required String title,
    int? setting,
    int max = 99,
    int min = 0,
    void Function(int value)? onChanged,
  }) {
    final String value = setting == null ? '' : '$setting';
    return _buildItem(
      title: title,
      value: value,
      onTap: () async {
        final result = await _showBottomPicker(setting, min, max);
        if (onChanged != null && result != null) onChanged(result);
      },
    );
  }

  Future<int?> _showBottomPicker(int? setting, int min, int max) {
    int value = setting ?? min;
    return showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(top: 8, bottom: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(value);
                    },
                    child: Text(AppLocalizations.of(context)!.save),
                  ),
                  SizedBox(width: 16),
                ],
              ),
              Expanded(
                child: ListWheelPicker(
                  fontSize: 28,
                  min: min,
                  max: max,
                  initialValue: value,
                  onChanged: (v) => value = v,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

typedef SettingOptionLabelCallback = String Function(String value);

class SettingOption {
  String value;
  String? label;

  SettingOption({required this.value, this.label});
}
