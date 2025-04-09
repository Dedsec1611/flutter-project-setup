import 'dart:io';
import 'dart:isolate';
import 'package:path/path.dart' as p;

class GitUtils {
  /// Copia il file .gitignore dal template alla cartella del progetto generato
  static Future<void> copyGitignoreToProject(String projectName) async {
    final currentDirectory = Directory.current.path;
    final projectPath = p.join(currentDirectory, projectName);

    // Ottieni il path del pacchetto effettivo (anche se installato globalmente)
    final uri = await Isolate.resolvePackageUri(Uri.parse('package:flutter_project_setup/flutter_project_setup.dart'));

    if (uri == null) {
      print('❌ Impossibile risolvere il percorso del pacchetto.');
      return;
    }

    final packageDir = File(uri.toFilePath()).parent.parent.path; // vai alla root del progetto
    final sourceFile = File(p.join(packageDir, 'templates', '.gitignore'));
    final destinationFile = File(p.join(projectPath, '.gitignore'));

    if (!await sourceFile.exists()) {
      print('❌ File .gitignore non trovato in ${sourceFile.path}');
      return;
    }

    if (await destinationFile.exists()) {
      print('⚠️ .gitignore esiste già in $projectPath');
      return;
    }

    try {
      await sourceFile.copy(destinationFile.path);
      print('✅ .gitignore copiato nella cartella $projectPath');
    } catch (e) {
      print('❌ Errore nella copia del file .gitignore: $e');
    }
  }
}
