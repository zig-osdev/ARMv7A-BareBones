pub const UARTBASE = 0x1c090000;

// UART Control Register Locations
pub const UART0_DR = @intToPtr([*]volatile usize, UARTBASE);
pub const UART0_LCRH = @intToPtr([*]volatile usize, UARTBASE + 0x2C);
pub const UART0_LCRM = @intToPtr([*]volatile usize, UARTBASE + 0x28);
pub const UART0_LCRL = @intToPtr([*]volatile usize, UARTBASE + 0x24);
pub const UART0_CR = @intToPtr([*]volatile usize, UARTBASE + 0x30);
pub const UART0_FR = @intToPtr([*]volatile usize, UARTBASE + 0x18);

// Line Control High Byte Register - LCRH
pub const LCRH_Word_Length_8 = 0x60;

// Line Control Medium Byte Register - LCRM
// This register specifies the high byte of the Baud rate divisor
pub const LCRM_Baud_460800 = 0x00;

// Line Control Low Byte Register - LCRL
// This register specifies the low byte of the Baud rate divisor
pub const LCRL_Baud_460800 = 0x01;

// Control Register - CR
pub const CR_TX_Int_Enable = 0x100;
pub const CR_RX_Int_Enable = 0x200;
pub const CR_UART_Enable = 0x01;

// Flag Register - FR
pub const FR_TX_Fifo_Full = 0x20;

pub fn init() void {
    UART0_CR.* = 0;

    // set the correct baud rate and word length
    UART0_LCRL.* = LCRL_Baud_460800;
    UART0_LCRM.* = LCRM_Baud_460800;
    UART0_LCRH.* = LCRH_Word_Length_8;

    // enable the serial port
    UART0_CR.* = CR_UART_Enable | CR_TX_Int_Enable | CR_RX_Int_Enable;
}

pub fn sendChar(byte: u8) void {
    while ((UART0_FR[0] & FR_TX_Fifo_Full) > 0) {}
    UART0_DR.* = byte;
}

pub fn print(bytes: []const u8) void {
    for (bytes) |byte|
        sendChar(byte);
}
