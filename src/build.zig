const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{
        .default_target = .{ .abi = .musl },
    });

    const exe = b.addExecutable(.{
        .name = "cImports",
        .root_module = b.createModule(.{
            .root_source_file = b.path("exercices/096_hello_c.zig"),
            .target = target,
            .link_libc = true,
        }),
    });

    b.installArtifact(exe);
}
