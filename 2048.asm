;-------------------------------2048 BOARD GAME ON 4*4 GRID
;-------------------------------FINAL PROJECT BY MUHAMMAD ABDULLAH ATIF
;-------------------------------ROLL NO # L21-6225
;-------------------------------SECTION AND BATCH BSDS-3A2-21
;-------------------------------HOPE YOU LIKE IT AND WIN :)
[org 0x0100]
;-------------------------------
;-------------------------------BASIC NEEDS (promts and messages)
;-------------------------------
jmp start
	welcomemsg1:     db " COAL FINAL PROJECT "
	welcomemsg2:     db " WELCOME TO 2048 BOARD GAME "
	welcomemsg3:     db " GAME WILL START IN FEW SECONDS "
	welcomemsg4:     db " 2048 BOARD GAME "
	welcomemsg5:     db " SCORE "
	welcomemsg6:     db " L21-6225 "
	welcomemsg7:     db " By MUHAMMAD ABDULLAH "
	instructionmsg1: db "Instructions :"
	instructionmsg2: db "1) Up     -  ^"
	instructionmsg3: db "2) Down   -  v"
	instructionmsg4: db "3) Left   -  <"
	instructionmsg5: db "4) Right  -  >"
	instructionmsg6: db "5) End    -ESC"
	endingmsg1:      db " ||GAME OVER|| "
	endingmsg2:      db " ||YOUR SCORE IS GIVEN BELOW|| "
	endingmsg3:      db " ||SCORE|| "
	random2:         dw 2
	endingscore:     dw 0
	endingcheck:     dw 2048
	random0123:      db 0
	oldisr:          dd 0
	score:           dw 0
	arr1:            dw 0,0,0,0
	arr2:            dw 0,0,0,0
	arr3:            dw 0,0,0,0
	arr4:            dw 0,0,0,0
    zerocheck:       dw 0
;-------------------------------
;-------------------------------CLEAR SCREEN (Clearing screen)
;-------------------------------
clearscreen:
		mov ax,0xb800
		mov es,ax
		mov di,0
	clr:
		mov word[es:di],0x0720
		add di,2
		cmp di,4000
		jne clr
		ret
;-------------------------------
;-------------------------------DELAY FUNCTION GRID LINE PRINT (delaying printing of lines in grid)
;-------------------------------
delay:
		mov bp, 2
		mov si, 2
	d:
		dec bp
		jnz d
		dec si
		cmp si,0    
		jnz d
		ret	
;-------------------------------
;-------------------------------DELAY FUNCTION2 GRID CROSSES PRINT (delaying printing of crosses in grid)
;-------------------------------
delay1:
		mov bp,10
		mov si,10
	d_1:
		dec bp
		jnz d_1
		dec si
		cmp si,0    
		jnz d_1
		ret
;-------------------------------
;-------------------------------DELAY FUNCTION3 WELCOME SCREEN COUNTER (delaying counter printing)
;-------------------------------
delay2:
		mov bp,20
		mov si,20
	d_2:
		dec bp
		jnz d_2
		dec si
		cmp si,0    
		jnz d_2
		ret
;-------------------------------
;-------------------------------DELAY FUNCTION4 BIOS
;-------------------------------	
delayprint:
		xor dx,dx
		mov cx,1
		mov ah,0x86
		int 0x0015
		mov ah,0x0c
		int 0x0021
		ret
;-------------------------------
;-------------------------------WELCOME SCREEN (page 1 /welcomemsg 1,2,3 and background)
;-------------------------------
welcomescreen:

		call clearscreen ;<><>

		mov ax,0xb800
		mov es,ax
		mov di,0
	wel:
		mov word[es:di],0x0F5F
		add di,2
		cmp di,4000
		jne wel
	welmessage1:
		mov ah,0x13
		mov al,0
		mov bh,0
		mov bl,0x4F
		mov dx,0x041F
		mov cx,20
		push cs
		pop es
		mov bp,welcomemsg1
		int 0x10
	welmessage2:
		mov ah,0x13
		mov al,0
		mov bh,0
		mov bl,0x2F
		mov dx,0x081B
		mov cx,28
		push cs
		pop es
		mov bp,welcomemsg2
		int 0x10
	welmessage3:
		mov ah,0x13
		mov al,0
		mov bh,0
		mov bl,0x1F
		mov dx,0x0C19
		mov cx,32
		push cs
		pop es
		mov bp,welcomemsg3
		int 0x10
	timer:
		call delay
		mov ax,0xb800
		mov es,ax
		mov di,2638
		mov dh,0x0F
		mov dl,0x35
		mov bx,6
	time:
		mov word[es:di],dx
		call delay2
		sub dl,0x01
		sub bx,1
		cmp bx,0
		jnz time

		call clearscreen ;<><>

		ret
;-------------------------------
;-------------------------------END SCREEN (page 3 /endingmsg 1,2,3 and background/final score)
;-------------------------------
endingscreen:

		call clearscreen ;<><>

		mov ax,0xb800
		mov es,ax
		mov di,0
	ends:
		mov word[es:di],0x0E5F
		add di,2
		cmp di,4000
		jne ends
		mov di,0
	ends1:
		mov word[es:di],0x0E7C
		add di,2
		cmp di,318
		jne ends1
		mov di,318
	ends2:
		mov word[es:di],0x0E7C
		add di,160
		cmp di,3998
		jne ends2
		mov di,3680
	ends3:
		mov word[es:di],0x0E7C
		add di,2
		cmp di,4000
		jne ends3
		mov di,3840
	ends4:
		mov word[es:di],0x0E7C
		sub di,160
		cmp di,0
		jne ends4
	endmessage1:
		mov ah,0x13
		mov al,0
		mov bh,0
		mov bl,0xCF
		mov dx,0x0A20
		mov cx,15
		push cs
		pop es
		mov bp,endingmsg1
		int 0x10
	endmessage2:
		mov ah,0x13
		mov al,0
		mov bh,0
		mov bl,0xAF
		mov dx,0x0C18
		mov cx,31
		push cs
		pop es
		mov bp,endingmsg2
		int 0x10
	endmessage3:
		mov ah,0x13
		mov al,0
		mov bh,0
		mov bl,0x9F
		mov dx,0x0E22
		mov cx,11
		push cs
		pop es
		mov bp,endingmsg3
		int 0x10	
	endscore:
		mov ax,2634
		push ax
		push word[score]

		call printnum	;<<>>

		ret
