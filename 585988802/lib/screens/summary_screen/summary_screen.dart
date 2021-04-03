import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_widgets/custom_drawer.dart';
import '../../db_helper/db_helper.dart';
import '../../models/font_size_customization.dart';
import '../../models/time_series_of_event_messages.dart';
import '../setting_screen/settings_screen_bloc.dart';
import 'summary_bloc.dart';
import 'summary_event.dart';
import 'summary_state.dart';
import 'timing_chart.dart';

class SummaryScreen extends StatefulWidget {
  final String title;

  SummaryScreen({Key key, this.title}) : super(key: key);

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  final DBHelper _dbHelper = DBHelper();

  _SummaryScreenState();

  @override
  void initState() {
    _dbHelper.initializeDatabase();
    BlocProvider.of<SummaryScreenBloc>(context).add(
      SummaryEventMessageListInit(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SummaryScreenBloc, SummaryScreenState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: _appBar,
          drawer: CustomDrawer(),
          body: _summaryScreenBody,
        );
      },
    );
  }

  AppBar get _appBar {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.color,
      iconTheme: Theme.of(context).iconTheme,
      title: Container(
        child: Text(
          'Statistics',
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
            fontSize:
                BlocProvider.of<SettingScreenBloc>(context).state.fontSize == 0
                    ? appBarSmallFontSize
                    : BlocProvider.of<SettingScreenBloc>(context)
                                .state
                                .fontSize ==
                            1
                        ? appBarDefaultFontSize
                        : appBarLargeFontSize,
          ),
        ),
        alignment: Alignment.centerLeft,
      ),
      elevation: 0.0,
    );
  }

  GestureDetector get _summaryScreenBody {
    return GestureDetector(
      onTap: () => FocusScope.of(context).nextFocus(),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                _statisticCard(
                                  'Total',
                                  BlocProvider.of<SummaryScreenBloc>(context)
                                      .state
                                      .countOfAllEventMessages
                                      .toString(),
                                  Colors.green,
                                ),
                                _statisticCard(
                                  'Images',
                                  BlocProvider.of<SummaryScreenBloc>(context)
                                      .state
                                      .countOfImageEventMessages
                                      .toString(),
                                  Colors.blueGrey,
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Row(
                              children: [
                                _statisticCard(
                                  'Labels',
                                  BlocProvider.of<SummaryScreenBloc>(context)
                                      .state
                                      .countOfCategoryEventMessages
                                      .toString(),
                                  Colors.orange,
                                ),
                                _statisticCard(
                                  'Favorites',
                                  BlocProvider.of<SummaryScreenBloc>(context)
                                      .state
                                      .countOfFavoriteEventMessages
                                      .toString(),
                                  Colors.red,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: TimeSeriesChart(
                        eventMessagesList:
                            _timeSeriesOfEventMessagesList(context),
                        isAnimate: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<charts.Series<TimeSeriesOfEventMessages, DateTime>>
      _timeSeriesOfEventMessagesList(BuildContext context) {
    return [
      charts.Series<TimeSeriesOfEventMessages, DateTime>(
        id: 'event_messages',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (eventMessages, _) => eventMessages.time,
        measureFn: (eventMessages, _) => eventMessages.countOfEventMessages,
        data: BlocProvider.of<SummaryScreenBloc>(context)
            .state
            .timeSeriesCountOfEventMessagesList,
      )
    ];
  }

  Expanded _statisticCard(String title, String count, MaterialColor color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              count,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
