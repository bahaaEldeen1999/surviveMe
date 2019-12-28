        PUBLIC main
        EXTRN player1name:BYTE
        EXTRN player2name:BYTE
        EXTRN currentLevel:BYTE
.model huge
.386
.stack 256 
.data
;------------------for serial---------------------------------------------
byteToReceive db ?
byteToSend db ?
;------------------------------------------------ for in game chat------------------------------
chat1Active db 0 
chat2Active db 0
seperator db '----------------------------------------$$$'
toEndGameWith db ' - To end game with $'
pressESC db 8,8,' press ESC$'
chatCursor dw 1601h
MessageToSend db 1000 dup('$')
MessageToSendIndex dw ?
MessageToReceive db 1000 dup('$')
MessageToReceiveIndex dw ?
typehere db '>$'
blankString db 100 dup('$')
ChatOrigin dw 1300h
victorytext db 'VICTORY!',10,'$'
defeattext db 'DEFEAT!',10,'$'
wonText db 8,8,' WON!$'
;------------------------------------------------ for in game chat------------------------------

;--------------------------------parameters for function like collision and drawing ---------------------------------
  
    x1 dw ?
    x2 dw ?
    x3 dw ?
    x4 dw ?
    
    y1 dw ?
    y2 dw ?
    y3 dw ?
    y4 dw ?
    
    ;to check for skipk frames
    deltaX1 dw ?
    deltaX2 dw ?
    deltaY1 dw ?
    deltaY2 dw ?
    skipFrameEdge dw 0
    
    edgeOfCollision dw 0 
    
    ;draw rectangle extra parameter
    rectangleColor db 5  
    
    ; health and score parameters
    health1 dw 1000
    health2 dw 1000
    score1 dw 1000
    score2 dw 1000

    health1Text db 'Health 1: $'
    health2Text db 'Health 2: $'
    score1Text db 'Score  1: $'
    score2Text db 'Score  2: $' 
;--------------------------------parameters for function like collision and drawing ---------------------------------

;---------------------------------------------draw player function---------------------------------
  
    height db 4
    widthy db 10
    width2 db ?
    widthDiv2 db ?
    widthDiv4 db ?
    height3 db ?
    heightDiv2 db ? 
    heightDiv4 db ?
    posX dw 50
    posY dw 50
    headColor db 14
    torsoColor db 9
    legColor db 1
    shoeColor db 0
    eyeSize db 3
    eyeColor db 0
;--------------------------------------------draw player function---------------------------------

;--------------------------------------------Game Parameters---------------------------------
    gameWidth dw 320
    gameHeight dw 140
    videoMode dw 0101h  
    squareColor db 2
    two db 2   
    player1PosX dw 30
    player1PosY dw 100
    player1Width db 10
    player1Height db 32
    player1deltaX dw 0
    player1DeltaY dw 0
    player1Health dw 100 
    player1Score dw 00

    mass db 1
    player1ForceX db 0
    player1ForceY db 0 
    player1AccX db 0
    player1AccY db 0
    player1moveForceX db 4
    player1moveForceY db 40 
    gravity db 6
    player1ForceFrameCounter db 0 
    player1forceFrameCounterMax db 15
;--------------------------------------------Game Parameters---------------------------------

;---------------------------------------Levels' Platforms-----------------------------------------------
    platformsX    dw 14 dup('#')
    platformsY    dw 14 dup('#')
    platformExist db 6  dup(1)
    platformssize dw 6
    platformColor db ?

    platforms1X    dw 10,60,   100,120, 50,90, 20,80, 100,140, 220,250,   '#','#'
    platforms1Y    dw 120,130, 110,120, 20,30, 50,60, 60,70,   120,130,   '#','#'
    platform1Exist db 1,1,1,1,1,1
    platforms1size dw 6
    platform1Color db 2ch

    platforms2X    dw 130,150, 150,170,  180,200, 20,80, 100,160, 210,250, '#','#'
    platforms2Y    dw 130,140, 120,130,  130,140, 50,60, 40,70,   100,110, '#','#'
    platform2Exist db 1,1,1,1,1,1
    platforms2size dw 6
    platform2Color db 30h

    platforms3X    dw 10,60,   100,150, 50,100, 120,140, 160,180, 200,220, '#','#'
    platforms3Y    dw 112,122, 90,100,   80,92,  100,110, 100,110, 40,50, '#','#'
    platform3Exist db 1,1,1,1,1,1
    platforms3size dw 6
    platform3Color db 28h
;---------------------------------------Levels' Platforms-----------------------------------------------
  
;---------------------------------------------------Players Data------------------------------------------  

    player1bulletSpeed db 1
    player1bulletPosX dw ?
    player1bulletPosY dw ? 
    player1bulletSize db 8
    player1mousePosX dw ?
    player1mousePosY dw ?
    player1bulletDirectionX dw ?
    player1bulletDirectionY dw ?
    player1mouseStatus dw 0 
    player1isThereBullet db 0
    player1bulletColor db 13
    player1currentFrameBullet dw 0
    player1bulletLife dw 90 
        
    player2PosX dw 90
    player2PosY dw 140
    player2Width db 10
    player2Height db 32
    player2deltaX dw 0
    player2DeltaY dw 0
    player2Health dw 100 
    player2Score dw 00
    player2ForceX db 0
    player2ForceY db 0 
    player2AccX db 0
    player2AccY db 0
    player2moveForceX db 4
    player2moveForceY db 40 
    
    player2ForceFrameCounter db 0 
    player2forceFrameCounterMax db 15
    
    player2bulletSpeed db 1
    player2bulletPosX dw ?
    player2bulletPosY dw ? 
    player2bulletSize db 8
    player2mousePosX dw ?
    player2mousePosY dw ?
    player2bulletDirectionX dw ?
    player2bulletDirectionY dw ?
    player2mouseStatus dw 0 
    player2isThereBullet db 0
    player2bulletColor db 9
    player2currentFrameBullet dw 0
    player2bulletLife dw 90 

;---------------------------------------------------Players Data------------------------------------------  

;---------------------------------------------------Bullets & Frames Data------------------------------------------
  
    winner db 0
    
    bulletDamage1 dw 20
    bulletDamage2 dw 50
    bulletDamage3 dw 10
    bulletDamage4 dw 25
    bulletDamage5 dw 100
    
    bullet1Color db 60h
    bullet2Color db 01h
    bullet3Color db 37h
    bullet4Color db 4fh
    bullet5Color db 6ch

    ;    bullet1Color db 01h
    ;   bullet2Color db 05h
    ;   bullet3Color db 09h
    ;   bullet4Color db 0dh
    ;   bullet5Color db 00h 
    
    player1CurrentBulletCurrent db ?
    player2CurrentBulletCurrent db ?
    
    
    player1CurrentBullet db 1
    player2CurrentBullet db 1
    
    player1CurrentBulletDamge dw ?
    player2CurrentBulletDamge dw ?
    
    player1Reversed db 0
    player2Reversed db 0
    
    player1ReversedFrame dw 0
    player2ReversedFrame dw 0
    playerMaxRevereFrame dw 100
    
    player1Stunned db 0
    player2Stunned db 0
    
    
    
    player1StunnedFrame dw 0
    player2StunnedFrame dw 0
    playerMaxStunFrame dw 100 
    

    roofCollectiblePosX dw ?
    roofCollectiblePosY dw ?
    isThereRoofCollectible db 0
    roofCollectibleType db ?
    roofCollectibleSize dw 7
    RoofCollectibleColor db 40h

    ;RoofCollectibleColor db 08h
    roofCollectibleSpeed dw 7

    skyColor db 0bh
    sandColor db 0eh
    grassColor db 30h
    hellColor db 70h
    stoneColor db 06h

    ;   skyColor db 0bh
    ;   sandColor db 0eh
    ;   grassColor db 0ah
    ;   hellColor db 04h
    ;   stoneColor db 06h

    maxForceX db 20
    maxForceY db 80

    maxVelX dw 20
    maxVelY dw 80  

    player1Mirrored db 0
    player2Mirrored db 1
;---------------------------------------------------Bullets & Frames Data------------------------------------------
;-- floating points
normalX1 dw ?
normalY1 dw ?

normalX2 dw ?
normalY2 dw ?
value21 dw ?
value22 dw ?
speed dw 8
.code

main proc far 
    mov ax,@data
    mov ds,ax
    mov es,ax    

    mov al,widthy
    mov cl,4   
    mov ah,0
    div cl  
    mov widthDiv4,al ;bl =  width/4
    mov al,widthy
    mov cl,2
    mov ah,0
    div cl
    mov widthDiv2,al ; bh = width/2  
    mov al,widthy
    mov cl,2
    mov ah,0
    mul cl
    mov width2,al ; bh = width/2
    mov al,height
    mov cl,3
    mov ah,0
    mul cl
    mov height3,al  
    mov al,height 
    mov ah,0
    mov cl,2
    div cl
    mov heightDiv2,al
    mov al,height
    mov cl,4   
    mov dx,0
    div cl  
    mov heightDiv4,al ;bl =  height/4  


 
    ;graphics mode
    ;mov ax,4F02h
    ;mov bx,videoMode
    ;int 10h

    mov al, 13h
    mov ah, 0
    int 10h 

        
    ;initialize mouse  
    mov ax,0
    INT 33h    
    mov ax, 1
    int 33h
    ;set mouse range
    ;mov ax,7
    ;mov cx,0
    ;mov dx,gameWidth
    ;int 33h
    ;
    ;mov ax,8
    ;mov cx,0
    ;mov dx,gameHeight
    ;int 33h


   call initGameChat



    ;jmp moveLeft
    ;call drawPlatforms
    ;call checkPlatforms
    ;game loop
    ;clear_screen_vga
    call initializePort
    gameLoop:
    call InGameChat 

;call receivebullet 
     mov al,0
    mov byteToSend,al
    mov byteToReceive,al

 

    mov al,0
    cmp winner,al
    jnz endGame

    ;call clearKeyBoardBuffer 

    ;;;;;

    ;add gravity
    mov al,gravity
    mov player1ForceY,al
    mov player2ForceY,al

    ;call printScore
    call printHealth



    
    ;call delay 


    mov al,1  
    cmp player2isThereBullet,al 
    jz  updateBulletLabelPlayer2
    ;call getMousePositionAndStatusPlayer1                                           
    ;mov ax,player1mouseStatus
    

    ;player 2 right mouse click
    mov al,1
    cmp player1IsThereBullet,al  
    jz  updateBulletLabelPlayer1

    ;jmp getKeyboardInput 
    ;get input and store it in ah    

    cmp chat1Active,0
    jne _getSecondPlayer

    getKeyboardInput:

    mov     ah, 01h     ; BIOS.ReadKeyboardStatus
    int     16h         ; -> AX ZF
    jz      _getSecondPlayer
    mov     ah, 00h     ; BIOS.ReadKeyboardCharacter
    int     16h         ; -> AX

    

    ;check if click Enter
    cmp ah,1ch
    jne cont00
    mov chat1Active,1
    cont00:

    ; check if click exit
    ;cmp al,27
    ;jz endGame

    ;;;; send
    mov byteToSend,ah
    call sendByte

    ;check if click escape
    cmp ah,01
    jne cont10101
    ret
    cont10101:
     
    ;check if click right
    cmp ah,77
    jz moveRightPlayer2
    ;check if click left
    cmp ah,75
    jz moveLeftPlayer2
    ;check if jump 
    cmp ah,039h
    jz jumpyPlayer2

    cmp ah,011h
    jz addBulletPlayer2


    
    _getSecondPlayer:

    mov ah,0
    call receiveByte
    mov ah,byteToReceive

    ;check if escape received
    cmp ah,01
    jne cont101021
    ret
    cont101021:

    ; check if enter received
    cmp ah,1ch
    jne lbl001
    mov chat2Active,1
    lbl001:

    ; check d for right player 2
    cmp ah,77
    jz moveRightPlayer1

    ;check a for left
    cmp ah,75
    jz moveLeftPlayer1
;check jump space bar
    cmp ah,039h
    jz jumpyPlayer1 

  
    cmp ah,011h
    jz addBulletPlayer1

    updateSqaure:
        call applyForceplayer1
        call applyForceplayer2
        
        
        call updateplayer1
        call updateplayer2
        ;call checkPlayersCollision
    
        call checkPlatformsPlayer1
        call checkPlatformsPlayer2

        call checkEdgesplayer1
        call checkEdgesplayer2 
        ;show mouse  
        mov ax, 1
        int 33h
        call drawPlayer1
        call drawPlayer2 
        

        call checkSpawnRoofCollectible
        call updateRoofCollectible
        call drawPlatforms
        call delay 
        call clearScreen
        
    _gameLoop:
        ;call clearKeyBoardBuffer 
        ;clear_screen_vga
    jmp gameLoop 



    addBulletPlayer1:
        call fireBulletplayer1 
        mov al,1
        mov player1isThereBullet,al
        jmp updateSqaure
        updateBulletLabelPlayer1:
        

        call checkBulletEdgeplayer1
        call checkBulletPlayer1Collision 
      ;  call checkBulletSkipFrameplayer1
        call checkBulletPlatformplayer1
        
        ;call checkBulletPlayerCollision
        mov al,1
       
        cmp player1isThereBullet,al 
        jnz getKeyboardInput
        call drawBulletplayer1
        call updateBulletplayer1
        jmp  getKeyboardInput
        ;jmp  _gameLoop

    addBulletPlayer2: 
        call fireBulletplayer2 
        mov al,1
        mov player2isThereBullet,al
        jmp _getSecondPlayer
        updateBulletLabelPlayer2:
    
        call checkBulletEdgeplayer2
        call checkBulletPlayer2Collision 
        
        call checkBulletPlatformplayer2
        
        
        mov al,1
        
        cmp player2isThereBullet,al 
        jnz getKeyboardInput
        call drawBulletplayer2
        call updateBulletplayer2
        jmp  getKeyboardInput
        ;jmp  _gameLoop

   moveRightPlayer1:
        
        push ax
        mov al,0
        mov player1Mirrored,al 
        mov al,player1moveForceX
        ;add player1ForceX,al
        ;mov player1ForceX,al
        cbw
         add player1PosX,ax
        
        pop ax  
        ;call clearKeyBoardBuffer
        jmp updateSqaure
        
        
    moveLeftPlayer1: 
    
        push ax
        mov al,1
        mov player1Mirrored,al 
        mov al,player1moveForceX
        neg al
        ;mov ah,0
        ;neg al
        ;sub player1ForceX,al 
        ;mov player1ForceX,al
      cbw
         add player1PosX,ax
        pop ax 
        
        endMoveLeft1:
        ; call clearKeyBoardBuffer  
            jmp updateSqaure   
        
    jumpyPlayer1:
        
        push ax 
        mov al,player1moveForceY
        
        neg al
        cbw
        add player1PosY,ax
        ;mov al,player1ForceX
        ;sub player1ForceY,al
        ;sub player1PosY,ax
        pop ax
        ;call clearKeyBoardBuffer 
        jmp updateSqaure    
        
    moveRightPlayer2:
        
        push ax
        mov al,0
        mov player2Mirrored,al  
        mov al,player2moveForceX
        
        ;add player2ForceX,al
        ;mov player2ForceX,al
        cbw
        add player2PosX,ax
        pop ax  
        ;call clearKeyBoardBuffer
        jmp _getSecondPlayer
        
        
    moveLeftPlayer2: 
    
        push ax
        mov al,1
        mov player2Mirrored,al 
        mov al,player2moveForceX
        mov ah,0
        neg al
         cbw
        add player2PosX,ax
        ;sub player2ForceX,al 
        ;sub player1PosX,ax
       ; mov player2ForceX,al
        pop ax 
        
        endMoveLeft2:
        ;    call clearKeyBoardBuffer  
            jmp _getSecondPlayer   
        
    jumpyPlayer2:
        
        push ax 
        mov al,player2moveForceY
        
        neg al
          cbw
        add player2PosY,ax
        ;mov al,player2ForceX
        ;sub player2ForceY,al
        ;sub player1PosY,ax
        pop ax
        ;call clearKeyBoardBuffer 
        jmp _getSecondPlayer    



    endGame:

    mov al,winner
    cmp al,0
    je toMainMenu

    call DisplayEndGame
    
    waitForExit:
    mov ah,1    
    int 16h
    jz waitForExit
    mov ah,0
    int 16h

    ;case ESC
    cmp ah,01h
    je toMainMenu
    jmp waitForExit

    toMainMenu:
    ret     
