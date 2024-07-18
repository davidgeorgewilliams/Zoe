const std = @import("std");
const zap = @import("zap");
const AdManager = @import("../ad_manager.zig").AdManager;

const ADS_HTML_TEMPLATE = @embedFile("../resources/ads.html");

pub fn handle(req: zap.Request, ad_manager: *AdManager) void {
    const ads = ad_manager.getAds();

    var json_string = std.ArrayList(u8).init(std.heap.page_allocator);
    defer json_string.deinit();

    std.json.stringify(ads, .{}, json_string.writer()) catch {
        req.setStatus(.internal_server_error);
        req.sendBody("Zoe encountered a black hole while fetching ads!") catch {};
        return;
    };

    const allocator = std.heap.page_allocator;

    // Calculate the size needed for the replaced content
    const replacement_size = std.mem.replacementSize(u8, ADS_HTML_TEMPLATE, "{[ads_data]}", json_string.items);

    // Allocate memory for the replaced content
    const html_content = allocator.alloc(u8, replacement_size) catch {
        req.setStatus(.internal_server_error);
        req.sendBody("Zoe's memory banks are full!") catch {};
        return;
    };
    defer allocator.free(html_content);

    // Perform the replacement
    _ = std.mem.replace(u8, ADS_HTML_TEMPLATE, "{[ads_data]}", json_string.items, html_content);

    req.setStatus(.ok);
    req.sendBody(html_content) catch {};
}