const zap = @import("zap");

const HOME_HTML = @embedFile("../resources/home.html");

pub fn handle(req: zap.Request) void {
    req.setStatus(.ok);
    req.sendBody(HOME_HTML) catch {};
}
