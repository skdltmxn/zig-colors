const std = @import("std");
const zigcolor = @import("zig-colors");

test "foreground colors" {
    var buffer = [_]u8{0} ** 1024;
    var b = std.io.fixedBufferStream(&buffer);
    var cw = zigcolor.coloredWriter(b.writer());

    const test_cases = [_]struct {
        style: zigcolor.Style,
        input: []const u8,
        expected: []const u8,
    }{
        .{ .style = .{ .foreground = zigcolor.Color.Black }, .input = "black", .expected = "\x1b[30mblack\x1b[0m" },
        .{ .style = .{ .foreground = zigcolor.Color.Red }, .input = "red", .expected = "\x1b[31mred\x1b[0m" },
        .{ .style = .{ .foreground = zigcolor.Color.Green }, .input = "green", .expected = "\x1b[32mgreen\x1b[0m" },
        .{ .style = .{ .foreground = zigcolor.Color.Yellow }, .input = "yellow", .expected = "\x1b[33myellow\x1b[0m" },
        .{ .style = .{ .foreground = zigcolor.Color.Blue }, .input = "blue", .expected = "\x1b[34mblue\x1b[0m" },
        .{ .style = .{ .foreground = zigcolor.Color.Magenta }, .input = "magenta", .expected = "\x1b[35mmagenta\x1b[0m" },
        .{ .style = .{ .foreground = zigcolor.Color.Cyan }, .input = "cyan", .expected = "\x1b[36mcyan\x1b[0m" },
        .{ .style = .{ .foreground = zigcolor.Color.White }, .input = "white", .expected = "\x1b[37mwhite\x1b[0m" },
        .{ .style = .{ .foreground = zigcolor.Color.BrightBlack }, .input = "bright black", .expected = "\x1b[90mbright black\x1b[0m" },
        .{ .style = .{ .foreground = zigcolor.Color.BrightRed }, .input = "bright red", .expected = "\x1b[91mbright red\x1b[0m" },
        .{ .style = .{ .foreground = zigcolor.Color.BrightGreen }, .input = "bright green", .expected = "\x1b[92mbright green\x1b[0m" },
        .{ .style = .{ .foreground = zigcolor.Color.BrightYellow }, .input = "bright yellow", .expected = "\x1b[93mbright yellow\x1b[0m" },
        .{ .style = .{ .foreground = zigcolor.Color.BrightBlue }, .input = "bright blue", .expected = "\x1b[94mbright blue\x1b[0m" },
        .{ .style = .{ .foreground = zigcolor.Color.BrightMagenta }, .input = "bright magenta", .expected = "\x1b[95mbright magenta\x1b[0m" },
        .{ .style = .{ .foreground = zigcolor.Color.BrightCyan }, .input = "bright cyan", .expected = "\x1b[96mbright cyan\x1b[0m" },
        .{ .style = .{ .foreground = zigcolor.Color.BrightWhite }, .input = "bright white", .expected = "\x1b[97mbright white\x1b[0m" },
    };

    inline for (test_cases) |tc| {
        _ = try cw.write(tc.style, tc.input);
        try std.testing.expect(std.mem.eql(u8, buffer[0..tc.expected.len], tc.expected));
        b.reset();
    }
}