;-------------------------------
;-------------------------------MAIN BOARD INITIALS (page 2/welcomemsg 4,5,6,7/keys instructions,top/bottom backgrounds,border print/actual grid print/printscore)
;-------------------------------
mainboard:
		mov ax,0xb800
		mov es,ax
		mov di,0
	main:
		mov word[es:di],0x4F2E
		add di,2
		cmp di,640
		jne main
		mov di,3360
	main1:
		mov word[es:di],0x4F2E
		add di,2
		cmp di,3840
		jne main1
	welmessage4:
		mov ah,0x13
		mov al,0
		mov bh,0
		mov bl,0x0E
		mov dx,0x021D
		mov cx,17
		push cs
		pop es
		mov bp,welcomemsg4
		int 0x10
	welmessage5:
		mov ah,0x13
		mov al,0
		mov bh,0
		mov bl,0x0E
		mov dx,0x023F
		mov cx,7
		push cs
		pop es
		mov bp,welcomemsg5
		int 0x10
	welmessage6:
		mov ah,0x13
		mov al,0
		mov bh,0
		mov bl,0x0E
		mov dx,0x0205
		mov cx,10
		push cs
		pop es
		mov bp,welcomemsg6
		int 0x10
	welmessage7:
		mov ah,0x13
		mov al,0
		mov bh,0
		mov bl,0x0E
		mov dx,0x161B
		mov cx,22
		push cs
		pop es
		mov bp,welcomemsg7
		int 0x10

       call printgrid ;<><>

	   call printborder ;<><>

		call delay1
		mov ah,0x13
		mov al,0
		mov bh,0
		mov bl,0x4F
		mov dx,0x0804
		mov cx,14
		push cs
		pop es
		mov bp,instructionmsg1
		int 0x10
	insmsg2:
		call delay
		mov ah,0x13
		mov al,0
		mov bh,0
		mov bl,0x1E
		mov dx,0x0A04
		mov cx,14
		push cs
		pop es
		mov bp,instructionmsg2
		int 0x10
	insmsg3:
		call delay
		mov ah,0x13
		mov al,0
		mov bh,0
		mov bl,0x2E
		mov dx,0x0C04
		mov cx,14
		push cs
		pop es
		mov bp,instructionmsg3
		int 0x10
	insmsg4:
		call delay
		mov ah,0x13
		mov al,0
		mov bh,0
		mov bl,0x5E
		mov dx,0x0E04
		mov cx,14
		push cs
		pop es
		mov bp,instructionmsg4
		int 0x10
	insmsg5:
		call delay
		mov ah,0x13
		mov al,0
		mov bh,0
		mov bl,0x3E
		mov dx,0x1004
		mov cx,14
		push cs
		pop es
		mov bp,instructionmsg5
		int 0x10
	insmsg6:
		call delay
		mov ah,0x13
		mov al,0
		mov bh,0
		mov bl,0x6E
		mov dx,0x1204
		mov cx,14
		push cs
		pop es
		mov bp,instructionmsg6
		int 0x10

		call delay1 ;<><>

		call printgridarray  ;<><> ;<><>

		call generate2 ;<><>

		call printscore ;<><>

		ret
;-------------------------------
;-------------------------------PRINT BORDER (printing border of grid)
;-------------------------------
printborder:
		mov ax,0xb800
		mov es,ax
		mov di,844
	border1:
		mov word[es:di],0x5ECD
		add di,2
		cmp di,908
		jne border1
		mov di,1066
	border2:
		mov word[es:di],0x5ECE
		add di,160
		cmp di,3146
		jne border2
		mov di,3146
	border3:
		mov word[es:di],0x5ECD
		sub di,2
		cmp di,3082
		jne border3
		mov di,2924
	border4:
		mov word[es:di],0x5ECE
		sub di,160
		cmp di,844
		jne border4
		ret
;-------------------------------
;-------------------------------PRINT GRID (actual grid printing)
;-------------------------------
printgrid:
		mov ax,0xb800
		mov es,ax
		mov di,1006	
	print1:
		mov word[es:di],0x31DF

		call delay ;<><>

		add di,2
		cmp di,1066
		jne print1
		mov di,1224
	print2:
		mov word[es:di],0x31DC

		call delay ;<><>

		add di,160
		cmp di,3144
		jne print2
		mov di,1222
	print3:
		mov word[es:di],0x31DC
		add di,160
		cmp di,3142
		jne print3
		mov di,2984
	print4:
		mov word[es:di],0x31DC

		call delay ;<><>

		sub di,2
		cmp di,2926
		jne print4
		mov di,2926
	print5:
		mov word[es:di],0x31DC

		call delay ;<><>
		 
		sub di,160
		cmp di,1006
		jne print5
		mov di,2928
	print6:
		mov word[es:di],0x31DC
		sub di,160
		cmp di,1008
		jne print6

		call delay1 ;<><>

		mov di,1180
	print7:
		mov word[es:di],0x31DC
		add di,160
		cmp di,2940
		jne print7	
		mov di,1182
	print8:
		mov word[es:di],0x31DC
		add di,160
		cmp di,2942
		jne print8
		mov di,1486
	print9:
		mov word[es:di],0x31DC
		add di,2
		cmp di,1544
		jne print9

		call delay1 ;<><>

		mov di,1194
	print10:
		mov word[es:di],0x31DC
		add di,160
		cmp di,2954
		jne print10	
		mov di,1196
	print11:
		mov word[es:di],0x31DC
		add di,160
		cmp di,2956
		jne print11
		mov di,1966
	print12:
		mov word[es:di],0x31DC
		add di,2
		cmp di,2024
		jne print12

		call delay1 ;<><>

		mov di,1208
	print13:
		mov word[es:di],0x31DC
		add di,160
		cmp di,2968
		jne print13	
		mov di,1210
	print14:
		mov word[es:di],0x31DC
		add di,160
		cmp di,2970
		jne print14	
		mov di,2446
	print15:
		mov word[es:di],0x31DC
		add di,2
		cmp di,2504
		jne print15

		call delay1 ;<><>

		ret
