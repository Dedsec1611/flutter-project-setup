import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:yaml_edit/yaml_edit.dart';

class DependencyManager {
  static Future<List?> selectDependencies() async {
    final libraries = <String>[
      'http',
      'provider',
      'flutter_bloc',
      'shared_preferences',
      'dio',
      'equatable',
      'get_it',
      'go_router',
      'hive',
      'path_provider',
      'geolocator',
      'permission_handler'
    ];

    print('\n📦 Seleziona le librerie da installare (separa con virgola):');
    for (int i = 0; i < libraries.length; i++) {
      print('${i + 1}. ${libraries[i]}');
    }

    stdout.write('\n> Selezione (es. 1,3,5): ');
    final input = stdin.readLineSync();
    if (input == null || input.trim().isEmpty) return null;

    final indices = input.split(',').map((i) => int.tryParse(i.trim()) ?? -1);
    final selected = indices
        .where((i) => i > 0 && i <= libraries.length)
        .map((i) => libraries[i - 1])
        .toList();
    return selected;
  }

  static Future<void> addDependenciesInteractively(
      List selected, String projectName) async {
    final String projectPath = path.join(Directory.current.path, projectName);
    final pubspec = File(path.join(projectPath, 'pubspec.yaml'));

    if (!pubspec.existsSync()) {
      print(
          '❌ File pubspec.yaml non trovato in: ${path.join(projectPath, 'pubspec.yaml')}');
      return;
    }

    final originalYaml = await pubspec.readAsString();
    final yamlEditor = YamlEditor(originalYaml);

    for (final lib in selected) {
      final version = await _getLatestVersion(lib);
      if (version != null) {
        try {
          yamlEditor.update(['dependencies', lib], '^$version');
          print('✅ Aggiunto $lib: ^$version');
        } catch (e) {
          print('⚠️ Errore durante l\'aggiunta di $lib: $e');
        }
      } else {
        print('⚠️ Impossibile trovare la versione di $lib');
      }
    }

    var resultScript = await pubspec.writeAsString(yamlEditor.toString());
    print('🔍 Result write: ${resultScript}');

    // Esegui pub get nella directory corretta
    print('\n📦 Eseguo `dart pub get`...\n');
    print('🔍 Current dir: ${Directory.current.path}');
    print('📁 Project path: $projectPath');
    final result = await Process.run(
      'dart',
      ['pub', 'get'],
      workingDirectory: projectPath,
    );
    stdout.write(result.stdout);
    stderr.write(result.stderr);
  }

  static Future<String?> _getLatestVersion(String package) async {
    try {
      final res =
          await http.get(Uri.parse('https://pub.dev/api/packages/$package'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        return data['latest']['version'];
      }
    } catch (e) {
      print('Errore recupero versione $package: $e');
    }
    return null;
  }
}
