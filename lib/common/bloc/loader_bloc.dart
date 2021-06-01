import 'package:Velmie/app.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoaderBloc extends Bloc<LoaderEvent, LoaderState> {
  LoaderBloc() : super(LoaderState.stopButtonLoadState);

  @override
  Stream<LoaderState> mapEventToState(LoaderEvent event) async* {
    logger.d(event);
    switch (event) {
      case LoaderEvent.screenLoadEvent:
        yield LoaderState.screenLoadState;
        break;
      case LoaderEvent.stopScreenLoadEvent:
        yield LoaderState.stopScreenLoadState;
        break;
      case LoaderEvent.buttonLoadEvent:
        yield LoaderState.buttonLoadState;
        break;
      case LoaderEvent.stopButtonLoadEvent:
        yield LoaderState.stopButtonLoadState;
        break;
    }
  }
}

enum LoaderEvent {
  screenLoadEvent,
  buttonLoadEvent,
  stopButtonLoadEvent,
  stopScreenLoadEvent,
}

enum LoaderState {
  screenLoadState,
  buttonLoadState,
  stopButtonLoadState,
  stopScreenLoadState,
}
