import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/event_repository.dart';
import '../../data/models/event.dart';
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
      pageId: -1,
    ),
  );

  void init(int pageId) {
    setPageId(pageId);
    showAllEvents();
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

  void setPageId(int pageId) {
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

  void setIndexOfSelectedPage(int index) =>
      emit(
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

  void unselectEvent() {
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
    eventRepository.deleteEvent(state.eventList[eventIndex]);
    eventRepository.insertEvent(eventIndex, selectedEvent);
    showAllEvents();
    emit(
      state.copyWith(
        isSelected: true,
        selectedEventIndex: eventIndex,
      ),
    );
    final selectedList =
    state.eventList.where((element) => element.isSelected).toList();
    if (selectedList.isEmpty) unselectEvent();
  }

  void searchEvent(String text) {
    emit(
      state.copyWith(
        searchData: text,
      ),
    );
  }

  void showSearchedEvents(String text) {
    final searchedEvents = eventRepository
        .eventsListByPageId(state.pageId)
        .where((element) => element.eventData.contains(text))
        .toList();
    emit(
      state.copyWith(
        eventList: searchedEvents,
      ),
    );
  }

  void showMarkedEvents(bool isAllMarked) {
    final List<Event> markedList;
    if (isAllMarked) {
      markedList = eventRepository
          .eventsListByPageId(state.pageId)
          .where((element) => element.isMarked)
          .toList();
    } else {
      markedList = eventRepository.eventsListByPageId(state.pageId).toList();
    }
    emit(state.copyWith(eventList: markedList, isAllMarked: isAllMarked));
  }

  void markEvent(int index) {
    final markedEvent = state.eventList[index].copyWith(
      isMarked: !state.eventList[index].isMarked,
    );
    eventRepository.deleteEvent(state.eventList[index]);
    eventRepository.insertEvent(index, markedEvent);
    showAllEvents();
  }

  void showAllEvents() {
    final List<Event> eventList;
    eventList = eventRepository.eventsListByPageId(state.pageId);
    emit(
      state.copyWith(
        eventList: eventList,
      ),
    );
  }

  void addEditedEvent(String eventText) {
    var newEvent = state.eventList[state.selectedEventIndex].copyWith(
      eventData: eventText,
    );
    eventRepository.deleteEvent(state.eventList[state.selectedEventIndex]);
    eventRepository.insertEvent(state.selectedEventIndex, newEvent);
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
      [String text = '', IconData? categoryIcon, String categoryName = '']) {
    final event = Event(
      id: eventRepository
          .eventsList()
          .length + 1,
      eventData: text,
      imagePath: state.selectedImage,
      categoryIcon: categoryIcon,
      categoryName: categoryName,
      creationDate: DateTime.now(),
      pageId: state.pageId,
      isSelected: false,
      isMarked: false,
    );
    eventRepository.addEvent(event);
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
      eventRepository.deleteEvent(state.eventList[state.selectedEventIndex]);
      eventRepository.insertEvent(state.selectedEventIndex, imageEvent);
    }
    emit(
      state.copyWith(
        selectedImage: image!.path,
      ),
    );
  }

  void replyEvents(int newPageId) {
    for (var i = 0; i < state.eventList.length; i++) {
      if (state.eventList[i].isSelected) {
        final eventToDelete = state.eventList[i];
        final eventToMove = state.eventList[i].copyWith(
          pageId: newPageId,
          id: state.eventList.length + 1,
        );
        eventRepository.deleteEvent(eventToDelete);
        eventRepository.addEvent(eventToMove);
      }
    }
    emit(
      state.copyWith(
        isSelected: false,
      ),
    );
    showAllEvents();
  }

  void delete(List<Event> selectedList) {
    for (var el in selectedList) {
      eventRepository.deleteEvent(el);
    }
    showAllEvents();
  }

  void copy() {
    final selectedList =
    state.eventList.where((element) => element.isSelected).toList();
    final buffer = StringBuffer();
    for (var el in selectedList) {
      buffer.writeln(el.eventData);
      buffer.writeln(el.imagePath);
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
