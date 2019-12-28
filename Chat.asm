    PUBLIC chat
    EXTRN player1name:BYTE
    EXTRN player2name:BYTE
.model small
.386
.stack 64
.data


chat1cursor dw 0100h ; YX
chat2cursor dw 0E00h ; YX
exitflag db 0
;player1name db 'Kareem: $'
;player2name db 'Yasuo: $'
VALUE db ?

.code

moveCursorTochat1 MACRO
    pusha
    mov ah,2
    mov bx,0
    mov dx,chat1cursor
    int 10h
    popa    
ENDM moveCursorTochat1 

moveCursorTochat2 MACRO
    pusha
    mov ah,2
    mov bx,0
    mov dx,chat2cursor
    int 10h
    popa    
ENDM moveCursorTochat2

updatechat1Cursor MACRO
    pusha
    mov ah,3h
    int 10h
    mov chat1cursor,dx
    popa
ENDM updatechat1Cursor

updatechat2Cursor MACRO
    pusha
    mov ah,3h
    int 10h
    mov chat2cursor,dx
    popa
ENDM updatechat2Cursor

scrollChat1 MACRO 
   pusha  
   
   mov ah,6       ; function 6
   mov al,1       ; scroll by 1 line    
   mov bh,1Fh     ; normal video attribute         
   mov ch,0       ; upper left Y
   mov cl,0       ; upper left X
   mov dh,12      ; lower right Y
   mov dl,79      ; lower right X 
   int 10h
   mov ax,chat1cursor
   dec ah
   mov chat1cursor,ax    
   popa     
ENDM scrollChat1

scrollChat2 MACRO 
   pusha  
   
   mov ah,6       ; function 6
   mov al,1       ; scroll by 1 line    
   mov bh,0Fh     ; normal video attribute         
   mov ch,13      ; upper left Y
   mov cl,0       ; upper left X
   mov dh,24      ; lower right Y
   mov dl,79      ; lower right X 
   int 10h
   mov ax,chat2cursor
   dec ah
   mov chat2cursor,ax    
   popa     
ENDM scrollChat2

Transmit_BL proc near
    pusha
    ;Check that Transmitter Holding Register is Empty       ;---------- sends the input character----------
	mov dx , 3FDH		; Line Status Register             ;---------- sends the input character----------
     AGAIN:  	In al , dx 			;Read Line Status      ;---------- sends the input character----------
  	test al , 00100000b                                    ;---------- sends the input character----------
  	JZ AGAIN                               ;Not empty      ;---------- sends the input character----------
                                                          ;---------- sends the input character----------
    ;If empty put the VALUE in Transmit data register       ;---------- sends the input character----------
  	mov dx , 3F8H		; Transmit data register           ;---------- sends the input character----------
  	mov  al,bl                                             ;---------- sends the input character----------
  	out dx , al                                            ;---------- sends the input character----------
    popa
    ret
Transmit_BL endp



 
chat proc far
    mov ax,@data
    mov ds,ax 
    

    call init
    
    chatloop:
    call run_chat
    cmp exitflag,0
    je chatloop
    
    
     
    ret
    chat endp


;----------------------------------------------------------------------------
;----------------------------------------------------------------------------
 init proc near
    mov exitflag,0 
    mov chat1cursor,0100h ; YX
    mov chat2cursor,0E00h ; YX
    
    mov al,3
    mov ah,0
    int 10h
    
    ;mov ah,0h                                                            
   ; Int 10h                                                              
                                                                         ;----------- communications ----------
    mov dx,3fbh 			; Line Control Register                      ;----------- communications ----------
    mov al,10000000b		;Set Divisor Latch Access Bit                ;----------- communications ----------
    out dx,al				;Out it                                      ;----------- communications ----------
                                                                         ;----------- communications ----------
    mov dx,3f8h			                                                 ;----------- communications ----------
    mov al,0ch			                                                 ;----------- communications ----------
    out dx,al                                                            ;----------- communications ----------
                                                                         ;----------- communications ----------
    mov dx,3f9h                                                          ;----------- communications ----------
    mov al,00h                                                           ;----------- communications ----------
    out dx,al                                                            ;----------- communications ----------
                                                                         ;----------- communications ----------
    mov dx,3fbh                                                          ;----------- communications ----------
    mov al,00011011b                                                     ;----------- communications ----------
                                                                         ;----------- communications ----------
    out dx,al                                                            ;----------- communications ----------

   pusha
   mov ah,7       ; function 6
   mov al,0       ; scroll by 1 line    
   mov bh,0Fh     ; normal video attribute         
   mov ch,13      ; upper left Y
   mov cl,0       ; upper left X
   mov dh,24      ; lower right Y
   mov dl,79      ; lower right X 
   int 10h 

   mov ah,7       ; function 6
   mov al,0       ; scroll by 1 line    
   mov bh,1Fh      ; normal video attribute         
   mov ch,0       ; upper left Y
   mov cl,0       ; upper left X
   mov dh,12      ; lower right Y
   mov dl,79      ; lower right X 
   int 10h                      
   popa
   
   
   moveCursorTochat1
   lea dx,player1name
   mov ah,9
   int 21h
   updatechat1Cursor
   
   moveCursorTochat2
   lea dx,player2name
   mov ah,9
   int 21h
   updatechat2Cursor
   
    
   ret
   init endp
