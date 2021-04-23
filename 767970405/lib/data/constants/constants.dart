enum TypeFontSize { def, small, large }

enum TypeFontFamily { roboto, robotoMono }

enum TypeTab { pages, tags, labels, other }

enum ModeFilter { wait, complete }

enum ModeFilterScreen { statisticFilter, timelineFilter }

enum TypeAccentColor { gold, cyan, mint, lime, pink, green, orange }

enum Mode { await, input, selection, edit }

enum FloatingBar { nothing, category, photosOption, tag, attach }

enum ModeListTag { listTags, newTag, nothing }

enum ResultSearch { found, notFound, wait }

enum ModeScreen { allPages, onePage }

enum TypeStatistic { labels, mood, charts, times, summary }

enum TypeTimeDiagram { today, pastSevenDays, pastThirtyDays, thisYear }

const double kSmall = 0.8;
const double kLarge = 1.2;

class DefaultFontSize {
  static const double titleText = 18.0;
  static const double bodyText = 14.0;
  static const double floatingWindowText = 14.0;
  static const double appBarTitle = 20.0;
}
