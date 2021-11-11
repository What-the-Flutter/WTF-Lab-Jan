import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:uuid/uuid.dart';

import '../../../model/chat_page.dart';
import '../../home/controller/home_controller.dart';

class AddChatPageController extends GetxController {
  late ChatPage page;

  RxString title = 'Create new page'.obs;

  RxBool _pageParamsStatus = false.obs;
  RxBool _isEditMode = false.obs;

  int? iconSelected;

  late int pageIndex;

  RxList<IconData> icons = <IconData>[].obs;
  Rx<TextEditingController> pageTitleController = TextEditingController().obs;
  final _homeController = Get.find<HomeController>();

  bool get status => _pageParamsStatus.value;

  AddChatPageController() {
    icons.add(LineIcons.home);
    icons.add(LineIcons.accusoft);
    icons.add(LineIcons.addressBook);
    icons.add(LineIcons.adobe);
    icons.add(LineIcons.youtube);
    icons.add(LineIcons.yelp);
    icons.add(LineIcons.accessibleIcon);
    icons.add(LineIcons.yoast);
    icons.add(LineIcons.yandex);
    icons.add(LineIcons.airFreshener);
    icons.add(LineIcons.adjust);
    icons.add(LineIcons.yahooLogo);
    icons.add(LineIcons.addressCard);
    icons.add(LineIcons.airbnb);
    icons.add(LineIcons.alipay);
    icons.add(LineIcons.alternateMobile);
    icons.add(LineIcons.book);
    icons.add(LineIcons.atom);

    final arguments = Get.arguments;
    if (arguments != null) {
      pageIndex = arguments[0];
      page = arguments[1];
      editMode();
    }
  }

  void editMode() {
    for (var i = 0; i < icons.length; i++) {
      if (icons[i] == page.icon) {
        iconSelected = i;
      }
    }
    title = 'Edit page'.obs;
    pageTitleController.value.text = page.title;
    _isEditMode = true.obs;
  }

  void checkPageParams() {
    if (pageTitleController.value.text.length >= 3 && iconSelected != null) {
      _pageParamsStatus.update((val) => _pageParamsStatus = true.obs);
    } else {
      _pageParamsStatus.update((val) => _pageParamsStatus = false.obs);
    }
    _pageParamsStatus.refresh();
  }

  void addChatPage() {
    if (_isEditMode.isFalse) {
      var page = ChatPage(
        id: const Uuid().v1(),
        title: pageTitleController.value.text,
        icon: icons[iconSelected!],
        createdTime: DateTime.now(),
        lastUpdate: DateTime.now(),
      );

      _homeController.chatPageList.add(page);
    } else {
      page.lastUpdate = DateTime.now();
      page.icon = icons[iconSelected!];
      page.title = pageTitleController.value.text;
      _homeController.chatPageList[pageIndex] = page;
    }
  }

  void selectIcon(int index) {
    iconSelected = index;
    icons.refresh();
  }
}
