# WebMacroSoftKeyboard

WebMacroSoftKeyboard is an open source software solution to use any device capable of displaying a website as a remote macro keyboard for your Windows / Linux / Mac PC.
Its written in C#/dotnet for the API on the pc and the client which is also served by the c# app is written with the [Angular](angular.io) framework.

Its currently under heavy development, so only use it for testing or development

## Installation

There is no released version so far, you have to follow the development documentation


## Development

### Requirements

* IDE of your choise (We recommend VSCodium / VSCode / Visual Studio)
* [Dotnet 5.0 SDK](https://dotnet.microsoft.com/download/dotnet/5.0) for your OS
* [nodejs / npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm) for the client dependencys

### Building and starting the application
* go to the WebMacroSoftKeyboard\ClientApp and run `npm install`
* in vscode / visual Studio you can just hit F5 or use the build tasks
* you can also use the shell `dotnet build` or `dotnet publish`

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
    - Image
    - Material icons
    - List
    - Interactive List
    - HTTP content

Panels
- Action(s)
- View  + If / Else (Toggle) (perhaps possibillity to mix all View types here)

Pages
- Panels

Pagecollections
- Pages
- (show on which devices, default All)


## Ideas / Todos

* Settings for Webserverport
* Setting pluginsreload
* OBS Websockets
* Virtual Midi Actions
* Local Media Control Actions
* PC Performancestatus view
* Clock view
* Teamspeak view :D
* Discord view 
* Maybe way in the future: Ableton control interface? :D







