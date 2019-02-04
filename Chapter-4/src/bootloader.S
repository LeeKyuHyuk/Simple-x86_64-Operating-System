.org 0x00				# Code의 시작 주소를 0x00으로 설정합니다.
.code16					# 16비트 코드로 설정합니다.

.text					# Text Segment를 정의합니다.
	.globl _start;

_start:
	jmp _boot # Boot 레이블로 이동합니다.
	
	# helloWorld, url에 문자열을 정의합니다.
	helloWorld: .asciz "Hello, World!\n\r"
	url: .asciz "https://github.com/LeeKyuHyuk/Simple-x86_64-Operating-System\n\r"

	# <Macro Start> print(str) : String을 출력하는 매크로
	.macro print str
		leaw  \str, %si		# str(argument)의 주소를 SI레지스터에 넣습니다.
		call .putchar		# putchar 호출합니다.
	.endm
	# <Macro End> print(str)

	# <Function Start> putchar : Character를 출력합니다.
	.putchar:
		lodsb
		orb  %al, %al
		jz   .putchar_end
		movb $0x0e, %ah
		int  $0x10
		jmp  .putchar
	# <Function End> putchar

	# <Function Start> putchar_end : putchar에서 Character를 모두 출력했을때 진입되는 Function 입니다.
	.putchar_end:
		ret
	# <Function End> putchar_end

_boot:
	print helloWorld
	print url

. = _start + 510			# 현재 위치에서 510번 주소로 이동합니다.
					# 현재 위치에서 510번 주소까지 0x00으로 채워진다.
.byte 0x55				# Boot Signature를 추가합니다.
.byte 0xAA				# 0x55 0xAA는 부트로더임을 알리는 값입니다.
