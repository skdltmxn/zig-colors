const std = @import("std");

pub const Color = enum {
    Default,
    Black,
    Red,
    Green,
    Yellow,
    Blue,
    Magenta,
    Cyan,
    White,
    BrightBlack,
    BrightRed,
    BrightGreen,
    BrightYellow,
    BrightBlue,
    BrightMagenta,
    BrightCyan,
    BrightWhite,
};

pub const Style = struct {
    bold: bool = false,
    dim: bool = false,
    italic: bool = false,
    underline: bool = false,
    blink: bool = false,
    inverse: bool = false,
    strikethrough: bool = false,
    foreground: Color = Color.Default,
    background: Color = Color.Default,
};

pub fn ColoredWriter(comptime WriterType: type) type {
    return struct {
        buffered_writer: std.io.BufferedWriter(4096, WriterType),

        pub const Error = WriterType.Error;
        pub const Writer = std.io.Writer(*Self, Error, struct {
            pub fn write(self: *Self, bytes: []const u8) Error!usize {
                return self.write(Color.Default, bytes);
            }
        }.write);

        const Self = @This();
        const reset = "\x1b[0m";

        pub fn writer(self: *Self) Writer {
            return .{ .context = self };
        }

        pub fn write(self: *Self, style: Style, bytes: []const u8) Error!usize {
            try self.writeCode(style);
            const len = try self.buffered_writer.write(bytes);
            _ = try self.buffered_writer.write(reset);
            try self.buffered_writer.flush();
            return len;
        }

        pub fn print(self: *Self, style: Style, comptime format: []const u8, args: anytype) Error!void {
            try self.writeCode(style);
            try self.buffered_writer.writer().print(format, args);
            _ = try self.buffered_writer.write(reset);
            try self.buffered_writer.flush();
        }

        fn writeCode(self: *Self, style: Style) Error!void {
            var buf: [256]u8 = undefined;
            var i: usize = 0;

            buf[i] = '\x1b';
            buf[i + 1] = '[';
            i += 2;

            if (style.bold) {
                buf[i] = '1';
                buf[i + 1] = ';';
                i += 2;
            }

            if (style.dim) {
                buf[i] = '2';
                buf[i + 1] = ';';
                i += 2;
            }

            if (style.italic) {
                buf[i] = '3';
                buf[i + 1] = ';';
                i += 2;
            }

            if (style.underline) {
                buf[i] = '4';
                buf[i + 1] = ';';
                i += 2;
            }

            if (style.blink) {
                buf[i] = '5';
                buf[i + 1] = ';';
                i += 2;
            }

            if (style.inverse) {
                buf[i] = '7';
                buf[i + 1] = ';';
                i += 2;
            }

            if (style.strikethrough) {
                buf[i] = '9';
                buf[i + 1] = ';';
                i += 2;
            }

            if (style.foreground != Color.Default) {
                const foregroundCode = getForegroundColorCode(style.foreground);
                @memcpy(buf[i .. i + foregroundCode.len], foregroundCode);
                buf[i + foregroundCode.len] = ';';
                i += foregroundCode.len + 1;
            }

            if (style.background != Color.Default) {
                const backgroundCode = getBackgroundColorCode(style.background);
                @memcpy(buf[i .. i + backgroundCode.len], backgroundCode);
                buf[i + backgroundCode.len] = 'm';
                i += backgroundCode.len + 1;
            }

            buf[i - 1] = 'm';

            _ = try self.buffered_writer.write(buf[0..i]);
        }

        fn getForegroundColorCode(color: Color) []const u8 {
            return switch (color) {
                Color.Default => "39",
                Color.Black => "30",
                Color.Red => "31",
                Color.Green => "32",
                Color.Yellow => "33",
                Color.Blue => "34",
                Color.Magenta => "35",
                Color.Cyan => "36",
                Color.White => "37",
                Color.BrightBlack => "90",
                Color.BrightRed => "91",
                Color.BrightGreen => "92",
                Color.BrightYellow => "93",
                Color.BrightBlue => "94",
                Color.BrightMagenta => "95",
                Color.BrightCyan => "96",
                Color.BrightWhite => "97",
            };
        }

        fn getBackgroundColorCode(color: Color) []const u8 {
            return switch (color) {
                Color.Default => "49",
                Color.Black => "40",
                Color.Red => "41",
                Color.Green => "42",
                Color.Yellow => "43",
                Color.Blue => "44",
                Color.Magenta => "45",
                Color.Cyan => "46",
                Color.White => "47",
                Color.BrightBlack => "100",
                Color.BrightRed => "101",
                Color.BrightGreen => "102",
                Color.BrightYellow => "103",
                Color.BrightBlue => "104",
                Color.BrightMagenta => "105",
                Color.BrightCyan => "106",
                Color.BrightWhite => "107",
            };
        }
    };
}

pub fn coloredWriter(underlying_stream: anytype) ColoredWriter(@TypeOf(underlying_stream)) {
    return .{ .buffered_writer = std.io.bufferedWriter(underlying_stream) };
}
