import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:flutter_project_setup/src/commands/create_project.dart';

class ProjectGenerator {
   static Future<void> createProjectStructure(String projectName, String architecture) async {
    final currentDir = Directory.current;
    final projectDir = Directory('${currentDir.path}/$projectName');

    print('🚀 Creazione progetto Flutter: $projectName');
    final result = await Process.run('flutter', ['create', projectName]);

    if (result.exitCode != 0) {
      print('❌ Errore nella creazione del progetto Flutter:');
      print(result.stderr);
      return;
    }

    print(result.stdout);

    if (!projectDir.existsSync()) {
      print('❌ La cartella del progetto non è stata trovata.');
      return;
    }

    print('📁 Creazione struttura architettura: $architecture');

    switch (architecture.toLowerCase()) {
      case 'mvc':
        await _createMvcStructure(projectDir);
        break;
      case 'mvvm':
        await _createMvvmStructure(projectDir);
        break;
      case 'clean':
        await _createCleanArchitecture(projectDir);
        break;
      default:
        print('❌ Architettura non riconosciuta.');
    }

    print('✅ Struttura creata con successo.');
  }

  static Future<void> _createMvcStructure(Directory baseDir) async {
    final libDir = Directory('${baseDir.path}/lib');
    await Directory('${libDir.path}/controllers').create(recursive: true);
    await Directory('${libDir.path}/models').create(recursive: true);
    await Directory('${libDir.path}/views').create(recursive: true);
  }

  static Future<void> _createMvvmStructure(Directory baseDir) async {
    final libDir = Directory('${baseDir.path}/lib');
    await Directory('${libDir.path}/viewmodels').create(recursive: true);
    await Directory('${libDir.path}/models').create(recursive: true);
    await Directory('${libDir.path}/views').create(recursive: true);
  }

  static Future<void> _createCleanArchitecture(Directory baseDir) async {
    final libDir = Directory('${baseDir.path}/lib');
    await Directory('${libDir.path}/core').create(recursive: true);
    await Directory('${libDir.path}/features').create(recursive: true);
    await Directory('${libDir.path}/features/example/data').create(recursive: true);
    await Directory('${libDir.path}/features/example/domain').create(recursive: true);
    await Directory('${libDir.path}/features/example/presentation').create(recursive: true);
  }

  static Future<void> _createDirs(Directory baseDir, List<String> paths) async {
    for (final path in paths) {
      final dir = Directory('${baseDir.path}/$path');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
        print('✅ Creata cartella: ${dir.path}');
      }
    }

    
  }

 static Future createFlutterProject(String projectName, String architecture) async {
  switch (architecture) {
    case 'mvc':
     await cloneRepo('flutter_mvc', projectName,architecture);
      break;
    case 'mvvc':
      await cloneRepo('flutter_mvvc', projectName,architecture);
      break;
    case 'clean':
      await cloneRepo('flutter_clean_arch', projectName,architecture);
      break;
  }
}

}

String getPathModels(String architecture){
switch (architecture) {
    case 'mvc':
      return "lib/models";
    case 'mvvc':
     return "lib/models";
    case 'clean':
      return "lib/data/models";
  }
  return "";
}

// Funzione ricorsiva per generare modelli Dart a partire da un JSON
Future<void> generateModels(dynamic jsonData, String architecture, String projectName) async {
   String currentDirectory = Directory.current.path;
  String projectPath = '$currentDirectory/$projectName';
  if (jsonData is Map<String, dynamic>) {
    // Caso: Oggetto JSON (Map)
    jsonData.forEach((key, value) async {
      if (value is Map || value is List) {
        // Se il valore è un oggetto o una lista, generiamo un modello
        String modelName = key.capitalize();
        String classCode = generateDartClass(value, modelName);
        
        // Salva la classe in un file separato
        String filePath = path.join(projectPath, getPathModels(architecture), '$modelName.dart');
        await createModelFile(filePath, classCode);
        
        print('File generato per la classe $modelName in $filePath');

        // Se il valore è un oggetto o una lista, chiamare ricorsivamente
        await generateModels(value, architecture, projectName);
      }
    });
  } else if (jsonData is List) {
    // Caso: Lista
    String modelName = 'ListModel';
    String listClassCode = generateListModel(jsonData, modelName);
    
    // Salva la lista in un file separato
    String filePath = path.join(projectPath, getPathModels(architecture), '$modelName.dart');
    await createModelFile(filePath, listClassCode);

    print('File generato per la lista in $filePath');
  }
}

// Funzione per generare una classe Dart per un oggetto
String generateDartClass(Map<String, dynamic> jsonData, String className) {
  StringBuffer classCode = StringBuffer();

  classCode.writeln('class $className {');

  // Genera i campi della classe
  jsonData.forEach((key, value) {
    String fieldType = getFieldType(value);
    classCode.writeln('  final $fieldType $key;');
  });

  // Costruttore
  classCode.writeln('\n  $className({');
  jsonData.forEach((key, value) {
    classCode.writeln('    required this.$key,');
  });
  classCode.writeln('  });\n');

  // fromJson e toJson
  classCode.writeln('  factory $className.fromJson(Map<String, dynamic> json) {');
  classCode.writeln('    return $className(');
  jsonData.forEach((key, value) {
    classCode.writeln('      $key: json[\'$key\'],');
  });
  classCode.writeln('    );');
  classCode.writeln('  }\n');

  classCode.writeln('  Map<String, dynamic> toJson() {');
  classCode.writeln('    return {');
  jsonData.forEach((key, value) {
    classCode.writeln('      \'$key\': $key,');
  });
  classCode.writeln('    };');
  classCode.writeln('  }');

  classCode.writeln('}\n');

  return classCode.toString();
}

// Funzione per generare una classe Dart per una lista
String generateListModel(List<dynamic> jsonData, String className) {
  StringBuffer classCode = StringBuffer();

  classCode.writeln('class $className {');
  classCode.writeln('  final List<dynamic> items;');

  // Costruttore
  classCode.writeln('\n  $className({');
  classCode.writeln('    required this.items,');
  classCode.writeln('  });\n');

  // fromJson e toJson
  classCode.writeln('  factory $className.fromJson(List<dynamic> json) {');
  classCode.writeln('    return $className(items: json.map((item) => item).toList());');
  classCode.writeln('  }\n');

  classCode.writeln('  List<dynamic> toJson() {');
  classCode.writeln('    return items.map((item) => item).toList();');
  classCode.writeln('  }');

  classCode.writeln('}\n');

  return classCode.toString();
}

// Funzione per determinare il tipo di un campo in Dart
String getFieldType(dynamic value) {
  if (value is int) {
    return 'int';
  } else if (value is double) {
    return 'double';
  } else if (value is String) {
    return 'String';
  } else if (value is bool) {
    return 'bool';
  } else if (value is List) {
    return 'List<dynamic>';
  } else if (value is Map) {
    return 'Map<String, dynamic>';
  }
  return 'dynamic';
}

// Funzione per creare un file Dart per una classe
Future<void> createModelFile(String filePath, String classCode) async {
  File file = File(filePath);
  await file.create(recursive: true);
  await file.writeAsString(classCode);
}

// Estensione per capitalizzare la prima lettera di una stringa
extension StringCapitalization on String {
  String capitalize() {
    return this[0].toUpperCase() + this.substring(1);
  }
}

