import 'dart:convert';
import 'dart:io';
import 'package:flutter_project_setup/src/commands/add_dependencies.dart';
import 'package:flutter_project_setup/src/services/project_generator.dart';
import 'package:flutter_project_setup/src/utils/git_utils.dart';
import 'package:args/args.dart';
import 'package:dart_console/dart_console.dart';
import 'package:flutter_project_setup/src/utils/console_utils.dart';

Future<void> main(List<String> arguments) async {
  List<String> architectures = ['mvc', 'mvvm', 'clean'];
  print("${ConsoleUtils.getName()} -  Version 1.0\n");
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

  // Project name
  var projectName = argResults['name'] as String?;
  projectName ??= ConsoleUtils.inputConsole(
      question: 'Inserisci il nome del tuo progetto: ');

  // Architecture name
  var architecture = argResults['arch'] as String?;
  if (architecture == null) {
    ConsoleUtils.console.setForegroundColor(ConsoleColor.cyan);
    ConsoleUtils.console.writeLine('Scegli l\'architettura:');
    for (int i = 0; i < architectures.length; i++) {
      ConsoleUtils.console.writeLine('${i + 1}. ${architectures[i]}');
    }
    ConsoleUtils.console.resetColorAttributes();

    int choice = int.parse(ConsoleUtils.console.readLine() ?? '');
    if (choice > architectures.length || choice < 1) {
      ConsoleUtils.console.setForegroundColor(ConsoleColor.red);
      print('Errore: inserire un valore tra 1 e ${architectures.length}');
      exit(1);
    }

    architecture = architectures[choice - 1];
    print('Hai scelto l\'architettura: $architecture');
  }

  if (projectName == null || projectName.isEmpty) {
    ConsoleUtils.console.setForegroundColor(ConsoleColor.red);
    print('Errore: specificare un nome valido per il progetto');
    exit(1);
  }

  print('$projectName - $architecture');

  // Prima chiedi se importare un modello JSON
  String? generateModel = ConsoleUtils.inputConsole(
      question: "Vuoi importare un json per la creazione del modello? (Y/n)");

  dynamic jsonData;

  if (generateModel == 'Y') {
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

    // Carica e analizza il file JSON
    String jsonString = await jsonFile.readAsString();
    jsonData = jsonDecode(jsonString);
  }

  // Poi chiedi se inizializzare una repository Git
  String? repoInit = ConsoleUtils.inputConsole(
      question: 'Vuoi partire da una repository git? (Y/n): ');

  // Poi chiedi se inizializzare il .gitignore
  String? gitIgnore = ConsoleUtils.inputConsole(
      question: "Vuoi inizializzare .gitignore? (Y/n)");

  List? selectedDependencies = await DependencyManager.selectDependencies();

  //Generazione del progetto
  if (repoInit == 'Y') {
    await ProjectGenerator.createFlutterProject(projectName, architecture);
  } else {
    print('Genero un nuovo progetto');
    await ProjectGenerator.createProjectStructure(projectName, architecture);
  }

  if (gitIgnore == 'Y') {
    GitUtils.copyGitignoreToProject(projectName);
  }

  if (generateModel == 'Y') {
    // Genera le entità basate sul JSON
    await generateModels(jsonData, architecture, projectName);
  }

  if (selectedDependencies != null && selectedDependencies.isNotEmpty) {
    await DependencyManager.addDependenciesInteractively(
        selectedDependencies, projectName);
  }
}
