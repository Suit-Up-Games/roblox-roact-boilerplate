# roblox-roact-boilerplate

A basic template for making a Roblox game

## Setup

1. Initialize the git submodules
   `git submodule update --init`

2. Install the latest `rojo` executable from https://github.com/rojo-rbx/rojo/releases and the plugin with matching version.

## Workflow

### Designers

- Create a "stable" place in Roblox Studio and enable Team Create
- Collaborate in the place with other designers & builders
- Export the place as an rbxl project or individual parts of the project as rbxms for developers to use
- Use `rojo serve` to sync the stable branch on git into the place

### Developers

- Save the stable place as a local rbxl file
- Avoid using rojo on the stable place
- Use `rojo serve` on the local development copy to write & test code
- Publish a personal development copy to have other team members try out in-development features

## Folders

Keep code and game content in separate folder structures underneath the root services to avoid rojo accidentally deleting models.

### ReplicatedStorage

This should store all code and models which are required by both the client + server.

Models in this folder will be loaded into the client when the user joins, so will load in quickly when later cloned into the Workspace.

### ReplicatedFirst

This should store code and UI that is displayed while the user is joining the server & before the game has fully loaded

### StarterPlayerScripts

This should store code which controls the local client UI and interactions.

## ServerScriptService

This should store code which only runs on the server.

## ServerStorage

Models in this folder will not be loaded into the client immediately, so will let the game load faster at the expense of being available more slowly when cloned into the Workspace.

## Libraries

### Rojo

When an IDE external to Roblox Studio is preferred, use Rojo to sync code from a the file system

- Run `rojo serve` in the root directory
- Open the place in Roblox Studio
- Open the rojo plugin & connect to local server
- Any changes on the file system will propagate to the place in realtime
- Have one team member only reponsible for syncing code to a shared place

### TestEZ

TestEZ is a unit test harness for Roblox.

https://github.com/Roblox/testEZ

### Stylua

Use StyLua to autoformat Lua code.

https://github.com/JohnnyMorganz/StyLua
