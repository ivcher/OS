	org 0x7c00

	cli
	mov	ax,cs
	mov	ds,ax
	mov	ss,ax
	mov	sp,0
	mov	es,ax
	sti

;	load	sector
	
	mov	ax,0x0201
	mov	ch,0
	mov	cl,2
	mov	dh,ch
	xor	dl,dl
	mov bx,buffer
	int 0x13
	jc	_err

	mov	si,buffer	
	mov	di,stroka1
_copy:
	lodsb
	stosb
	test	al,al
	jnz	_copy

	mov	si,stroka1
	jmp	_print
	
_err:
	mov	si,error
	jmp	_print

_print:	
	lodsb
	cmp	al,0
	je	_end
	mov	ah,0x0e
	mov	bx,3
	int	0x10

	jmp	_print
	
_end:
	cli
	hlt
	ret

error	db	'Error.',0
stroka1	db	0
;buffer
	times	510-($-$$)	db 0
	db	0x55,0xaa
stroka	db	'Hello, world!',0
	times	498	db 0
buffer	db	?	