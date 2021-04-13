import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../charts/time_statistics/cubit/timestatistics_cubit.dart';

class SelectPeriodDropdownButton extends StatefulWidget {
  @override
  _SelectPeriodDropdownButtonState createState() =>
      _SelectPeriodDropdownButtonState();
}

class _SelectPeriodDropdownButtonState
    extends State<SelectPeriodDropdownButton> {
  List<SelectPeriodDropdownMenuItem> menuItems;
  SelectPeriodDropdownMenuItem _currentItem;

  @override
  void initState() {
    super.initState();
    menuItems = getDropdownItemsList(context);
    _currentItem = menuItems.first;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).buttonColor,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: DropdownButton<SelectPeriodDropdownMenuItem>(
            underline: SizedBox(
              height: 0,
            ),
            iconEnabledColor: Theme.of(context).accentColor,
            dropdownColor: Theme.of(context).buttonColor,
            value: _currentItem,
            icon: Icon(Icons.access_time),
            items: menuItems
                .map((e) => DropdownMenuItem(child: Text(e.name), value: e))
                .toList(),
            onChanged: (value) {
              setState(() {
                _currentItem = value;
              });
              value.onSelect();
            },
          ),
        ),
      ),
    );
  }
}

List<SelectPeriodDropdownMenuItem> getDropdownItemsList(BuildContext context) {
  return [
    SelectPeriodDropdownMenuItem(
      name: 'Week',
      onSelect: () => context.read<TimestatisticsCubit>().loadChart(),
    ),
    SelectPeriodDropdownMenuItem(
      name: 'Month',
      onSelect: () => context.read<TimestatisticsCubit>().loadMonthChart(),
    )
  ];
}

class SelectPeriodDropdownMenuItem {
  final String name;
  final void Function() onSelect;

  SelectPeriodDropdownMenuItem({this.name, this.onSelect});
}
