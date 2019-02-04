.org 0x00                      # Code의 시작 주소를 0x00으로 설정합니다.
.code16                        # 16비트 코드로 설정합니다.

.text                          # Text Segment를 정의합니다.
    .globl _start;

_start:
    mov $0x7C00, %AX           # AX에 0x7C00(부트로더의 시작 주소)를 설정합니다.
    movw %AX, %DS              # DS에 AX값을 설정합니다. (DS = 0x7C00)
    mov $0xB800, %AX           # AX에 0xB800(비디오 메모리의 시작 주소)를 설정합니다.
    movw %AX, %ES              # ES에 AX값을 설정합니다. (ES = 0xB800)
    mov $0, %SI                # SI 레지스터를 초기화합니다.

.SCREENCLEARLOOP:              # 화면을 지우는 반복문
    movb $0x00, %ES:(%SI)      # 비디오 메모리의 문자에 위치하는 주소에 0을 복사하여 문자를 삭제
    movb $0x1F, %ES:1(%SI)     # 속성값에 파란 바탕에 하얀 글씨 속성을 복사
    add $2, %SI                # 문자와 속성을 설정했으므로 다음 위치(2바이트뒤)로 이동
    cmp $(80 * 25 * 2), %SI    # 화면의 전체 크기(80*25*2)와 SI의 값을 비교
    jl .SCREENCLEARLOOP        # SI 레지스터가 80*25*2의 값보다 작다면 아직 지우지 못한 영역이 있으므로,
                               # .SCREENCLEARLOOP 레이블로 이동

.PRINTMYNAME:                  # 내 이름을 출력하는 레이블
    movb $'K', %ES:0x00
    movb $0x47, %ES:0x01
    movb $'y', %ES:0x02
    movb $0x47, %ES:0x03
    movb $'u', %ES:0x04
    movb $0x47, %ES:0x05
    movb $'H', %ES:0x06
    movb $0x47, %ES:0x07
    movb $'y', %ES:0x08
    movb $0x47, %ES:0x09
    movb $'u', %ES:0x0A
    movb $0x47, %ES:0x0B
    movb $'k', %ES:0x0C
    movb $0x47, %ES:0x0D

. = _start + 510               # 현재 위치(0x00)에서 510번 주소로 이동
                               # 현재 위치(0x00)에서 510번 주소까지 0x00으로 채워진다.
.byte 0x55                     # Boot Signature 추가
.byte 0xaa                     # 0x55 0xAA는 부트로더임을 알리는 값입니다.