main endp 

;------------------------------------------Players Utilities------------------------------------------
drawPlayer1 proc near   
    ; to keep the values of the registers   
    pushf
    push ax
    push bx
    push cx
    push dx
    mov al,0fh 
    mov headColor,al
    mov ax,player1PosX
    mov dx,player1PosY
                         
    mov posX,ax
    mov posY,dx  
    ;mov al,player1Width
    ;mov widthy,al
    ;mov al,player1Height
    ;mov cl,8
    ;div cl
    ;mov height,al 
    mov al,00
    mov torsoColor,al
    mov al,player1Mirrored
    cmp al,1
    jz drawPlayer1Mirrored
    call drawPlayer   
    
    enddrawPlayer1:
    pop dx
    pop cx
    pop bx
    pop ax 
    popf
    ret 
    drawPlayer1Mirrored:
    call drawPlayerMirror
    jmp enddrawPlayer1
drawPlayer1 endp


drawPlayer2 proc near   
    ; to keep the values of the registers   
    pushf
    push ax
    push bx
    push cx
    push dx
     
    mov al,7 
    mov headColor,al
    mov ax,player2PosX
    mov dx,player2PosY
                         
    mov posX,ax
    mov posY,dx
    mov al,04h
    mov torsoColor,al

    mov al,player2Mirrored
    cmp al,1
    jz drawPlayer2Mirrored
    call drawPlayer
  
    
    
    
    enddrawPlayer2:
    pop dx
    pop cx
    pop bx
    pop ax 
    popf
    ret 

     drawPlayer2Mirrored:
    call drawPlayerMirror
    jmp enddrawPlayer2
drawPlayer2 endp
;------------------------------------------Players Utilities------------------------------------------

;------------------------------------------General Utilities------------------------------------------
clearScreen proc near 
    ; to keep the values of the registers   
    pushf
    push ax
    push cx
    push di
    push es
    
    mov ax, 2
    int 33h
    ;draw size x size square start from player1PosX player1PosY
    ; mov al,0 ;Pixel color 
    ; mov ah,0ch ;Draw Pixel Command 
    ; mov dx,0
    ; clearScreenOuter:
    ;     mov cx,0
    ;     clearScreenInner:  
    ;         int 10h
    ;         inc cx
    ;         cmp cx,gameWidth
    ;         jnz clearScreenInner
        
    ;     inc dx
    ;     cmp dx,gameHeight
    ;     jnz clearScreenOuter  
    mov al,1
    cmp currentLevel,al
    jz drawLevel1BG
    mov al,2
    cmp currentLevel,al
    jz drawLevel2BG 
    mov al,3
    cmp currentLevel,al
    jz drawLevel3BG  
   
    endClearScreen:
    pop es
    pop di
    pop cx
    pop ax
    popf  
    ret

    drawLevel1BG:
        call level1BG
        ;--------------------------------------Loading Level's Platform--------------------------
        call loadplatformslvl1
        ;--------------------------------------Loading Level's Platform--------------------------
        jmp endClearScreen
    drawLevel2BG:
        call level2BG
        ;--------------------------------------Loading Level's Platform--------------------------
        call loadplatformslvl2
        ;--------------------------------------Loading Level's Platform--------------------------
        jmp endClearScreen

    drawLevel3BG:
        call level3BG
        ;--------------------------------------Loading Level's Platform--------------------------
        call loadplatformslvl3
        ;--------------------------------------Loading Level's Platform--------------------------
        jmp endClearScreen
clearScreen endp 

delay proc   near  
    ; to keep the values of the registers  
    pushf
    push ax
    push bx
    push cx
    push dx
    
    ;L4:	inc di			
    ;cmp di,100		
    ;jnz L4    			       
    mov cx, 0
    mov dx, 8235h
    mov ah, 86h 
    int 15h

     
    pop dx
    pop cx
    pop bx
    pop ax 
    popf 
    ret   
delay endp 

clearKeyBoardBuffer proc  near 
    push ax
  
    mov ah,0ch
    mov al,00h
    int 21h
  
    pop ax
    ret  
clearKeyBoardBuffer endp   
;------------------------------------------General Utilities------------------------------------------

;------------------------------------------Players Utilities------------------------------------------ 
applyForcePlayer1 proc   near  
    ; to keep the values of the registers  
    pushf
    push ax
    push bx
    push cx
    push dx
    
    ;divide force by mass save it to bx
    ;mov al,player1ForceX
    ;div mass
    ;mov bl,al
    
    ;mov al,player1ForceY
    ;div mass
    ;mov bh,al
    
    ;bl = player1ForceX/mass bh = player1ForceY/mass
    mov bl,player1ForceX
    mov bh,player1ForceY
    ; cmp bl,maxForceX
    ; jge resetPlayer1MaxForceX
    ; completeComparisonP1Y:
    ; cmp bh,maxForceY
    ; jge resetPlayer1MaxForceY
    ; completeAddAccP1:
    add player1AccX,bl
    add player1AccY, bh  
    
     
    pop dx
    pop cx
    pop bx
    pop ax  
    popf
    ret  

    ; resetPlayer1MaxForceX:
    ; mov bl,maxForceX
    ; jmp completeComparisonP1Y
    ; resetPlayer1MaxForceY:
    ; mov bh,maxForceY
    ; jmp completeAddAccP1



applyForcePlayer1 endp 



applyForcePlayer2 proc   near  
    ; to keep the values of the registers  
    pushf
    push ax
    push bx
    push cx
    push dx
    
    ;divide force by mass save it to bx
    ;mov al,player1ForceX
    ;div mass
    ;mov bl,al
    
    ;mov al,player1ForceY
    ;div mass
    ;mov bh,al
    
    ;bl = player1ForceX/mass bh = player1ForceY/mass
    mov bl,player2ForceX
    mov bh,player2ForceY
    ; cmp bl,maxForceX
    ; jge resetPlayer2MaxForceX
    ; completeComparisonP2Y:
    ; cmp bh,maxForceY
    ; jge resetPlayer2MaxForceY
    ; completeAddAccP2: 
    add player2AccX,bl
    add player2AccY, bh  
    
     
    pop dx
    pop cx
    pop bx
    pop ax  
    popf
    ret  
    ; resetPlayer2MaxForceX:
    ; mov bl,maxForceX
    ; jmp completeComparisonP2Y
    ; resetPlayer2MaxForceY:
    ; mov bh,maxForceY
    ; jmp completeAddAccP2
           
applyForcePlayer2 endp


updatePlayer1 proc  near    
    ;call clearScreen
     ;clear_screen_vga 
    ; to keep the values of the registers   
    pushf
    push ax
    push bx
    push cx
    push dx
    
    mov bl,1
    add player1ForceFrameCounter,bl
    cmp player1Reversed,bl
    jz addReversedPlayer1Frame
    
    
    cmp player1Stunned,bl
    jz addStunnedPlayer1Frame
    
    
    completeUpdatePlayer1:
    
    mov al,player1AccX
    cbw
    add player1deltaX,ax 
    mov al,player1AccY
    cbw
    add player1DeltaY,ax
    
    mov ax,player1deltaX
    cmp ax,maxVelX
    jge resetVelxP1
    completeComparisonP1Y:
    add player1PosX,ax 
    
    mov ax,player1DeltaY
    cmp ax,maxVelY
    jge  resetVelYP1
    completeAddingVelP1:
    add player1PosY,ax
    
    skipUpdatingPlayer1:
    ;clear acceleration
    mov al,0  
    mov bl,player1ForceFrameCounter
    cmp bl,player1forceFrameCounterMax
    jg resetFrameCounter
   ; mov player1AccX,al
    ;mov player1AccY,al
   ; cmp player1AccX,0
   ; jl incAccX
   ; jg decAccX
    
   ; completeAccYCheck:
    ;cmp player1AccY,0
   ; jl incAccY
    ;jg decAccY 
      
    clearingForces:  
    ;clear forces
    mov ax,0
    mov player1AccX,al
    mov player1AccY,al 
    
    ;reset velocity
    mov player1deltaX,ax
    mov player1DeltaY,ax
    
    
    
    pop dx
    pop cx
    pop bx
    pop ax
    popf  
    ret
    
    resetVelxP1:
    mov ax,maxVelX
    jmp completeComparisonP1Y

    resetVelYP1:
    mov ax,maxVelY
    jmp completeAddingVelP1

    incAccX:
        mov bl,1
        add player1AccX,bl
       ; jmp completeAccYCheck 
        
    decAccX:
        mov bl,1
        sub player1AccX,bl
      ;  jmp completeAccYCheck  
    incAccY:
        mov bl,1
        add player1AccY,bl
        jmp clearingForces 
        
    decAccY:
        mov bl,1
        sub player1AccY,bl
        jmp clearingForces
        
   resetFrameCounter:
        mov bl,0
        mov player1ForceFrameCounter,bl
        mov player1ForceX,bl
        mov player1ForceY,bl
        jmp clearingForces
        
        
     addReversedPlayer1Frame:
        mov bx,1
        add player1ReversedFrame,bx
        mov bx,playerMaxRevereFrame
        cmp player1ReversedFrame,bx
        jge removeReversePlayer1
        jmp skipUpdatingPlayer1
        
        
  removeReversePlayer1:
        mov bx,0
        mov player1Reversed,bl
        mov player1ReversedFrame,bx
        mov al,player1MoveForceX
        neg al
        mov player1MoveForceX,al
        
        mov al,player1MoveForceY
        neg al
        mov player1MoveForceY,al
        jmp completeUpdatePlayer1
        
        
        
  addStunnedPlayer1Frame:
        mov bx,1
        add player1StunnedFrame,bx
        mov bx,playerMaxStunFrame
        cmp player1StunnedFrame,bx
        jge removeStunnedPlayer1
        jmp clearingForces
        
   removeStunnedPlayer1:
        mov bx,0
        mov player1Stunned,bl
        mov player1StunnedFrame,bx
    
        jmp completeUpdatePlayer1      
                     
updatePlayer1 endp


updatePlayer2 proc  near    
    ;call clearScreen
    ;clear_screen_vga 
    ; to keep the values of the registers   
    pushf
    push ax
    push bx
    push cx
    push dx
    
    mov bl,1
    add player2ForceFrameCounter,bl
    cmp player2Reversed,bl
    jz addReversedPlayer2Frame 
    
    cmp player2Stunned,bl
    jz addStunnedPlayer2Frame
    
    completeUpdatePlayer2:
    
    mov al,player2AccX
    cbw
    add player2deltaX,ax 
    mov al,player2AccY
    cbw
    add player2DeltaY,ax
    
    mov ax,player2deltaX
    add player2PosX,ax 
    
    mov ax,player2DeltaY
    add player2PosY,ax
    
    skipUpdatingPlayer2:
    ;clear acceleration
    mov al,0  
    mov bl,player2ForceFrameCounter
    cmp bl,player2forceFrameCounterMax
    jg resetFrameCounter2
   ; mov player1AccX,al
    ;mov player1AccY,al
   ; cmp player1AccX,0
   ; jl incAccX
   ; jg decAccX
    
   ; completeAccYCheck:
    ;cmp player1AccY,0
   ; jl incAccY
    ;jg decAccY 
      
    clearingForces2:  
    ;clear forces
    mov ax,0
    mov player2AccX,al
    mov player2AccY,al 
    
    ;reset velocity
    mov player2deltaX,ax
    mov player2DeltaY,ax
    
    pop dx
    pop cx
    pop bx
    pop ax
    popf  
    ret
    
    incAccX2:
        mov bl,2
        add player2AccX,bl
       ; jmp completeAccYCheck 
        
    decAccX2:
        mov bl,2
        sub player2AccX,bl
      ;  jmp completeAccYCheck  
    incAccY2:
        mov bl,2
        add player2AccY,bl
        jmp clearingForces2 
        
    decAccY2:
        mov bl,1
        sub player2AccY,bl
        jmp clearingForces2
        
   resetFrameCounter2:
        mov bl,0
        mov player2ForceFrameCounter,bl
        mov player2ForceX,bl
        mov player2ForceY,bl
        jmp clearingForces2
        
        
  addReversedPlayer2Frame:
        mov bx,1
        add player2ReversedFrame,bx
        mov bx,playerMaxRevereFrame
        cmp player2ReversedFrame,bx
        jge removeReversePlayer2
        jmp completeUpdatePlayer2
        
        
  removeReversePlayer2:
        mov bx,0
        mov player2Reversed,bl
        mov player2ReversedFrame,bx
        mov al,player2MoveForceX
        neg al
        mov player2MoveForceX,al
            
        mov al,player2MoveForceY
        neg al
        mov player2MoveForceY,al 
        
        
        jmp completeUpdatePlayer2 
        
        
    addStunnedPlayer2Frame:
        mov bx,1
        add player2StunnedFrame,bx
        mov bx,playerMaxStunFrame
        cmp player2StunnedFrame,bx
        jge removeStunnedPlayer2
        jmp skipUpdatingPlayer2
        
    removeStunnedPlayer2:
        mov bx,0
        mov player2Stunned,bl
        mov player2StunnedFrame,bx
    
        jmp completeUpdatePlayer2 
                           
updatePlayer2 endp
;------------------------------------------Players Utilities------------------------------------------

;------------------------------------------Platforms Utilities------------------------------------------
checkEdgesPlayer1 proc  near 
    ; to keep the values of the registers
    pushf
    push ax
    push bx
    push cx
    push dx
    
    mov bl,player1Width
    mov bh,0
    
    
    mov ax,player1PosX
    cmp ax,0
    jle touchLeft1
    
    add ax,bx
    cmp ax,gameWidth
    jge touchRight1
     
    complete1:
    
    mov ax,player1PosY
    cmp ax,0
    jle touchTop1
    
    mov bl,player1Height
    add ax,bx
    cmp ax,gameHeight
    jge touchBottom1
    
    endCheckEdge1:
    pop dx
    pop cx
    pop bx
    pop ax  
    popf
    ret
       
     touchLeft1:
            mov ax,0
            mov player1PosX,ax
            jmp complete1 
            
     touchRight1:
            mov ax,gameWidth 
            mov bl,player1Width 
            mov bh,0
            sub ax,bx
            mov player1PosX,ax
            jmp complete1
     
     touchTop1:
            mov ax,5
            mov player1PosY,ax
            jmp endCheckEdge1
            
     touchBottom1:
           mov ax,gameHeight
           sub ax,bx
           mov player1PosY,ax
           jmp endCheckEdge1
            
            
                 
checkEdgesPlayer1 endp     


