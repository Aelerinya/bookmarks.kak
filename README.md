# bookmarks.kak

A bookmarks plugin for the kakoune editor.

## Installation

The recommended way to install this plugin is using [plug.kak](https://github.com/andreyorst/plug.kak).

```kak
plug "Ersikan/bookmarks.kak"
```

## Configuration

You can enable the bookmarks user mode for all windows like this :
```kak
plug "Ersikan/bookmarks.kak" %{
    hook global WinCreate .* bookmarks-enable
}
```

## Usage

`bookmarks-enable` enables the `bookmarks` user mode, which can be entered by pressing `,b`.

`bookmarks-add` (`,ba`) adds a new bookmark at the current cursor position.

`bookmarks-delete` (`,bd`) deletes an existing bookmark.

`bookmarks-menu` (`,bb`) jumps to a specific bookmark.
