# flutter-project-setup
Formato del json in input
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


dart pub global activate --source path .
echo 'export PATH="$HOME/.pub-cache/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc  
flutter_project_setup 

# 🚀 flutter_project_setup

> Una CLI potente per generare rapidamente progetti Flutter con architetture strutturate, librerie personalizzate e modelli da JSON.

[![Pub Version](https://img.shields.io/pub/v/flutter_project_setup.svg)](https://pub.dev/packages/flutter_project_setup)
[![License: Custom](https://img.shields.io/badge/license-Custom-blue.svg)](#%EF%B8%8F-licenza)
[![Platform](https://img.shields.io/badge/platform-Dart%20%7C%20Flutter-blue)](https://flutter.dev)

## ✨ Funzionalità

- Selezione interattiva dell'architettura: MVC, MVVM, Clean Architecture
- Inizializzazione automatica del progetto con `flutter create`
- Supporto a `.gitignore`, Git init e struttura cartelle
- Aggiunta di dipendenze Flutter selezionabili con versioni aggiornate
- Generazione automatica di modelli da JSON
- Supporto i18n per rilevamento lingua sistema
- CLI dinamica e interattiva su tutte le piattaforme

## 📦 Installazione

### 🔧 Da Pub.dev

Assicurati di avere Dart installato:

```bash
dart pub global activate flutter_project_setup
```

Poi esegui con:

```bash
flutter_project_setup
```

> Assicurati che `$HOME/.pub-cache/bin` sia incluso nel tuo PATH.

### 🛠️ Da GitHub

Clona il progetto:

```bash
git clone https://github.com/Dedsec1611/flutter-project-setup.git
cd flutter_project_setup
dart pub global activate --source path .
```

Esegui:

```bash
flutter_project_setup
```

## 💡 Utilizzo

```bash
flutter_project_setup
```

Flusso interattivo:

1. Inserisci il nome del progetto
2. Scegli l'architettura
3. Decidi se usare `flutter create` o un template Git
4. Scelta opzionale di inizializzazione Git e `.gitignore`
5. Inserisci percorso JSON per generare i modelli
6. Aggiunta dipendenze selezionabili (es. provider, dio, etc.)


## ✅ Esempi librerie disponibili

- `provider`
- `dio`
- `get_it`
- `flutter_bloc`
- `equatable`
- `json_serializable`

## 📁 Struttura generata

```
my_project/
├── lib/
│   ├── models/
│   ├── view/
│   ├── controller/
├── pubspec.yaml
├── .gitignore
```

## 📝 Licenza

Licenza personalizzata: **Non è consentito l’uso commerciale senza una licenza a pagamento.**
Contattare `Dedsec1611` per uso aziendale o personalizzato.

