import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'background_image_state.dart';

class BackgroundImageCubit extends Cubit<BackgroundImageState> {
  BackgroundImageCubit()
      : super(
          BackgroundImageState(
            imagePath: '',
            isImageSetted: false,
          ),
        );

  void setImage() async {
    final _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    emit(
      state.copyWith(
        imagePath: image!.path,
        isImageSetted: true,
      ),
    );
  }

  void unsetImage() {
    emit(
      state.copyWith(
        imagePath: '',
        isImageSetted: false,
      ),
    );
  }
}