checkEdgesPlayer2 proc  near 
    ; to keep the values of the registers
    pushf
    push ax
    push bx
    push cx
    push dx
    
    mov bl,player2Width
    mov bh,0
    
    
    mov ax,player2PosX
    cmp ax,0
    jle touchLeft2
    
    add ax,bx
    cmp ax,gameWidth
    jge touchRight2
     
    complete2:
    
    mov ax,player2PosY
    cmp ax,0
    jle touchTop2
    
    mov bl,player2Height
    add ax,bx
    cmp ax,gameHeight
    jge touchBottom2
    
    
    endCheckEdge2:
    pop dx
    pop cx
    pop bx
    pop ax  
    popf
    ret
       
     touchLeft2:
            mov ax,0
            mov player2PosX,ax
            jmp complete2 
            
     touchRight2:
            mov ax,gameWidth
            sub ax,bx
            mov player2PosX,ax
            jmp complete2
     
     touchTop2:
            mov ax,0
            mov player2PosY,ax
            jmp endCheckEdge2
            
     touchBottom2:
           mov ax,gameHeight
           sub ax,bx
           mov player2PosY,ax
           jmp endCheckEdge2
            
            
                 
checkEdgesPlayer2 endp     


drawPlatforms proc  near
    ; to keep the values of the registers
    pushf
    pusha                

    lea bx,platformsX  
    lea si,platformsY       
    lea di,platformExist
   
    
    
    drawPlatformsLoop:
                  mov dx,[si] 
        add bx,2
        add si,2
        ;mov al,[di]
    ; add al,30h
    ;mov ah, 0eh
    ;int 10h
         
        mov al,0
        cmp [di],al

        jz skipDrawingPlatform
         

        drawPlatformOuter:     
            mov cx,[bx-2]   
            drawPlatformInner:
               
                mov al,platformColor ;Pixel color 
                mov ah,0ch ;Draw Pixel Command 
                int 10h
                inc cx
                cmp cx,[bx]
                jl drawPlatformInner
            inc dx
            cmp dx,[si]
            jl drawPlatformOuter
            
            
            skipDrawingPlatform:
            mov ax,'#'
            add bx,2
            add si,2
            add di,1
            cmp [bx],ax
            jnz drawPlatformsLoop  

    endDrawPlatform:                 
                     
    popa 
    popf 
    ret                 
drawPlatforms endp
    


checkPlatformsPlayer1 proc  near
    
    ; to keep the values of the registers
    pushf
    pusha                

    lea bx,platformsX  
    lea si,platformsY
    lea di,platformExist
    
    mov cx,player1PosX
    mov x1,cx
    add cl,player1Width
    adc ch,0
    mov x2,cx
    
    mov cx,player1PosY
    mov y1,cx
    add cl,player1Height
    adc ch,0
    mov y2,cx
      
   
        
    mov ax,'#' 
    
    loopOnPlatforms1: 
        mov al,0
        cmp [di],al
        jz completeLoopingPlatform1
        checkPlatForm1:
            mov cx,[bx]
            mov x3,cx
            mov cx,[bx+2]
            mov x4,cx
            
            mov cx,[si]
            mov y3,cx
            mov cx,[si+2]
            mov y4,cx
            
            call  checkCollision
            mov cx,edgeOfCollision
  
            
            cmp cx,4
            jz  touchDown1
            cmp cx,5
            jz  touchDown1
            cmp cx,7
            jz  touchDown1
            ;cmp cx,9
            ;jz touchDown
            
            ;cmp cx,3
            ;jz stayOnRightEdge1
            ;cmp cx,1
            ;jz stayOnLeftEdge1
            
            ;cmp dx,[si]
            ;jl comparePosYPlusSize
            completeLoopingPlatform1:
                add di,1
                add bx,4
                add si,4
                mov ax,'#'
                cmp [bx],ax 
                jnz loopOnPlatforms1     
   
    
    
   
    endCheckPlatform1:                 
 
    popa
    popf 
    ret
    

    touchDown1:
        mov dx,[si]
        sub dl,player1Height
        sbb dh,0
        mov player1PosY,dx
        jmp endCheckPlatform1
        
        
    stayOnLeftEdge1:
        mov cx,[bx] 
        sub cl,player1Width
        sbb ch,0
        ;mov player1PosX,cx
        jmp completeLoopingPlatform1
        
        
    stayOnRightEdge1:
        ;mov cx,[bx+2]
        ;mov al,5
        ;mov squareColor,al 
        ;mov player1PosX,cx
        jmp completeLoopingPlatform1      
             
    
checkPlatformsPlayer1 endp


checkPlatformsPlayer2 proc  near
    
    ; to keep the values of the registers
    pushf
    pusha                 

    lea bx,platformsX  
    lea si,platformsY
    lea di,platformExist
    
    mov cx,player2PosX
    mov x1,cx
    add cl,player2Width
    adc ch,0
    mov x2,cx
    
    mov cx,player2PosY
    mov y1,cx
    add cl,player2Height
    adc ch,0
    mov y2,cx
      
   
        
    mov ax,'#' 
    
    loopOnPlatforms2: 
        mov al,0
        cmp [di],al
        jz completeLoopingPlatform2
        checkPlatForm2:
            mov cx,[bx]
            mov x3,cx
            mov cx,[bx+2]
            mov x4,cx
            
            mov cx,[si]
            mov y3,cx
            mov cx,[si+2]
            mov y4,cx
            
            call  checkCollision
            mov cx,edgeOfCollision
  
            
            cmp cx,4
            jz  touchDown2
            cmp cx,5
            jz  touchDown2
            cmp cx,7
            jz  touchDown2
            ;cmp cx,9
            ;jz touchDown
            
            ;cmp cx,3
            ;jz stayOnRightEdge2
            ;cmp cx,1
            ;jz stayOnLeftEdge2
            
            ;cmp dx,[si]
            ;jl comparePosYPlusSize
            completeLoopingPlatform2:
                add di,1
                add bx,4
                add si,4
                mov ax,'#'
                cmp [bx],ax 
                jnz loopOnPlatforms2     
   
    
    
   
    endCheckPlatform2:                 
    popa 
    popf 
    ret
    

    touchDown2:
        mov dx,[si]
        sub dl,player2Height
        sbb dh,0
        mov player2PosY,dx
        jmp endCheckPlatform2
        
        
    stayOnLeftEdge2:
        ;mov cx,[bx] 
        ;sub cl,player2Width
        ;sbb ch,0
        ;mov player2PosX,cx
        jmp completeLoopingPlatform2
        
        
    stayOnRightEdge2:
        ;mov cx,[bx+2]
        ;mov al,5
        ;mov squareColor,al 
        ;mov player2PosX,cx
        jmp completeLoopingPlatform2      
             
    
checkPlatformsPlayer2 endp
;------------------------------------------Platforms Utilities------------------------------------------

;------------------------------------------Bullet Utilities------------------------------------------
drawBulletPlayer1 proc  near
    ; to keep the values of the registers
    pushf
    push ax
    push bx
    push cx
    push dx
    
    
    mov cx,player1bulletPosX
    mov dx,player1bulletPosY
    
    mov al,player1CurrentBulletCurrent ;Pixel color 
    mov ah,0ch ;Draw Pixel Command 
    drawBulletOuter1:
        mov cx,player1bulletPosX
       
        mov bl,0
        drawBulletInner1:  
            int 10h
            inc cx
            inc bl
            cmp bl,player1bulletSize
            jle drawBulletInner1
        inc bh
        inc dx
        cmp bh,player1bulletSize
        jle drawBulletOuter1
    
      
      
      
                   
    pop dx
    pop cx
    pop bx
    pop ax 
    popf 
    ret
                       
                       
drawBulletPlayer1 endp


drawBulletPlayer2 proc  near
    ; to keep the values of the registers
    pushf
    push ax
    push bx
    push cx
    push dx
    
    
    mov cx,player2bulletPosX
    mov dx,player2bulletPosY
    
    mov al,player2CurrentBulletCurrent ;Pixel color 
    mov ah,0ch ;Draw Pixel Command 
    drawBulletOuter2:
        mov cx,player2bulletPosX
       
        mov bl,0
        drawBulletInner2:  
            int 10h
            inc cx
            inc bl
            cmp bl,player2bulletSize
            jle drawBulletInner2
        inc bh
        inc dx
        cmp bh,player2bulletSize
        jle drawBulletOuter2
    
      
      
      
                   
    pop dx
    pop cx
    pop bx
    pop ax 
    popf 
    ret
    
drawBulletPlayer2 endp



getMousePositionAndStatusPlayer1 proc near
     ; to keep the values of the registers
    pushf
    push ax
    push bx
    push cx
    push dx

    ;get mouse position and status 
    ;if left button is down: BX=1
    ;if right button is down: BX=2
    ;if both buttons are down: BX=3
    ;CX = x
    ;DX = y 
    mov ax,3
    int 33h
    
    mov player1mouseStatus,bx 
    mov ax,cx
    mov cl,1
    shr ax,cl
    mov player1mousePosX,ax
    mov player1mousePosY,dx 
    
     
           
    pop dx
    pop cx
    pop bx
    pop ax 
    popf 
    ret
    
getMousePositionAndStatusPlayer1 endp    
    

getMousePositionAndStatusPlyer2 proc near
    ; to keep the values of the registers
    pushf
    push ax
    push bx
    push cx
    push dx

    ;get mouse position and status 
    ;if left button is down: BX=1
    ;if right button is down: BX=2
    ;if both buttons are down: BX=3
    ;CX = x
    ;DX = y 
    mov ax,3
    int 33h
    
    mov player2mouseStatus,bx 
    mov ax,cx
    mov cl,1
    shr ax,cl
    mov player2mousePosX,ax
    mov player2mousePosY,dx 
    
     
           
    pop dx
    pop cx
    pop bx
    pop ax 
    popf 
    ret
    
getMousePositionAndStatusPlyer2 endp 


fireBulletPlayer1 proc   near
    ; to keep the values of the registers
    pushf
    push ax
    push bx
    push cx
    push dx
    push si  
    
    mov bx,0
    mov player1currentFrameBullet,bx 
    ;jmp firebulletType2Player1 
    
    mov al,1
    cmp player1CurrentBullet,al
    jz firebulletType1Player1 
    
    mov al,2 
    cmp player1CurrentBullet,al
    jz firebulletType2Player1 
    
    mov al,3 
    cmp player1CurrentBullet,al
    jz firebulletType3Player1
     
    mov al,4 
    cmp player1CurrentBullet,al
    jz firebulletType4Player1                    
                         
    mov al,5
    cmp player1CurrentBullet,al
    jz firebulletType5Player1 
    
    endfireBulletPlayer1:  
    ; mov ax,player1bulletDirectionY
    ; cmp player1bulletDirectionX ,AX
    ; jl divideByP1Bulletx
    ; jmp divideByP1BulletY 

    endOptimize:
    pop si                 
    pop dx
    pop cx
    pop bx
    pop ax 
    popf 
    ret
    
    ; divideByP1Bulletx:
    ; mov cx,player1bulletDirectionX
    ; mov ax,player1bulletDirectionX
    ; cmp ax,0
    ; jle absoluteBulletDirectionXP1
    ; completedivideByP1Bulletx:
    ; ; to never be zero
    ; add cx,1
    ; mov ax,1
    ; mov player1bulletDirectionX,ax
    ; mov ax,player1bulletDirectionY
    ; cwd
    ; mov dx,0
    ; div cx
    ; add ax,1
    ; mov player1bulletDirectionY,ax
    ; jmp endOptimize


    ; absoluteBulletDirectionXP1:
    ; mov ax,player1bulletDirectionX
    ; neg ax
    ; mov cx,ax
    ; jmp completedivideByP1Bulletx

    ; divideByP1BulletY:
    ; mov cx,player1bulletDirectionY
    ; mov ax,player1bulletDirectionY
    ; cmp ax,0
    ; jle absoluteBulletDirectionYP1
    ; completedivideByP1BulletY:
    ; ; to never be zero
    ; add cx,1
    ; mov ax,1
    ; mov player1bulletDirectionY,ax
    ; mov ax,player1bulletDirectionX
    ; cwd
    ; mov dx,0
    ; div cx
    ; add ax,1
    ; mov player1bulletDirectionY,ax
    ; jmp endOptimize


    ; absoluteBulletDirectionYP1:
    ; mov ax,player1bulletDirectionY
    ; neg ax
    ; mov cx,ax
    ; jmp completedivideByP1BulletY
    
    firebulletType1Player1:
    mov al,player1bulletColor
    mov player1CurrentBulletCurrent,al
    call followMouseBullet1
    mov ax,bulletDamage1
    mov player1CurrentBulletDamge,ax
    jmp endfireBulletPlayer1  
     
     
     
    firebulletType2Player1:
    mov al,bullet2Color
    mov player1CurrentBulletCurrent,al 
    mov ax,player2PosX ;ax = mx
    ;mov bl,player1Width ;bl = size
    ;mov cl,1    ; cl = 1
    ;shr bl,cl   ; bl = bl/2
    ;mov bh,0 
    ;cwd   ; bh = 0
    ;sub ax,bx   ; ax = mx-size/2
    sub ax,player1PosX ; ax = mx-player1PosX-size/2  
    mov cx,2
    ;shr ax,cl 
    ;mov dx,0 
    CWD
    idiv cx


    mov player1bulletDirectionX,ax  
    
    mov ax,player2PosY
    ;mov bl,player1Height
    ;mov cl,1
    ;shr bl,cl
    ;mov bh,0 
    ;cwd
    ;sub ax,bx
    sub ax,player1PosY   
    mov cx,2  
    mov dx,0 
    CWD
    idiv cx
    ;shr ax,cl
    mov player1bulletDirectionY,ax
    
mov ax,player1bulletDirectionX
    cwd
    ;mov dx,0
    imul ax
    mov value21,ax

    mov ax,player1bulletDirectionY
    cwd
    ;mov dx,0
    imul ax
    add value21,ax

    mov ax,player1bulletDirectionX
    mov normalX1,ax
    mov ax,player1bulletDirectionY
    mov normalY1,ax


     finit
     fild value21
     fsqrt 
     fist value21

    finit
    fild normalX1
    fimul speed
    fidiv value21
    fist normalX1 

    finit
    fild normalY1
    fimul speed
    fidiv value21
    fist normalY1

    mov ax,normalX1
    ;add ax,1
    mov player1bulletDirectionX,ax
    mov ax,normalY1
    ;add ax,1
    mov player1bulletDirectionY,ax

    
    mov ax,player1PosX
    ;mov bx,0
    ;mov bl,sizy
    ;shr bl,cl
    ;add ax,bx
    mov player1bulletPosX,ax
    
    mov ax,player1PosY
    ;mov bx,0
    ;mov bl,sizy
    ;shr bl,cl
    ;add ax,bx
    mov player1bulletPosY,ax
    mov ax,bulletDamage2
    mov player1CurrentBulletDamge,ax
    jmp endfireBulletPlayer1
    
    
    firebulletType3Player1:
    mov al,bullet3Color
    mov player1CurrentBulletCurrent,al
    call followMouseBullet1
    
    mov ax,bulletDamage3
    mov player1CurrentBulletDamge,ax
    jmp endfireBulletPlayer1
    
    
    firebulletType4Player1:
    mov al,bullet4Color
    mov player1CurrentBulletCurrent,al
    call followMouseBullet1
    
    mov ax,bulletDamage4
    mov player1CurrentBulletDamge,ax
    jmp endfireBulletPlayer1
    
    
    
    firebulletType5Player1:
    mov al,bullet5Color
    mov player1CurrentBulletCurrent,al
    call followMouseBullet1
    
    mov ax,bulletDamage5
    mov player1CurrentBulletDamge,ax
    jmp endfireBulletPlayer1
       
    
