part of 'app_bar_cubit.dart';

@immutable
abstract class AppBarState {
  final Operation mode;
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
  AppBarInput({String title, Function onBack, Function onSearch})
      : super(
          leading: Action(
            icon: Icons.arrow_back,
            onTap: onBack,
          ),
          title: title,
          actions: [
            Action(
              icon: Icons.bookmark,
            ),
            Action(
              icon: Icons.search,
              onTap: onSearch,
            ),
          ],
          mode: Operation.input,
        );
}

class AppBarSelected extends AppBarState {
  AppBarSelected({
    Function onClose,
    String title,
    Function onShare,
    Function onFavor,
    Function onCopy,
    Function onEdit,
    Function onDelete,
    int countMessages,
  }) : super(
          leading: Action(
            icon: Icons.close,
            onTap: onClose,
          ),
          title: title,
          actions: [
            Action(
              icon: Icons.copy,
              onTap: onCopy,
            ),
            Action(
              icon: Icons.delete,
              onTap: onDelete,
            ),
          ],
          mode: Operation.selection,
        );
}

class AppBarEdit extends AppBarState {
  AppBarEdit({
    Function onClose,
    String title,
    Function onShare,
    Function onEdit,
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
              icon: Icons.copy,
              onTap: onCopy,
            ),
            Action(
              icon: Icons.delete,
              onTap: onDelete,
            ),
          ],
          mode: Operation.edit,
        );
}

class Action {
  final IconData icon;
  final Function onTap;

  Action({this.icon, this.onTap});
}
