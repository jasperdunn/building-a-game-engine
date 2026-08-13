# Building a Game Engine

Learning 3D graphics with Zig, SDL3, and Slang

> [!NOTE]
> Here you'll find the source code for each article within my [Building a Game Engine](https://www.jasperdunn.com/series/building-a-game-engine/) series.
>
> You'll need have Zig installed to follow along.

## Installing Zig

If you're using Visual Studio Code like me, the best way to install Zig is with the [official extension](https://marketplace.visualstudio.com/items?itemName=ziglang.vscode-zig) (which includes ZLS). We're using `0.16.0` at the time of writing.

Alternatively you can [install Zig directly](https://ziglang.org/learn/getting-started/#direct) or via [package managers](https://ziglang.org/learn/getting-started/#managers). You'll also want to install [ZLS (Zig Language Server)](https://zigtools.org/zls/install/).

## Running the code

Each folder has this name: `<number>-<url-slug>`.

The folder holds the **_final_** code of that article.

Some articles do not continue from the previous one. These articles have a
second folder with `-start` at the end of the name.

```sh
cd 002-zig-sdl3-and-a-window

zig build run
```

|     | Article                                                                                                         | Folder                                      |
| --- | --------------------------------------------------------------------------------------------------------------- | ------------------------------------------- |
| 1   | [The other side of the screen](https://www.jasperdunn.com/blog/the-other-side-of-the-screen/)                   | —                                           |
| 2   | [Zig, SDL3, and a window](https://www.jasperdunn.com/blog/zig-sdl3-and-a-window/)                               | `002-zig-sdl3-and-a-window`                 |
| 3   | [The square moves faster on my machine](https://www.jasperdunn.com/blog/the-square-moves-faster-on-my-machine/) | `003-the-square-moves-faster-on-my-machine` |
