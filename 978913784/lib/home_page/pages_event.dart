import '../page.dart';

abstract class PagesEvent {
  const PagesEvent();
}

class PageAdded extends PagesEvent {
  final JournalPage page;

  const PageAdded(this.page);
}

class PagePinned extends PagesEvent {
  final JournalPage page;

  const PagePinned(this.page);
}

class PageEdited extends PagesEvent {
  final JournalPage page;
  final JournalPage editedPage;

  const PageEdited(this.page,this.editedPage);
}

class PageUpdated extends PagesEvent {
  const PageUpdated();
}

class PageDeleted extends PagesEvent {
  final JournalPage page;

  const PageDeleted(this.page);
}

class ForwardAccepted extends PagesEvent {
  final JournalPage page;
  final Set<Event> forwarded;

  const ForwardAccepted(this.page, this.forwarded);
}