;-------------------------------
;-------------------------------GET RANDOM 2 (getting randomly 2)
;-------------------------------
getrandom2:
		MOV AH, 00h ; interrupts to get system time
		INT 1AH ; CX:DX now hold number of clock ticks since midnight
		mov dx,2
		mov ax, dx
		xor dx, dx
		mov cx, 3;
		div cx ; here dx contains the remainder of the division - from 0 to 9
		add dl, '0' ; to ascii from '0' to '9'
		mov word[random2],dx;
		ret
;-------------------------------
;-------------------------------GET RANDOM 0123 (getting randomly 0123)
;-------------------------------	
getrandom0123:
		MOV AH, 00h ; interrupts to get system time
		INT 1AH ; CX:DX now hold number of clock ticks since midnight
		mov ax, dx
		xor dx, dx
		mov cx, 8
		div cx ; here dx contains the remainder of the division - from 0 to 9
		add dl, '0' ; to ascii from '0' to '9'
		mov word[random0123],dx;
		ret
;-------------------------------
;-------------------------------PRINT SCORE (printing score on page 2)
;-------------------------------
printscore:
		mov ax,0xb800
		mov es,ax
		mov ax,462
		push ax
		push word[score]

		call printnum ;<><>

		ret
;-------------------------------
;-------------------------------PRINT RANDOM 2 (printing 2 randomly out of any 16 locations)
;-------------------------------
printgridarray:
		mov ax,0xb800
		mov es,ax
	
		mov ax,1330
		push ax
		push word[arr1]

		call printnum ;<><>
		
		mov ax,1344
		push ax
		push word[arr1+2]

		call printnum ;<><>
		
		mov ax,1358
		push ax
		push word[arr1+4]

		call printnum ;<><>
		
		mov ax,1372
		push ax
		push word[arr1+6]

		call printnum ;<><>
	
		mov ax,1810
		push ax
		push word[arr2]

		call printnum ;<><>
		
		mov ax,1824
		push ax
		push word[arr2+2]

		call printnum ;<><>
		
		mov ax,1838
		push ax
		push word[arr2+4]

		call printnum ;<><>
		
		mov ax,1852
		push ax
		push word[arr2+6]

		call printnum ;<><>
		
		mov ax,2290
		push ax
		push word[arr3]

		call printnum ;<><>
		
		mov ax,2304
		push ax
		push word[arr3+2]

		call printnum ;<><>
		
		mov ax,2318
		push ax
		push word[arr3+4]

		call printnum ;<><>
		
		mov ax,2332
		push ax
		push word[arr3+6]

		call printnum ;<><>
	
		mov ax,2770
		push ax
		push word[arr4]

		call printnum ;<><>
		
		mov ax,2784
		push ax
		push word[arr4+2]

		call printnum ;<><>

		
		mov ax,2798
		push ax
		push word[arr4+4]

		call printnum ;<><>
		
		mov ax,2812
		push ax
		push word[arr4+6]

		call printnum ;<><>
		ret			
;-------------------------------
;-------------------------------RIGHT KEY FUNCTION
;-------------------------------
rightfunction:
	rarray_1:
			mov ax,[arr1+4]
			mov bx,[arr1+6]
			cmp ax,bx
			jz r1
		rback2:
			mov ax,[arr1+2]
			mov bx,[arr1+4]
			cmp ax,bx
			jz r2
		rback3:
			mov ax,[arr1]
			mov bx,[arr1+2]
			cmp ax,bx
			jz r3
		rback4:
			mov ax,[arr1]
			mov bx,[arr1+4]
			cmp ax,bx
			jz r4
		rback5:
			mov ax,[arr1]
			mov bx,[arr1+6]
			cmp ax,bx
			jz r5
		rback6:
			mov ax,[arr1+2]
			mov bx,[arr1+6]
			cmp ax,bx
			jz r6
			jmp rarray_2
		r1:
			add ax,bx
			mov word[arr1+6],ax
			mov word[arr1+4],0
 
            call printgridarray  ;<><>

            add word[score],5
			jmp rback2
		r2:
			add ax,bx
			mov word[arr1+4],ax
			mov word[arr1+2],0
			
			call printgridarray ;<><>

            add word[score],5
			jmp rback3
		r3:
			add ax,bx
			mov word[arr1+2],ax
			mov word[arr1],0
			
			call printgridarray ;<><>

            add word[score],5
			jmp rback4
		r4:
			add ax,bx
			mov word[arr1+4],ax
			mov word[arr1],0
			
			call printgridarray ;<><>

            add word[score],5
			jmp rback5
		r5:
			add ax,bx
			mov word[arr1+6],ax
			mov word[arr1],0
			
			call printgridarray ;<><>

            add word[score],5
			jmp rback6	
		r6:
			add ax,bx
			mov word[arr1+6],ax
			mov word[arr1+2],0
			
			call printgridarray ;<><>
			add word[score],5

	rarray_2:
			mov ax,[arr2+4]
			mov bx,[arr2+6]
			cmp ax,bx
			jz rr1
		rrback2:
			mov ax,[arr2+2]
			mov bx,[arr2+4]
			cmp ax,bx
			jz rr2
		rrback3:
			mov ax,[arr2]
			mov bx,[arr2+2]
			cmp ax,bx
			jz rr3
		rrback4:
			mov ax,[arr2]
			mov bx,[arr2+4]
			cmp ax,bx
			jz rr4
		rrback5:
			mov ax,[arr2]
			mov bx,[arr2+6]
			cmp ax,bx
			jz rr5
		rrback6:
			mov ax,[arr2+2]
			mov bx,[arr2+6]
			cmp ax,bx
			jz rr6
			jmp rarray_3
		rr1:
			add ax,bx
			mov word[arr2+6],ax
			mov word[arr2+4],0
			
			call printgridarray  ;<><>

            add word[score],5
			jmp rrback2
		rr2:
			add ax,bx
			mov word[arr2+4],ax
			mov word[arr2+2],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp rrback3
		rr3:
			add ax,bx
			mov word[arr2+2],ax
			mov word[arr2],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp rrback4
		rr4:
			add ax,bx
			mov word[arr2+4],ax
			mov word[arr2],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp rrback5
		rr5:
			add ax,bx
			mov word[arr2+6],ax
			mov word[arr2],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp rrback6	
		rr6:
			add ax,bx
			mov word[arr2+6],ax
			mov word[arr2+2],0
			
			call printgridarray  ;<><>
     
            add word[score],5	

	rarray_3:
			mov ax,[arr3+4]
			mov bx,[arr3+6]
			cmp ax,bx
			jz rrr1
		rrrback2:
			mov ax,[arr3+2]
			mov bx,[arr3+4]
			cmp ax,bx
			jz rrr2
		rrrback3:
			mov ax,[arr3]
			mov bx,[arr3+2]
			cmp ax,bx
			jz rrr3
		rrrback4:
			mov ax,[arr3]
			mov bx,[arr3+4]
			cmp ax,bx
			jz rrr4
		rrrback5:
			mov ax,[arr3]
			mov bx,[arr3+6]
			cmp ax,bx
			jz rrr5
		rrrback6:
			mov ax,[arr3+2]
			mov bx,[arr3+6]
			cmp ax,bx
			jz rrr6
			jmp rarray_4
		rrr1:
			add ax,bx
			mov word[arr3+6],ax
			mov word[arr3+4],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp rrrback2
		rrr2:
			add ax,bx
			mov word[arr3+4],ax
			mov word[arr3+2],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp rrrback3
		rrr3:
			add ax,bx
			mov word[arr3+2],ax
			mov word[arr3],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp rrrback4
		rrr4:
			add ax,bx
			mov word[arr3+4],ax
			mov word[arr3],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp rrrback5
		rrr5:
			add ax,bx
			mov word[arr3+6],ax
			mov word[arr3],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp rrrback6	
		rrr6:
			add ax,bx
			mov word[arr3+6],ax
			mov word[arr3+2],0
			
			call printgridarray  ;<><>
     
            add word[score],5	

	rarray_4:
			mov ax,[arr4+4]
			mov bx,[arr4+6]
			cmp ax,bx
			jz rrrr1
		rrrrback2:
			mov ax,[arr4+2]
			mov bx,[arr4+4]
			cmp ax,bx
			jz rrrr2
		rrrrback3:
			mov ax,[arr4]
			mov bx,[arr4+2]
			cmp ax,bx
			jz rrrr3
		rrrrback4:
			mov ax,[arr4]
			mov bx,[arr4+4]
			cmp ax,bx
			jz rrrr4
		rrrrback5:
			mov ax,[arr4]
			mov bx,[arr4+6]
			cmp ax,bx
			jz rrrr5
		rrrrback6:
			mov ax,[arr4+2]
			mov bx,[arr4+6]
			cmp ax,bx
			jz rrrr6
			jmp rend
		rrrr1:
			add ax,bx
			mov word[arr4+6],ax
			mov word[arr4+4],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp rrrrback2
		rrrr2:
			add ax,bx
			mov word[arr4+4],ax
			mov word[arr4+2],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp rrrrback3
		rrrr3:
			add ax,bx
			mov word[arr4+2],ax
			mov word[arr4],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp rrrrback4
		rrrr4:
			add ax,bx
			mov word[arr4+4],ax
			mov word[arr4],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp rrrrback5
		rrrr5:
			add ax,bx
			mov word[arr4+6],ax
			mov word[arr4],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp rrrrback6	
		rrrr6:
			add ax,bx
			mov word[arr4+6],ax
			mov word[arr4+2],0
			
			call printgridarray  ;<><>
     
            add word[score],5	
		rend:	
			ret
