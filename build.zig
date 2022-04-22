const std = @import("std");
const CrossTarget = std.zig.CrossTarget;

const default_target = CrossTarget{
    .cpu_arch = .thumb,
    .os_tag = .freestanding,
    .cpu_model = .{
        .explicit = &std.Target.arm.cpu.cortex_a15,
    },
    .abi = .eabi,
};

pub fn build(b: *std.build.Builder) !void {
    const target = b.standardTargetOptions(.{ .whitelist = &.{default_target}, .default_target = default_target });
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("kernel", "src/main.zig");
    exe.addAssemblyFile("src/start.s");
    exe.setLinkerScriptPath(.{ .path = "src/linker.ld" });
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.install();

    const run_cmd = b.addSystemCommand(&.{
        "qemu-system-arm",
        "-kernel",
        "zig-out/bin/kernel",
        "-cpu",
        "cortex-a15",
        "-M",
        "vexpress-a15",
        "-nographic",
    });
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
