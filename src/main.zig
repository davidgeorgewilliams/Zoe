const std = @import("std");
const zap = @import("zap");
const ad_server = @import("ad_server.zig");

var global_server: *ad_server.AdServer = undefined;

fn handleRequest(r: zap.Request) void {
    global_server.handleRequest(r);
}

pub fn main() !void {
    var server = try ad_server.init(std.heap.page_allocator);
    defer server.deinit();

    // Set the global server reference
    global_server = &server;

    // Set up Zap listener
    var listener = zap.HttpListener.init(.{
        .port = 3000,
        .on_request = handleRequest,
        .log = true,
    });

    try listener.listen();

    std.log.info("Zoe is ready for space adventures on http://localhost:3000", .{});

    // Start the server
    zap.start(.{
        .threads = 4,
        .workers = 2,
    });
}
