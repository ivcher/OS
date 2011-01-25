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
flag	dw	0
	
text_all db 'This int, but not 13.'
len_all	dw	$ - text_all

text_error 		db 	'Error.'
len_error	dw	$ - text_error

text_int13 db 'It is int 13!'
len_int13	dw	$ - text_int13

text_int9 db 'It is int 9!'
len_int9	dw	$ - text_int9

text_s_kodom	db	'Int with error code.'
len_s_kodom	dw	$ - text_s_kodom
_start:	
	mov	ax, 0204h
	mov	cx, 0002h
	mov	dh, ch
	mov	bx, buffer
	int	013h
	jc	_error

	mov	ax,3	; ochistka ekrana
	int 10h
	
	cli
	lgdt	[gdt_table]
	lidt	[idt_table]
	mov	eax, cr0
	or	al, 01h
	mov	cr0, eax

	jmp	08h:_1

_1:	
	xor	ax, ax
	mov	ds, ax
	mov	es, ax
	mov	ax, 8 * 2
	mov	ss, ax

	mov	al, 00010011b	; ICW1
	;0001 - init
	;0 - level trigged mode
	;0 - call addr interval 4
	;1 - single mode
	;1 - ICW4 needed
	out	20h, al
	mov	al, 00001000b	; ICW2
	out	21h, al
	mov	al, 00000001b	; ICW4
	out	21h, al
	mov	al, 11111101b	; disable mask
	out	21h, al
	sti
	
_2:
;	int	13
;	int 14
	mov	ax,flag
	cmp	 ax,1
	je	_2
	mov	[flag],ax
	int 8
	jmp	_2
	
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
int_s_kodom_oshibki:
	push	cx
	push	si
	mov	cx, [len_s_kodom] 
	mov	si, text_s_kodom
	call	print
	pop	si
	pop	cx
	pop	ax		; kod oshibki... 
				;15-3 - ,biti selectora, vizvavshego int
				;2 - TI, 1 esli prichia v LDT , 0 - GDT
				;1 - IDT, 1 esli prichina - descriptor v IDT
				;0 - EXT, 1 esli pichina - apparatnoe prerivanie
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
int_9:
	push	cx
	push	si
	mov	cx, [len_int9]
	mov	si, text_int9
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
;	xor	di, di
	mov	ax,0
	mov	ds, ax
	mov	al, 0ah
_print_ckl:
	movsb
	stosb
	loop	_print_ckl
	
;	cli
;	hlt
	
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
		%rep 8
			dw	int_all
			dw	08h
			db 	00h, 10000110b, 00h, 00h

		%endrep
			dw int_s_kodom_oshibki	; int 8 so smescheniem
			dw 08h
			db 00h, 10000110b, 00h, 00h
		
			dw int_9
			dw 08h
			db 00h, 10000110b, 00h, 00h

			dw int_s_kodom_oshibki	; int 0Ah
			dw 08h
			db 00h, 10000110b, 00h, 00h

			dw	int_all	; int 0Bh
			dw	08h
			db 	00h, 10000110b, 00h, 00h

		%rep 3
			dw int_s_kodom_oshibki	; int 0Ch - 0Eh
			dw 08h
			db 00h, 10000110b, 00h, 00h
		%endrep
		
		%rep 2
			dw	int_all		; 0Fh - 10h
			dw	08h
			db 	00h, 10000110b, 00h, 00h
		%endrep
			dw int_s_kodom_oshibki	; int 11h
			dw 08h
			db 00h, 10000110b, 00h, 00h

		%rep 256 - (17+1)
			dw int_all
			dw 08h
			db 00h, 10000110b, 00h, 00h
		%endrep