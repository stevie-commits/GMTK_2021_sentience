# GMTK 2021 game jam entry

## Conventions

There is a rough folder structure created for ease of use. Code, assets and scene files grouped together for ease and modularity.

- `actors` contais all the characters and other non-static units. Use a `sfx` sub folder for the character and weapon sound effects for each actor type.
- `addons` folder is used for external addons. Also contains the custom AI framework.
- `camera` folder for the base RTS style camera. Als any additional camera effects (such as screen shake, other camera types etc.) go here
- `music` folder has all the background music loops.
- `script_templates` folder is recognized by godot for template used when new script is created.
- `ui` contains everything UI related. `ui/hud` folder has the in-game HUD that should be loaded with the levels. `ui/menu` is set up to support a simple main menu. Any UI part that are reusable are also placed in their relevant folder, such as buttons and labels. `ui/sfx` has the sound effects for UI.
- `utils` for any content that is reused in multiple places.
- `world` contains all the levels for the game. Each sub folder is for a particular level (or level theme in case of procedural). The `map_generator` folder has the templates for the levels. `city_template.tscn` is the base for map level. The `map_controller.tscn` should contain the generator code and level selection/change logic. Use a `sfx` sub folder for the ambient environment sound effects for each level.

Please use **snake_case** for assets and folder names. Avoid spaces and speacial characters in the name. Keep the names descriptive and contextual.
