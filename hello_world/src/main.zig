const serial = @import("serial.zig");

export fn main() callconv(.Naked) noreturn {
    serial.init();
    serial.print("Hello World!");
    while (true) {}
}
