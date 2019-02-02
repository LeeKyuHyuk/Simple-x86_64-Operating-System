.org 0x00			# Code의 시작 주소를 0x00으로 설정
.code16			# 16비트 코드로 설정

.text				# Text Segment를 정의
	.globl _start;

_start:
	. = _start + 510	# 현재 위치(0x00)에서 510번 주소로 mov
				# 현재 위치(0x00)에서 510번 주소까지 0x00으로 채워진다.
	.byte 0x55		# Boot Signature 추가
	.byte 0xaa		# 0x55 0xAA는 부트로더임을 알리는 값입니다.
