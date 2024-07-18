const zap = @import("zap");

pub fn handle(req: zap.Request) void {
    req.setStatus(.ok);
    req.sendBody(
        \\<!DOCTYPE html>
        \\<html>
        \\<head><title>Zoe's Space Adventure</title></head>
        \\<body>
        \\    <h1>Join Zoe on her Cosmic Adventure!</h1>
        \\    <p>Zoe the dino is zooming through the stars, delivering ads faster than light!</p>
        \\    <pre>
        \\          .
        \\         /=\\
        \\        /===\    🦖
        \\       /=====\    Zoe
        \\      /=======\
        \\     /=========\
        \\    /===========\
        \\   /=============\
        \\  /===============\
        \\ /=================\
        \\       |___|
        \\
        \\    </pre>
        \\</body>
        \\</html>
    ) catch {};
}
