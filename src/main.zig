export fn main() callconv(.Naked) noreturn {
    @intToPtr([*]volatile u32, 0x1c090000).* = 'A';
    while (true) {}
}
