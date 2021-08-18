import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';

import '../../../utils/constants.dart';
import 'bloc/bloc.dart';
import 'font_size_dialog.dart';

class SettingsContent extends StatefulWidget {
  @override
  _SettingsContentState createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
  late SettingsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<SettingsBloc>();
  }

  void _showFontSizeDialog(MainSettingsState state) async {
    final result = await showDialog<SettingsFontSize>(
      context: context,
      builder: (context) => FontSizePickerDialog(
        initialFontSizeIndex: state.fontSize.index.toDouble(),
        values: SettingsFontSize.values,
      ),
    );
    if (result != null) {
      _bloc.add(UpdateFontSizeEvent(result));
    }
  }

  void _resetSettings() {
    _bloc.add(const ResetSettingsEvent());
  }

  List<Widget> _generalSettings(MainSettingsState state) {
    return [
      ListTile(title: Text('General', style: Theme.of(context).textTheme.subtitle2)),
      SwitchListTile(
        activeColor: Theme.of(context).accentColor,
        activeTrackColor: Theme.of(context).accentColor.withAlpha(Alpha.alpha80),
        title: const Text('Dark mode'),
        secondary: state.isDarkMode ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode),
        value: state.isDarkMode,
        onChanged: (_) => _bloc.add(const SwitchThemeEvent()),
      ),
      SwitchListTile(
        activeColor: Theme.of(context).accentColor,
        activeTrackColor: Theme.of(context).accentColor.withAlpha(Alpha.alpha80),
        title: const Text('Bubble Alignment'),
        subtitle: const Text('Force right-to-left bubble alignment'),
        secondary: state.isRightBubbleAlignment
            ? const Icon(Icons.align_horizontal_right)
            : const Icon(Icons.align_horizontal_left),
        value: state.isRightBubbleAlignment,
        onChanged: (_) => _bloc.add(const UpdateAlignmentEvent()),
      ),
      SwitchListTile(
        activeColor: Theme.of(context).accentColor,
        activeTrackColor: Theme.of(context).accentColor.withAlpha(Alpha.alpha80),
        title: const Text('Date-time modification'),
        subtitle: const Text('Allows manual date-time for a note'),
        secondary: const Icon(Icons.today),
        value: state.isDateTimeModificationEnabled,
        onChanged: (_) => _bloc.add(const UpdateDateTimeModificationEvent()),
      ),
      ListTile(
        title: const Text('Font size'),
        leading: const Icon(Icons.text_fields),
        subtitle: const Text('Small / Normal / Large'),
        onTap: () => _showFontSizeDialog(state),
      )
    ];
  }

  List<Widget> _securitySettings(MainSettingsState state) {
    return [
      ListTile(title: Text('Security', style: Theme.of(context).textTheme.subtitle2)),
      SwitchListTile(
        activeColor: Theme.of(context).accentColor,
        activeTrackColor: Theme.of(context).accentColor.withAlpha(Alpha.alpha80),
        title: const Text('Fingerprint'),
        subtitle: const Text('Enable fingerprint unlock'),
        secondary: const Icon(Icons.fingerprint),
        value: state.checkBiometrics == BiometricsCheck.enabled,
        onChanged: state.checkBiometrics == BiometricsCheck.notAvailable
            ? null
            : (value) => _bloc.add(UpdateBiometricsEvent(value)),
      ),
    ];
  }

  List<Widget> _info() {
    return [
      ListTile(title: Text('Info', style: Theme.of(context).textTheme.subtitle2)),
      GestureDetector(
        onTap: () => Share.share('Keep track of your life with CoolNotes 😆'),
        child: const ListTile(
          leading: Icon(Icons.share_outlined),
          title: Text('Share the app'),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final content;
        if (state is MainSettingsState) {
          content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._generalSettings(state),
              const Divider(),
              ..._securitySettings(state),
              const Divider(),
              ..._info(),
            ],
          );
        } else {
          content = Center(
            child: CircularProgressIndicator(color: Theme.of(context).accentColor),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('Settings', style: Theme.of(context).appBarTheme.titleTextStyle),
            actions: [
              TextButton(
                onPressed:
                    state is MainSettingsState && state.settingsChanged ? _resetSettings : null,
                child: const Text('Reset'),
              )
            ],
          ),
          body: content,
        );
      },
    );
  }
}
