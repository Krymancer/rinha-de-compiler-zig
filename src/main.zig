const std = @import("std");
const json = @import("std").json;

const Print = struct { kind: []const u8, value: []const u8, location: Location };
const Expression = struct { kind: []const u8, value: Print, location: Location };
const Location = struct { start: usize, end: usize, filename: []const u8 };
const Program = struct { name: []const u8, expression: Expression, location: Location };

pub fn readProgramFromStdin(allocator: std.mem.Allocator) ![]const u8 {
    const stdin = std.io.getStdIn();
    var buffer: [4096]u8 = undefined;
    var content = std.ArrayList(u8).init(allocator);
    defer content.deinit();

    while (true) {
        const bytesRead = try stdin.read(buffer[0..]);
        if (bytesRead == 0) break;
        try content.appendSlice(buffer[0..bytesRead]);
    }

    return content.toOwnedSlice();
}

pub fn parseProgramFromJsonString(json_string: []const u8, allocator: std.mem.Allocator) !Program {
    const program_json = try json.parseFromSlice(Program, allocator, json_string, .{});
    defer program_json.deinit();
    return program_json.value;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const input = try readProgramFromStdin(allocator);
    const program = try parseProgramFromJsonString(input, allocator);
    std.debug.print("Loaded program: {s}", .{program.name});
}
