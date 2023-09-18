const std = @import("std");

const Location = struct {
    start: usize,
    end: usize,
    filine: []const u8,
};

const Term = union {
    Int: i64,
    Float: f64,
    String: []const u8,
    Bool: bool,
};

const Str = struct { value: []const u8, location: Location };

const Print = struct { value: Term, location: Location };

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const stdin = std.io.getStdIn();

    var buffer: [4096]u8 = undefined;

    var content = std.ArrayList(u8).init(allocator);
    defer content.deinit();

    while (true) {
        const bytesRead = try stdin.read(buffer[0..]);
        if (bytesRead == 0) {
            break;
        } else {
            try content.appendSlice(buffer[0..bytesRead]);
        }
    }

    const inputSlice = content.items;
    std.debug.print("Saved content: {s}", .{inputSlice});
}
