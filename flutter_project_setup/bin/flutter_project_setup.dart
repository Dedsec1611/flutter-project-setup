import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:args/args.dart';
import 'package:dart_console/dart_console.dart';
import 'package:flutter_project_setup/flutter_project_setup.dart'
    as flutter_project_setup;
import 'package:flutter_project_setup/src/utils/console_utils.dart';

String getName() {
  return """

██████╗ ███████╗██████╗ ███████╗███████╗ ██████╗ ██╗ ██████╗ ██╗ ██╗
██╔══██╗██╔════╝██╔══██╗██╔════╝██╔════╝██╔════╝███║██╔════╝███║███║
██║  ██║█████╗  ██║  ██║███████╗█████╗  ██║     ╚██║███████╗╚██║╚██║
██║  ██║██╔══╝  ██║  ██║╚════██║██╔══╝  ██║      ██║██╔═══██╗██║ ██║
██████╔╝███████╗██████╔╝███████║███████╗╚██████╗ ██║╚██████╔╝██║ ██║
╚═════╝ ╚══════╝╚═════╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝ ╚═════╝ ╚═╝ ╚═╝
                                                                                                                                                                                    
                                                                                                                    """;
}

Future<void> main(List<String> arguments) async {
  var console = Console();
  List<String> architectures = ['mvc', 'mvvm', 'clean'];

  print(getName());
  final parser = ArgParser()
    ..addOption('name', abbr: 'n', help: 'Nome del progetto Flutter')
    ..addOption(
      'arch',
      abbr: 'a',
      help: 'Architettura desiderata',
      allowed: architectures,
    )
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Mostra aiuto');

  final argResults = parser.parse(arguments);

  if (argResults['help'] as bool) {
    print('Utilizzo:');
    print(parser.usage);
    return;
  }

  var projectName = argResults['name'] as String?;
  projectName ??=
      ConsoleUtils.inputConsole(question: 'Inserisci il nome del tuo progetto: ');

  var architecture = argResults['arch'] as String?;
  if (architecture == null) {
    console.setForegroundColor(ConsoleColor.cyan);
    console.writeLine('Scegli l\'architettura:');
    for (int i = 0; i < architectures.length; i++) {
      console.writeLine('${i + 1}. ${architectures[i]}');
    }
    console.resetColorAttributes();

    int choice = int.parse(console.readLine() ?? '');
    if (choice > architectures.length || choice < 1) {
      console.setForegroundColor(ConsoleColor.red);
      print('Errore: inserire un valore tra 1 e ${architectures.length}');
      exit(1);
    }

    architecture = architectures[choice - 1];

    print('Hai scelto l\'architettura: $architecture');
  }
  if (projectName == null) {
    console.setForegroundColor(ConsoleColor.red);
    print('Errore: specificare un nome per il progetto con --name=<nome>');
    exit(1);
  }

  print('$projectName - $architecture');


  //Model generator
    print('Inserisci il percorso del file JSON:');
  String? jsonFilePath = stdin.readLineSync();

  if (jsonFilePath == null || jsonFilePath.isEmpty) {
    print('Percorso file non valido.');
    return;
  }


  // Verifica se il file esiste
  File jsonFile = File(jsonFilePath);
  if (!jsonFile.existsSync()) {
    print('Il file $jsonFilePath non esiste.');
    return;
  }
  createFlutterProject(projectName, architecture);

  // Carica e analizza il file JSON
  String jsonString = await jsonFile.readAsString();
  dynamic jsonData = jsonDecode(jsonString);

  // Genera le entità basate sul JSON
  await generateModels(jsonData, architecture, projectName);
}



void cloneRepo(String branch, String projectName, String architecture) async{
  String currentDirectory = Directory.current.path;
  // Percorso dove verrà creato il progetto
  String projectPath = '$currentDirectory/$projectName';
  // Verifica se la cartella esiste già
  if (Directory(projectPath).existsSync()) {
    print(
        'Errore: La cartella "$projectName" esiste già nella directory corrente.');
    exit(1);
  }
  final repoUrl =
      'https://github.com/Dedsec1611/flutter-architecture-templates.git';
  print('Clonando il template da $repoUrl in $projectPath...');
  ProcessResult result = Process.runSync(
      'git', ['clone', '--branch', branch, repoUrl, projectPath]);
  if (result.exitCode == 0) {
    print('Template scaricato con successo!');
    // Rimuove la cartella .git per non ereditare la cronologia del template
    Directory gitDir = Directory('$projectPath/.git');
    if (gitDir.existsSync()) {
      gitDir.deleteSync(recursive: true);
    }

    //CHIEDIAMO SE INIZIALIZZARE GIT
    String? gitInitOption = ConsoleUtils.inputConsole(question: 'Vuoi inizializzare un nuovo repository Git? (Y/n): ');

    if (gitInitOption == 'Y') {
      ProcessResult gitInitResult = await Process.run('git', ['init'], workingDirectory: projectPath);
      if (gitInitResult.exitCode == 0) {
        print('Repository Git inizializzato con successo!');
      } else {
        print('Errore durante git init: ${gitInitResult.stderr}');
      }
    }
    print(
        'Progetto "$projectName" creato con successo in "$projectPath" con architettura "$architecture".');
  } else {
    print('Errore durante il clone: ${result.stderr}');
  }
  print('Progetto creato con l\'architettura $branch!');
}

void createFlutterProject(String projectName, String architecture) {
  switch (architecture) {
    case 'mvc':
      cloneRepo('flutter_mvc', projectName,architecture);
      break;
    case 'mvvc':
      cloneRepo('flutter_mvvc', projectName,architecture);
      break;
    case 'clean':
      cloneRepo('flutter_clean_arch', projectName,architecture);
      break;
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

