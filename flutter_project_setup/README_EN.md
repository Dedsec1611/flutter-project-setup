# flutter_project_setup

[![Pub Version](https://img.shields.io/pub/v/flutter_project_setup.svg)](https://pub.dev/packages/flutter_project_setup)
[![License: Custom](https://img.shields.io/badge/license-Custom-blue.svg)](#%EF%B8%8F-licenza)
[![Platform](https://img.shields.io/badge/platform-Dart%20%7C%20Flutter-blue)](https://flutter.dev)

✨ **flutter_project_setup** is an open-source CLI that allows you to quickly generate a Flutter project with a desired structure, core libraries, and initial setup. Perfect for starting new projects in a standardized and efficient way.

## 🚀 Key Features

- Create a new Flutter project
- Choose architecture: `MVC`, `MVVM`, `Clean`
- Option to clone a Git template or start from an empty project
- Optional Git initialization
- Generate `.gitignore`
- Generate models from JSON input
- Interactive library selection (`http`, `provider`, `shared_preferences`, etc.)
- Automatically installs the latest library versions

## 💻 Installation

### From GitHub

```bash
dart pub global activate --source git https://github.com/Dedsec1611/flutter-project-setup.git
```

### From pub.dev (when published)

```bash
dart pub global activate flutter_project_setup
```

### Ensure global package path is in your PATH:

#### macOS / Linux

Add to `.zshrc` or `.bashrc`:

```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

#### Windows (PowerShell)

```powershell
$env:Path += ";$HOME\AppData\Local\Pub\Cachein"
```

## 🛠️ Usage

```bash
flutter_project_setup
```

Follow the interactive flow:

1. Enter project name
2. Select architecture
3. Choose Git template or empty project
4. Choose whether to initialize Git
5. Add `.gitignore`
6. Optionally provide a JSON file for model generation
7. Select libraries to install

## Example json model

{
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john.doe@example.com"
  },
  "object": {
    "id": 101,
    "name": "Laptop",
    "price": 1299.99
  }
}

After the project has been created in the model, the User and Object classes will be created.

## 📄 License

This project uses a custom license that **does not allow commercial use** without permission. For licensing requests, contact the author.

---

Made with ❤️ by Dedsec1611
