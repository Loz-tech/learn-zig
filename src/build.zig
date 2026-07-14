const std = @import("std");

pub fn build(b: *std.Build) !void {
    const exe = b.addExecutable(.{
        .name = "cImports",
        .root_module = b.createModule(.{
            .root_source_file = b.lazyImport(comptime asking_build_zig: type, comptime dep_name: []const u8)"/exercices/096_hello_c.zig",
            .target = b.graph.host,
        }),
    });

    b.installArtifact(b, exe);
}
