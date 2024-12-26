const std = @import("std");
const zigcolors = @import("zig-colors");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var cw = zigcolors.coloredWriter(stdout);

    // Use .bold, .italic, .underline, and .blink to set text styles.
    try cw.print(.{ .bold = true }, "bold\n", .{});
    try cw.print(.{ .dim = true }, "dim\n", .{});
    try cw.print(.{ .italic = true }, "italic\n", .{});
    try cw.print(.{ .underline = true }, "underline\n", .{});
    try cw.print(.{ .blink = true }, "blink\n", .{});
    try cw.print(.{ .inverse = true }, "inverse\n", .{});
    try cw.print(.{ .strikethrough = true }, "strikethrough\n", .{});

    // Use .foreground to set the foreground color.
    try cw.print(.{ .foreground = zigcolors.Color.Black }, "black\n", .{});
    try cw.print(.{ .foreground = zigcolors.Color.Red }, "red\n", .{});
    try cw.print(.{ .foreground = zigcolors.Color.Green }, "green\n", .{});
    try cw.print(.{ .foreground = zigcolors.Color.Yellow }, "yellow\n", .{});
    try cw.print(.{ .foreground = zigcolors.Color.Blue }, "blue\n", .{});
    try cw.print(.{ .foreground = zigcolors.Color.Magenta }, "magenta\n", .{});
    try cw.print(.{ .foreground = zigcolors.Color.Cyan }, "cyan\n", .{});
    try cw.print(.{ .foreground = zigcolors.Color.White }, "white\n", .{});

    // Use .background to set the background color.
    // Notice that newline applies the background color to the entire next line and it is not a bug.
    _ = try cw.write(.{ .background = zigcolors.Color.Black }, "black\n");
    try cw.print(.{ .background = zigcolors.Color.Red }, "red\nand yet more text here", .{});
    try cw.print(.{ .background = zigcolors.Color.Green }, "green\n", .{});
    try cw.print(.{ .background = zigcolors.Color.Yellow }, "yellow\n", .{});
    try cw.print(.{ .background = zigcolors.Color.Blue }, "blue\n", .{});
    try cw.print(.{ .background = zigcolors.Color.Magenta }, "magenta\n", .{});
    try cw.print(.{ .background = zigcolors.Color.Cyan }, "cyan\n", .{});
    try cw.print(.{ .background = zigcolors.Color.White }, "white\n", .{});
}
