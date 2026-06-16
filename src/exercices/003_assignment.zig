const std = @import("std");

pub fn main() void {
    var n: u8 = 50;
    n = n + 5;

    const pi: u20 = 314159;
    const negative_eleven: i8 = -18;

    std.debug.print("{} {} {}\n", .{ n, negative_eleven, pi });
}
