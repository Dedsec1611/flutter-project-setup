# flutter_project_setup

[![Pub Version](https://img.shields.io/pub/v/flutter_project_setup.svg)](https://pub.dev/packages/flutter_project_setup)
[![License: Custom](https://img.shields.io/badge/license-Custom-blue.svg)](#%EF%B8%8F-licenza)
[![Platform](https://img.shields.io/badge/platform-Dart%20%7C%20Flutter-blue)](https://flutter.dev)

✨ **flutter_project_setup** è una CLI open-source che consente di generare rapidamente un progetto Flutter con la struttura desiderata, librerie di base, e configurazioni iniziali. Ideale per avviare nuovi progetti in modo standardizzato ed efficiente.

## 🚀 Funzionalità principali

- Creazione progetto Flutter da zero
- Scelta dell'architettura: `MVC`, `MVVM`, `Clean`
- Opzione per clonare template da repository Git o creare un progetto vuoto
- Inizializzazione Git opzionale
- Generazione file `.gitignore`
- Supporto alla generazione di modelli da JSON
- Selezione interattiva delle librerie più comuni da installare (es. `http`, `provider`, `shared_preferences`)
- Installazione automatica delle ultime versioni delle dipendenze

## 💻 Installazione

### Da GitHub

```bash
dart pub global activate --source git https://github.com/tuo-username/flutter_project_setup.git
```

### Da pub.dev (quando pubblicato)

```bash
dart pub global activate flutter_project_setup
```

### Assicurati che il path dei pacchetti globali sia nel tuo PATH:

#### macOS / Linux

Aggiungi al tuo `.zshrc` o `.bashrc`:

```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

#### Windows (PowerShell)

```powershell
$env:Path += ";$HOME\AppData\Local\Pub\Cachein"
```

## 🛠️ Utilizzo

```bash
flutter_project_setup
```

Segui il flusso interattivo:

1. Inserisci il nome del progetto
2. Seleziona l’architettura
3. Scegli tra clonare un template o creare un progetto vuoto
4. Scegli se inizializzare Git
5. Aggiungi il file `.gitignore`
6. Inserisci un file JSON per generare modelli (opzionale)
7. Seleziona le librerie da installare

## Example json model

{
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john.doe@example.com"
  },
  "oggetto": {
    "id": 101,
    "name": "Laptop",
    "price": 1299.99
  }
}

Dopo che il progetto è stato creato nel modello saranno creati le classi User e Oggetto.


## 📄 Licenza

Questo progetto è distribuito con una licenza personalizzata che **non consente l’uso commerciale** senza autorizzazione. Per richieste di licenza, contattare l'autore.

---

Creato con ❤️ da Dedsec1611