;-------------------------------
;-------------------------------LEFT KEY FUNCTION
;-------------------------------
leftfunction:
	larray_1:
			mov ax,[arr1+4]
			mov bx,[arr1+6]
			cmp ax,bx
			jz l1
		lback2:
			mov ax,[arr1+2]
			mov bx,[arr1+4]
			cmp ax,bx
			jz l2
		lback3:
			mov ax,[arr1]
			mov bx,[arr1+2]
			cmp ax,bx
			jz l3
		lback4:
			mov ax,[arr1]
			mov bx,[arr1+4]
			cmp ax,bx
			jz l4
		lback5:
			mov ax,[arr1]
			mov bx,[arr1+6]
			cmp ax,bx
			jz l5
		lback6:
			mov ax,[arr1+2]
			mov bx,[arr1+6]
			cmp ax,bx
			jz l6
			jmp larray_2
		l1:
			add ax,bx
			mov word[arr1+4],ax
			mov word[arr1+6],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp lback2
		l2:
			add ax,bx
			mov word[arr1+2],ax
			mov word[arr1+4],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp lback3
		l3:
			add ax,bx
			mov word[arr1],ax
			mov word[arr1+2],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp lback4
		l4:
			add ax,bx
			mov word[arr1],ax
			mov word[arr1+4],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp lback5
		l5:
			add ax,bx
			mov word[arr1],ax
			mov word[arr1+6],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp lback6	
		l6:
			add ax,bx
			mov word[arr1+2],ax
			mov word[arr1+6],0
			
			call printgridarray  ;<><>
     
            add word[score],5	

	larray_2:
			mov ax,[arr2+6]
			mov bx,[arr2+4]
			cmp ax,bx
			jz ll1
		llback2:
			mov ax,[arr2+4]
			mov bx,[arr2+2]
			cmp ax,bx
			jz ll2
		llback3:
			mov ax,[arr2]
			mov bx,[arr2+2]
			cmp ax,bx
			jz ll3
		llback4:
			mov ax,[arr2+4]
			mov bx,[arr2]
			cmp ax,bx
			jz ll4
		llback5:
			mov ax,[arr2+6]
			mov bx,[arr2]
			cmp ax,bx
			jz ll5
		llback6:
			mov ax,[arr2+6]
			mov bx,[arr2+2]
			cmp ax,bx
			jz ll6
			jmp larray_3
		ll1:
			add ax,bx
			mov word[arr2+4],ax
			mov word[arr2+6],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp llback2
		ll2:
			add ax,bx
			mov word[arr2+2],ax
			mov word[arr2+4],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp llback3
		ll3:
			add ax,bx
			mov word[arr2],ax
			mov word[arr2+2],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp llback4
		ll4:
			add ax,bx
			mov word[arr2],ax
			mov word[arr2+4],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp llback5
		ll5:
			add ax,bx
			mov word[arr2],ax
			mov word[arr2+6],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp llback6	
		ll6:
			add ax,bx
			mov word[arr2+2],ax
			mov word[arr2+6],0
			
			call printgridarray  ;<><>
     
            add word[score],5	

	larray_3:
			mov ax,[arr3+6]
			mov bx,[arr3+4]
			cmp ax,bx
			jz lll1
		lllback2:
			mov ax,[arr3+4]
			mov bx,[arr3+2]
			cmp ax,bx
			jz lll2
		lllback3:
			mov ax,[arr3+2]
			mov bx,[arr3]
			cmp ax,bx
			jz lll3
		lllback4:
			mov ax,[arr3+4]
			mov bx,[arr3]
			cmp ax,bx
			jz lll4
		lllback5:
			mov ax,[arr3+6]
			mov bx,[arr3]
			cmp ax,bx
			jz lll5
		lllback6:
			mov ax,[arr3+6]
			mov bx,[arr3+2]
			cmp ax,bx
			jz lll6
			jmp larray_4
		lll1:
			add ax,bx
			mov word[arr3+4],ax
			mov word[arr3+6],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp lllback2
		lll2:
			add ax,bx
			mov word[arr3+2],ax
			mov word[arr3+4],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp lllback3
		lll3:
			add ax,bx
			mov word[arr3],ax
			mov word[arr3+2],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp lllback4
		lll4:
			add ax,bx
			mov word[arr3],ax
			mov word[arr3+1],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp lllback5
		lll5:
			add ax,bx
			mov word[arr3],ax
			mov word[arr3+6],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp lllback6	
		lll6:
			add ax,bx
			mov word[arr3+2],ax
			mov word[arr3+6],0
			
			call printgridarray  ;<><>
     
            add word[score],5	

	larray_4:
			mov ax,[arr4+4]
			mov bx,[arr4+6]
			cmp ax,bx
			jz llll1
		llllback2:
			mov ax,[arr4+2]
			mov bx,[arr4+4]
			cmp ax,bx
			jz llll2
		llllback3:
			mov ax,[arr4]
			mov bx,[arr4+2]
			cmp ax,bx
			jz llll3
		llllback4:
			mov ax,[arr4]
			mov bx,[arr4+4]
			cmp ax,bx
			jz llll4
		llllback5:
			mov ax,[arr4]
			mov bx,[arr4+6]
			cmp ax,bx
			jz llll5
		llllback6:
			mov ax,[arr4+2]
			mov bx,[arr4+6]
			cmp ax,bx
			jz llll6
			jmp lend
		llll1:
			add ax,bx
			mov word[arr4+4],ax
			mov word[arr4+6],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp llllback2
		llll2:
			add ax,bx
			mov word[arr4+2],ax
			mov word[arr4+4],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp llllback3
		llll3:
			add ax,bx
			mov word[arr4],ax
			mov word[arr4+2],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp llllback4
		llll4:
			add ax,bx
			mov word[arr4],ax
			mov word[arr4+4],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp llllback5
		llll5:
			add ax,bx
			mov word[arr4],ax
			mov word[arr4+6],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp llllback6	
		llll6:
			add ax,bx
			mov word[arr4+2],ax
			mov word[arr4+6],0
			
			call printgridarray  ;<><>
     
            add word[score],5	
		lend:	
			ret	
