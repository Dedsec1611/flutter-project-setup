import 'dart:io';

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

void main(List<String> arguments) {
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

  createFlutterProject(projectName, architecture);
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
