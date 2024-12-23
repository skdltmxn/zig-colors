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

pub fn ColoredWriter(comptime WriterType: type) type {
    return struct {
        uncolored_writer: WriterType,

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

        pub fn write(self: *Self, color: Color, bytes: []const u8) Error!usize {
            const colorCode = getForegroundColorCode(color);
            _ = try self.uncolored_writer.write(colorCode);
            const len = try self.uncolored_writer.write(bytes);
            _ = try self.uncolored_writer.write(reset);
            return len;
        }

        pub fn print(self: *Self, color: Color, comptime format: []const u8, args: anytype) Error!void {
            const colorCode = getForegroundColorCode(color);
            _ = try self.uncolored_writer.write(colorCode);
            _ = try self.uncolored_writer.print(format, args);
            _ = try self.uncolored_writer.write(reset);
        }

        fn getForegroundColorCode(color: Color) []const u8 {
            return switch (color) {
                Color.Default => "\x1b[39m",
                Color.Black => "\x1b[30m",
                Color.Red => "\x1b[31m",
                Color.Green => "\x1b[32m",
                Color.Yellow => "\x1b[33m",
                Color.Blue => "\x1b[34m",
                Color.Magenta => "\x1b[35m",
                Color.Cyan => "\x1b[36m",
                Color.White => "\x1b[37m",
                Color.BrightBlack => "\x1b[90m",
                Color.BrightRed => "\x1b[91m",
                Color.BrightGreen => "\x1b[92m",
                Color.BrightYellow => "\x1b[93m",
                Color.BrightBlue => "\x1b[94m",
                Color.BrightMagenta => "\x1b[95m",
                Color.BrightCyan => "\x1b[96m",
                Color.BrightWhite => "\x1b[97m",
            };
        }
    };
}

pub fn coloredWriter(underlying_stream: anytype) ColoredWriter(@TypeOf(underlying_stream)) {
    return .{ .uncolored_writer = underlying_stream };
}