;-------------------------------
;-------------------------------DOWN KEY FUNCTION
;-------------------------------
downfunction:
	darray_1:
			mov ax,[arr3+0]
			mov bx,[arr4+0]
			cmp ax,bx
			jz d1
		dback2:
			mov ax,[arr2+0]
			mov bx,[arr3+0]
			cmp ax,bx
			jz d2
		dback3:
			mov ax,[arr1+0]
			mov bx,[arr2+0]
			cmp ax,bx
			jz d3
		dback4:
			mov ax,[arr1+0]
			mov bx,[arr3+0]
			cmp ax,bx
			jz d4
		dback5:
			mov ax,[arr1+0]
			mov bx,[arr4+0]
			cmp ax,bx
			jz d5
		dback6:
			mov ax,[arr2+0]
			mov bx,[arr4+0]
			cmp ax,bx
			jz d6
			jmp darray_2
		d1:
			add ax,bx
			mov word[arr4+0],ax
			mov word[arr3+0],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp dback2
		d2:
			add ax,bx
			mov word[arr3+0],ax
			mov word[arr2+0],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp dback3
		d3:
			add ax,bx
			mov word[arr2+0],ax
			mov word[arr1+0],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp dback4
		d4:
			add ax,bx
			mov word[arr3+0],ax
			mov word[arr1+0],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp dback5
		d5:
			add ax,bx
			mov word[arr4+0],ax
			mov word[arr1+0],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp dback6	
		d6:
			add ax,bx
			mov word[arr4+0],ax
			mov word[arr2+0],0
			
			call printgridarray  ;<><>
     
            add word[score],5	

	darray_2:
			mov ax,[arr3+2]
			mov bx,[arr4+2]
			cmp ax,bx
			jz dd1
		ddback2:
			mov ax,[arr2+2]
			mov bx,[arr3+2]
			cmp ax,bx
			jz dd2
		ddback3:
			mov ax,[arr1+2]
			mov bx,[arr2+2]
			cmp ax,bx
			jz dd3
		ddback4:
			mov ax,[arr1+2]
			mov bx,[arr3+2]
			cmp ax,bx
			jz dd4
		ddback5:
			mov ax,[arr1+2]
			mov bx,[arr4+2]
			cmp ax,bx
			jz dd5
		ddback6:
			mov ax,[arr2+2]
			mov bx,[arr4+2]
			cmp ax,bx
			jz dd6
			jmp darray_3
		dd1:
			add ax,bx
			mov word[arr4+2],ax
			mov word[arr3+2],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp ddback2
		dd2:
			add ax,bx
			mov word[arr3+2],ax
			mov word[arr2+2],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp ddback3
		dd3:
			add ax,bx
			mov word[arr2+2],ax
			mov word[arr1+2],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp ddback4
		dd4:
			add ax,bx
			mov word[arr3+2],ax
			mov word[arr1+2],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp ddback5
		dd5:
			add ax,bx
			mov word[arr4+2],ax
			mov word[arr1+2],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp ddback6	
		dd6:
			add ax,bx
			mov word[arr4+2],ax
			mov word[arr2+2],0
			
			call printgridarray  ;<><>
     
            add word[score],5	

	darray_3:
			mov ax,[arr3+4]
			mov bx,[arr4+4]
			cmp ax,bx
			jz ddd1
		dddback2:
			mov ax,[arr2+4]
			mov bx,[arr3+4]
			cmp ax,bx
			jz ddd2
		dddback3:
			mov ax,[arr1+4]
			mov bx,[arr2+4]
			cmp ax,bx
			jz ddd3
		dddback4:
			mov ax,[arr1+4]
			mov bx,[arr3+4]
			cmp ax,bx
			jz ddd4
		dddback5:
			mov ax,[arr1+4]
			mov bx,[arr4+4]
			cmp ax,bx
			jz ddd5
		dddback6:
			mov ax,[arr2+4]
			mov bx,[arr4+4]
			cmp ax,bx
			jz ddd6
			jmp darray_4
		ddd1:
			add ax,bx
			mov word[arr4+4],ax
			mov word[arr3+4],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp dddback2
		ddd2:
			add ax,bx
			mov word[arr3+4],ax
			mov word[arr2+4],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp dddback3
		ddd3:
			add ax,bx
			mov word[arr2+4],ax
			mov word[arr1+4],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp dddback4
		ddd4:
			add ax,bx
			mov word[arr3+4],ax
			mov word[arr1+4],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp dddback5
		ddd5:
			add ax,bx
			mov word[arr4+4],ax
			mov word[arr1+4],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp dddback6	
		ddd6:
			add ax,bx
			mov word[arr4+4],ax
			mov word[arr2+4],0
			
			call printgridarray  ;<><>
     
            add word[score],5		

	darray_4:
			mov ax,[arr3+6]
			mov bx,[arr4+6]
			cmp ax,bx
			jz dddd1
		ddddback2:
			mov ax,[arr2+6]
			mov bx,[arr3+6]
			cmp ax,bx
			jz dddd2
		ddddback3:
			mov ax,[arr1+6]
			mov bx,[arr2+6]
			cmp ax,bx
			jz dddd3
		ddddback4:
			mov ax,[arr1+6]
			mov bx,[arr3+6]
			cmp ax,bx
			jz dddd4
		ddddback5:
			mov ax,[arr1+6]
			mov bx,[arr4+6]
			cmp ax,bx
			jz dddd5
		ddddback6:
			mov ax,[arr2+6]
			mov bx,[arr4+6]
			cmp ax,bx
			jz dddd6
			jmp rend
		dddd1:
			add ax,bx
			mov word[arr4+6],ax
			mov word[arr3+6],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp ddddback2
		dddd2:
			add ax,bx
			mov word[arr3+6],ax
			mov word[arr2+6],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp ddddback3
		dddd3:
			add ax,bx
			mov word[arr2+6],ax
			mov word[arr1+6],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp ddddback4
		dddd4:
			add ax,bx
			mov word[arr3+6],ax
			mov word[arr1+6],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp ddddback5
		dddd5:
			add ax,bx
			mov word[arr4+6],ax
			mov word[arr1+6],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp ddddback6	
		dddd6:
			add ax,bx
			mov word[arr4+6],ax
			mov word[arr2+6],0
			
			call printgridarray  ;<><>
     
            add word[score],5	
		dend:	
			ret	
