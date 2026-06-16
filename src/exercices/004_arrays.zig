const std = @import("std");

pub fn main() void {
    const zoo: [3]u32 = [3]u32{ 6564565, 124142, 213223 };
    var foo = [_]u32{ 1412412, 1241241243, 45454545, 6456565 };

    foo[2] = 3553535;

    const secondValue = foo[2];

    std.debug.print("{}\n", .{secondValue});
    std.debug.print("{}\n", .{zoo[1]});
}