fireBulletPlayer1 endp 
 
 
followMouseBullet1 proc near 
    pusha
    mov ax,player1mousePosX ;ax = mx
    ;mov bl,player1Width ;bl = size
    ;mov cl,1    ; cl = 1
    ;shr bl,cl   ; bl = bl/2
    ;mov bh,0 
    ;cwd   ; bh = 0
    ;sub ax,bx   ; ax = mx-size/2
    cwd
    sub ax,player1PosX ; ax = mx-player1PosX-size/2  
    mov cx,2
    cwd
    idiv cx
    ;mov dx,0 
    ;CWD
    ;idiv cx
    mov player1bulletDirectionX,ax  
    
    mov ax,player1mousePosY
    ;mov bl,player1Height
    ;mov cl,1
    ;shr bl,cl
    ;mov bh,0 
    ;cwd
    ;sub ax,bx
    cwd
    sub ax,player1PosY  
     
    mov cx,2   
    ;mov dx,0 
    CWD
    idiv cx
    ;shr ax,cl
    mov player1bulletDirectionY,ax

    mov ax,player1bulletDirectionX
    cwd
    ;mov dx,0
    imul ax
    mov value21,ax

    mov ax,player1bulletDirectionY
    cwd
    ;mov dx,0
    imul ax
    add value21,ax

    mov ax,player1bulletDirectionX
    mov normalX1,ax
    mov ax,player1bulletDirectionY
    mov normalY1,ax


     finit
     fild value21
     fsqrt 
     fist value21

    finit
    fild normalX1
    fimul speed
    fidiv value21
    fist normalX1 

    finit
    fild normalY1
    fimul speed
    fidiv value21
    fist normalY1

    mov ax,normalX1
    ;add ax,1
    mov player1bulletDirectionX,ax
    mov ax,normalY1
    ;add ax,1
    mov player1bulletDirectionY,ax

    mov ax,player1PosX
    ;mov bx,0
    ;mov bl,sizy
    ;shr bl,cl
    ;add ax,bx
    mov player1bulletPosX,ax
    
    mov ax,player1PosY
    ;mov bx,0
    ;mov bl,sizy
    ;shr bl,cl
    ;add ax,bx
    mov player1bulletPosY,ax
    
    popa
    ret 
followMouseBullet1 endp 


fireBulletPlayer2 proc   near
    ; to keep the values of the registers
    pushf
    push ax
    push bx
    push cx
    push dx
    push si  
    
    mov bx,0
    mov player2currentFrameBullet,bx      

    ;jmp firebulletType2Player2 
    mov al,1
    cmp player2CurrentBullet,al
    jz firebulletType1Player2 
    mov al,2
    cmp player2CurrentBullet,al 
    jz  firebulletType2Player2
    
    mov al,3 
    cmp player2CurrentBullet,al
    jz firebulletType3Player2  
     
    mov al,4 
    cmp player2CurrentBullet,al
    jz firebulletType4Player2                  
                         
    mov al,5 
    cmp player2CurrentBullet,al
    jz firebulletType5Player2
    
      
    endfireBulletPlayer2:  
    pop si                 
    pop dx
    pop cx
    pop bx
    pop ax 
    popf 
    ret
    firebulletType1Player2:
    mov al,player2bulletColor
    mov player2CurrentBulletCurrent,al 
    call followMouseBullet2
    mov ax,bulletDamage1
    mov player2CurrentBulletDamge,ax
    jmp endfireBulletPlayer2
    
    
    firebulletType2Player2:
    mov al,bullet2Color
    mov player2CurrentBulletCurrent,al  
    mov ax,player1PosX ;ax = mx
    ;mov bl,player1Width ;bl = size
    ;mov cl,1    ; cl = 1
    ;shr bl,cl   ; bl = bl/2
    ;mov bh,0 
    ;cwd   ; bh = 0
    ;sub ax,bx   ; ax = mx-size/2
    sub ax,player2PosX ; ax = mx-player1PosX-size/2  
    mov cx,2
    ;shr ax,cl 
    ;mov dx,0 
    CWD
    idiv cx
    mov player2bulletDirectionX,ax  
    
    mov ax,player1PosY
    ;mov bl,player1Height
    ;mov cl,1
    ;shr bl,cl
    ;mov bh,0 
    ;cwd
    ;sub ax,bx
    sub ax,player2PosY   
    mov cx,2   
    ;mov dx,0 
    CWD
    idiv cx
    ;shr ax,cl
    mov player2bulletDirectionY,ax
    mov ax,player2bulletDirectionX
    cwd
    ;mov dx,0
    imul ax
    mov value22,ax

    mov ax,player2bulletDirectionY
    cwd
    ;mov dx,0
    imul ax
    add value22,ax

    mov ax,player2bulletDirectionX
    mov normalX2,ax
    mov ax,player2bulletDirectionY
    mov normalY2,ax


     finit
     fild value22
     fsqrt 
     fist value22

    finit
    fild normalX2
    fimul speed
    fidiv value22
    fist normalX2

    finit
    fild normalY2
    fimul speed
    fidiv value22
    fist normalY2

    mov ax,normalX2
    ;add ax,1
    mov player2bulletDirectionX,ax
    mov ax,normalY2
    ;add ax,1
    mov player2bulletDirectionY,ax
    
    mov ax,player2PosX
    ;mov bx,0
    ;mov bl,sizy
    ;shr bl,cl
    ;add ax,bx
    mov player2bulletPosX,ax
    
    mov ax,player2PosY
    ;mov bx,0
    ;mov bl,sizy
    ;shr bl,cl
    ;add ax,bx
    mov player2bulletPosY,ax
    mov ax,bulletDamage2
    mov player2CurrentBulletDamge,ax
    jmp endfireBulletPlayer2
    
    
    firebulletType3Player2:
    mov al,bullet3Color
    mov player2CurrentBulletCurrent,al 
    call followMouseBullet2
    
    mov ax,bulletDamage3
    mov player2CurrentBulletDamge,ax
    jmp endfireBulletPlayer2
    
    
    
    
    firebulletType4Player2:
    mov al,bullet4Color
    mov player2CurrentBulletCurrent,al 
    call followMouseBullet2
    
    mov ax,bulletDamage4
    mov player2CurrentBulletDamge,ax
    jmp endfireBulletPlayer2
    
    
    firebulletType5Player2:
    mov al,bullet5Color
    mov player2CurrentBulletCurrent,al 
    call followMouseBullet2
    
    mov ax,bulletDamage5
    mov player2CurrentBulletDamge,ax
    jmp endfireBulletPlayer2 
    
fireBulletPlayer2 endp  


followMouseBullet2 proc near
    pusha
     
    mov ax,player2mousePosX ;ax = mx
    ;mov bl,player1Width ;bl = size
    ;mov cl,1    ; cl = 1
    ;shr bl,cl   ; bl = bl/2
    ;mov bh,0 
    ;cwd   ; bh = 0
    ;sub ax,bx   ; ax = mx-size/2
    sub ax,player2PosX ; ax = mx-player1PosX-size/2  
    mov cx,2
    ;shr ax,cl 
    ;mov dx,0 
    CWD
    idiv cx
    mov player2bulletDirectionX,ax  
    
    mov ax,player2mousePosY
    ;mov bl,player1Height
    ;mov cl,1
    ;shr bl,cl
    ;mov bh,0 
    ;cwd
    ;sub ax,bx
    sub ax,player2PosY   
    mov cx,2   
    ;mov dx,0 
    CWD
    idiv cx
    ;shr ax,cl
    mov player2bulletDirectionY,ax
    
 mov ax,player2bulletDirectionX
    cwd
    ;mov dx,0
    imul ax
    mov value22,ax

    mov ax,player2bulletDirectionY
    cwd
    ;mov dx,0
    imul ax
    add value22,ax

    mov ax,player2bulletDirectionX
    mov normalX2,ax
    mov ax,player2bulletDirectionY
    mov normalY2,ax


     finit
     fild value22
     fsqrt 
     fist value22

    finit
    fild normalX2
    fimul speed
    fidiv value22
    fist normalX2

    finit
    fild normalY2
    fimul speed
    fidiv value22
    fist normalY2

    mov ax,normalX2
    ;add ax,1
    mov player2bulletDirectionX,ax
    mov ax,normalY2
    ;add ax,1
    mov player2bulletDirectionY,ax

    
    mov ax,player2PosX
    ;mov bx,0
    ;mov bl,sizy
    ;shr bl,cl
    ;add ax,bx
    mov player2bulletPosX,ax
    
    mov ax,player2PosY
    ;mov bx,0
    ;mov bl,sizy
    ;shr bl,cl
    ;add ax,bx
    mov player2bulletPosY,ax 
    
    popa
    ret
followMouseBullet2 endp 


updateBulletPlayer1 proc   near
    ; to keep the values of the registers
    pushf
    push ax
    push bx
    push cx
    push dx
    push si 
    
     
    mov bx,player1currentFrameBullet
    inc bx
    cmp bx,player1bulletLife
    jge removeBulletUpdate
    
    mov player1currentFrameBullet,bx
    mov ax,player1bulletDirectionX 
    mov al,player1bulletSpeed
    mov ah,0
    add player1bulletPosX,ax 
    ;mov ax,player1bulletDirectionY  
    ;mov ax,1
    ;add player1bulletPosY,ax
    
    endUpdateBullet:  
    pop si                 
    pop dx
    pop cx
    pop bx
    pop ax 
    popf 
    ret
   
    removeBulletUpdate:
    mov bl,0
    mov player1isThereBullet,bl
    mov bl,1
    mov player1CurrentBullet,bl
    jmp endUpdateBullet
    
updateBulletPlayer1 endp

                   
updateBulletPlayer2 proc   near
    ; to keep the values of the registers
    pushf
    push ax
    push bx
    push cx
    push dx
    push si
      
    mov bx,player2currentFrameBullet
    inc bx
    cmp bx,player2bulletLife
    jge removeBulletUpdate2
    
    mov player2currentFrameBullet,bx
    mov al,player1bulletSpeed
    mov ah,0
    ;mov ax,1
    add player2bulletPosX,ax 
    ;mov ax,player2bulletDirectionY  
    ;mov ax,1
    ;add player2bulletPosY,ax
    
    endUpdateBullet2:  
    pop si                 
    pop dx
    pop cx
    pop bx
    pop ax 
    popf 
    ret
    
    removeBulletUpdate2:
    mov bl,0
    mov player2isThereBullet,bl
    mov bl,1
    mov player2CurrentBullet,bl
    jmp endUpdateBullet2
    
updateBulletPlayer2 endp


checkBulletEdgePlayer1 proc near
       ; to keep the values of the registers
    pushf 
    push ax
    push cx
    
    
    mov cx,player1bulletPosX
    add cl,player1bulletSize
    adc cx,0
    cmp cx,gameWidth
    jge removeBullet
    
    mov cx,player1bulletPosX
    cmp cx,0
    jle removeBullet
    
    
    mov cx,player1bulletPosY
    add cl,player1bulletSize 
    adc cx,0
    cmp cx,gameHeight
    jge removeBullet
    
    mov cx,player1bulletPosY
    cmp cx,0
    jle removeBullet
        
    endCheckBulletEdge: 
    pop cx
    pop ax     
    popf 
    ret
    
    removeBullet: 
        mov al,0
        mov player1isThereBullet,0
        mov bl,1
        mov player1CurrentBullet,bl
        jmp endCheckBulletEdge 
      
checkBulletEdgePlayer1 endp   


checkBulletEdgePlayer2 proc near
       ; to keep the values of the registers
    pushf 
    push ax
    push cx
    
    
    mov cx,player2bulletPosX
    add cl,player2bulletSize
    adc cx,0
    cmp cx,gameWidth
    jge removeBullet2
    
    mov cx,player2bulletPosX
    cmp cx,0
    jle removeBullet2
    
    
    mov cx,player2bulletPosY
    add cl,player2bulletSize 
    adc cx,0
    cmp cx,gameHeight
    jge removeBullet2
    
    mov cx,player2bulletPosY
    cmp cx,0
    jle removeBullet2
    
    endCheckBulletEdge2: 
    pop cx
    pop ax     
    popf 
    ret
    
    removeBullet2: 
        mov al,0
        mov player2isThereBullet,0
        mov bl,1
        mov player2CurrentBullet,bl
        jmp endCheckBulletEdge2 
        
    
    
checkBulletEdgePlayer2 endp 


checkBulletPlatformPlayer1 proc near
    ; to keep the values of the registers
    pushf
    pusha                

    lea bx,platformsX  
    lea si,platformsY
    lea di,platformExist 
    
    loopOnPlatformsBullet: 
        mov al,0
        cmp [di],al
        jz  completeLoopingPlatformBullet
        checkPlatFormBullet:
            ;initialize parameters
            mov cx,player1bulletPosX
            mov x1,cx
            add cl,player1bulletSize
            adc cx,0
            mov x2,cx
            mov cx,player1bulletPosY
            mov y1,cx
            add cl,player1bulletSize
            adc cx,0
            mov y2,cx
            
            mov cx,[bx]
            mov x3,cx
            mov cx,[bx+2]
            mov x4,cx
            mov cx,[si]
            mov y3,cx
            mov cx,[si+2]
            mov y4,cx
            
            call  checkCollision
            mov cx,edgeOfCollision
            
            cmp cx,1
            jz reflectOnX
            cmp cx,3
            jz reflectOnX
            cmp cx,2
            jz reflectOnY
            cmp cx,4
            jz reflectOnY
               cmp cx,5
            jz reflectOnXY
            cmp cx,6
            jz reflectOnXY
            cmp cx,7
            jz reflectOnXY
            cmp cx,8
            jz reflectOnXY
            

             
            completeLoopingPlatformBullet: 
            
                mov ax,'#' 
                add di,1
                add bx,4
                add si,4
                cmp [bx],ax 
                jnz loopOnPlatformsBullet     
   
    endCheckPlatformBullet:                 
    popa
    popf 
    ret
          
    reflectOnX:
        mov al,5
        cmp player1CurrentBullet,al
        jz destroyPlatform
        
       
        mov ax,player1bulletDirectionX
        neg ax
        mov player1bulletDirectionX,ax
        jmp endCheckPlatformBullet 
        
        
    reflectOnY:
        
        mov al,5
        cmp player1CurrentBullet,al
        jz destroyPlatform
        mov ax,player1bulletDirectionY
        neg ax
        mov player1bulletDirectionY,ax
        jmp endCheckPlatformBullet

        reflectOnXY:
        
        mov al,5
        cmp player1CurrentBullet,al
        jz destroyPlatform
        mov ax,player1bulletDirectionX
        neg ax
        mov player1bulletDirectionX,ax
        mov ax,player1bulletDirectionY
        neg ax
        mov player1bulletDirectionY,ax
        jmp endCheckPlatformBullet           
   destroyPlatform:
        mov al,0
        mov [di],al 
        mov  player1isThereBullet,al
        jmp endCheckPlatformBullet
    
checkBulletPlatformPlayer1 endp

