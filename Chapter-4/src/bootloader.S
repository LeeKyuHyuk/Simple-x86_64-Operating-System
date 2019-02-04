.org 0x00			# Code의 시작 주소를 0x00으로 설정합니다.
.code16				# 16비트 코드로 설정합니다.

.text				# Text Segment를 정의합니다.
	.globl _start;

_start:
	#print letter 'K' onto the screen
	movb $'K' , %AL		# 출력할 문자
	movb $0x0E, %AH		# 출력할 BIOS Service Code
	int  $0x10		# CPU 인터럽트 0x10 발생

	#print letter 'y' onto the screen
	movb $'y' , %AL
	movb $0x0E, %AH
	int  $0x10

	#print letter 'u' onto the screen
	movb $'u' , %AL
	movb $0x0E, %AH
	int  $0x10

	#print letter 'H' onto the screen
	movb $'H' , %AL
	movb $0x0E, %AH
	int  $0x10

	#print letter 'y' onto the screen
	movb $'y' , %AL
	movb $0x0E, %AH
	int  $0x10

	#print letter 'u' onto the screen
	movb $'u' , %AL
	movb $0x0E, %AH
	int  $0x10

	#print letter 'k' onto the screen
	movb $'k' , %AL
	movb $0x0E, %AH
	int  $0x10

	. = _start + 510	# 현재 위치에서 510번 주소로 이동합니다.
				# 현재 위치에서 510번 주소까지 0x00으로 채워진다.
	.byte 0x55		# Boot Signature를 추가합니다.
	.byte 0xAA		# 0x55 0xAA는 부트로더임을 알리는 값입니다.
