part of 'screen_message_cubit.dart';

enum Mode { await, input, selection, edit }

enum FloatingBar { nothing, category, photosOption, tag, attach }

enum ModeListTag { listTags, newTag, nothing }

class ScreenMessageState extends Equatable {
  final ModelPage page;
  final Mode mode;
  final List<ModelMessage> list;
  final int counter;
  final bool isBookmark;
  final bool enabledController;
  final FloatingBar floatingBar;
  final DateTime fromDate;
  final TimeOfDay fromTime;
  final bool isReset;
  final int indexCategory;
  final Function onAddCategory;
  final IconData iconDataPhoto;
  final Function onAddMessage;
  final ModeListTag listTag;
  final String curTag;
  final List<ModelTag> tags;
  final String attachedPhotoPath;

  const ScreenMessageState({
    this.fromDate,
    this.fromTime,
    this.isReset,
    this.page,
    this.counter,
    this.mode,
    this.list,
    this.isBookmark,
    this.enabledController,
    this.floatingBar,
    this.indexCategory,
    this.onAddCategory,
    this.iconDataPhoto,
    this.onAddMessage,
    this.listTag,
    this.curTag,
    this.tags,
    this.attachedPhotoPath = '',
  });

  @override
  String toString() {
    return 'ScreenMessageState{appBar: $mode, list: $list,'
        ' counter: $counter, isBookmark: $isBookmark,'
        ' enabledController: $enabledController,'
        ' onAdd: $onAddMessage}\n';
  }

  ScreenMessageState copyWith({
    final ModelPage page,
    final Mode mode,
    final List<ModelMessage> list,
    final int counter,
    final bool isBookmark,
    final bool enabledController,
    final FloatingBar floatingBar,
    final DateTime fromDate,
    final TimeOfDay fromTime,
    final bool isReset,
    final int indexCategory,
    final Function onAddCategory,
    final IconData iconDataPhoto,
    final Function onAddMessage,
    final ModeListTag listTag,
    final String curTag,
    final List<ModelTag> tags,
    final String attachedPhotoPath,
  }) {
    return ScreenMessageState(
      fromDate: fromDate ?? this.fromDate,
      fromTime: fromTime ?? this.fromTime,
      isReset: isReset ?? this.isReset,
      page: page ?? this.page,
      mode: mode ?? this.mode,
      list: list ?? this.list,
      counter: counter ?? this.counter,
      isBookmark: isBookmark ?? this.isBookmark,
      enabledController: enabledController ?? this.enabledController,
      floatingBar: floatingBar ?? this.floatingBar,
      indexCategory: indexCategory ?? this.indexCategory,
      onAddCategory: onAddCategory ?? this.onAddCategory,
      iconDataPhoto: iconDataPhoto ?? this.iconDataPhoto,
      onAddMessage: onAddMessage ?? this.onAddMessage,
      listTag: listTag ?? this.listTag,
      curTag: curTag ?? this.curTag,
      tags: tags ?? this.tags,
      attachedPhotoPath: attachedPhotoPath ?? this.attachedPhotoPath,
    );
  }

  @override
  List<Object> get props => [
        mode,
        counter,
        list,
        isBookmark,
        enabledController,
        floatingBar,
        indexCategory,
        onAddCategory,
        iconDataPhoto,
        onAddMessage,
        fromTime,
        fromDate,
        isReset,
        listTag,
        curTag,
        tags,
        attachedPhotoPath,
      ];
}
