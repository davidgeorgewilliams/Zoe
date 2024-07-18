const std = @import("std");
const zap = @import("zap");
const AdManager = @import("../ad_manager.zig").AdManager;

pub fn handle(req: zap.Request, ad_manager: *AdManager) void {
    const method = req.method orelse {
        req.setStatus(.bad_request);
        req.sendBody("Invalid request: missing method") catch {};
        return;
    };

    if (std.mem.eql(u8, method, "GET")) {
        const ads = ad_manager.getAds();

        var json_string = std.ArrayList(u8).init(std.heap.page_allocator);
        defer json_string.deinit();

        std.json.stringify(ads, .{}, json_string.writer()) catch {
            req.setStatus(.internal_server_error);
            req.sendBody("Zoe encountered a black hole while fetching ads!") catch {};
            return;
        };

        req.setStatus(.ok);
        req.setContentType(.JSON) catch {
            req.setStatus(.internal_server_error);
            req.sendBody("Zoe had trouble setting the content type!") catch {};
            return;
        };

        req.sendBody(json_string.items) catch {
            // If we fail to send the body, there's not much we can do
            std.debug.print("Failed to send response body", .{});
        };
    } else {
        req.setStatus(.method_not_allowed);
        req.sendBody("Zoe only responds to GET signals from Earth!") catch {
            std.debug.print("Failed to send method not allowed message", .{});
        };
    }
}