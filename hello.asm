section .data
	readerr: db 'There was an error reading from the file...',10
	readerrlen: equ $-readerr

section .bss
	buf: resb 8192		; buffer for reading up to 8192 bytes
	bufsize: resb 1		; size of buffer

section .text
	global _start

cat:
	mov ebx,eax			; ebx = fd from open (eax)
	mov eax,3			; read
	mov ecx,buf			; address of buf (i.e. this is "output")
	mov edx,bufsize		; address of bufsize
	int 80h

	test eax,eax
	jz eof				; eof
	js error			;

	mov edx,eax			; edx = bytecount from read
	mov eax,4			; write
	mov ebx,1			; stdout
	; ecx is buf still
	int 80h

	jmp exit

_start:
	pop ebx ; pop argc
	pop ebx ; pop argv[0]
	pop ebx ; filename

	mov eax,5			; open
	; ebx is from argv
	mov ecx,0			; read only
	int 80h

	test eax,eax		; valid?
	jns cat

eof:
	jmp exit

error:
	mov eax,4
	mov ebx,1
	mov ecx,readerr
	mov edx,readerrlen
	int 80h

	jmp exit

exit:
	mov eax,1			; exit
	mov ebx,0			; exit code
	int 80h
