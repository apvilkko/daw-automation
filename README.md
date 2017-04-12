# daw-automation

Making music in a DAW is manual work. This is an attempt to automate the boring parts of it and at the same time introduce some rudimentary "machines create music" magic in the process.

These AutoIt scripts are tailored to my personal setup with Ableton Live 8 on Windows (e.g. UI colors have to be hardcoded for a single theme), but I've tried to make them somewhat generic. You're free to study and use them at your own risk.

Because Ableton Live doesn't use native Windows controls, everything needs to be read from pixels. At some point I think I need OCR because working without it is slow and hacky. For example the VST plugin selection is done by counting arrow presses and comparing it to the VST plugin list we get from filesystem.
