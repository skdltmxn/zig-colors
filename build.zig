const std = @import("std");

pub fn build(b: *std.Build) !void {
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

    inline for ([_]struct {
        name: []const u8,
        src: []const u8,
    }{
        .{ .name = "simple", .src = "examples/simple.zig" },
    }) |ex| {
        const ex_build_desc = try std.fmt.allocPrint(
            b.allocator,
            "build the {s} example",
            .{ex.name},
        );
        const ex_run_stepname = try std.fmt.allocPrint(
            b.allocator,
            "run-{s}",
            .{ex.name},
        );
        const ex_run_stepdesc = try std.fmt.allocPrint(
            b.allocator,
            "run the {s} example",
            .{ex.name},
        );
        const example_run_step = b.step(ex_run_stepname, ex_run_stepdesc);
        const example_step = b.step(ex.name, ex_build_desc);

        var example = b.addExecutable(.{
            .name = ex.name,
            .root_source_file = b.path(ex.src),
            .target = target,
            .optimize = optimize,
        });

        example.root_module.addImport("zig-colors", zig_colors_module);

        const example_run = b.addRunArtifact(example);
        example_run_step.dependOn(&example_run.step);

        // install the artifact - depending on the "example"
        const example_build_step = b.addInstallArtifact(example, .{});
        example_step.dependOn(&example_build_step.step);
    }
}
