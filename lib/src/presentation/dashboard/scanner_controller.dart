import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scanner_controller.g.dart';

@riverpod
class ScannerController extends _$ScannerController {
  final _imagePicker = ImagePicker();

  @override
  FutureOr<String?> build() {
    // Initial state is no text recognized yet
    return null;
  }

  Future<void> scanDocument() async {
    try {
      // 1. Pick image from camera
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.camera);
      
      if (image == null) {
        // User cancelled camera
        return;
      }

      // 2. Set state to Loading to show processing UI (Skeleton/Pulse)
      state = const AsyncLoading();

      // 3. Initialize ML Kit TextRecognizer
      final inputImage = InputImage.fromFilePath(image.path);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin); // Or cyrillic if needed, but latin is default. We'll use default. 
      // Note: for Russian/Kazakh we might need specific scripts if supported, but default Latin+Cyrillic works in V2 models.
      
      // 4. Process Image
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      
      // 5. Build final string
      final String extractedText = recognizedText.text;
      
      // 6. Close the recognizer to prevent memory leaks
      await textRecognizer.close();

      // 7. Update state with the result
      state = AsyncData(extractedText);

    } catch (e, st) {
      // Throw clear exception so UI can capture via ref.listen
      state = AsyncError(Exception('Не удалось распознать текст: $e'), st);
    }
  }

  void reset() {
    state = const AsyncData(null);
  }
}
