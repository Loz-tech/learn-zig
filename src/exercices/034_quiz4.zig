//
// Quiz time. See if you can make this program work!
//
// Solve this any way you like, just be sure the output is:
//
//     my_num=42
//
const std = @import("std");

const NumError = error{IllegalNumber};

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    var stdout_writer = std.Io.File.stdout().writer(io, &.{});
    const stdout = &stdout_writer.interface;

    const my_num: NumError!u32 = getNumber();

    if (my_num) |value| {
        try stdout.print("my_num={}\n", .{value});
    } else |err| switch (err) {
        NumError.IllegalNumber => try stdout.print("Illegal{}", .{err}),
        else => unreachable,
    }
}

// This function is obviously weird and non-functional. But you will not be changing it for this quiz.
fn getNumber() NumError!u32 {
    if (false) return NumError.IllegalNumber;

    return 42;
}
