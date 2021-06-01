import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:network_utils/resource.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ext_storage/ext_storage.dart';

import '../../enities/iwt/iwt_instruction_entity.dart';
import '../../repository/iwt_repository.dart';

part 'iwt_state.dart';

class IwtCubit extends Cubit<IwtState> {
  final IwtRepository _iwtRepository;
  List<IwtInstruction> instructions;

  IwtCubit(this._iwtRepository) : super(IwtInitial());

  void loadInstructions({int accountId}) async {
    instructions = null;
    emit(IwtInstructionsLoadingState());

    await for (final resource in _iwtRepository.loadInstructions(accountId: accountId)) {
      if (resource.status == Status.success) {
        instructions = resource.data;
        emit(IwtInstructionsLoadedState());
        return;
      } else if (resource.status == Status.error) {
        return;
      }
    }
  }

  void saveFile({int accountId, int iwtId}) async {
    emit(IwtFileSaving());
    await for (final resource in _iwtRepository.downloadPdf(accountId: accountId, iwtId: iwtId)) {
      if (resource.status == Status.success) {
        String path;

        if (Platform.isAndroid) {
          path = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
          if (!(await Permission.storage.isGranted)) {
            await Permission.storage.request();
          }
        } else if (Platform.isIOS) {
          path = (await getApplicationDocumentsDirectory()).path;
        }

        final fileName = 'IWT ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}.pdf';
        final file = File('$path/$fileName');
        file.writeAsBytesSync(resource.data, mode: FileMode.writeOnly);

        emit(IwtFileSaved(fileName: fileName));
        return;
      } else if (resource.status == Status.error) {
        emit(IwtFileSaveError());
        return;
      }
    }
  }

  void iwtLoadEvent() {
    /// Stub
  }
}
