import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

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

  static Future<void> addDependenciesInteractively(List selected) async{
      final pubspec = File('pubspec.yaml');
    if (!pubspec.existsSync()) {
      print('❌ File pubspec.yaml non trovato.');
      return;
    }

    final sink = pubspec.openWrite(mode: FileMode.append);

    for (final lib in selected) {
      final version = await _getLatestVersion(lib);
      if (version != null) {
        sink.writeln('$lib: ^$version');
        print('✅ Aggiunto $lib:^$version');
      } else {
        print('⚠️  Impossibile trovare la versione di $lib');
      }
    }

    await sink.flush();
    await sink.close();

    print('\n📦 Eseguo `dart pub get`...\n');
    final result = await Process.run('dart', ['pub', 'get']);
    stdout.write(result.stdout);
    stderr.write(result.stderr);
  }
  static Future<String?> _getLatestVersion(String package) async {
    try {
      final res = await http.get(Uri.parse('https://pub.dev/api/packages/$package'));
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
