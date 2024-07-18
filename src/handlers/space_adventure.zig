const zap = @import("zap");

const ADVENTURE_HTML = @embedFile("../resources/adventure.html");

pub fn handle(req: zap.Request) void {
    req.setStatus(.ok);
    req.sendBody(ADVENTURE_HTML) catch {};
}