;-------------------------------
;-------------------------------UP KEY FUNCTION
;-------------------------------
upfunction:
	uarray_1:
			mov ax,[arr3+0]
			mov bx,[arr4+0]
			cmp ax,bx
			jz u1
		uback2:
			mov ax,[arr2+0]
			mov bx,[arr3+0]
			cmp ax,bx
			jz u2
		uback3:
			mov ax,[arr1+0]
			mov bx,[arr2+0]
			cmp ax,bx
			jz u3
		uback4:
			mov ax,[arr1+0]
			mov bx,[arr3+0]
			cmp ax,bx
			jz u4
		uback5:
			mov ax,[arr1+0]
			mov bx,[arr4+0]
			cmp ax,bx
			jz u5
		uback6:
			mov ax,[arr2+0]
			mov bx,[arr4+0]
			cmp ax,bx
			jz u6
			jmp uarray_2
		u1:
			add ax,bx
			mov word[arr3+0],ax
			mov word[arr4+0],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp uback2
		u2:
			add ax,bx
			mov word[arr2+0],ax
			mov word[arr3+0],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp uback3
		u3:
			add ax,bx
			mov word[arr1+0],ax
			mov word[arr2+0],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp uback4
		u4:
			add ax,bx
			mov word[arr1+0],ax
			mov word[arr3+0],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp uback5
		u5:
			add ax,bx
			mov word[arr1+0],ax
			mov word[arr4+0],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp uback6	
		u6:
			add ax,bx
			mov word[arr2+0],ax
			mov word[arr4+0],0
			
			call printgridarray  ;<><>
     
            add word[score],5	

	uarray_2:
			mov ax,[arr3+2]
			mov bx,[arr4+2]
			cmp ax,bx
			jz dd1
		uuback2:
			mov ax,[arr2+2]
			mov bx,[arr3+2]
			cmp ax,bx
			jz uu2
		uuback3:
			mov ax,[arr1+2]
			mov bx,[arr2+2]
			cmp ax,bx
			jz uu3
		uuback4:
			mov ax,[arr1+2]
			mov bx,[arr3+2]
			cmp ax,bx
			jz uu4
		uuback5:
			mov ax,[arr1+2]
			mov bx,[arr4+2]
			cmp ax,bx
			jz uu5
		uuback6:
			mov ax,[arr2+2]
			mov bx,[arr4+2]
			cmp ax,bx
			jz uu6
			jmp uarray_3
		uu1:
			add ax,bx
			mov word[arr3+2],ax
			mov word[arr4+2],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp uuback2
		uu2:
			add ax,bx
			mov word[arr2+2],ax
			mov word[arr3+2],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp uuback3
		uu3:
			add ax,bx
			mov word[arr1+2],ax
			mov word[arr2+2],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp uuback4
		uu4:
			add ax,bx
			mov word[arr1+2],ax
			mov word[arr3+2],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp uuback5
		uu5:
			add ax,bx
			mov word[arr1+2],ax
			mov word[arr4+2],0
			
			call printgridarray  ;<><>
     
            add word[score],5
			jmp uuback6	
		uu6:
			add ax,bx
			mov word[arr2+2],ax
			mov word[arr4+2],0
			
			call printgridarray  ;<><>
     
            add word[score],5	

	uarray_3:
			mov ax,[arr3+4]
			mov bx,[arr4+4]
			cmp ax,bx
			jz 1
		uuuback2:
			mov ax,[arr2+4]
			mov bx,[arr3+4]
			cmp ax,bx
			jz uuu2
		uuuback3:
			mov ax,[arr1+4]
			mov bx,[arr2+4]
			cmp ax,bx
			jz uuu3
		uuuback4:
			mov ax,[arr1+4]
			mov bx,[arr3+4]
			cmp ax,bx
			jz uuu4
		uuuback5:
			mov ax,[arr1+4]
			mov bx,[arr4+4]
			cmp ax,bx
			jz uuu5
		uuuback6:
			mov ax,[arr2+4]
			mov bx,[arr4+4]
			cmp ax,bx
			jz uuu6
			jmp uarray_4
		uuu1:
			add ax,bx
			mov word[arr3+4],ax
			mov word[arr4+4],0
			call printgridarray  ;<><>
     
            add word[score],5
			jmp uuuback2
		uuu2:
			add ax,bx
			mov word[arr2+4],ax
			mov word[arr3+4],0
			call printgridarray  ;<><>
     
            add word[score],5
			jmp uuuback3
		uuu3:
			add ax,bx
			mov word[arr1+4],ax
			mov word[arr2+4],0
			call printgridarray  ;<><>
     
            add word[score],5
			jmp uuuback4
		uuu4:
			add ax,bx
			mov word[arr1+4],ax
			mov word[arr3+4],0
			call printgridarray  ;<><>
     
            add word[score],5
			jmp uuuback5
		uuu5:
			add ax,bx
			mov word[arr1+4],ax
			mov word[arr4+4],0
			call printgridarray  ;<><>
     
            add word[score],5
			jmp uuuback6	
		uuu6:
			add ax,bx
			mov word[arr2+4],ax
			mov word[arr4+4],0		
			call printgridarray  ;<><>
     
            add word[score],5	
				
	uarray_4:
			mov ax,[arr3+6]
			mov bx,[arr4+6]
			cmp ax,bx
			jz uuuu1
		uuuuback2:
			mov ax,[arr2+6]
			mov bx,[arr3+6]
			cmp ax,bx
			jz uuuu2
		uuuuback3:
			mov ax,[arr1+6]
			mov bx,[arr2+6]
			cmp ax,bx
			jz uuuu3
		uuuuback4:
			mov ax,[arr1+6]
			mov bx,[arr3+6]
			cmp ax,bx
			jz uuuu4
		uuuuback5:
			mov ax,[arr1+6]
			mov bx,[arr4+6]
			cmp ax,bx
			jz uuuu5
		uuuuback6:
			mov ax,[arr2+6]
			mov bx,[arr4+6]
			cmp ax,bx
			jz uuuu6
			jmp rend
		uuuu1:
			add ax,bx
			mov word[arr3+6],ax
			mov word[arr4+6],0		
			call printgridarray  ;<><>
     
            add word[score],5
			jmp uuuuback2
		uuuu2:
			add ax,bx
			mov word[arr2+6],ax
			mov word[arr3+6],0		
			call printgridarray  ;<><>
     
            add word[score],5
			jmp uuuuback3
		uuuu3:
			add ax,bx
			mov word[arr1+6],ax
			mov word[arr2+6],0		
			call printgridarray  ;<><>
     
            add word[score],5
			jmp uuuuback4
		uuuu4:
			add ax,bx
			mov word[arr1+6],ax
			mov word[arr3+6],0	
			call printgridarray  ;<><>
     
            add word[score],5
			jmp uuuuback5
		uuuu5:
			add ax,bx
			mov word[arr1+6],ax
			mov word[arr4+6],0	
			call printgridarray  ;<><>
     
            add word[score],5
			jmp uuuuback6	
		uuuu6:
			add ax,bx
			mov word[arr2+6],ax
			mov word[arr4+6],0
			call printgridarray  ;<><>
     
            add word[score],5	
		uend:	
			ret
