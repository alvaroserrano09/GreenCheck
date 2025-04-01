import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class FileReader {
  Future<String> readFile(PlatformFile file) async {
    if (kIsWeb) {
      if (file.bytes == null) throw Exception('Could not read file bytes');
      return utf8.decode(file.bytes!);
    } else {
      if (file.path == null) throw Exception('File path not available');
      return await File(file.path!).readAsString();
    }
  }
}
