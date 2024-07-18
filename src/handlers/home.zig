const zap = @import("zap");

pub fn handle(req: zap.Request) void {
    req.setStatus(.ok);
    req.sendBody(
        \\<!DOCTYPE html>
        \\<html>
        \\<head><title>Welcome to Zoe's Ad-ventures!</title></head>
        \\<body>
        \\    <h1>Welcome to Zoe's Intergalactic Ad Server!</h1>
        \\    <p>Blast off to new advertising horizons with our dino-mite service!</p>
        \\    <ul>
        \\        <li><a href="/ads">View Ads</a></li>
        \\        <li><a href="/adventure">Join Zoe's Space Adventure</a></li>
        \\    </ul>
        \\</body>
        \\</html>
    ) catch {};
}