checkBulletPlatformPlayer2 proc near
    ; to keep the values of the registers
    pushf
    pusha               

    lea bx,platformsX  
    lea si,platformsY
    lea di,platformExist
   
        
    mov ax,'#' 
    
    loopOnPlatformsBullet2: 
        mov al,0
        cmp [di],al
        jz  completeLoopingPlatformBullet2
        checkPlatFormBullet2:
            ;initialize parameters
            mov cx,player2bulletPosX
            mov x1,cx
            add cl,player2bulletSize
            adc cx,0
            mov x2,cx
            mov cx,player2bulletPosY
            mov y1,cx
            add cl,player2bulletSize
            adc cx,0
            mov y2,cx
            
            mov cx,[bx]
            mov x3,cx
            mov cx,[bx+2]
            mov x4,cx
            mov cx,[si]
            mov y3,cx
            mov cx,[si+2]
            mov y4,cx
            
            call  checkCollision
            mov cx,edgeOfCollision
            
            cmp cx,1
            jz reflectOnX2
            cmp cx,3
            jz reflectOnX2
            cmp cx,2
            jz reflectOnY2
            cmp cx,4
            jz reflectOnY2
              cmp cx,5
            jz reflectOnXY2
            cmp cx,6
            jz reflectOnXY2
            cmp cx,7
            jz reflectOnXY2
            cmp cx,8
            jz reflectOnXY2
            

             
            completeLoopingPlatformBullet2:
             mov ax,'#'
                add di,1
                add bx,4
                add si,4
                cmp [bx],ax 
                jnz loopOnPlatformsBullet2     
   
    
    
   
    endCheckPlatformBullet2:                 
    popa
    popf
    ret
    

          
    reflectOnX2:
        ;mov al,9
        ;mov player1bulletColor,al 
        mov al,5
        cmp player2CurrentBullet,al
        jz destroyPlatform2
        
        mov ax,player2bulletDirectionX
        neg ax
        mov player2bulletDirectionX,ax
        jmp endCheckPlatformBullet2 
        
        
    reflectOnY2:
        ;mov al,3
        ;mov player1bulletColor,al
        mov al,5
        cmp player2CurrentBullet,al
        jz destroyPlatform2

        reflectOnXY2:
        
        mov al,5
        cmp player2CurrentBullet,al
        jz destroyPlatform2
        mov ax,player2bulletDirectionX
        neg ax
        mov player2bulletDirectionX,ax
        mov ax,player2bulletDirectionY
        neg ax
        mov player2bulletDirectionY,ax
        jmp endCheckPlatformBullet2 
         
        mov ax,player2bulletDirectionY
        neg ax
        mov player2bulletDirectionY,ax
        jmp endCheckPlatformBullet2        
       destroyPlatform2: 
        mov al,0
        mov [di],al     
        mov  player2isThereBullet,al
        jmp endCheckPlatformBullet2
    
checkBulletPlatformPlayer2 endp 
;------------------------------------------Bullet Utilities------------------------------------------

;------------------------------------------General Utilities------------------------------------------
checkCollision proc near  
    ; to keep the values of the registers  
    push bx
    push cx
    push dx             
  
       
            ; check left edge  
            mov cx,x1  
            cmp cx,x3
            jle checkCollisionLeftEdgeX2
            
            checkCollisionLeftEgdeCase2:
            mov cx,x2
            cmp cx,x3
            jge checkCollisionLeftEgdeCase2X1
            
            checkCollisionLeftEgdeCase3:
            mov cx,x1
            cmp cx,x3
            jle checkCollisionLeftEgdeCase3X2
            
            
          
             
            checkCollisionRightEdge:
            mov cx,x1  
            mov dx,y1
             
            cmp cx,x4
            jle checkCollisionRightEdgeX2
            
            checkCollisionRightEdgeCase2:
            mov cx,x1
            cmp cx,x4
            jle checkCollisionRightEdgeCase2X2
            
             
            checkCollisionRightEdgeCase3:
            mov cx,y1
            cmp cx,y4
            jle checkCollisionRightEdgeCase3Y2 
             
            checkCollisionDown:
              
            mov cx,y1
             
            cmp cx,y4
            jle checkCollisionDownY2
            
            checkCollisionUp: 
            mov cx,x1  
            mov dx,y1
            
            cmp dx,y3
            jle checkCollisionUpY2
            
            ;check id inside object 
            checkInside:
            mov cx,x1
            cmp cx,x3
            jge checkInsideX2
            jmp noHit

   
    
    
   
    endCheckCollision:                 
                   
    pop dx
    pop cx 
    pop bx 
    ret
    
    checkCollisionLeftEdgeX2:
        mov cx,x2
        cmp cx,x3
        jge checkCollisionLeftEdgeY1
        jmp checkCollisionLeftEgdeCase2
        
    
    checkCollisionLeftEdgeY1:
        mov cx,y1
        cmp cx,y3
        jge checkCollisionLeftEdgeY2
        jmp checkCollisionLeftEgdeCase2 
        
    checkCollisionLeftEdgeY2:
        mov cx,y2
        cmp cx,y4
        jle hitLeftEdge
        jmp checkCollisionLeftEgdeCase2
        
        
        
    checkCollisionLeftEgdeCase2X1:
        mov cx,x1
        cmp cx,x3
        jle checkCollisionLeftEgdeCase2Y1
        jmp checkCollisionLeftEgdeCase3
        
    checkCollisionLeftEgdeCase2Y1:
        mov cx,y1
        cmp cx,y3
        jle checkCollisionLeftEgdeCase2Y2
        jmp checkCollisionLeftEgdeCase3
        
    checkCollisionLeftEgdeCase2Y2:
        mov cx,y2
        cmp cx,y3
        jge hitLeftEdgeCase2
        jmp checkCollisionLeftEgdeCase3
            
    checkCollisionLeftEgdeCase3X2:
        mov cx,x2
        cmp cx,x3
        jge checkCollisionLeftEgdeCase3Y1
        jmp checkCollisionRightEdge
    
    checkCollisionLeftEgdeCase3Y1:
        mov cx,y1
        cmp cx,y4
        jle checkCollisionLeftEgdeCase3Y2
        jmp checkCollisionRightEdge
        
        
    checkCollisionLeftEgdeCase3Y2:
        mov cx,y2
        cmp cx,y4
        jge hitLeftEdgeCase3
        jmp checkCollisionRightEdge
        
        
        
            
            
    checkCollisionRightEdgeX2:
        mov cx,x2
        cmp cx,x4
        jge checkCollisionRightEdgeY1
        jmp checkCollisionRightEdgeCase2  
        
        
    checkCollisionRightEdgeY1:
        mov cx,y1
        cmp cx,y3
        jge checkCollisionRightEdgeY2
        jmp checkCollisionRightEdgeCase2 
        
    checkCollisionRightEdgeY2:
        mov cx,y2
        cmp cx,y4
        jle hitRightEdge
        jmp checkCollisionRightEdgeCase2
        
        
    checkCollisionRightEdgeCase2X2:
        mov cx,x2
        cmp cx,x4
        jge checkCollisionRightEdgeCase2Y1
        jmp checkCollisionRightEdgeCase3
        
        
    checkCollisionRightEdgeCase2Y1:
        mov cx,y1
        cmp cx,y3
        jle checkCollisionRightEdgeCase2Y2
        jmp checkCollisionRightEdgeCase3
        
        
        
    checkCollisionRightEdgeCase2Y2:
        mov cx,y2
        cmp cx,y3
        jge hitRightEdgeCase2
        jmp checkCollisionRightEdgeCase3
        
    checkCollisionRightEdgeCase3Y2:
        mov cx,y2
        cmp cx,y4
        jge checkCollisionRightEdgeCase3X1
        jmp checkCollisionDown 
        
    checkCollisionRightEdgeCase3X1:
        mov cx,x1
        cmp cx,x4
        jle checkCollisionRightEdgeCase3X2
        jmp checkCollisionDown
        
        
    checkCollisionRightEdgeCase3X2:
        mov cx,x2
        cmp cx,x4
        mov al,1 
        jge hitRightEdgeCase3
        jmp checkCollisionDown
        
    
    
    ; check if collsion at down edge      
    checkCollisionDownY2:
        mov cx,y2
        cmp cx,y4
        jge checkCollisionDownX1
        jmp checkCollisionUp 
        
        
    checkCollisionDownX1:
        mov cx,x1
        cmp cx,x3
        jge checkCollisionDownX2
        jmp checkCollisionUp
         
    
    
    checkCollisionDownX2:
        mov cx,x2
        cmp cx,x4
        jle hitDownEdge
        jmp checkCollisionUp  
        
    ; check collision with upper edge
        
    checkCollisionUpY2:
        mov cx,y2
        cmp cx,y3
        jge checkCollisionUpX1
        jmp noHit
        
        
    checkCollisionUpX1: 
        mov cx,x1
        cmp cx,x3
        jge checkCollisionUpX2
        jmp noHit
         
    
    
    checkCollisionUpX2:
        mov cx,x2
        cmp cx,x4
        jle hitUpEdge
        jmp noHit
        
    
    
    checkInsideX2:
        mov cx,x2
        cmp cx,x4
        jle checkInsideY1
        jmp noHit
        
        
    checkInsideY1:
        mov cx,y1
        cmp cx,y3
        jge checkInsideY2
        jmp noHit
        
        
    checkInsideY2:
        mov cx,y2
        cmp cx,y4
        jle hitInside
        jmp noHit
        
        
    hitLeftEdge:
        mov bx,1
        mov edgeOfCollision,bx
        jmp endCheckCollision
        
        
    hitRightEdge:
        mov bx,3   
        mov edgeOfCollision,bx
        jmp endCheckCollision
        
    hitDownEdge:
        mov bx,2    
        mov edgeOfCollision,bx
        jmp endCheckCollision
        
    hitUpEdge:
        mov bx,4   
        mov edgeOfCollision,bx
        jmp endCheckCollision
        
   hitLeftEdgeCase2:
        mov bx,5   
        mov edgeOfCollision,bx
        jmp endCheckCollision
        
   hitLeftEdgeCase3:
        mov bx,6   
        mov edgeOfCollision,bx
        jmp endCheckCollision
        
   hitRightEdgeCase2:
        mov bx,7   
        mov edgeOfCollision,bx
        jmp endCheckCollision
        
   hitRightEdgeCase3:
        mov bx,8   
        mov edgeOfCollision,bx
        jmp endCheckCollision
    
   hitInside:
        mov bx,9
        mov edgeOfCollision,bx
        jmp endCheckCollision
        
   noHit:
        mov bx,0 
        mov edgeOfCollision,bx
        jmp endCheckCollision        

   
    
    
checkCollision endp  


checkSkipFrame proc near
            ; to keep the values of the registers  
            push bx
            push cx
            push dx             
          
            ; check if skiped from left to right
            mov cx,y1
            cmp cx,y3
            jge checkLeftToRightY2 
            
            
            ; check if skipped right to left
            checkRightToLeft:
            mov cx,x1
            cmp cx,x4
            jge checkRightToLeftDeltax1
            ; check down to up
            checkDownToUp:
            mov cx,x1
            cmp cx,x3
            jge checkDownToUpX2
            ; check up to down
            checkUpToDown:
            mov cx,y2
            cmp cx,y3
            jle checkUpToDownDeltaY1
    
           
            endCheckSkipFrame:                 
                           
            pop dx
            pop cx 
            pop bx 
            ret   
            
            checkLeftToRightY2:
            mov cx,y2
            cmp cx,y4
            jle checlLeftToRightX2
            jmp checkDownToUp
            
            checlLeftToRightX2:
            mov cx,x2
            cmp cx,x3
            jle checkLeftToRightDeltaX1
            jmp checkRightToLeft
            
            
            checkLeftToRightDeltaX1:
            mov cx,x1
            add cx,deltaX1
            mov dx,x4
            add dx,deltaX2
            cmp cx,dx
            jge skipLeftToRight
            jmp checkRightToLeft 
             
            checkRightToLeftDeltaX1:
            mov cx,x2
            add cx,deltaX1
            mov dx,x3
            add dx,deltaY1
            cmp cx,dx
            jle skipRightToLeft
            jmp checkDownToUp
            
            checkDownToUpX2:
            mov cx,x2
            cmp cx,x4
            jle checkDownToUpY1
            jmp endCheckSkipFrame
            
            checkDownToUpY1:
            mov cx,y1
            cmp cx,y4
            jge checkDownToUpDeltaY1
            jmp checkUpToDown
            
            checkDownToUpDeltaY1:
            mov cx,y2
            add cx,deltaY1
            mov dx,y3
            add dx,deltaY2
            cmp cx,dx
            jle skipDownToUp
            jmp checkUpToDown
            
            
            checkUpToDownDeltaY1:
            mov cx,y1
            add cx,deltaY1
            mov dx,y4
            add dx,deltaY2
            cmp cx,dx
            jge skipUpToDown
            
            skipLeftToRight:
            mov ax,1
            mov skipFrameEdge,ax
            jmp endCheckSkipFrame
            
            skipRightToLeft:
            mov ax,3
            mov skipFrameEdge,ax
            jmp endCheckSkipFrame
            
            skipDownToUp:
            mov ax,2
            mov skipFrameEdge,ax
            jmp endCheckSkipFrame
            
            skipUpToDown:
            mov ax,4
            mov skipFrameEdge,ax
            jmp endCheckSkipFrame
                
checkSkipFrame endp
;------------------------------------------General Utilities------------------------------------------

;------------------------------------------Bullet Utilities------------------------------------------
checkBulletSkipFrame proc near 
     ; to keep the values of the registers
    pushf
    push ax
    push bx
    push cx
    push dx
    push si                 

    lea bx,platformsX  
    lea si,platformsY
   
   
        
    mov ax,'#' 
    
    loopOnSkipping: 
            ;initialize parameters
            mov cx,player1bulletPosX
            mov x1,cx
            add cl,player1bulletSize
            adc cx,0
            mov x2,cx
            mov cx,player1bulletPosY
            mov y1,cx
            add cl,player1bulletSize
            adc cx,0
            mov y2,cx
            
            mov cx,[bx]
            mov x3,cx
            mov cx,[bx+2]
            mov x4,cx
            mov cx,[si]
            mov y3,cx
            mov cx,[si+2]
            mov y4,cx
            
            mov cx,player1bulletDirectionX
            mov deltaX1,cx
             
             
            mov cx,player1bulletDirectionY
            mov deltaY1,cx
            
            mov cx,0
            mov deltaX2,cx
            mov deltaY2,cx
            mov skipFrameEdge,0
             
            call  checkSkipFrame
            mov cx,skipFrameEdge
            
            cmp cx,1
            jz reflectOnXSkipping
            cmp cx,3
            jz reflectOnXSkipping
            cmp cx,2
            jz reflectOnYSkipping
            cmp cx,4
            jz reflectOnYSkipping
           
                add bx,4
                add si,4
                cmp [bx],ax 
                jz  endCheckBulletSkipFrame
                jmp  loopOnSkipping  
   
    
    
   
    endCheckBulletSkipFrame:                 
    pop si                 
    pop dx
    pop cx
    pop bx
    pop ax 
    popf 
    ret
    

          
    reflectOnXSkipping:
        ;mov al,9
        ;mov player1bulletColor,al 
        ;mov ax,player1bulletDirectionX
        ;neg ax
        ;mov player1bulletDirectionX,ax
        jmp endCheckBulletSkipFrame 
        
        
    reflectOnYSkipping:
        ;mov al,3
        ;mov player1bulletColor,al
        ;mov ax,[si+2] 
        ;mov player1bulletPosY,ax
        ;mov ax,player1bulletDirectionY
        ;neg ax
        ;mov player1bulletDirectionY,ax
        jmp endCheckBulletSkipFrame        
        
    
    
    
checkBulletSkipFrame endp

;add here