;-------------------------------
;-------------------------------KEYS (up/down/left/right)
;-------------------------------
kbisr:
		push ax
		push es
		mov ax, 0xb800
		mov es, ax 
		in al, 0x60
	up:
		cmp al, 0x48 
		jne down

        call generate2 ;<><>

		call printscore ;<><>

		call endcondition ;<><>

		call upfunction ;<><>

	down:
		cmp al, 0x50 
		jne left

        call generate2 ;<><>

		call printscore ;<><>

		call endcondition ;<><>

		call downfunction ;<><>

	left:
		cmp al, 0x4B
		jne right 
        call generate2 ;<><>

		call printscore ;<><>

		call endcondition ;<><>

		call leftfunction ;<><>

	right:
		cmp al, 0x4D
		jne nomatch
        call generate2 ;<><>

		call printscore ;<><>

		call endcondition ;<><>

		call rightfunction ;<><>
		
	nomatch:
		pop es
		pop ax
		jmp far [cs:oldisr]		
;-------------------------------
;-------------------------------HOOKING KEYS (up/down/left/right)
;-------------------------------
hookeys:
		xor ax, ax
		mov es, ax 
		mov ax, [es:9*4]
		mov [oldisr], ax 
		mov ax, [es:9*4+2]
		mov [oldisr+2], ax 
		cli 
		mov word [es:9*4], kbisr 
		mov [es:9*4+2], cs 
		sti 
	hook1:
		mov ah, 0
		int 0x16
		cmp al, 27 
		jne hook1
		jmp backto
;-------------------------------
;-------------------------------PRINT NUM 2,4,8...(ranging the numbers)
;-------------------------------	
printnum:
		push bp
		mov bp, sp
		push es
		push ax
		push bx
		push cx
		push dx
		push di
		mov ax, 0xb800
		mov es, ax
		mov bx, 10 
		mov cx, 0 
		mov ax, [bp+4] 
		mov di, [bp+6] 
        mov word[es:di],0x0720
        mov word[es:di+2],0x0720
        mov word[es:di+4],0x0720
	nextdigit: 
		mov dx, 0 
		div bx
		add dl, 0x30
		push dx
		inc cx
		cmp ax, 0 
		jnz nextdigit 
	nextpos:
		pop dx 
		mov dh, 0x07
		mov [es:di], dx 
		add di, 2 
		loop nextpos 
		pop di
		pop dx
		pop cx
		pop bx
		pop ax
		pop es
		pop bp
		ret 4	
