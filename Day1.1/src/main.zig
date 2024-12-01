const std = @import("std");
const fs = std.fs;

const NumberList = std.ArrayList(i64);
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const file = try fs.cwd().openFile("input.txt", .{});
    defer file.close();

    var left_list = NumberList.init(allocator);
    var right_list = NumberList.init(allocator);
    defer left_list.deinit();
    defer right_list.deinit();

    var reader = file.reader();
    while (reader.readUntilDelimiterOrEofAlloc(allocator, '\n', 1024)) |maybe_line| {
        const line = maybe_line orelse break;
        defer allocator.free(line);

        var it = std.mem.splitSequence(u8, line, "   ");

        const left = try std.fmt.parseInt(i64, it.next().?, 10);
        const right = try std.fmt.parseInt(i64, it.next().?, 10);

        try left_list.append(left);
        try right_list.append(right);

        std.debug.print("{d} - {d}\n", .{ left, right });
    } else |err| {
        std.debug.print("got: {?}\n", .{err});
    }

    std.mem.sort(i64, left_list.items, {}, comptime std.sort.asc(i64));
    std.mem.sort(i64, right_list.items, {}, comptime std.sort.asc(i64));

    var total:u64 = 0;
    for (left_list.items, right_list.items) |left, right| {
        std.debug.print("{d} - {d}\n", .{ left, right });
        total = total + @abs(left-right);
    }

    std.debug.print("total dist : {d}",.{total});
}