checkBulletPlayer1Collision proc near   
        push ax
        push cx
   
  
        ;initialize parameters
        mov cx,player1bulletPosX
        mov x1,cx
        add cl,player1bulletSize
        adc cx,0
        mov x2,cx
        mov cx,player1bulletPosY
        mov y1,cx
        add cl,player1bulletSize
        adc cx,0
        mov y2,cx
        
        mov cx,player2PosX
        mov x3,cx
        add cl,player2Width
        adc cx,0
        mov x4,cx
        mov cx,player2PosY
        mov y3,cx 
        add cl,player2Height
        adc cx,0
        mov y4,cx 
        call checkCollision
        
        mov cx,edgeOfCollision
        
            cmp cx,0
            jnz decreaseHealth2

        

  
        endcheckBulletPlayerCollision:
        pop cx
        pop ax
        ret
    
        decreaseHealth2:
        
        mov al,3
        cmp player1CurrentBullet,al
        jz reversePlayer2MoveForce  
        
        mov al,4
        cmp player1CurrentBullet,al
        jz stunPlayer2
         
        completeDecreaseHealth2:
        mov bl,1
        mov player1CurrentBullet,bl
          
        mov al,0
        mov player1IsThereBullet,al
        mov ax,health2
      
        sub ax, player1CurrentBulletDamge
          cmp ax,0
        jle player2Dead
        mov health2,ax
        jmp endcheckBulletPlayerCollision 
        
       
        
        player2Dead:
            mov al,1
            mov winner,al
            jmp endcheckBulletPlayerCollision
            
            
        reversePlayer2MoveForce:
            mov al,1
            mov player2Reversed ,al
            mov al,player2MoveForceX
            neg al
            mov player2MoveForceX,al
            
            mov al,player2MoveForceY
            neg al
            mov player2MoveForceY,al
            jmp completeDecreaseHealth2
         
        stunPlayer2:
            mov al,1
            mov player2Stunned,al
            jmp completeDecreaseHealth2   
            
          
        
    
    
checkBulletPlayer1Collision endp    


checkBulletPlayer2Collision proc near   
        push ax
        push cx
   
  
        ;initialize parameters
        mov cx,player2bulletPosX
        mov x1,cx
        add cl,player2bulletSize
        adc cx,0
        mov x2,cx
        mov cx,player2bulletPosY
        mov y1,cx
        add cl,player2bulletSize
        adc cx,0
        mov y2,cx
        
        
        mov cx,player1PosX
        mov x3,cx
        add cl,player1Width
        adc cx,0
        mov x4,cx
        mov cx,player1PosY
        mov y3,cx 
        add cl,player1Height
        adc cx,0
        mov y4,cx 
        call checkCollision
        
            mov cx,edgeOfCollision
        
                cmp cx,0
            jnz decreaseHealth1

        

  
        endcheckBulletPlayerCollision2:
        pop cx
        pop ax
        ret
    
        decreaseHealth1:
        mov al,3
        cmp player2CurrentBullet,al
        jz reversePlayer1MoveForce  
        
        mov al,4
        cmp player2CurrentBullet,al
        jz stunPlayer1
         
        completeDecreaseHealth1:
        
        mov bl,1
        mov player2CurrentBullet,bl  
        mov al,0
        mov player2IsThereBullet,al
        mov ax,health1
      
        sub ax, player2CurrentBulletDamge
        cmp ax,0
        jle player1Dead
        mov health1,ax
        jmp endcheckBulletPlayerCollision 
        
       
        
        player1Dead:
            mov al,2
            mov winner,al
            jmp endcheckBulletPlayerCollision2
            
            
        reversePlayer1MoveForce:
            mov al,1
            mov player1Reversed ,al
            mov al,player1MoveForceX
            neg al
            mov player1MoveForceX,al
            
            mov al,player1MoveForceY
            neg al
            mov player1MoveForceY,al
            jmp completeDecreaseHealth1
         
        stunPlayer1:
            mov al,1
            mov player1Stunned,al
            jmp completeDecreaseHealth1     
        
    
    
    
checkBulletPlayer2Collision endp  

;------------------------------------------Bullet Utilities------------------------------------------

;------------------------------------------Players Utilities------------------------------------------
drawRectangle proc near
    pusha
    mov al,rectangleColor
    mov ah,0ch
    
    mov dx,y1
    drawSlice:
    
    mov cx,x1
    
    drawPixel:
    int 10h
    inc cx
    cmp cx,x2
    jle drawPixel
    
    inc dx
    cmp dx,y2
    jle drawSlice 
    
    RectangleDrawn:
    popa
    ret
drawRectangle endp 


printAx proc near ; displays ax as string      
    mov bx,10; to divide by 10                       ;-----------------------------------------------------
    mov cx,0 ; use cx to count number of digits      ;-----------------------------------------------------
                                                     ;-----------------------------------------------------
    nextDigit:                                       ;-----------------------------------------------------
    mov dx,0                                         ;-----------------------------------------------------
    div bx    ; dl = first digit of ax               ;---------------Convert ax to a string-------------
    add dl,'0'; convert to ascii                     ;-----------------------------------------------------
                                                     ;--------(Stack used to correct the order)------
    push dx   ; save digit in stack                  ;-----------------------------------------------------
    inc cx                                           ;-----------------------------------------------------
                                                     ;-----------------------------------------------------
    cmp ax,0  ; stops when ax is empty               ;-----------------------------------------------------
    jne nextDigit                                    ;-----------------------------------------------------

    mov ah,2    ;-------------------------------------------------------  

    loop101:       
        pop dx      ;-----display digits -----------------------------------
        int 21h     ;-------------------------------------------------------
        dec cx      ;-------------------------------------------------------
        jnz loop101 ;-------------------------------------------------------    
        
    ;POPA
    ret
printAx endp

printHealth proc near
    
    ;move cursor
    mov ah,2
    mov dx,0000h
    int 10h
    
    lea dx,player1name
    mov ah,9
    int 21h
    
    mov ax,health1
    call printAx
    
    ;move cursor
    mov ah,2
    mov dx,001Ah
    int 10h
    
    lea dx,player2name
    mov ah,9
    int 21h
    
    mov ax,health2
    call printAx
    
    ret
printHealth endp

printScore proc near
    ;move cursor
    mov ah,2
    mov dx,0100h
    int 10h
    
    
    lea dx,score1text
    mov ah,9
    int 21h
    
    mov ax,score1
    call printAx
    
    ;move cursor
    mov ah,2
    mov dx,011Ah
    int 10h
    
    lea dx,score2text
    mov ah,9
    int 21h
    
    mov ax,score2
    call printAx
    
    ret
printScore endp


drawPlayer proc near

    push ax
    push bx
    push cx
    push dx
    push si 
    
    
    ;draw head  at posX,posY

    mov bl,0
    mov bh,0  
    mov al,headColor ;Pixel color 
    mov ah,0ch ;Draw Pixel Command 
    mov dx,posY
    drawHeadOuter:
        mov cx,posx
       
        mov bl,0
        drawHeadInner:  
            int 10h
            inc cx
            inc bl
            cmp bl,widthy
            jnz drawHeadInner
        inc bh
        inc dx
        cmp bh,height
        jnz drawHeadOuter
        
    ;draw eye
    mov bl,0
    mov bh,0  
    mov al,eyeColor ;Pixel color 
    mov ah,0ch ;Draw Pixel Command 
    mov dx,posY
    add dl,heightDiv4
    drawEyeOuter:
        mov cx,posX
        add cl,widthDiv2
        mov bl,0
        drawEyeInner:  
            int 10h
            inc cx
            inc bl
            cmp bl,eyeSize
            jnz drawEyeInner
        inc bh
        inc dx
        cmp bh,eyeSize
        jnz drawEyeOuter
        
    ; draw neck

    mov ax,posX
    add al,widthDiv4
    adc ax,0
    mov dx,posY
    add dl,height
    adc dx,0
    
    mov si,ax
    mov bl,0
    mov bh,0  
    mov al,headColor ;Pixel color 
    mov ah,0ch ;Draw Pixel Command 
    drawNeckOuter:
        mov cx,si
        mov bl,0
        drawNeckInner:  
            int 10h
            inc cx
            inc bl
            cmp bl,widthDiv2
            jnz drawNeckInner
        inc bh
        inc dx
        cmp bh,heightDiv2
        jnz drawNeckOuter

    ;draw torso

          
    
    
   
    mov bl,0
    mov bh,0  
    mov al,torsoColor ;Pixel color 
    mov ah,0ch ;Draw Pixel Command 
    drawTorsoOuter:
        mov cx,posX
        mov bl,0
        drawTorsoInner:  
            int 10h
            inc cx
            inc bl
            cmp bl,widthy
            jnz drawTorsoInner
        inc bh
        inc dx
        cmp bh,height3
        jnz drawTorsoOuter


    ;draw leg

    mov bl,0
    mov bh,0  
    mov al,legColor ;Pixel color 
    mov ah,0ch ;Draw Pixel Command 
    drawLegOuter:
        mov cx,posX
        mov bl,0
        drawLegInner:  
            int 10h
            inc cx
            inc bl
            cmp bl,widthDiv2
            jnz drawLegInner
        inc bh
        inc dx
        cmp bh,height3
        jnz drawLegOuter
        
    ;draw show

    mov bl,0
    mov bh,0  
    mov al,shoeColor ;Pixel color 
    mov ah,0ch ;Draw Pixel Command 
    drawShoeOuter:
        mov cx,posX
        mov bl,0
        drawShoeInner:  
            int 10h
            inc cx
            inc bl
            cmp bl,widthy
            jnz drawShoeInner
        inc bh
        inc dx
        cmp bh,heightDiv2
        jnz drawShoeOuter




    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret   
drawPlayer endp

checkPlayersCollision proc near
     
     pusha
      
     mov cx,player1PosX
     mov x1,cx  
     add cl,player1Width
     adc ch,0
     mov x2,cx
     mov cx,player1PosY
     mov y1,cx
     add cl,player1Height
     adc ch,0
     mov y2,cx
     
     
     mov cx,player2PosX
     mov x3,cx  
     add cl,player2Width
     adc ch,0
     mov x4,cx
     mov cx,player2PosY
     mov y3,cx
     add cl,player2Height
     adc ch,0
     mov y4,cx
     
     
     call checkCollision
     mov cx,edgeOfCollision
     
     cmp cx,1
     jz stayRightPlayer
     ;cmp cx,5
     ;jz stayRightPlayer
     ;cmp cx,6
     ;jz stayRightPlayer
     
     ;cmp cx,7
     ;jz stayRightPlayer
      cmp cx,3
     jz stayRightPlayer
     ; cmp cx,8
     ;jz stayRightPlayer
     
     
     cmp cx,2
     jz stayDownPlayer
     
     cmp cx,4
     jz stayUpPlayer
     
     
     
     endCheckPlayersCollision: 
     
     
     popa
     ret
     
     stayLeftPlayer:
        ;mov cx,x3
        ;add cl,player1Width
        ;adc ch,0
        ;mov player1PosX,cx
        ;mov ax,player1DeltaX
        ;neg ax
        ;mov player1DeltaX,ax
        ;mov ax,player2DeltaX
        ;neg ax
        ;mov player2DeltaX,ax
        jmp endCheckPlayersCollision 
        
        
     stayRightPlayer:
        ;mov al,player1ForceX
        ;neg al
        ;mov player1ForceX,al
        ;mov al,player2ForceX
        ;neg al
        ;mov player2ForceX,al
        ;mov cx,x4
        ;mov player1PosX,cx
        ;mov al,player1AccX
        ;neg al
        ;mov player1AccX,al 
        ;mov al,player2AccX
       ; neg al
        ;mov player2AccX,al
        jmp endCheckPlayersCollision
                                     
                                     
    stayDownPlayer:
        ;mov ax,player1DeltaY
        ;neg ax
        ;mov player1DeltaY,ax
       ; mov ax,player2DeltaY
       ; neg ax
       ;mov player2DeltaY,ax
        ;mov cx,y4
        ;mov player1PosY,cx
        jmp endCheckPlayersCollision
        
                                        
    stayUpPlayer: 
        ;mov al,player1AccY
        ;neg al
        ;mov player1AccY,al 
        ;mov al,player2AccY
        ;neg al        
        ;mov player2AccY,al
        ;mov ax,player1DeltaY
       ; neg ax
        ;mov player1DeltaY,ax
       ; mov ax,player2DeltaY
        ;neg ax
        ;mov player2DeltaY,ax
        ;mov cx,y3
        ;sub cl,player1Height
        ;sbb ch,0
        
        ;mov player1PosY,cx
        jmp endCheckPlayersCollision
    
checkPlayersCollision endp

;------------------------------------------Players Utilities------------------------------------------

;-------------------------------------------Collectibles functions-------------------------------------

checkSpawnRoofCollectible proc near ;spawn collectible every 15 seconds
    pusha
    mov al,isThereRoofCollectible
  
    mov al,1
    cmp isThereRoofCollectible,al
    jz endCheckRoofCollectible
    mov ah,2ch
    int 21h

    
    cmp dh,30
    jz _spawnRoofCollectible
     cmp dh,15
    jz _spawnRoofCollectible
     cmp dh,45
    jz _spawnRoofCollectible
     cmp dh,0
    jz _spawnRoofCollectible 
    ;jmp _spawnRoofCollectible

    endCheckRoofCollectible:
    popa
    ret

    _spawnRoofCollectible:
    mov al,1
    mov isThereRoofCollectible,al
    call spawnRoofCollectible
    jmp endCheckRoofCollectible

checkSpawnRoofCollectible endp

spawnRoofCollectible proc near
    pusha
    mov ah,0
    int 1Ah

    mov bx,dx ; save dx value for later use

    mov cx,gamewidth
    sub cx,40
    mov ax,dx
    mov dx,0
    DIV cx   
    
    add dx,20
    mov roofCollectiblePosX,dx
    mov ax,0
    mov roofCollectiblePosY,ax
    
     mov al,bl
     mov cl,5
     mov ah,0
     div cl

     ;mov al,ah
    ;add al,30h
    ;mov ah, 0eh
    ;int 10h
    add al,1
    cmp al,1
    jz addOneToType
    completeMovingType:
    mov roofCollectibleType,ah

    ;mov al,2
    ;mov roofCollectibleType,al

    popa
    ret
    addOneToType:
        add al,1
        jmp completeMovingType
spawnRoofCollectible endp

updateRoofCollectible proc near 
    PUSHA
    mov al,0
    cmp isThereRoofCollectible,al
    jz endupdateRoofCollectible

    mov ax,roofCollectiblePosY
    add ax,roofCollectibleSpeed
    mov roofCollectiblePosY,ax

    call roofCollectbleCollision
    call drawRoofCollectible

    endupdateRoofCollectible:
    popa
    ret
updateRoofCollectible endp


drawRoofCollectible proc near
    pusha
    mov ax,roofCollectiblePosX
    mov x1,ax
    add ax,roofCollectibleSize
    mov x2,ax
    mov ax,roofCollectiblePosY
    mov y1,ax
    add ax,roofCollectibleSize
    mov y2,ax
    mov al,RoofCollectibleColor
    mov rectangleColor,al
    call drawRectangle
    popa
    ret
drawRoofCollectible endp

roofCollectbleCollision proc near
    PUSHA
    call roofCollectiblePlayer1Collision
    call roofCollectiblePlayer2Collision
    call roofCollectbleCollisionPlatform
    call checkRoofCollectibleEdge
    popa
    ret
roofCollectbleCollision endp

roofCollectbleCollisionPlatform proc near
            PUSHA
            lea bx,platformsX
            lea si,platformsY
            lea di,platformExist
            mov cx,roofCollectiblePosX
            mov x1,cx
            add cx,roofCollectibleSize
            
            mov x2,cx
            mov cx,roofCollectiblePosY
            mov y1,cx
            add cx,roofCollectibleSize
            mov y2,cx
    loopOnPlatformsRoof: 
            mov al,0
            cmp [di],al
            jz  completeLoopingPlatformRoof
            checkPlatFormRoof:
            ;initialize parameters
            mov cx,[bx]
            mov x3,cx
            mov cx,[bx+2]
            mov x4,cx
            mov cx,[si]
            mov y3,cx
            mov cx,[si+2]
            mov y4,cx
            
            call  checkCollision
            mov cx,edgeOfCollision
            ; mov al,cl
            ; add al,30h
            ; mov ah, 0eh
            ; int 10h
           cmp cx,5
           jz stayOnEdgeRoof
           cmp cx,4
           jz stayOnEdgeRoof
           cmp cx,7
           jz stayOnEdgeRoof
            completeLoopingPlatformRoof: 
                add di,1
                add bx,4
                add si,4
                mov ax,'#' 
                cmp [bx],ax 
                jnz loopOnPlatformsRoof     

    endroofCollectbleCollisionPlatform:
    popa
    ret
    stayOnEdgeRoof:
    mov ax,[si]
    sub ax,roofCollectibleSize
    mov roofCollectiblePosY,ax
    jmp endroofCollectbleCollisionPlatform

