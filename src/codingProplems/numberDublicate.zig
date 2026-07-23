// The proplem that we have the duplicate in array we need to find the way to print true if we have duplicate in array

const std = @import("std");
const testing = std.testing;

// []const u8 = slice of any length (read-only). Call with &array — *[N]u8 coerces to []const u8.
fn bruteForceFindDuplicateSolution(someArray: []const u8) bool {
    for (someArray, 0..) |someNum, index| {
        for (index + 1..someArray.len) |next| {
            if (someNum == someArray[next]) {
                return true;
            }
        }
    }
    return false;
}

// Sorted array: adjacent equals = duplicate.
fn findDuplicateInSorted(someArray: []const u8) bool {
    if (someArray.len < 2) return false;

    for (0..someArray.len - 1) |index| {
        if (someArray[index] == someArray[index + 1]) {
            return true;
        }
    }
    return false;
}

// []u8 = mutable slice (sort needs write).
fn sortBeforeDuplicationFindingAproach(someArray: []u8) bool {
    std.mem.sort(u8, someArray, {}, std.sort.asc(u8));
    return findDuplicateInSorted(someArray);
}

fn findDuplicateWithHashMap(someArray: []const u8, hashMap: *std.AutoHashMap(u8, void)) !bool {
    for (someArray) |element| {
        if (hashMap.contains(element)) {
            return true;
        }
        try hashMap.put(element, {});
    }
    return false;
}

pub fn main() !void {
    var arrayWithDuplicates = [_]u8{ 1, 5, 6, 8, 2, 6, 4, 2 };
    var arrayWithNoDuplicate = [_]u8{ 1, 2, 3, 4, 5, 6, 7, 8 };

    // &arr → *[N]u8 → coerces to []u8 / []const u8
    const result = bruteForceFindDuplicateSolution(&arrayWithDuplicates);
    const secondResult = bruteForceFindDuplicateSolution(&arrayWithNoDuplicate);

    const secondMethodResult = sortBeforeDuplicationFindingAproach(&arrayWithDuplicates);
    const secondMethodNoDuplicatesResult = sortBeforeDuplicationFindingAproach(&arrayWithNoDuplicate);

    std.debug.print("Find the duplicate: {}\n", .{result});
    std.debug.print("Find the duplicate: {}\n", .{secondResult});
    std.debug.print("Find the duplicate first sort: {}\n", .{secondMethodResult});
    std.debug.print("Find the duplicate first sort: {}\n", .{secondMethodNoDuplicatesResult});

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    var hashMap = std.AutoHashMap(u8, void).init(allocator);
    defer hashMap.deinit();

    const resulthashMap = try findDuplicateWithHashMap(&arrayWithDuplicates, &hashMap);
    std.debug.print("Find the duplicate hash map: {}\n", .{resulthashMap});
}

test "findingDuplicate" {
    var arrayWithDuplicates = [_]u8{ 1, 5, 6, 8, 2, 6, 4, 2 };
    var arrayWithNoDuplicate = [_]u8{ 1, 2, 3, 4, 5, 6, 7, 8 };

    try testing.expect(bruteForceFindDuplicateSolution(&arrayWithDuplicates) == true);
    try testing.expect(bruteForceFindDuplicateSolution(&arrayWithNoDuplicate) == false);

    var map = std.AutoHashMap(u8, void).init(testing.allocator);
    defer map.deinit();
    try testing.expect(try findDuplicateWithHashMap(&arrayWithDuplicates, &map) == true);

    var map2 = std.AutoHashMap(u8, void).init(testing.allocator);
    defer map2.deinit();
    try testing.expect(try findDuplicateWithHashMap(&arrayWithNoDuplicate, &map2) == false);
}

const TimingResult = struct {
    brute_full_ns: u64,
    sort_full_ns: u64,
    hash_full_ns: u64,
    brute_find_ns: u64,
    sort_find_ns: u64,
    hash_find_ns: u64,
};

