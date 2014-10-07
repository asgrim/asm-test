section .data
	hello:     db 'Hello world!',10    ; 'Hello world!' plus a linefeed character
	helloLen:  equ $-hello             ; Length of the 'Hello world!' string
	                                   ; (I'll explain soon)

section .text
	global _start

print:
	mov eax,4		; write system call
	mov ebx,1		; stdout
	mov ecx,hello
	mov edx,helloLen
	int 80h
	ret
; endp print

_start:
	call print

	mov eax,1            ; The system call for exit (sys_exit)
	mov ebx,0            ; Exit with return code of 0 (no error)
	int 80h