roofCollectbleCollisionPlatform endp

checkRoofCollectibleEdge proc near
       ; to keep the values of the registers
    pushf 
    push ax
    push cx

    mov cx,roofCollectiblePosY
    add cx,roofCollectibleSize
    cmp cx,gameHeight
    jge StickRoofCollectible
      
    endCheckRoofCollectibleEdge: 
    pop cx
    pop ax     
    popf 
    ret
    
    StickRoofCollectible: 
        mov ax,gameHeight
        sub ax,roofCollectibleSize
        mov roofCollectiblePosY,ax
     
        jmp endCheckRoofCollectibleEdge 
    
checkRoofCollectibleEdge endp

roofCollectiblePlayer1Collision proc near

    pusha
    ;initialize parameters
        mov cx,roofCollectiblePosX
        mov x1,cx
        add cx,roofCollectibleSize

        mov x2,cx
        mov cx,roofCollectiblePosY
        mov y1,cx
        add cx,roofCollectibleSize
        mov y2,cx
        
        mov cx,player1PosX
        mov x3,cx
        add cl,player1Width
        adc cx,0
        mov x4,cx
        mov cx,player1PosY
        mov y3,cx 
        add cl,player1Height
        adc cx,0
        mov y4,cx 
        call checkCollision
        
        mov cx,edgeOfCollision
        cmp cx,0
        jnz player1GetRoofCollectible

    endroofCollectiblePlayer1Collision:
    popa
    ret

    player1GetRoofCollectible:
    mov cl,roofCollectibleType
    mov player1CurrentBullet,cl
    mov al,0
    mov isThereRoofCollectible,0
    jmp endroofCollectiblePlayer1Collision


roofCollectiblePlayer1Collision endp

roofCollectiblePlayer2Collision proc near

    pusha
    ;initialize parameters
        mov cx,roofCollectiblePosX
        mov x1,cx
        add cx,roofCollectibleSize

        mov x2,cx
        mov cx,roofCollectiblePosY
        mov y1,cx
        add cx,roofCollectibleSize
        mov y2,cx
        
        mov cx,player2PosX
        mov x3,cx
        add cl,player2Width
        adc cx,0
        mov x4,cx
        mov cx,player2PosY
        mov y3,cx 
        add cl,player2Height
        adc cx,0
        mov y4,cx 
        call checkCollision
        
        mov cx,edgeOfCollision
        cmp cx,0
        jnz player2GetRoofCollectible

    endroofCollectiblePlayer2Collision:
    popa
    ret

    player2GetRoofCollectible:
    mov cl,roofCollectibleType
    mov player2CurrentBullet,cl
    mov al,0
    mov isThereRoofCollectible,0
    jmp endroofCollectiblePlayer2Collision
roofCollectiblePlayer2Collision endp
;-------------------------------------------Collectibles functions-------------------------------------

;---------------------------------------------Levels' background and loading coordinates in global array------------------
loadplatformslvl1 proc near
    pusha
    mov cx,platforms1size
    add cx,platforms1size
    lea si,platforms1X
    lea bx,platformsX
    populateplatforms1x:
        mov ax,[si]
        mov [bx],ax
        inc si
        inc si
        inc bx
        inc bx
    loop populateplatforms1x
    
    mov cx,platforms1size
    add cx,platforms1size
    lea si,platforms1Y
    lea bx,platformsY
    populateplatforms1y:
        mov ax,[si]
        mov [bx],ax
        inc si
        inc si
        inc bx
        inc bx
    loop populateplatforms1y
                    
    mov al,platform1Color
    mov platformColor,al
    popa
    ret
loadplatformslvl1 endp

level1BG proc near
    pusha
    mov ax,0
    mov x1,ax
    mov ax,gameWidth
    mov x2,ax
    mov ax,0
    mov y1,ax
    mov ax,gameHeight
    sub ax,50
    mov y2,ax
    mov al,skyColor
    mov rectangleColor,al
    ;draw sky
    call drawRectangle
    ; draw grass
    mov ax,y2
    mov y1,ax
    mov ax,gameHeight
    mov y2,ax
    mov al,grassColor

    mov rectangleColor,al
    call drawRectangle

    popa
    ret
level1BG endp

loadplatformslvl2 proc near
    pusha
    
    mov cx,platforms2size
    add cx,platforms2size
    lea si,platforms2X
    lea bx,platformsX
    populateplatforms2x:
        mov ax,[si]
        mov [bx],ax
        inc si
        inc si
        inc bx
        inc bx
    loop populateplatforms2x
    
    mov cx,platforms2size
    add cx,platforms2size
    lea si,platforms2Y
    lea bx,platformsY
    populateplatforms2y:
        mov ax,[si]
        mov [bx],ax
        inc si
        inc si
        inc bx
        inc bx
    loop populateplatforms2y
    
    mov al,platform2Color
    mov platformColor,al

    popa
    ret
loadplatformslvl2 endp

level2BG proc near
    pusha

    mov ax,0
    mov x1,ax
    mov ax,gameWidth
    mov x2,ax
    mov ax,0
    mov y1,ax
    mov ax,gameHeight
    sub ax,50
    mov y2,ax
    mov al,skyColor
    mov rectangleColor,al
    ;draw sky
    call drawRectangle
    ; draw grass
    mov ax,y2
    mov y1,ax
    mov ax,gameHeight
    mov y2,ax
    mov al,sandColor

    mov rectangleColor,al
    call drawRectangle
    popa
    ret
level2BG endp

loadplatformslvl3 proc near
    pusha
    
    mov cx,platforms3size
    add cx,platforms3size
    lea si,platforms3X
    lea bx,platformsX
    populateplatforms3x:
        mov ax,[si]
        mov [bx],ax
        inc si
        inc si
        inc bx
        inc bx
    loop populateplatforms3x
    
    mov cx,platforms3size
    add cx,platforms3size
    lea si,platforms3Y
    lea bx,platformsY
    populateplatforms3y:
        mov ax,[si]
        mov [bx],ax
        inc si
        inc si
        inc bx
        inc bx
    loop populateplatforms3y
    
    mov al,platform3Color
    mov platformColor,al

    popa
    ret
loadplatformslvl3 endp

level3BG proc near
    pusha
     
    mov ax,0
    mov x1,ax
    mov ax,gameWidth
    mov x2,ax
    mov ax,0
    mov y1,ax
    mov ax,gameHeight
    sub ax,50
    mov y2,ax
    mov al,hellColor
    mov rectangleColor,al
    ;draw sky
    call drawRectangle
    ; draw grass
    mov ax,y2
    mov y1,ax
    mov ax,gameHeight
    mov y2,ax
    mov al,stoneColor

    mov rectangleColor,al
    call drawRectangle
    popa
    ret
level3BG endp
;---------------------------------------------Levels' background and loading coordinates in global array------------------
drawPlayerMirror proc near
    ; to keep the values of the registers   
    pushf
    push ax
    push bx
    push cx
    push dx     
   ;draw head

    mov bl,0
    mov bh,0  
    mov al,headColor ;Pixel color 
    mov ah,0ch ;Draw Pixel Command 
    mov dx,posY
    drawHeadOuter3:
        mov cx,posx
       
        mov bl,0
        
        drawHeadInner3:  
            int 10h
            inc cx
            inc bl
            cmp bl,widthy
            jnz drawHeadInner3
        inc bh
        inc dx
        cmp bh,height
        jnz drawHeadOuter3
        
    ;draw eye
    mov bl,0
    mov bh,0  
    mov al,eyeColor ;Pixel color 
    mov ah,0ch ;Draw Pixel Command 
    mov dx,posY
    add dl,heightDiv4
    drawEyeOuter3:
        mov cx,posX
        add cl,widthDiv4
        mov bl,0
        drawEyeInner3:  
            int 10h
            inc cx
            inc bl
            cmp bl,eyeSize
            jnz drawEyeInner3
        inc bh
        inc dx
        cmp bh,eyeSize
        jnz drawEyeOuter3
        
    ; draw neck

    mov ax,posX
    add al,widthDiv4
    adc ax,0
    mov dx,posY
    add dl,height
    adc dx,0
    
    mov si,ax
    mov bl,0
    mov bh,0  
    mov al,headColor ;Pixel color 
    mov ah,0ch ;Draw Pixel Command 
    drawNeckOuter3:
        mov cx,si
        mov bl,0
        drawNeckInner3:  
            int 10h
            inc cx
            inc bl
            cmp bl,widthDiv2
            jnz drawNeckInner3
        inc bh
        inc dx
        cmp bh,heightDiv2
        jnz drawNeckOuter3

    ;draw torso   
    mov bl,0
    mov bh,0  
    mov al,torsoColor ;Pixel color 
    mov ah,0ch ;Draw Pixel Command 
    drawTorsoOuter3:
        mov cx,posX
        mov bl,0
        drawTorsoInner3:  
            int 10h
            inc cx
            inc bl
            cmp bl,widthy
            jnz drawTorsoInner3
        inc bh
        inc dx
        cmp bh,height3
        jnz drawTorsoOuter3


    ;draw leg

    mov bl,0
    mov bh,0  
    mov al,legColor ;Pixel color 
    mov ah,0ch ;Draw Pixel Command 
    drawLegOuter3:
        mov cx,posX
        add cl,widthDiv2
        adc ch,0
        mov bl,0
        drawLegInner3:  
            int 10h
            inc cx
            inc bl
            cmp bl,widthDiv2
            jnz drawLegInner3
        inc bh
        inc dx
        cmp bh,height3
        jnz drawLegOuter3
        
    ;draw shoe

    mov bl,0
    mov bh,0  
    mov al,shoeColor ;Pixel color 
    mov ah,0ch ;Draw Pixel Command 
    drawShoeOuter3:
        mov cx,posX
      
        mov bl,0
        drawShoeInner3:  
            int 10h
            inc cx
            inc bl
            cmp bl,widthy
            jnz drawShoeInner3
        inc bh
        inc dx
        cmp bh,heightDiv2
        jnz drawShoeOuter3

    
    
    
    
    enddrawPlayerMirror:
    pop dx
    pop cx
    pop bx
    pop ax 
    popf
    ret 



drawPlayerMirror endp

;--------------------------------------------------IN GAME CHAT-----------------------------------------------

;------------------------- IN GAME CHAT ----------------------
;------------------------- IN GAME CHAT ----------------------
;------------------------- IN GAME CHAT ----------------------
;------------------------- IN GAME CHAT ----------------------



initGameChat proc near
    pusha
    
    lea ax,MessageToSend
    mov MessageToSendIndex,ax
    lea ax,MessageToReceive
    mov MessageToReceiveIndex,ax

    mov ah,6       ; function 6
    mov al,0       ; scroll by 1 line    
    mov bh,0FFh     ; normal video attribute         
    mov cx,ChatOrigin
    mov dx,ChatOrigin
    add dh,6
    add dl,80 
    int 10h
    
    mov bh,0
    mov ah,2
    mov dx,ChatOrigin
    int 10h
    
    lea dx,seperator
    mov ah,9
    int 21h
    
    mov bh,0
    mov ah,2
    mov dx,ChatOrigin
    add dh,4
    int 10h
    
    lea dx,seperator
    mov ah,9
    int 21h
    
    mov bh,0
    mov ah,2
    mov dx,ChatOrigin
    add dh,3
    int 10h

    lea dx,typehere
    mov ah,9
    int 21h
    

    mov bh,0
    mov ah,2
    mov dx,ChatOrigin
    add dh,5
    int 10h
    
    lea dx,ToEndGameWith
    mov ah,9
    int 21h
    
    lea dx,player2name
    mov ah,9
    int 21h
    
    lea dx,pressESC
    mov ah,9
    int 21h
    


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
     
    popa
    ret
    initGameChat endp

updateChatCursor MACRO
    pusha
    mov ah,3h
    int 10h
    mov chatCursor,dx
    popa
ENDM updateChatCursor

scrollChat MACRO 
   pusha  
   
   mov ah,6       ; function 6
   mov al,1       ; scroll by 1 line    
   mov bh,0FFh     ; normal video attribute    
   mov cx,ChatOrigin
   add ch,1
   mov dx,ChatOrigin
   add dh,2
   add dl,80 
   int 10h
   
       
   popa     
ENDM scrollChat

clearTypingArea proc near 
   pusha  
   
   mov ah,6       ; function 6
   mov al,0       ; clear ;scroll by 1 line    
   mov bh,0FFh     ; normal video attribute         
   mov cx,ChatOrigin
   add ch,3
   add cl,0
   mov dx,ChatOrigin
   add dh,3
   add dl,80 
   int 10h
   
   mov bh,0
   mov ah,2
   mov dx,ChatOrigin
   add dh,4
   int 10h
   
   lea dx,seperator
   mov ah,9
   int 21h

   mov bh,0
   mov ah,2
   mov dx,ChatOrigin
   add dh,3
   int 10h     

   lea dx,typehere
   mov ah,9
   int 21h
   
   mov bh,0
   mov ah,2
   mov dx,ChatOrigin
   add dh,5
   int 10h
   
   lea dx,ToEndGameWith
   mov ah,9
   int 21h
   
   lea dx,player2name
   mov ah,9
   int 21h
   
   lea dx,pressESC
   mov ah,9
   int 21h

    
   mov ax,ChatOrigin        ;----------- returns the cursor to initial position -------------
   add ah,3                 ;----------- returns the cursor to initial position -------------
   add al,1                 ;----------- returns the cursor to initial position -------------
   mov chatCursor,ax        ;----------- returns the cursor to initial position -------------

   lea si,blankString          ;------------ fills MessageToSend with $$$ again -----------
   lea di,MessageToSend        ;------------ fills MessageToSend with $$$ again -----------
   mov cx,100                  ;------------ fills MessageToSend with $$$ again -----------
   rep movsb                   ;------------ fills MessageToSend with $$$ again -----------

   lea di,MessageToSend        ;-------------- sets the index back to first character -----------
   mov MessageToSendIndex,di   ;-------------- sets the index back to first character -----------




   popa     
clearTypingArea endp