fn measureDuplicateApproaches(source: []const u8, iterations: usize) !TimingResult {
    const io = testing.io;
    var i: usize = 0;

    // --- full: setup inside timer ---
    const brute_full_start = std.Io.Clock.now(.awake, io);
    i = 0;
    while (i < iterations) : (i += 1) {
        try testing.expect(bruteForceFindDuplicateSolution(source));
    }
    const brute_full_ns: u64 = @intCast(brute_full_start.durationTo(std.Io.Clock.now(.awake, io)).toNanoseconds());

    const sort_full_start = std.Io.Clock.now(.awake, io);
    i = 0;
    while (i < iterations) : (i += 1) {
        var buf: [256]u8 = undefined;
        @memcpy(buf[0..source.len], source);
        try testing.expect(sortBeforeDuplicationFindingAproach(buf[0..source.len]));
    }
    const sort_full_ns: u64 = @intCast(sort_full_start.durationTo(std.Io.Clock.now(.awake, io)).toNanoseconds());

    const hash_full_start = std.Io.Clock.now(.awake, io);
    i = 0;
    while (i < iterations) : (i += 1) {
        var map = std.AutoHashMap(u8, void).init(testing.allocator);
        defer map.deinit();
        try testing.expect(try findDuplicateWithHashMap(source, &map));
    }
    const hash_full_ns: u64 = @intCast(hash_full_start.durationTo(std.Io.Clock.now(.awake, io)).toNanoseconds());

    // --- find-only: setup outside timer ---
    const brute_find_start = std.Io.Clock.now(.awake, io);
    i = 0;
    while (i < iterations) : (i += 1) {
        try testing.expect(bruteForceFindDuplicateSolution(source));
    }
    const brute_find_ns: u64 = @intCast(brute_find_start.durationTo(std.Io.Clock.now(.awake, io)).toNanoseconds());

    var sorted_buf: [256]u8 = undefined;
    @memcpy(sorted_buf[0..source.len], source);
    const sorted = sorted_buf[0..source.len];
    std.mem.sort(u8, sorted, {}, std.sort.asc(u8));
    const sort_find_start = std.Io.Clock.now(.awake, io);
    i = 0;
    while (i < iterations) : (i += 1) {
        try testing.expect(findDuplicateInSorted(sorted));
    }
    const sort_find_ns: u64 = @intCast(sort_find_start.durationTo(std.Io.Clock.now(.awake, io)).toNanoseconds());

    var map = std.AutoHashMap(u8, void).init(testing.allocator);
    defer map.deinit();
    var hash_find_ns: u64 = 0;
    i = 0;
    while (i < iterations) : (i += 1) {
        map.clearRetainingCapacity();
        const hash_start = std.Io.Clock.now(.awake, io);
        const found = try findDuplicateWithHashMap(source, &map);
        hash_find_ns += @intCast(hash_start.durationTo(std.Io.Clock.now(.awake, io)).toNanoseconds());
        try testing.expect(found);
    }

    return .{
        .brute_full_ns = brute_full_ns,
        .sort_full_ns = sort_full_ns,
        .hash_full_ns = hash_full_ns,
        .brute_find_ns = brute_find_ns,
        .sort_find_ns = sort_find_ns,
        .hash_find_ns = hash_find_ns,
    };
}

fn printTimingCase(label: []const u8, n: usize, iterations: usize, r: TimingResult) void {
    std.debug.print("\n--- {s} (len={d}, {d} iters) ---\n", .{ label, n, iterations });
    std.debug.print("{s:<12} {s:>14} {s:>14}\n", .{ "approach", "full ns/op", "find-only ns/op" });
    std.debug.print("{s:<12} {d:>14} {d:>14}\n", .{ "brute force", r.brute_full_ns / iterations, r.brute_find_ns / iterations });
    std.debug.print("{s:<12} {d:>14} {d:>14}\n", .{ "sort", r.sort_full_ns / iterations, r.sort_find_ns / iterations });
    std.debug.print("{s:<12} {d:>14} {d:>14}\n", .{ "hash map", r.hash_full_ns / iterations, r.hash_find_ns / iterations });
}

test "timeMeasurement small early duplicate" {
    const iterations: usize = 100_000;
    const source = [_]u8{ 1, 1, 2, 3, 4, 5, 6, 7 };
    const r = try measureDuplicateApproaches(&source, iterations);
    printTimingCase("small early duplicate", source.len, iterations, r);
}

test "timeMeasurement medium mid duplicate" {
    const iterations: usize = 100_000;
    const source = [_]u8{ 1, 5, 6, 8, 2, 6, 4, 2, 9, 3, 7, 0, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 6 };
    const r = try measureDuplicateApproaches(&source, iterations);
    printTimingCase("medium mid duplicate", source.len, iterations, r);
}

test "timeMeasurement larger late duplicate" {
    const iterations: usize = 50_000;
    var source: [128]u8 = undefined;
    for (&source, 0..) |*e, idx| e.* = @intCast(idx % 256);
    source[127] = source[0]; // only dup at end
    const r = try measureDuplicateApproaches(&source, iterations);
    printTimingCase("larger late duplicate", source.len, iterations, r);
}
