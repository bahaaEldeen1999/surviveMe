        EXTRN main:FAR
        EXTRN chat:FAR
        PUBLIC player1name
        PUBLIC player2name
        PUBLIC currentLevel
.model large
.386
.stack 128
.data
MenuText db '* To start chatting press 1',13,10,10,0Ah dup(32),'* To start game press 2',13,10,10,0Ah dup(32),'* To end the program press ESC$'
LevelsText db '* Level 1 press 1',13,10,10,0Ah dup(32)
           db '* Level 2 press 2',13,10,10,0Ah dup(32)
           db '* Level 3 press 3',13,10,10,0Ah dup(32)
           db '* To return to main menu press ESC$'


           


TitleText db 'SURVIVE ME$'
enterYourNameText db 'Please enter your name: $'

inputName db 30,?,30 dup('$')
player1name db 30 dup('$')
player2name db 30 dup('$')

name1ready db 0
name2ready db 0

waitForUser2 db 'Waiting for other player...','$'

otherChatReady db 0

currentLevel db 1

.code

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



MainMenu proc far


    mov ax,@data
    mov ds,ax
    mov es,ax
    
    call init
    call intro

start:    
    ;Go to text mode
    mov ah,0
    mov al,3h
    int 10h
    
    ;set cursor
    mov ah,2
    mov dx,0A0Ah
    int 10h
    
    ;display menu
    mov ah,9
    lea dx,MenuText
    int 21h
    
    ;capture input    
    waitForInput:
    mov ah,1    
    int 16h
    jz checkESC
    mov ah,0
    int 16h

    
    ;case 1
    cmp al,31H
    je startChatting
    
    ;case 2
    cmp al,32h
    je startGame
    
    ;case ESC
    cmp ah,01h
    je endProgram
    
    checkESC:
    ;Check that Data is Ready
    mov dx , 3FDH		; Line Status Register
    in al , dx 
    test al , 1
    JZ waitForInput                                  ;Not Ready
    ;If Ready read the VALUE in Receive data register
    mov dx , 03F8H
    in al , dx 
    cmp al,01h
    je endProgram

    jmp waitForInput
    
    
    startChatting:
    mov bl,9
    call Transmit_BL ; send ready to chat

    mov ah,1                                    ;--------- Captures Input -----------
    int 16h                                     ;--------- Captures Input -----------
    jz cont213                                  ;--------- Captures Input -----------
                                                ;--------- Captures Input -----------
    mov ah,0                                    ;--------- Captures Input -----------
    int 16h                                     ;--------- Captures Input -----------
    mov bl,al ; bx stores the input character   ;--------- Captures Input -----------

    cmp bl,27
    jz start

    cont213:
    ;Go to text mode
    mov ah,0
    mov al,3h
    int 10h
        
    mov ah, 9
    mov dx, offset waitForUser2
    int 21h

    ;Check that Data is Ready
    mov dx , 3FDH		; Line Status Register
    in al , dx 
    test al , 1
    JZ startChatting                                  ;Not Ready
    ;If Ready read the VALUE in Receive data register
    mov dx , 03F8H
    in al , dx 
    cmp al,9
    jne startChatting
    
    ;call chat proc here
    call chat
    jmp start
    

    startGame:
    mov bl,6
    call Transmit_BL ; send ready to chat

    mov ah,1                                    ;--------- Captures Input -----------
    int 16h                                     ;--------- Captures Input -----------
    jz cont220                                  ;--------- Captures Input -----------
                                                ;--------- Captures Input -----------
    mov ah,0                                    ;--------- Captures Input -----------
    int 16h                                     ;--------- Captures Input -----------
    mov bl,al ; bx stores the input character   ;--------- Captures Input -----------

    cmp bl,27
    jz start

    cont220:
    ;Go to text mode
    mov ah,0
    mov al,3h
    int 10h
        
    mov ah, 9
    mov dx, offset waitForUser2
    int 21h

    ;Check that Data is Ready
    mov dx , 3FDH		; Line Status Register
    in al , dx 
    test al , 1
    JZ startGame                                  ;Not Ready
    ;If Ready read the VALUE in Receive data register
    mov dx , 03F8H
    in al , dx 
    cmp al,6
    jne startGame
    ;call game proc here
    call GameLevels
    jmp start 
    
    
    endProgram:
    
    mov bl,01h
    call Transmit_BL

    mov ah,04ch
    int 21h
    
    MainMenu endp



