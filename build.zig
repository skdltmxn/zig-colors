const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "zig-colors",
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(lib);

    const zig_colors_module = b.addModule("zig-colors", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const color_test = b.addTest(.{
        .name = "color_tests",
        .root_source_file = b.path("src/tests/test_colors.zig"),
        .target = target,
        .optimize = optimize,
    });

    color_test.root_module.addImport("zig-colors", zig_colors_module);

    const run_color_test = b.addRunArtifact(color_test);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_color_test.step);
}