;-------------------------------
;-------------------------------GENERATE 2 randomly(randomly 2 on 16 locations)
;-------------------------------
generate2:
    g2_1:
        mov ax,[arr1+0]
        mov bx,[zerocheck]
        cmp ax,bx
        jz gn1
    g2_2:
        mov ax,[arr2+2]
        mov bx,[zerocheck]
        cmp ax,bx
        jz gn2
    g2_3:
        mov ax,[arr3+4]
        mov bx,[zerocheck]
        cmp ax,bx
        jz gn3
    g2_4:
        mov ax,[arr4+6]
        mov bx,[zerocheck]
        cmp ax,bx
        jz gn4
    g2_5:
        mov ax,[arr1+2]
        mov bx,[zerocheck]
        cmp ax,bx
        jz gn5
    g2_6:
        mov ax,[arr2+0]
        mov bx,[zerocheck]
        cmp ax,bx
        jz gn6
    g2_7:
        mov ax,[arr3+6]
        mov bx,[zerocheck]
        cmp ax,bx
        jz gn7
    g2_8:
        mov ax,[arr4+4]
        mov bx,[zerocheck]
        cmp ax,bx
        jz gn8
    g2_9:
        mov ax,[arr1+4]
        mov bx,[zerocheck]
        cmp ax,bx
        jz gn9
    g2_10:
        mov ax,[arr2+6]
        mov bx,[zerocheck]
        cmp ax,bx
        jz gn10
    g2_11:
        mov ax,[arr3+0]
        mov bx,[zerocheck]
        cmp ax,bx
        jz gn11
    g2_12:
        mov ax,[arr4+2]
        mov bx,[zerocheck]
        cmp ax,bx
        jz gn12
    g2_13:
        mov ax,[arr1+6]
        mov bx,[zerocheck]
        cmp ax,bx
        jz gn13
    g2_14:
        mov ax,[arr2+4]
        mov bx,[zerocheck]
        cmp ax,bx
        jz gn14
    g2_15:
        mov ax,[arr3+2]
        mov bx,[zerocheck]
        cmp ax,bx
        jz gn15
    g2_16:
        mov ax,[arr4+0]
        mov bx,[zerocheck]
        cmp ax,bx
        jz gn16
        jmp backto

    gn1:
        mov word[arr1+0],2
        mov ax,1330
        push ax
        push word[random2]

        call printnum ;<><>

        jmp gend
    gn2:
        mov word[arr2+2],2
        mov ax,1344
        push ax
        push word[random2]

        call printnum ;<><>

        jmp gend
    gn3:
        mov word[arr3+4],2
        mov ax,1358
        push ax
        push word[random2]

        call printnum ;<><>

        jmp gend
    gn4:
        mov word[arr4+6],2
        mov ax,1372
        push ax
        push word[random2]

        call printnum ;<><>

        jmp gend
    gn5:
        mov word[arr1+2],2
        mov ax,1810
        push ax
        push word[random2]

        call printnum ;<><>

        jmp gend
    gn6:
        mov word[arr2+0],2
        mov ax,1824
        push ax
        push word[random2]

        call printnum ;<><>

        jmp gend
    gn7:
        mov word[arr3+6],2
        mov ax,1838
        push ax
        push word[random2]

        call printnum ;<><>
        jmp gend
    gn8:
        mov word[arr4+4],2
        mov ax,1852
        push ax
        push word[random2]

        call printnum ;<><>

        jmp gend
    gn9:
        mov word[arr1+4],2
        mov ax,2290
        push ax
        push word[random2]

        call printnum ;<><>

        jmp gend
    gn10:
        mov word[arr2+6],2
        mov ax,2304
        push ax
        push word[random2]

        call printnum ;<><>

        jmp gend
    gn11:
        mov word[arr3+0],2
        mov ax,2318
        push ax
        push word[random2]

        call printnum ;<><>

        jmp gend
    gn12:
        mov word[arr4+2],2
        mov ax,2332
        push ax
        push word[random2]

        call printnum ;<><>

        jmp gend
    gn13:
        mov word[arr1+6],2
        mov ax,2770
        push ax
        push word[random2]

        call printnum ;<><>

        jmp gend
    gn14:
        mov word[arr2+4],2
        mov ax,2784
        push ax
        push word[random2]

        call printnum ;<><>

        jmp gend
    gn15:
        mov word[arr3+2],2
        mov ax,2798
        push ax
        push word[random2]

        call printnum ;<><>

        jmp gend
    gn16:
        mov word[arr4+0],2
        mov ax,2812
        push ax
        push word[random2] ;<><>

        call printnum

        jmp gend
    gend:
        ret
;-------------------------------
;-------------------------------ENDING CONDITION CHECK
;-------------------------------
endcondition:
	base:
		mov bx,2048
	ec1:
		mov ax,[arr1+0]
		cmp ax,bx
		jz backto
	ec2:
		mov ax,[arr1+2]
		cmp ax,bx
		jz backto
	ec3:
		mov ax,[arr1+4]
		cmp ax,bx
		jz backto
	ec4:
		mov ax,[arr1+6]
		cmp ax,bx
		jz backto
	ec5:	
		mov ax,[arr2+0]
		cmp ax,bx
		jz backto
	ec6:	
		mov ax,[arr2+2]
		cmp ax,bx
		jz backto
	ec7:
		mov ax,[arr2+4]
		cmp ax,bx
		jz backto
	e8:	
		mov ax,[arr2+6]
		cmp ax,bx
		jz backto
	e9:
		mov ax,[arr3+0]
		cmp ax,bx
		jz backto
	e10:
		mov ax,[arr3+2]
		cmp ax,bx
		jz backto
	e11:
		mov ax,[arr3+4]
		cmp ax,bx
		jz backto
	e12:	
		mov ax,[arr3+6]
		cmp ax,bx
		jz backto
	e13:	
		mov ax,[arr4+0]
		cmp ax,bx
		jz backto
	e14:	
		mov ax,[arr4+2]
		cmp ax,bx
		jz backto
	e15:
		mov ax,[arr4+4]
		cmp ax,bx
		jz backto
	e16:		
		mov ax,[arr4+6]
		cmp ax,bx
		jz backto
	ecend:
		ret
;-------------------------------
;-------------------------------START LABEL (program starting from here)
;-------------------------------
start:

		call welcomescreen ;<><>

		call mainboard ;<><>

		call hookeys ;<><>

	backto:

		call endingscreen ;<><>

	mov ax, 0x4c00 
	int 0x21