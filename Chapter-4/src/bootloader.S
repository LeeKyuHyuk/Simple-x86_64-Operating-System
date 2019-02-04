.org 0x00				# Code의 시작 주소를 0x00으로 설정합니다.
.code16					# 16비트 코드로 설정합니다.

.text					# Text Segment를 정의합니다.
	.globl _start;

_start:
	jmp _boot # _boot 레이블로 이동합니다.

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
		lodsb # AX의 하위 1바이트(AL) 레지스터에
					# DS 세그먼트의 오프셋 SI 의 값을 저장합니다.
					# AL = DS:SI와 같습니다.
					# 여기서 SI의 값은 print 매크로에서 저장한 str(argument)의 주소 입니다.
		orb  %AL, %AL		# % AL과 AL를 OR 연산 합니다.
		jz   .putchar_end	# orb  %al, %al의 결과가 0일 경우 .putchar_end로 이동합니다.
		movb $0x0E, %AH		# BIOS Service Code (Write Character in TTY Mode)
		int  $0x10		# 인터럽트 0x10 발생 (Video Service)
		jmp  .putchar		# .putchar_end로 이동합니다. (Loop)
	# <Function End> putchar

	# <Function Start> putchar_end : putchar에서 Character를 모두 출력했을때 진입되는 Function 입니다.
	.putchar_end:
		ret			# 처음 함수나 매크로를 호출했던곳으로 이동합니다.
	# <Function End> putchar_end

_boot:
	# _start에 있는 print 매크로를 실행합니다. argument로 helloWorld와 url를 넣습니다.
	print helloWorld
	print url

. = _start + 510			# 현재 위치에서 510번 주소로 이동합니다.
					# 현재 위치에서 510번 주소까지 0x00으로 채워진다.
.byte 0x55				# Boot Signature를 추가합니다.
.byte 0xAA				# 0x55 0xAA는 부트로더임을 알리는 값입니다.
