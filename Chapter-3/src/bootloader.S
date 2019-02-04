.org 0x00                             # Code의 시작 주소를 0x00으로 설정합니다.
.code16                               # 16비트 코드로 설정합니다.

.text                                 # Text Segment를 정의합니다.
    .globl _start;

_start:
    mov $0xB800, %AX                  # AX에 0xB800을 설정합니다.
    movw %AX, %DS                     # DS에 AX값을 설정합니다. (DS = 0xB800)
	
    movb $'K', %DS:0x00               # 0xB800 + 0x0000에 'K' Byte를 저장합니다.
    movb $0x47, %DS:0x01              # 0xB800 + 0x0001에 '0x47' Byte를 저장합니다.
    movb $'H', %DS:0x02               # 0xB800 + 0x0002에 'H' Byte를 저장합니다.
    movb $0x17, %DS:0x03              # 0xB800 + 0x0003에 '0x17' Byte를 저장합니다.

    . = _start + 510                  # 현재 위치에서 510번 주소로 이동합니다.
                                           # 현재 위치에서 510번 주소까지 0x00으로 채워진다.
    .byte 0x55                        # Boot Signature를 추가합니다.
    .byte 0xAA                        # 0x55 0xAA는 부트로더임을 알리는 값입니다.