;----------------------------------------------------------------------------
;----------------------------------------------------------------------------



;----------------------------------------------------------------------------
;----------------------------------------------------------------------------
run_chat proc near 
    
    call SEND
    call Receive

    ret
    run_chat endp
;----------------------------------------------------------------------------
;----------------------------------------------------------------------------



;----------------------------------------------------------------------------
;----------------------------------------------------------------------------
SEND proc near 
    pusha
    moveCursorTochat1
    
    mov ah,1                                    ;--------- Captures Input -----------
    int 16h                                     ;--------- Captures Input -----------
    jz endChat1                                 ;--------- Captures Input -----------
                                                ;--------- Captures Input -----------
    mov ah,0                                    ;--------- Captures Input -----------
    int 16h                                     ;--------- Captures Input -----------
    mov bl,al ; bx stores the input character   ;--------- Captures Input -----------
    
    cmp bl,27
    je setExitFlag
    
    cmp bl,8
    jne cont 
    call printBackSpace
	call sendBackSpace
    jmp end_of_input_chat1
    cont:

    cmp bl,13
    je newline
    
    mov ah,2     ;------ displays the input character----------
    mov dl,bl    ;------ displays the input character----------
    int 21h      ;------ displays the input character----------
    jmp end_of_input_chat1
    
    newline:
    mov dl,10
    mov ah,2
    int 21h
    lea dx,player1name
    mov ah,9
    int 21h
    jmp end_of_input_chat1
    
    setExitFlag:
    mov exitflag,1
    jmp endchat1    
    
    end_of_input_chat1:
    call Transmit_BL
    updatechat1Cursor
    mov ax,chat1Cursor
    cmp ah,0Bh
    jbe endChat1
    scrollChat1
    
    
    endChat1:
    cmp exitflag,1
    jne cont888

    mov bl,27
    call Transmit_BL

    cont888:
    popa
    ret
SEND endp
;----------------------------------------------------------------------------
;----------------------------------------------------------------------------


;----------------------------------------------------------------------------
;----------------------------------------------------------------------------
RECEIVE proc near 
    pusha
    ;Check that Data is Ready
		mov dx , 3FDH		; Line Status Register
	    in al , dx 
  		test al , 1
  		JZ endChat2                                  ;Not Ready
    ;If Ready read the VALUE in Receive data register
  		mov dx , 03F8H
  		in al , dx 
        mov VALUE , al

    moveCursorTochat2
    
    cmp VALUE,27
    je setExitFlag2
    
    ;cmp VALUE,8
    ;je end_of_input_chat2
    
    cmp VALUE,13
    je newline2
    
    mov ah,2     ;------ displays the received character----------
    mov dl,VALUE    ;------ displays the received character----------
    int 21h      ;------ displays the received character----------
    jmp end_of_input_chat2
    
    newline2:
    mov dl,10
    mov ah,2
    int 21h
    lea dx,player2name
    mov ah,9
    int 21h
    jmp end_of_input_chat2
    
    setExitFlag2:
    mov exitflag,1
    jmp endchat2    
    
    end_of_input_chat2:
    
    updatechat2Cursor
    mov ax,chat2Cursor
    cmp ah,17h
    jbe endchat2

    scrollChat2
    
    endChat2:
    popa
    ret
RECEIVE endp
;----------------------------------------------------------------------------
;----------------------------------------------------------------------------


printBackSpace proc near
    pusha
	mov ah,2
	mov dl,8
	int 21h

	mov ah,2
	mov dl,32
	int 21h

    mov ah,2
	mov dl,8
	int 21h
    popa
	ret
printBackSpace endp

sendBackSpace proc near
    pusha



	mov dx , 3FDH		; Line Status Register
    AGAIN4:  	In al , dx 			;Read Line Status
 	test al , 00100000b
 	JZ AGAIN4	;Not empty


 	;If empty put the VALUE in Transmit data register
 	mov dx , 3F8H		; Transmit data register
 	mov  al,32
 	out dx , al

	mov dx , 3FDH		; Line Status Register
    AGAIN5:  	In al , dx 			;Read Line Status
 	test al , 00100000b
 	JZ AGAIN5	;Not empty


 	;If empty put the VALUE in Transmit data register
 	mov dx , 3F8H		; Transmit data register
 	mov  al,8
 	out dx , al
	
    popa
	ret
sendBackSpace endp

end