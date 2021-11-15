import 'package:chat_journal/models/chat_model.dart';
import 'package:chat_journal/models/message_model.dart';
import 'package:chat_journal/models/sectionicon_model.dart';

class EventState {
  final List<Message> selected;
  final List<Message> favourites;
  final List<SectionIcon> sectionsList;
  final List<Message> foundList;
  final Chat? currentChat;
  final bool? isAnySelected;
  final bool? isShowFav;
  final bool? searchMode;
  final bool? editMode;
  final int replyChatIndex;
  final Chat? replyChat;
  final bool? isWriting;
  final bool? isNew;
  final bool? showPanel;
  final SectionIcon? selectedSection;

  EventState({
    this.searchMode = false,
    this.editMode = false,
    this.foundList = const [],
    this.selected = const [],
    this.sectionsList = const [],
    this.favourites = const [],
    this.currentChat,
    this.isAnySelected = false,
    this.isShowFav = false,
    this.replyChatIndex = 0,
    this.replyChat,
    this.isNew = true,
    this.isWriting = false,
    this.showPanel = false,
    this.selectedSection = const SectionIcon(
        iconTitle: 'work', title: 'workspaces_filled', id: -1),
  });

  EventState copyWith({
    List<Message>? selected,
    List<Message>? favourites,
    List<SectionIcon>? sectionsList,
    List<Message>? foundList,
    Chat? currentChat,
    bool? isAnySelected,
    bool? isShowFav,
    bool? searchMode,
    bool? editMode,
    int? replyChatIndex,
    Chat? replyChat,
    bool? isWriting,
    bool? isNew,
    bool? showPanel,
    SectionIcon? selectedSection,
  }) {
    return EventState(
      foundList: foundList ?? this.foundList,
      currentChat: currentChat ?? this.currentChat,
      sectionsList: sectionsList ?? this.sectionsList,
      selected: selected ?? this.selected,
      favourites: favourites ?? this.favourites,
      isAnySelected: isAnySelected ?? this.isAnySelected,
      isShowFav: isShowFav ?? this.isShowFav,
      searchMode: searchMode ?? this.searchMode,
      editMode: editMode ?? this.editMode,
      replyChatIndex: replyChatIndex ?? this.replyChatIndex,
      replyChat: replyChat ?? this.replyChat,
      isNew: isNew ?? this.isNew,
      isWriting: isWriting ?? this.isWriting,
      showPanel: showPanel ?? this.showPanel,
      selectedSection: selectedSection ?? this.selectedSection,
    );
  }
}
