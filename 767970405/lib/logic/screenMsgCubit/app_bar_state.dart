part of 'app_bar_cubit.dart';

@immutable
abstract class AppBarState {
  final ModeOperation mode;
  final Action leading;
  final String title;
  final List<Action> actions;

  AppBarState({
    this.mode,
    this.leading,
    this.title,
    this.actions,
  });

  @override
  String toString() {
    return 'AppBarState{mode: $mode, title: $title}';
  }
}

class AppBarInput extends AppBarState {
  AppBarInput(
      {String title, Function onBack, Function onSearch, Function onChange})
      : super(
          leading: Action(
            icon: Icons.arrow_back,
            onTap: onBack,
          ),
          title: title,
          actions: [
            Action(
              icon: Icons.search,
              onTap: onSearch,
            ),
            Action(
              icon: Icons.bookmark_border,
              onTap: onChange,
            ),
          ],
          mode: ModeOperation.input,
        );
}

class AppBarSelected extends AppBarState {
  AppBarSelected({
    Function onClose,
    String title,
    Function onShare,
    Function onEdit,
    Function onFavor,
    Function onCopy,
    Function onDelete,
  }) : super(
          leading: Action(
            icon: Icons.close,
            onTap: onClose,
          ),
          title: title,
          actions: [
            Action(
              icon: Icons.share,
              onTap: onShare,
            ),
            Action(
              icon: Icons.edit,
              onTap: onEdit,
            ),
            Action(
              icon: Icons.bookmark_border,
              onTap: onFavor,
            ),
            Action(
              icon: Icons.copy,
              onTap: onCopy,
            ),
            Action(
              icon: Icons.delete,
              onTap: onDelete,
            ),
          ],
          mode: ModeOperation.selection,
        );
}

class AppBarEdit extends AppBarState {
  AppBarEdit({
    Function onBack,
    String title,
    Function onClose,
  }) : super(
          leading: Action(
            icon: Icons.arrow_back,
            onTap: onBack,
          ),
          title: title,
          actions: [
            Action(
              icon: Icons.close,
              onTap: onClose,
            ),
          ],
          mode: ModeOperation.edit,
        );
}

class Action {
  final IconData icon;
  final Function onTap;

  Action({this.icon, this.onTap});
}
