global sub_int
sub_int:
	push	ebp
	mov	ebp,esp
	mov	eax,[ss:ebp+12]
	sub	eax,[ss:ebp+8]
	pop	ebp
	ret