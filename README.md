# TextMate package

Makes your life hard by keeping Atom undistinguishable from TextMate.

## Installing

    git clone https://github.com/elia/atom-textmate ~/.atom/packages/atom-textmate
    cd ~/.atom/packages/atom-textmate && apm install

Then reload Atom with <kbd>⌃⌥⌘L</kbd> (or via the menu clicking `View` → `Reload`)


## Fixing key-equivalents

```yml
ctrl-alt-cmd-d: tree-view:toggle
alt-cmd-tab:    tree-view:toggle-focus
ctrl-cmd-r:     tree-view:reveal-active-file
ctrl-cmd-t:     command-palette:toggle
ctrl-D:         editor:duplicate-line
cmd-L:          editor:select-line
cmd-down:       tree-view:open-selected-entry
```

## Open Favorites

The “Open Favorites” dialog:

![The Favorites dialog](http://f.cl.ly/items/0V1K3H2y3o3w233q0U0W/Screen%20Shot%202014-03-18%20at%2012.16.05%20am.png)


My TextMate Favorites folder:

![My TextMate Favorites folder](http://f.cl.ly/items/0m0j2u2A1F3P172B2j2h/Screen%20Shot%202014-03-18%20at%2012.16.55%20am.png)

### How the Favorites folder works

- Every symlink inside `~/Library/Application\ Support/TextMate/Favorites/` is a favorite
- If the symlink's name starts with `[DIR] ` all of the link's target sub-folders will be considered projects

## LICENSE

See the `LICENSE.md` file.
