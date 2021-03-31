import '../event.dart';
import '../note.dart';

class StatesEventPage {
  List<Event> currentEventsList = [];
  Note note;
  int selectedIconIndex;
  bool isEventSelected = false;
  bool isEditing = false;
  bool isSearch = false;
  bool isAddingPhoto = false;
  bool isSendPhotoButton = true;
  bool isDateTimeModification = false;
  bool isBubbleAlignment = false;
  bool isCenterDateBubble = false;
  int selectedItemIndex = 0;
  int selectedPageReplyIndex = 0;
  String selectedDate;
  String selectedTime;

  StatesEventPage copyWith({
    List<Event> currentEventsList,
    Note note,
    String selectedDate,
    String selectedTime,
    int selectedIconIndex,
    bool isDateTimeModification,
    bool isBubbleAlignment,
    bool isCenterDateBubble,
    bool isEventSelected,
    bool isEditing,
    bool isAddingPhoto,
    bool isSendPhotoButton,
    bool isSearch,
    int selectedItemIndex,
    int selectedPageReplyIndex,
  }) {
    var state = StatesEventPage(note ?? this.note);
    state.currentEventsList = currentEventsList ?? this.currentEventsList;
    state.selectedIconIndex = selectedIconIndex ?? this.selectedIconIndex;
    state.isEventSelected = isEventSelected ?? this.isEventSelected;
    state.selectedDate = selectedDate ?? this.selectedDate;
    state.selectedTime = selectedTime ?? this.selectedTime;
    state.isDateTimeModification =
        isDateTimeModification ?? this.isDateTimeModification;
    state.isBubbleAlignment = isBubbleAlignment ?? this.isBubbleAlignment;
    state.isCenterDateBubble = isCenterDateBubble ?? this.isCenterDateBubble;
    state.isEditing = isEditing ?? this.isEditing;
    state.isAddingPhoto = isAddingPhoto ?? this.isAddingPhoto;
    state.isSendPhotoButton = isSendPhotoButton ?? this.isSendPhotoButton;
    state.isSearch = isSearch ?? this.isSearch;
    state.selectedItemIndex = selectedItemIndex ?? this.selectedItemIndex;
    state.selectedPageReplyIndex =
        selectedPageReplyIndex ?? this.selectedPageReplyIndex;
    return state;
  }

  StatesEventPage(this.note);
}