InGameChat proc near
    pusha   
    
    cmp chat1Active,1
    jne DoneSending

    mov ah,1                                 ;--------- checks for Input -----------
    int 16h                                  ;--------- checks for Input -----------
    jz DoneSending                           ;--------- checks for Input -----------


    mov ah,0                                    ;--------- Consumes Input -----------
    int 16h                                     ;--------- Consumes Input -----------
    mov bl,al ; bl holds the input character    ;--------- Consumes Input -----------
    
    ;case key is ENTER
    cmp bl,13
    je displaySent
    
    ;case key is backspace
    cmp bl,8
    je caseBackspace
    
    ;else
    ProcessInputChar:
    
    mov di,MessageToSendIndex
    lea dx,MessageToSend
    sub di,dx
    cmp di,90
    jae DoneSending

        mov dx,chatCursor   ;------- check if cursor reached max distance ------------
    cmp dx,161Ah        ;------- check if cursor reached max distance ------------
    jae DoneSending  ;------- check if cursor reached max distance ------------                                                          
    mov ah,2            ;------------ sets cursor ------------
    int 10h             ;------------ sets cursor ------------

    mov di,MessageToSendIndex          ;--------------- stores the input character in the MessageToSend variable ---------------
    mov [di],bl                        ;--------------- stores the input character in the MessageToSend variable ---------------
    inc di                             ;--------------- stores the input character in the MessageToSend variable ---------------
    mov MessageToSendIndex,di          ;--------------- stores the input character in the MessageToSend variable ---------------



    mov ah,2            ;------ displays the input character----------
    mov dl,bl           ;------ displays the input character----------
    int 21h             ;------ displays the input character----------

    updateChatCursor

    ;Check that Transmitter Holding Register is Empty        ;---------- sends the input character----------
	mov dx , 3FDH		; Line Status Register               ;---------- sends the input character----------
     AGAIN:  	In al , dx 			;Read Line Status        ;---------- sends the input character----------
  	test al , 00100000b                                      ;---------- sends the input character----------
  	JZ AGAIN                               ;Not empty        ;---------- sends the input character----------
                                                             ;---------- sends the input character----------
    ;If empty put the VALUE in Transmit data register        ;---------- sends the input character----------
  	mov dx , 3F8H		; Transmit data register             ;---------- sends the input character----------
  	mov  al,bl                                               ;---------- sends the input character----------
  	out dx , al                                              ;---------- sends the input character----------

    jmp DoneSending

    ;----------------------- CASE BACKSPACE -----------------------------
    ;----------------------- CASE BACKSPACE -----------------------------
    ;----------------------- CASE BACKSPACE -----------------------------
    ;----------------------- CASE BACKSPACE -----------------------------
    caseBackspace:

    mov dx,chatCursor   ;------- check if cursor reached max distance ------------
    cmp dx,1601h        ;------- check if cursor reached max distance ------------
    jbe DoneSending  ;------- check if cursor reached max distance ------------ 

    mov di,MessageToSendIndex
    mov cl,8          ;---------------store backspace  ---------------
    mov [di],cl                       ;--------------- store backspace ---------------
    inc di   
    mov ch,32                          ;---------------store backspace  ---------------
    mov [di],ch
    inc di
    mov [di],cl
    inc di
    mov MessageToSendIndex,di          



    mov bh,0
    mov ah,2            ;------------ sets cursor ------------
    int 10h             ;------------ sets cursor ------------

    mov ah,2            ;------display backspace ----------
    mov dl,8           ;------ display backspace ---------
    int 21h             ;------display backspace ----------

    mov ah,2            ;------display backspace ----------
    mov dl,32           ;------ display backspace ---------
    int 21h             ;------display backspace ----------

    mov ah,2            ;------display backspace ----------
    mov dl,8           ;------ display backspace ---------
    int 21h             ;------display backspace ----------

    updateChatCursor

    ;Check that Transmitter Holding Register is Empty        ;---------- sends the input character----------
	mov dx , 3FDH		; Line Status Register               ;---------- sends the input character----------
     AGAIN3:  	In al , dx 			;Read Line Status        ;---------- sends the input character----------
  	test al , 00100000b                                      ;---------- sends the input character----------
  	JZ AGAIN3                               ;Not empty        ;---------- sends the input character----------
                                                             ;---------- sends the input character----------
    ;If empty put the VALUE in Transmit data register        ;---------- sends the input character----------
  	mov dx , 3F8H		; Transmit data register             ;---------- sends the input character----------
  	mov  al,8                                               ;---------- sends the input character----------
  	out dx , al                                              ;---------- sends the input character----------


    jmp DoneSending
    ;----------------------- CASE BACKSPACE -----------------------------
    ;----------------------- CASE BACKSPACE -----------------------------
    ;----------------------- CASE BACKSPACE -----------------------------
    ;----------------------- CASE BACKSPACE -----------------------------



    displaySent:
    call DisplaySentMessage
    
    ;Check that Transmitter Holding Register is Empty        ;---------- sends ENTER----------
	mov dx , 3FDH		; Line Status Register               ;---------- sends ENTER----------
     AGAIN2:  	In al , dx 			;Read Line Status        ;---------- sends ENTER----------
  	test al , 00100000b                                      ;---------- sends ENTER----------
  	JZ AGAIN2                               ;Not empty       ;---------- sends ENTER----------
                                                             ;---------- sends ENTER----------
    ;If empty put the VALUE in Transmit data register        ;---------- sends ENTER----------
  	mov dx , 3F8H		; Transmit data register             ;---------- sends ENTER----------
  	mov  al,13                                               ;---------- sends ENTER----------
  	out dx , al                                              ;---------- sends ENTER----------
    
    call clearTypingArea

    jmp DoneSending

   
    ;scroll:
    ;scrollChat
    
    DoneSending:
    cmp chat2Active,1
    jne InGameChatDone
    startReceiving:
    ;Check that Data is Ready                                ;------ receive character ----------       
	mov dx , 3FDH		; Line Status Register               ;------ receive character ----------
	in al , dx                                               ;------ receive character ----------
  	test al , 1                                              ;------ receive character ----------
  	JZ InGameChatDone         ;Not Ready                     ;------ receive character ----------
    ;If Ready read the VALUE in Receive data register        ;------ receive character ----------
  	mov dx , 03F8H                                           ;------ receive character ----------
  	in al , dx                                               ;------ receive character ----------

    cmp al,13
    je displayReceived

    mov di,MessageToReceiveIndex          ;--------------- stores the received character in the MessageToReceive variable ---------------
    mov [di],al                           ;--------------- stores the received character in the MessageToReceive variable ---------------
    inc di                                ;--------------- stores the received character in the MessageToReceive variable ---------------
    mov MessageToReceiveIndex,di          ;--------------- stores the received character in the MessageToReceive variable ---------------
    jmp InGameChatDone

    displayReceived:
    call DisplayReceivedMessage
    lea di,MessageToReceive
    mov MessageToReceiveIndex,di

    InGameChatDone:
    popa
    ret
    InGameChat endp

DisplaySentMessage proc near
pusha
scrollChat

mov dx,ChatOrigin
add dh,2   
mov ah, 2      ;------- move cursor -------  
int 10h        ;------- move cursor ------- 

lea dx,player1name
mov ah,9
int 21h

lea dx,MessageToSend
mov ah,9
int 21h

mov chat1Active,0

popa
ret
DisplaySentMessage endp

DisplayReceivedMessage proc near
pusha

mov al,MessageToReceive
cmp al,'$'
je noMessage

scrollChat

mov dx,ChatOrigin    ;------- move cursor -------
add dh,2             ;------- move cursor ------- 
mov ah, 2            ;------- move cursor -------  
int 10h              ;------- move cursor ------- 

lea dx,player2name
mov ah,9
int 21h

;lea dx,MessageToReceive
;mov ah,9
;int 21h
lea di,MessageToReceive
nextChar:
mov dl,[di]
cmp dl,'$'
je endofMessage
cmp dl,8
je backspaceReceived
mov ah,2
int 21h
inc di
jmp nextChar

backspaceReceived:
mov ah,2
mov dl,8
int 21h
mov dl,32
int 21h
mov dl,8
int 21h
inc di
jmp nextChar
endofMessage:

lea si,blankString          ;------------ fills MessageToReceive with $$$ again -----------
lea di,MessageToReceive     ;------------ fills MessageToReceive with $$$ again -----------
mov cx,100                  ;------------ fills MessageToReceive with $$$ again -----------
rep movsb                   ;------------ fills MessageToReceive with $$$ again -----------

mov chat2Active,0

noMessage:
popa
ret
DisplayReceivedMessage endp

;sendMessage proc near
;pusha
;
;lea bx,MessageToSend
;
;
;Transmit:
;mov al,[bx]
;cmp al,'$'
;je endSend
;
;;Check that Transmitter Holding Register is Empty     ;----- communication code -----
;mov dx , 3FDH		; Line Status Register            ;----- communication code -----
;AGAIN:  	In al , dx 			;Read Line Status     ;----- communication code -----
;test al , 00100000b                                   ;----- communication code -----
;JZ AGAIN                               ;Not empty     ;----- communication code -----
;                                                      ;----- communication code -----
;;If empty put the VALUE in Transmit data register     ;----- communication code -----
;mov dx , 3F8H		; Transmit data register          ;----- communication code -----
;mov  al,[bx]                                          ;----- communication code -----
;out dx , al                                           ;----- communication code -----
;inc bx
;
;jmp Transmit
;
;endSend:
;
;;Check that Transmitter Holding Register is Empty     ;----- communication code -----
;mov dx , 3FDH		; Line Status Register            ;----- communication code -----
;AGAIN1:  	In al , dx 			;Read Line Status     ;----- communication code -----
;test al , 00100000b                                   ;----- communication code -----
;JZ AGAIN1                               ;Not empty    ;----- communication code -----
;                                                      ;----- communication code -----
;;If empty put the VALUE in Transmit data register     ;----- communication code -----
;mov dx , 3F8H		; Transmit data register          ;----- communication code -----
;mov  al,'$'                                           ;----- communication code -----
;out dx , al                                           ;----- communication code -----
;
;popa
;ret
;sendMessage endp

;receiveMessage proc near
;pusha
;
;receive:
;    mov bx,MessageToReceiveIndex
;;Check that Data is Ready
;	mov dx , 3FDH		; Line Status Register
;	in al , dx 
;  	test al , 1
;  	JZ endReceive                                  ;Not Ready
;;If Ready read the VALUE in Receive data register
;  	mov dx , 03F8H
;  	in al , dx 
;
;    cmp al,'$'
;    je messageComplete
;
;    mov [bx],al
;    inc MessageToReceiveIndex
;    jmp receive
;
;    messageComplete:
;    call DisplayReceivedMessage
;
;    ;resetting the index
;    lea bx,MessageToReceive
;    mov MessageToReceiveIndex,bx
;
;    endReceive:
; 
;popa
;ret
;receiveMessage endp




DisplayEndGame proc near

pusha

mov ax,gamewidth
mov dx,0
mov bx,5
div bx

mov x1,ax

mov bx,4
mul bx

mov x2,ax


mov ax,gameHeight
mov dx,0
mov bx,5
div bx

mov y1,ax

mov bx,4
mul bx

mov y2,ax



mov al,1
mov RectangleColor,al

call drawRectangle

;move cursor
mov ah,2
mov dl,16
mov dh,7
int 10h

mov al,1
mov bl,2
cmp winner,al
je player1won

cmp winner,bl
je player2won

jmp EndGameEnd



player1won:
lea dx,victorytext
mov ah,9
int 21h

;move cursor
mov ah,2
mov dl,14
mov dh,9
int 10h

lea dx,player1name
mov ah,9
int 21h

lea dx,wonText
mov ah,9
int 21h

jmp EndGameEnd


player2won:

lea dx,defeattext
mov ah,9
int 21h

;move cursor
mov ah,2
mov dl,14
mov dh,9
int 10h

lea dx,player2name
mov ah,9
int 21h

lea dx,wonText
mov ah,9
int 21h

jmp EndGameEnd




EndGameEnd:
popa
ret
DisplayEndGame endp
;--------------------------------------------------IN GAME CHAT-----------------------------------------------

sendByte proc near
PUSHA
 ;Clear buffer
    MOV AH,0CH
    MOV AL,0
    INT 21H
    MOV DX,3FDH
        _sendByte:   
        IN AL,DX
        AND AL,00100000B
        JZ _sendByte                    
       
        MOV DX,3F8H  
        MOV AL,byteToSend
        OUT DX,AL 
;***********************************************
;  mov al,0
;     waitRecieve:
;     MOV DX,3FDH
;     IN AL,DX
;     test AL,1 
;     jz waitRecieve

popa
ret
sendByte endp

receiveByte proc near
pusha
    MOV DX,3FDH
    IN AL,DX
    test AL,1 
    JZ endReceive

    MOV DX,3F8H
    IN AL,DX
    MOV byteToReceive, AL
    jmp endd
;*************************************************************
    ;  _sendByte1:   
    ; IN AL,DX
    ;  AND AL,00100000B
    ; JZ _sendByte1  

    ; mov al,1
    ; MOV DX,3F8H  
    ; MOV AL,byteToSend
    ; OUT DX,AL 
    ; jmp endd
;*************************************************************
    endReceive:
    mov al,0
    mov byteToReceive,al
    endd:
    popa
    ret
receiveByte endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;
initializePort proc near 
    push ax
    push dx
	
    mov dx,3fbh 			; Line Control Register
    mov al,10000000b		;Set Divisor Latch Access Bit
    out dx,al				;Out it

    mov dx,3f8h			
    mov al,0ch			
    out dx,al

    mov dx,3f9h
    mov al,00h
    out dx,al
	
    mov dx,3fbh
    mov al,00011011b
    out dx,al
	
    pop dx
    pop ax 
    ret    
initializePort endp
;;;;;;;;;;;;;;;;;;;;;;;;;;

receivebullet proc near
    pusha
    
    mov dx , 3FDH		; Line Status Register
    in al , dx 
        
    test al , 1
    JZ no_receive                                    ;Not Ready

    ;If Ready read the VALUE in Receive data register
    
    mov bx,0

    mov dx , 03F8H
    in ax , dx 
    mov bx,ax 

    ;****snedflag
		mov dx , 3FDH		; Line Status Register
    wt1:  In al , dx 			;Read Line Status
  		test al , 00100000b
    JZ wt1            ;Not empty

        ;If empty put the VALUE in Transmit data register
  		mov dx , 03F8H		; Transmit data register
  		mov al , 1
  		out dx , al
    ;****

mov dx , 3FDH		; Line Status Register
    CHKY1:  
    in al , dx 
    test al , 1
    JZ CHKY1
    mov al,0  
    mov dx , 03F8H
    in ax , dx 
    mov bh,al
    mov player1bulletPosX,bx

;/////////////////////////////////////////////////////////////////////////////////

    mov dx , 3FDH		; Line Status Register
    in al , dx 
        
    ;If Ready read the VALUE in Receive data register
    
    mov bx,0

    mov dx , 03F8H
    in ax , dx 
    mov bx,ax 

    ;****snedflag
		mov dx , 3FDH		; Line Status Register
    wt2:  In al , dx 			;Read Line Status
  		test al , 00100000b
    JZ wt2            ;Not empty

        ;If empty put the VALUE in Transmit data register
  		mov dx , 03F8H		; Transmit data register
  		mov al , 1
  		out dx , al
    ;****

mov dx , 3FDH		; Line Status Register
    CHKY2:  
    in al , dx 
    test al , 1
    JZ CHKY2
    mov al,0  
    mov dx , 03F8H
    in ax , dx 
    mov bh,al
    mov player1bulletPosY,bx

       ;****snedflag
		mov dx , 3FDH		; Line Status Register
    wt3:  In al , dx 			;Read Line Status
  		test al , 00100000b
    JZ wt3            ;Not empty

        ;If empty put the VALUE in Transmit data register
  		mov dx , 03F8H		; Transmit data register
  		mov al , 1
  		out dx , al
    ;****

mov dx , 3FDH		; Line Status Register
    CHKY3:  
    in al , dx 
    test al , 1
    JZ CHKY3
    mov al,0  
    mov dx , 03F8H
    in ax , dx 
    mov player1IsThereBullet,al
    
           ;****snedflag
		mov dx , 3FDH		; Line Status Register
    wt4:  In al , dx 			;Read Line Status
  		test al , 00100000b
    JZ wt4            ;Not empty

        ;If empty put the VALUE in Transmit data register
  		mov dx , 03F8H		; Transmit data register
  		mov al , 1
  		out dx , al
    ;****

no_receive:

popa
ret 
receivebullet endp


end 