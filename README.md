# MakroBoard

MakroBoard is an open source software solution to use any device capable of displaying a website as a remote macro keyboard for your Windows / Linux / Mac PC.
Its written in C#/dotnet for the API on the pc and the client which is also served by the c# app is written in [Dart](dart.dev) with the [Flutter](flutter.dev) framework.

Its currently under heavy development, so only use it for testing or development

## Installation

There is no released version so far, you have to follow the development steps below

## Development

### Requirements

- IDE of your choise (We recommend VSCodium / VSCode / Visual Studio)
- [Dotnet 5.0 SDK](https://dotnet.microsoft.com/download/dotnet/5.0) for your OS
- [flutter](https://flutter.dev/docs/get-started/install) for your OS

### Building and starting the application

- go to the makro_board_client folder and run `flutter pub get`
- go to the makro_board_client folder and run `flutter run` to start the frontend
- in vscode / visual studio you can now just hit F5 or use the build tasks to start the backend
- you can also use the shell `dotnet build` or `dotnet publish` in the root of the repo to start the backend

### Building the documentation

Currently you can only build the documentation on a Windows client. Install [docfx](https://dotnet.github.io/docfx/tutorial/docfx_getting_started.html#2-use-docfx-as-a-command-line-tool) via the prefered way, clone the MakroBoard repo, go with an administrative shell to the `Docs` folder and run `docfx --serve`. Then you can navigate with the prefered Webbrowser to `http://localhost:8080/`

## Structure

Control

- Actions - Key, Exec, ..., Makro(Ablauf von Actions), Selection
  - Key
  - Application
  - Makro
  - Selection
  - (HTTP/WS call)
  - Direct HTTP/WS call from client
- View
  - Text
  - If / Else Text
  - Image
  - If / Else Image
  - Material icons
  - If / Else Material icons
  - List
  - Interactive List
  - HTTP content
  - If / Else HTTP content

Panels

- Action
- Viewconfig

Pages

- Panels

Pagecollections

- Pages
- (show on which devices, default All)

## ControlDB Structure

- Pages
  - SymbolicName
  - Label
  * Group
    - SymbolicName
    - Label
    * Panel (Visualize Control)
      - PluginName
      - SymbolicName
      * ConfigParameter
        - SymbolicName
        - Value (any/string)

## Ideas / Todos

https://github.com/MakroBoard/MakroBoard/issues
