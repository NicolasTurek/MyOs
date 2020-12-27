[BITS 16]
[ORG 0x7C00]

CALL Clear

MOV SI, StartMsg
CALL PrintString
MOV WORD [0x1600], 0	;prepare stdio string

Begin:
CALL NewLine
MOV AL, '#'
CALL PrintCharacter

Main:
CALL ReadKey
;vypis znaku
CMP AX, 7187
JNE nenter
CALL CallFunction
nenter:
CMP AX, 385
JE PowerOff
JMP Main

PrintCharacter:
MOV AH, 0x0E
MOV BH, 0x00
MOV BL, 0X03
INT 0x10
RET

PrintString:

next_character:
MOV AL, [SI]
INC SI

CMP AL, 0
JE exit_function

CALL PrintCharacter
JMP next_character
exit_function:
RET

PrintNumber:
MOV [0X1500], AX
MOV AX, 0x0
MOV [0X1502], AX
MOV [0X1504], AX
MOV BX, 0X000A
MOV CL, 0X00

PrNumDivLoop:
INC CL
MOV DX, 0x0000
MOV AX, [0X1500]
IDIV BX
MOV [0X1500], AX
MOV CH, DL
MOV AX, [0x1502]
MUL BX
MOV BL, CH
ADD AX, BX
MOV [0X1502], AX
MOV BX, 0X000A
MOV AX, [0X1500]
CMP AX, 0X0
JNE PrNumDivLoop
PrNumLoop:

MOV DX, 0x0000
MOV AX, [0X1502]
IDIV BX
MOV [0X1502], AX
MOV AL, DL
ADD AL, 0X30
CALL PrintCharacter

MOV BX, 0X000A

DEC CL
CMP CL, 0x00
JNE PrNumLoop
RET

NewLine:
MOV AL, 0xA
CALL PrintCharacter
MOV AL, 0xD
CALL PrintCharacter
int 0x10
RET

CallFunction:
CALL NewLine
RET

Clear:
MOV AL, 0x00		;Clear
MOV AH, 0x06		;Scroll up bios func
MOV BH, 0x0A		;color
MOV CX, 0X0000		;Upper left corner, CH = row
MOV DX, 0x184F		;Lower right corner, DH = row
int 0x10
RET

CompareStrings:		;function to compare strings at address AL and AH

RET

Sleep:
MOV AX, 0x0000
INT 0x1A
ADD DX, 0x01		;add mili seconds
MOV [0x1510], DX
timer:
MOV AX, 0X0000
INT 0x1A
CMP DX, [0x1510]
JNE timer
ret

ReadKey:
MOV AX, [0x1600]
INC WORD [0x1600]
IMUL AX, 0x2
ADD AX, 0x1604
MOV [0x1602], AX

MOV AH, 0x00		;read key by bios
INT 0x16

CMP AH, 0xA
JNE $ + 7
MOV BX, [0x1602]
MOV [BX], AH
RET

PowerOff:
MOV AX, 0x5301
XOR BX, BX
INT 0x15

MOV AX, 0x530E
XOR BX, BX
MOV CX, 0x0102

MOV AX, 0x5307
MOV BX, 0x0001
MOV CX, 0x0003
INT 0x15
RET

Reboot:
db 0x00ea
dw 0x0000
dw 0xFFFF
RET

StartMsg db 'Welcome, this is my bootloader', 0
EndMsg db 'Bye :)', 0

TIMES 510 - ($ - $$) db 0
DW 0xAA55

StrPwrOff db "poweroff", 0
StrReBoot db "reboot", 0

TIMES 1024 - ($ - $$) db 0
