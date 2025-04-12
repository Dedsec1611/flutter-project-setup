import 'dart:io';

import 'package:flutter_project_setup/src/utils/console_utils.dart';

Future cloneRepo(String branch, String projectName, String architecture) async {
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
    String? gitInitOption = ConsoleUtils.inputConsole(
        question: 'Vuoi inizializzare un nuovo repository Git? (Y/n): ');

    if (gitInitOption == 'Y') {
      ProcessResult gitInitResult =
          await Process.run('git', ['init'], workingDirectory: projectPath);
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
