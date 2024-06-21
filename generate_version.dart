// ignore_for_file: avoid_print

import 'dart:io';
import 'package:path/path.dart';

void main() {
  try {
    final pubspecFile = File('pubspec.yaml');
    final pubspecText = pubspecFile.readAsStringSync();
    final versionPattern = RegExp(r'version:\s*(\d+\.\d+\.\d+)');
    final match = versionPattern.firstMatch(pubspecText);
    if (match != null) {
      final version = match.group(1);
      final generatedCode = 'const appVersion = "$version";';
      final outputFilePath = join('lib', 'version.dart');
      final outputFile = File(outputFilePath);
      outputFile.writeAsStringSync(generatedCode);
      print('Generated version.dart with version: $version');
    } else {
      print('Version not found in pubspec.yaml');
    }
  } catch (e) {
    print('Error generating version.dart: $e');
  }
}
