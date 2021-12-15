import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../data/model/event.dart';
import '../../data/repository/event_repository.dart';
import 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  final EventRepository eventRepository;

  EventCubit(this.eventRepository)
      : super(
          EventState(
            isEditing: false,
            isSelected: false,
            isMarked: false,
            isAllMarked: false,
            isSearching: false,
            isCategoryListOpened: false,
            searchData: '',
            selectedEventIndex: -1,
            selectedPage: -1,
            selectedImage: '',
            selectedCategoryIndex: -1,
            eventList: [],
            pageId: '',
          ),
        );

  void init(String pageId) {
    setPageId(pageId);
    showAllEvents();
    closeCategoryList();
  }

  void setIsSearching() {
    emit(
      state.copyWith(
        isSearching: true,
      ),
    );
  }

  void setFinishSearching() {
    emit(
      state.copyWith(
        isSearching: false,
        searchData: '',
      ),
    );
  }

  void setPageId(String pageId) {
    emit(
      state.copyWith(
        pageId: pageId,
      ),
    );
  }

  void setSelectedImage(String selectedImage) {
    emit(
      state.copyWith(
        selectedImage: selectedImage,
      ),
    );
  }

  void setCategoryIndex(int selectedCategoryIndex) {
    emit(
      state.copyWith(
        selectedCategoryIndex: selectedCategoryIndex,
      ),
    );
  }

  void setCategoryInitialIndex() {
    emit(
      state.copyWith(
        selectedCategoryIndex: -1,
      ),
    );
  }

  void setIndexOfSelectedPage(int index) => emit(
        state.copyWith(selectedPage: index),
      );

  void openCategoryList() {
    emit(
      state.copyWith(
        isCategoryListOpened: true,
      ),
    );
  }

  void closeCategoryList() {
    emit(
      state.copyWith(
        isCategoryListOpened: false,
      ),
    );
  }

  void unselectEvent() async {
    for (var i = 0; i < state.eventList.length; i++) {
      if (state.eventList[i].isSelected) {
        final unSelectedEvent = state.eventList[i].copyWith(
          isSelected: false,
        );
        eventRepository.updateEvent(unSelectedEvent);
      }
    }
    showAllEvents();
    emit(
      state.copyWith(
        isSelected: false,
      ),
    );
  }

  void selectEvent(int eventIndex) {
    final selectedEvent = state.eventList[eventIndex].copyWith(
      isSelected: !state.eventList[eventIndex].isSelected,
    );
    eventRepository.updateEvent(selectedEvent);
    showAllEvents();
    emit(
      state.copyWith(
        isSelected: true,
        selectedEventIndex: eventIndex,
      ),
    );
  }

  void searchEvent(String text) {
    emit(
      state.copyWith(
        searchData: text,
      ),
    );
  }

  void showSearchedEvents(String text) async {
    final searchedEvents = await eventRepository.fetchEventList();
    //  await eventRepository.fetchSearchedEventList(state.pageId, text);
    emit(
      state.copyWith(
        eventList: searchedEvents,
      ),
    );
  }

  void showMarkedEvents(bool isAllMarked) async {
    final markedList = await eventRepository.fetchEventList();
    var markedListByPageId = <Event>[];
    if (isAllMarked) {
      markedListByPageId = markedList
          .where(
              (event) => event.pageId == state.pageId && event.isMarked == true)
          .toList();
      markedListByPageId
          .sort((a, b) => a.creationDate.compareTo(b.creationDate));
      //markedList = await eventRepository.fetchMarkedAllEventList(state.pageId);
    } else {
      final markedList = await eventRepository.fetchEventList();
      markedListByPageId =
          markedList.where((event) => event.pageId == state.pageId).toList();
      markedListByPageId
          .sort((a, b) => a.creationDate.compareTo(b.creationDate));
      //markedList = await eventRepository.fetchEventList(state.pageId);
    }
    emit(
      state.copyWith(
        eventList: markedListByPageId,
        isAllMarked: isAllMarked,
      ),
    );
  }

  void markEvent(int index) {
    final markedEvent = state.eventList[index].copyWith(
      isMarked: !state.eventList[index].isMarked,
    );
    eventRepository.updateEvent(markedEvent);
    showAllEvents();
  }

  void showAllEvents() async {
    final eventList = await eventRepository.fetchEventList();
    final eventListByPageId =
        eventList.where((event) => event.pageId == state.pageId).toList();
    eventListByPageId.sort((a, b) => a.creationDate.compareTo(b.creationDate));
    emit(
      state.copyWith(
        eventList: eventListByPageId,
      ),
    );
  }

  void addEditedEvent(String eventText) {
    var editedEvent = state.eventList[state.selectedEventIndex].copyWith(
      eventData: eventText,
    );
    eventRepository.updateEvent(editedEvent);
    emit(
      state.copyWith(
        isEditing: false,
        isSelected: false,
        selectedEventIndex: -1,
      ),
    );
    showAllEvents();
  }

  void deleteEvent(Event event) {
    eventRepository.deleteEvent(event);
    showAllEvents();
  }

  void addEvent(
      [String text = '', int? categoryIconIndex, String categoryName = '']) {
    final event = Event(
      id: const Uuid().v4(),
      eventData: text,
      imagePath: state.selectedImage,
      categoryIcon: categoryIconIndex,
      categoryName: categoryName,
      creationDate: DateTime.now(),
      pageId: state.pageId,
      isSelected: false,
      isMarked: false,
    );
    eventRepository.insertEvent(event);
    if (state.selectedImage.isNotEmpty) {
      eventRepository.addImageEvent(event.id, state.selectedImage);
    }
    showAllEvents();
  }

  Future<void> addImageEvent() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    final Event imageEvent;
    if (state.isSelected) {
      imageEvent = state.eventList[state.selectedEventIndex].copyWith(
        imagePath: image!.path,
      );
      eventRepository.updateEvent(imageEvent);
    }
    emit(
      state.copyWith(
        selectedImage: image!.path,
      ),
    );
  }

  void replyEvents(String newPageId) {
    for (var i = 0; i < state.eventList.length; i++) {
      if (state.eventList[i].isSelected) {
        final eventToReply = state.eventList[i].copyWith(
          pageId: newPageId,
          isSelected: false,
        );
        eventRepository.updateEvent(eventToReply);
      }
    }
    emit(
      state.copyWith(
        isSelected: false,
      ),
    );
    showAllEvents();
  }

  void delete() async {
    final selectedList = await eventRepository.fetchEventList();
    final selectedListByPageId =
        selectedList.where((event) => event.isSelected == true).toList();
    //final selectedList = await eventRepository.fetchSelectedEventList();
    for (final event in selectedListByPageId) {
      eventRepository.deleteEvent(event);
    }
    showAllEvents();
    emit(
      state.copyWith(
        eventList: state.eventList,
      ),
    );
  }

  void copy() {
    final selectedList =
        state.eventList.where((element) => element.isSelected).toList();
    final buffer = StringBuffer();
    for (final event in selectedList) {
      buffer.writeln(event.eventData);
      buffer.writeln(event.imagePath);
    }
    Clipboard.setData(
      ClipboardData(text: buffer.toString()),
    );
  }

  String edit(int eventIndex) {
    emit(
      state.copyWith(
        isEditing: true,
        selectedEventIndex: eventIndex,
      ),
    );
    return state.eventList[eventIndex].eventData;
  }
}
