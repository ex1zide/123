import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contract_analyzer_controller.g.dart';

// ────────────────────── State Model ──────────────────────

/// Represents the result of contract AI analysis.
class ContractAnalysisResult {
  const ContractAnalysisResult({
    required this.summary,
    required this.risks,
    required this.isClean,
  });

  /// Full AI response text.
  final String summary;

  /// Individual risk items extracted from the response.
  final List<String> risks;

  /// True if no risks were found.
  final bool isClean;
}

// ────────────────────── Controller ──────────────────────

/// Manages the contract analyzer lifecycle:
/// 1. Pick file (PDF/Image)
/// 2. Extract text (ML Kit for images, raw bytes for PDF)
/// 3. Send to Cloud Function `analyzeContract`
/// 4. Return structured AI analysis
@riverpod
class ContractAnalyzerController extends _$ContractAnalyzerController {
  @override
  FutureOr<ContractAnalysisResult?> build() => null;

  /// Pick image from gallery and analyze.
  Future<void> pickImageAndAnalyze() async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.gallery);
    if (xFile == null) return;

    state = const AsyncLoading<ContractAnalysisResult?>().copyWithPrevious(
      const AsyncData(null),
    );

    try {
      String extractedText;

      if (kIsWeb) {
        // ML Kit not available on Web — send raw bytes to Cloud Function
        final bytes = await xFile.readAsBytes();
        extractedText = '[IMAGE_BYTES:${bytes.length}]'; // Placeholder; server can do OCR
        // For web, we still try to send what we have
        throw Exception('OCR на Web не поддерживается. Загрузите PDF-файл.');
      } else {
        // Native: use ML Kit for text recognition
        final inputImage = InputImage.fromFilePath(xFile.path);
        final recognizer = TextRecognizer();
        final recognized = await recognizer.processImage(inputImage);
        await recognizer.close();
        extractedText = recognized.text;
      }

      if (extractedText.trim().isEmpty) {
        throw Exception('Не удалось распознать текст. Попробуйте более чёткое фото.');
      }

      await _analyzeWithAI(extractedText);
    } catch (e, st) {
      state = AsyncError<ContractAnalysisResult?>(e, st);
    }
  }

  /// Pick PDF and analyze.
  Future<void> pickPdfAndAnalyze() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    state = const AsyncLoading<ContractAnalysisResult?>().copyWithPrevious(
      const AsyncData(null),
    );

    try {
      final file = result.files.first;
      final Uint8List? bytes = file.bytes;

      if (bytes == null) {
        throw Exception('Не удалось прочитать PDF-файл.');
      }

      // Send base64 PDF bytes to Cloud Function for server-side extraction
      final base64Pdf = Uri.encodeFull(String.fromCharCodes(bytes));
      // For large files we send raw text extraction request to server
      await _analyzeWithAI('[PDF_FILE:${file.name}]', pdfBytes: bytes);
    } catch (e, st) {
      state = AsyncError<ContractAnalysisResult?>(e, st);
    }
  }

  /// Sends extracted text to Cloud Function for AI analysis.
  Future<void> _analyzeWithAI(String text, {Uint8List? pdfBytes}) async {
    try {
      final callable = FirebaseFunctions.instance.httpsCallable(
        'analyzeContract',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 60)),
      );

      final result = await callable.call<Map<String, dynamic>>({
        'contractText': text,
        if (pdfBytes != null) 'pdfBase64': base64Encode(pdfBytes),
      });

      final data = result.data;
      final answer = (data['analysis'] as String?) ?? '';
      final risksFound = (data['risksFound'] as bool?) ?? false;
      final risksList = (data['risks'] as List<dynamic>?)
              ?.map((r) => r.toString())
              .toList() ??
          [];

      state = AsyncData(ContractAnalysisResult(
        summary: answer,
        risks: risksList,
        isClean: !risksFound,
      ));
    } on FirebaseFunctionsException catch (e) {
      throw Exception('Ошибка сервера: ${e.message}');
    }
  }

  /// Reset to initial state.
  void reset() {
    state = const AsyncData(null);
  }
}

// Helper
String base64Encode(Uint8List bytes) {
  // Using dart:convert would be cleaner but keeping it simple
  return Uri.encodeFull(String.fromCharCodes(bytes));
}