GameLevels proc near
    ;Go to text mode
    mov ah,0
    mov al,3h
    int 10h
    
    ;set cursor
    mov ah,2
    mov dx,0A0Ah
    int 10h
    
    ;display menu
    mov ah,9
    lea dx,LevelsText
    int 21h
    
    ;capture input
    mov ah,1
    waitForInput2:    
    int 16h
    jz cont444
    mov ah,0
    int 16h

    cmp al,27
    jne cont155
    mov bl,al
    call Transmit_BL
    jmp backToMainMenu


    cont155:
    mov bl,al
    call Transmit_BL

    mov cl,al
   
    cont444:
    ;Check that Data is Ready
    mov dx , 3FDH		; Line Status Register
    in al , dx 
    test al , 1
    JZ cont111                         ;Not Ready
    ;If Ready read the VALUE in Receive data register
    mov dx , 03F8H
    in al , dx 

    mov cl,al

    cmp cl,27
    jne cont111
    jmp backToMainMenu
    

    cont111:
    ;check if 1
    cmp cl,31H
    je startLevel1
    
    ;check if 2
    cmp cl,32h
    je startLevel2
    
    ;check if 3
    cmp cl,33h
    je startLevel3
    
    ;check if ESC
    cmp cl,01h
    je backToMainMenu

    jmp waitForInput2
    
    
    
    startLevel1:
    mov bl,11
    call Transmit_BL
    mov al,1
    mov currentLevel,al
    call main
    ret
    
    startLevel2:
    mov bl,22
    call Transmit_BL
    mov al,2
    mov currentLevel,al
    call main
    ret
    
    startLevel3:
    mov bl,33
    call Transmit_BL
    mov al,3
    mov currentLevel,al
    call main
    ret
    
    
    backToMainMenu:
    ret
GameLevels endp




intro proc near
 
    pusha

    ;--------------- PLAYER 1 ---------------
    ;--------------- PLAYER 1 ---------------
    ;--------------- PLAYER 1 ---------------
    
    mov al,3      ;--------- text mode ---------
    mov ah,0      ;--------- text mode ---------
    int 10h       ;--------- text mode ---------

    mov ah,2      ;--------- move cursor -------
    mov dh,2      ;--------- move cursor -------
    mov dl,32     ;--------- move cursor -------
    int 10h       ;--------- move cursor -------

    lea dx,TitleText  ;------ display title --------
    mov ah,9          ;------ display title --------
    int 21h           ;------ display title --------

    mov ah,2          ;------ move cursor --------
    mov dh,10         ;------ move cursor --------
    mov dl,20         ;------ move cursor --------
    int 10h           ;------ move cursor --------

    lea dx,enterYourNameText    ;------ display enter your name ---------
    mov ah,9                    ;------ display enter your name ---------
    int 21h                     ;------ display enter your name ---------

    lea si,player1name
    lea di,player2name
    
    send:
    cmp name1ready,1
    je receive

    mov ah,1                                    ;--------- Captures Input -----------
    int 16h                                     ;--------- Captures Input -----------
    jz receive                                  ;--------- Captures Input -----------
                                                ;--------- Captures Input -----------
    mov ah,0                                    ;--------- Captures Input -----------
    int 16h                                     ;--------- Captures Input -----------
    mov bl,al ; bx stores the input character   ;--------- Captures Input -----------
    
 

    cmp bl,8
    jne cont7
    jmp receive

    cont7:
    call Transmit_BL

    cmp bl,13 ; case ENTER pressed
    jne cont
    mov name1ready,1
    mov al,':'
    mov [si],al
    inc si
    mov al,' '
    mov [si],al
    inc si

    ;Go to text mode
    mov ah,0
    mov al,3h
    int 10h
        
    mov ah, 9
    mov dx, offset waitForUser2
    int 21h

    mov al,name1ready                   
    and al,name2ready
    jnz namesReady

    jmp receive
    cont:

    mov [si],bl ; ---- STORE CHARACTER---- 
    inc si

    mov ah,2                        ;------ displays the input character----------
    mov dl,bl                       ;------ displays the input character----------
    int 21h                         ;------ displays the input character----------

    

    receive:

    cmp name2ready,1
    je send

    ;Check that Data is Ready
    mov dx , 3FDH		; Line Status Register
    in al , dx 
    test al , 1
    JZ send                                  ;Not Ready
    ;If Ready read the VALUE in Receive data register
    mov dx , 03F8H
    in al , dx 

    cmp al,13
    jne cont2
    mov name2ready,1
    mov al,':'
    mov [di],al
    inc di
    mov al,' '
    mov [di],al
    inc di
    mov al,name1ready
    and al,name2ready
    jnz namesReady
    jmp send
    cont2:

    mov[di], al
    inc di
    jmp send


    namesReady:
    popa
    ret
intro endp


init proc near                               ; Serial
        ;	Set Divisor Latch Access Bit
        mov dx,3fbh 			; Line Control Register
        mov al,10000000b		;Set Divisor Latch Access Bit
        out dx,al				;Out it
        ;	Set LSB byte of the Baud Rate Divisor Latch register.
        mov dx,3f8h			
        mov al,0ch			
        out dx,al
        ;	Set MSB byte of the Baud Rate Divisor Latch register.
        mov dx,3f9h
        mov al,00h
        out dx,al
        ;	Set port configuration
        mov dx,3fbh
        mov al,00011011b
        out dx,al
    ret
init endp

end MainMenu

    