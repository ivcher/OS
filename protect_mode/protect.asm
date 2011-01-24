org	7C00h		
	cli
	xor		ax, ax
	mov		ss, ax
	xor		sp, sp
	sti
	mov		ds, ax
	mov		es, ax
	
	jmp	_start
	
gdt_table:
	dw	32 - 1
	dd	GDT

idt_table:
	dw	256 * 8
	dd	buffer

text_all db 'This int, but not 13.'
len_all	dw	$ - text_all

text_error 		db 	'Error.'
len_error	dw	$ - text_error

text_int13 db 'It is int 13!'
len_int13	dw	$ - text_int13
		
_start:	
	mov	ax, 0204h
	mov	cx, 0002h
	mov	dh, ch
	mov	bx, buffer
	int	013h
	jc	_error

	cli
	lgdt	[gdt_table]
	lidt	[idt_table]
	mov	eax, cr0
	or	al, 01h
	mov	cr0, eax
	
	xor	ax, ax
	mov	ds, ax
	mov	es, ax
	mov	ax, 8 * 2
	mov	ss, ax
	jmp	08h:_1

_1:
	sti
;	int	13
	int 14

_error:
	mov	ax, 01301h
	xor	bh, bh
	mov	bl, 4
	mov	cx, [len_error]
	mov	bp, text_error
	xor	dx, dx
	int	10h
	cli
	hlt

int_all:
	push	cx
	push	si
	mov	cx, [len_all] 
	mov	si, text_all
	call	print
	pop	si
	pop	cx
	iret

int_13:
	push	cx
	push	si
	mov	cx, [len_int13]
	mov	si, text_int13
	call	print
	pop	si
	pop	cx
	iret

print:
	push	di
	push	ds
	push	es
	mov	ax, 8 * 3
	mov	es, ax
	xor	di, di
	mov	ds, di
	mov	al, 0ah
_print_ckl:
	movsb
	stosb
	loop	_print_ckl
	
	cli
	hlt
	
	pop	es
	pop	ds
	pop	di
	ret

GDT:
		times 8 db 00h
		db	0FFh, 0FFh, 	00h, 00h,  00h, 10011000b, 00000000b, 00h
		db	0FFh, 0FFh, 	00h, 00h,  00h, 10010110b, 00001111b, 00h
		db	00h,  010h, 	00h, 080h, 0Bh, 10010010b, 00000000b, 00h
buffer:
		times 510 - ($ - $$) db 00h
		db	055h, 0AAh

IDT:
		%rep 13
			dw	int_all
			dw	08h
			db 	00h, 10000110b, 00h, 00h

		%endrep

			dw int_13
			dw 08h
			db 00h, 10000110b, 00h, 00h

		%rep 242
			dw int_all
			dw 08h
			db 00h, 10000110b, 00h, 00h
		%endrep