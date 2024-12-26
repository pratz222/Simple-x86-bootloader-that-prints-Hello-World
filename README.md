# Simple x86 Bootloader - "Hello, World!"

This project is a simple x86 bootloader written in assembly that prints "Hello, World!" directly to the screen using BIOS interrupts. It is designed to run in real mode and demonstrates low-level programming concepts such as direct hardware interaction and boot sector programming.

## Features

- Displays "Hello, World!" on the screen using BIOS interrupt `INT 0x10`.
- Implements basic system setup in real mode, including segment initialization and stack configuration.
- Compliant with boot sector requirements for BIOS.

## Prerequisites

- **Assembler:** [NASM](https://www.nasm.us/) (Netwide Assembler)
- **Emulator:** [QEMU](https://www.qemu.org/)
- **Make Utility:** For running the provided `Makefile` (optional)

## How It Works

The bootloader performs the following steps:

1. Sets up the segment registers and stack.
2. Loads the "Hello, World!" message into memory.
3. Outputs each character to the screen using BIOS interrupt `INT 0x10`.
4. Halts the CPU once the message is displayed.

## Setup Instructions

### 1. Assemble the Bootloader
Run the following command to assemble the bootloader:
```bash
make
```

This will create the binary file `./bin/boot.bin`.

### 2. Test the Bootloader
Use an emulator to test the bootloader. For example, with QEMU:
```bash
qemu-system-x86_64 -hda ./boot.bin
```

## Bootloader Code

The main assembly code for the bootloader is located in [`src/boot.asm`](src/boot.asm). Here’s a snippet:

```asm
[BITS 16]
[ORG 0x7C00]

start:
    cli                 ; Disable interrupts
    xor ax, ax          ; AX = 0
    mov ds, ax          ; Data segment = 0
    mov es, ax          ; Extra segment = 0
    mov ss, ax          ; Stack segment = 0
    mov sp, 0x7BFF      ; Stack pointer
    sti                 ; Enable interrupts

    mov si, msg         ; Load address of the message into SI
print:
    lodsb               ; Load byte at DS:SI into AL, increment SI
    cmp al, 0           ; Check for null terminator
    je done             ; If null terminator, jump to done
    mov ah, 0x0E        ; BIOS teletype function
    int 0x10            ; Print character in AL
    jmp print           ; Repeat for next character

done:
    cli
    hlt                 ; Halt CPU

msg db 'Hello, World!', 0 ; Null-terminated string

times 510 - ($ - $$) db 0 ; Pad with zeros
dw 0xAA55                 ; Boot sector signature
```

## Makefile

The project includes a `Makefile` to simplify the build process. Key targets:

- `all`: Assembles the bootloader binary.
- `clean`: Removes the generated binary.

## Notes

- Ensure the bootloader binary is exactly 512 bytes with the boot signature (`0xAA55`) at the end.
- Always test the bootloader in an emulator before writing it to physical media to prevent data loss.
