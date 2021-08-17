import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Theme.of(context).accentColor)),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is InitialSettingsState) {
            return const Center(child: CircularProgressIndicator());
          }
          state as MainSettingsState;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(title: Text('General', style: Theme.of(context).textTheme.subtitle2)),
              SwitchListTile(
                activeColor: Theme.of(context).accentColor,
                activeTrackColor: Theme.of(context).accentColor.withAlpha(80),
                title: const Text('Dark mode'),
                secondary:
                    state.isDarkMode ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode),
                value: state.isDarkMode,
                onChanged: (_) => _bloc.add(const SwitchThemeEvent()),
              ),
              SwitchListTile(
                activeColor: Theme.of(context).accentColor,
                activeTrackColor: Theme.of(context).accentColor.withAlpha(80),
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
                activeTrackColor: Theme.of(context).accentColor.withAlpha(80),
                title: const Text('Date-time modification'),
                subtitle: const Text('Allows manual date-time for a note'),
                secondary: const Icon(Icons.today),
                value: state.isDateTimeModificationEnabled,
                onChanged: (_) => _bloc.add(const UpdateDateTimeModificationEvent()),
              ),
              const Divider(),
              ListTile(title: Text('Security', style: Theme.of(context).textTheme.subtitle2)),
              SwitchListTile(
                activeColor: Theme.of(context).accentColor,
                activeTrackColor: Theme.of(context).accentColor.withAlpha(80),
                title: const Text('Fingerprint'),
                subtitle: const Text('Enable fingerprint unlock'),
                secondary: const Icon(Icons.fingerprint),
                value: state.checkBiometrics == BiometricsCheck.enabled,
                onChanged: state.checkBiometrics == BiometricsCheck.notAvailable
                    ? null
                    : (value) => _bloc.add(UpdateBiometricsEvent(value)),
              ),
            ],
          );
        },
      ),
    );
  }
}
