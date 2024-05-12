.syntax unified
.cpu cortex-m0plus
.thumb

.text

.equ IO_BANK0_GPIO_CTRL_BASE, 0x40014004

.equ PADS_BANK0_GPIO_BASE, 0x4001c004
.equ PAD_INIT_VALUE, 0b00010110

.equ SIO_BASE, 0xd0000000
.equ GPIO_OE,     SIO_BASE + 0x020 @ GPIO output enable
.equ GPIO_OE_SET, SIO_BASE + 0x024 @ GPIO output enable set
.equ GPIO_OE_CLR, SIO_BASE + 0x028 @ GPIO output enable clear
.equ GPIO_OE_TGL, SIO_BASE + 0x02c @ GPIO output enable XOR
.equ GPIO_OUT,     SIO_BASE + 0x010 @ GPIO output value
.equ GPIO_OUT_SET, SIO_BASE + 0x014 @ GPIO output value set
.equ GPIO_OUT_CLR, SIO_BASE + 0x018 @ GPIO output value clear
.equ GPIO_OUT_TGL, SIO_BASE + 0x01c @ GPIO output value XOR

.equ LED_PIN, 25

.global main
.thumb_func
main:
    @ Initialize GPIO LED_PIN
    ldr r0, =IO_BANK0_GPIO_CTRL_BASE
    movs r1, #5 @ GPIO function initialize value
    ldr r2, =LED_PIN
    lsls r3, r2, #3
    str r1, [r0, r3]

    @ Intialize PAD Config
    ldr r0, =PADS_BANK0_GPIO_BASE
    ldr r1, =PAD_INIT_VALUE
    lsls r3, r2, #2
    str r1, [r0, r3]

    @ Set DOE
    movs r0, #1
    lsls r1, r0, #LED_PIN
    ldr r3, =GPIO_OE_SET
    str r0, [r3]

    ldr r4, =GPIO_OUT_TGL
    movs r5, r1
    loop:
        bl delay_1_second
        str r5, [r4]
        b loop

delay_1_second:
    ldr r0, =#1000000
    inner_loop:
        subs r0, r0, #1
        bne inner_loop
    bx lr
    
.end
