import 'package:rxdart/rxdart.dart';

class NewEntryBloc {
  DateTime thisInstant = DateTime.now();
  BehaviorSubject<DateTime> _selectedDeadline$;
  BehaviorSubject<DateTime> get selectedDeadline$ => _selectedDeadline$;

  NewEntryBloc() {
    _selectedDeadline$ = BehaviorSubject<DateTime>.seeded(thisInstant);
  }

  void dispose() {
    _selectedDeadline$.close();
  }

  void updateDeadline(DateTime deadline) {
    _selectedDeadline$.add(deadline);
  }
}
