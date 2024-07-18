const std = @import("std");
const zap = @import("zap");
const embedded_files = @import("../embedded_files.zig").embedded_files;

pub fn handleStatic(req: zap.Request) void {
    const path = req.path orelse {
        req.setStatus(.bad_request);
        req.sendBody("Invalid request: missing path") catch {};
        return;
    };

    if (!std.mem.startsWith(u8, path, "/creatives/")) {
        req.setStatus(.not_found);
        req.sendBody("Not found") catch {};
        return;
    }

    if (path.len <= "/creatives/".len) {
        req.setStatus(.not_found);
        req.sendBody("Not found") catch {};
        return;
    }

    const fileName = path["/creatives/".len..];

    var segments = std.mem.splitScalar(u8, fileName, '/');
    var file_name: ?[]const u8 = null;

    while (segments.next()) |segment| {
        if (segment.len > 0) {
            file_name = segment;
        }
    }

    if (file_name) |name| {
        if (embedded_files.get(name)) |content| {
            const extension = std.fs.path.extension(name);
            const content_type = if (std.mem.eql(u8, extension, ".jpg") or std.mem.eql(u8, extension, ".jpeg"))
                "image/jpeg"
            else if (std.mem.eql(u8, extension, ".png"))
                    "image/png"
                else if (std.mem.eql(u8, extension, ".gif"))
                        "image/gif"
                    else
                        "application/octet-stream";

            req.setHeader("Content-Type", content_type) catch {};
            req.sendBody(content) catch {};
        } else {
            req.setStatus(.not_found);
            req.sendBody("File not found") catch {};
        }
    } else {
        req.setStatus(.not_found);
        req.sendBody("No file name found") catch {};
    }
}
