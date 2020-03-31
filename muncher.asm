;Muncher game for DavidDOS By David Badiei
org 4000h
start:
;Change Video mode to VGA 320x200
mov ah,0
mov al,13h
int 10h
;Set background
mov ax,0A000h
mov es,ax
mov cx,0xffff
loopbg:
mov bx,cx
mov byte [es:bx],0x0a
loop loopbg
;Spawn player
mov byte [playerColor],4
call spawnplayer
;Show Score
call printscore
;Spawn fruit
mov byte [fruitColor],0ch
call spawnfruit
;Wait for keypress
userInput:
mov ah,1
int 16h
jz keepgoin
mov ah,0
int 16h
jmp updateplayer
keepgoin:
mov ah,byte [lastmove]
updateplayer:
pusha
call printscore
popa
cmp ah,4bh
je left
cmp ah,4dh
je right
cmp ah,50h
je down
cmp al,1bh
je doneprog
cmp ah,48h
jne keepgoin
up:
mov byte [playerColor],0x0a
call spawnplayer
cmp word [y1],0
je gameOver
sub word [y1],4
sub word [y2],4
mov byte [playerColor],0x04
call spawnplayer
mov byte [lastmove],48h
jmp upcheck
down:
mov byte [playerColor],0x0a
call spawnplayer
cmp word [y2],200
jge gameOver
add word [y1],4
add word [y2],4
mov byte [playerColor],0x04
call spawnplayer
mov byte [lastmove],50h
jmp downcheck
left:
mov byte [playerColor],0x0a
call spawnplayer
cmp word [x1],0
je gameOver
sub word [x1],4
sub word [x2],4
mov byte [playerColor],0x04
call spawnplayer
mov byte [lastmove],4bh
jmp leftcheck
right:
mov byte [playerColor],0x0a
call spawnplayer
cmp word [x2],320
jge gameOver
add word [x1],4
add word [x2],4
mov byte [playerColor],0x04
call spawnplayer
mov byte [lastmove],4dh
jmp rightcheck
moveplayer:
mov cx,1
mov dx,86A0h
mov ah,86h
int 15h
jmp userInput
;Return Video mode back to text mode
doneprog:
mov ah,0
mov al,3
int 10h
retf

x1 dw 160
y1 dw 100

x2 dw 165
y2 dw 105

scoreStr db 'Score:',0
lastmove db 0x4d
playerColor db 0
score db 0
fruitColor db 0
twoplusone dw 0
fruitx dw 0
fruity dw 0
fruitx1 dw 0
fruity1 dw 0
biosColor db 0
tailColor db 0
obstacleX dw 0
obstacleY dw 0

spawnplayer:
mov dx,[y1]
loopsqr1:
mov cx,[x1]
loopsqr2:
mov ah,0ch
mov al,byte [playerColor]
int 10h
inc cx
cmp cx,[x2]
jle loopsqr2
inc dx
cmp dx,[y2]
jle loopsqr1
ret

printscore:
mov dx,0
mov ah,02h
int 10h
mov si,scoreStr
call print_string
xor ah,ah
mov al,byte [score]
mov byte [biosColor],6
call inttostr
ret

print_string:
mov ah,0eh
loopprint:
lodsb
test al,al
jz doneprint
mov bl,6
int 10h
jmp loopprint
doneprint:
ret

rand:
mov ah,00
int 1ah
mov ax,dx
xor dx,dx
div bx
inc dx
ret

spawnfruit:
pusha
call seedrand
mov ax,0
mov bx,197
call getrand
mov dx,cx
push dx
mov bx,318
call rand
mov cx,dx
pop dx
mov word [fruity],dx
mov word [fruitx],cx
mov word [fruity1],dx
mov word [fruitx1],cx
inc word [fruitx]
loopfruit1:
mov ah,0ch
mov al,byte [fruitColor]
int 10h
inc cx
cmp cx,word [fruitx]
jle loopfruit1
sub word [fruitx],2
mov cx,word [fruitx]
add word [fruitx],3
inc dx
loopfruit2:
mov ah,0ch
mov al,byte [fruitColor]
int 10h
inc cx
cmp cx,word [fruitx]
jle loopfruit2
sub word [fruitx],3
mov cx,word [fruitx]
add word [fruitx],3
inc dx
loopfruit3:
mov ah,0ch
mov al,byte [fruitColor]
int 10h
inc cx
cmp cx,word [fruitx]
jle loopfruit3
sub word [fruitx],2
mov cx,word [fruitx]
inc word [fruitx]
inc dx
loopfruit4:
mov ah,0ch
mov al,byte [fruitColor]
int 10h
inc cx
cmp cx,word [fruitx]
jle loopfruit4
sub word [fruitx],2
popa
ret

clearfruit:
pusha
mov cx,word [fruitx1]
mov dx,word [fruity1]
inc word [fruitx1]
loopfruit5:
mov ah,0ch
mov al,0ah
int 10h
inc cx
cmp cx,word [fruitx1]
jle loopfruit5
sub word [fruitx1],2
mov cx,word [fruitx1]
add word [fruitx1],3
inc dx
loopfruit6:
mov ah,0ch
mov al,0ah
int 10h
inc cx
cmp cx,word [fruitx1]
jle loopfruit6
sub word [fruitx1],3
mov cx,word [fruitx1]
add word [fruitx1],3
inc dx
loopfruit7:
mov ah,0ch
mov al,0ah
int 10h
inc cx
cmp cx,word [fruitx1]
jle loopfruit7
sub word [fruitx1],2
mov cx,word [fruitx1]
inc word [fruitx1]
inc dx
loopfruit8:
mov ah,0ch
mov al,0ah
int 10h
inc cx
cmp cx,word [fruitx1]
jle loopfruit8
sub word [fruitx1],2
popa
ret

upcheck:
push cx
mov cx,word [x2]
mov word [twoplusone],cx
inc word [twoplusone]
pop cx
mov cx,word [x1]
mov dx,word [y1]
dec dx
uploop:
mov ah,0dh
int 10h
cmp al,0ch
je hitfruit
cmp al,0dh
je gameOver
inc cx
cmp cx,word [twoplusone]
je moveplayer
jmp uploop

downcheck:
push cx
mov cx,word [x2]
mov word [twoplusone],cx
inc word [twoplusone]
pop cx
mov cx,word [x1]
mov dx,word [y2]
inc dx
downloop:
mov ah,0dh
int 10h
cmp al,0ch
je hitfruit
cmp al,0dh
je gameOver
inc cx
cmp cx,word [twoplusone]
je moveplayer
jmp downloop

leftcheck:
push cx
mov cx,word [y2]
mov word [twoplusone],cx
inc word [twoplusone]
pop cx
mov cx,word [x1]
mov dx,word [y1]
dec cx
leftloop:
mov ah,0dh
int 10h
cmp al,0ch
je hitfruit
cmp al,0dh
je gameOver
inc dx
cmp dx,word [twoplusone]
je moveplayer
jmp leftloop

rightcheck:
push cx
mov cx,word [y2]
mov word [twoplusone],cx
inc word [twoplusone]
pop cx
mov cx,word [x2]
mov dx,word [y1]
inc cx
rightloop:
mov ah,0dh
int 10h
cmp al,0ch
je hitfruit
cmp al,0dh
je gameOver
inc dx
cmp dx,word [twoplusone]
je moveplayer
jmp rightloop

inttostr:
pusha
mov cx,0
mov bx,10
pushit:
xor dx,dx
div bx
inc cx
push dx
test ax,ax
jnz pushit
popit:
pop dx
add dl,30h
pusha
mov al,dl
mov ah,0eh
mov bl,byte [biosColor]
int 10h
popa
inc di
dec cx
jnz popit
popa
ret

hitfruit:
call clearfruit
inc byte [score]
call printscore
call seedrand
mov byte [playerColor],0ch
call spawnfruit
inc byte [obstacleAmount]
call addobstacle
jmp moveplayer

seedrand:
push bx
push ax
mov bx,0
mov al,02h
out 70h,al
in al,71h
mov bl,al
add word [randseed],bx
pop ax
pop bx
ret
randseed dw 0

getrand:
push dx
push bx
push ax
sub bx,ax
call genrand
mov dx,bx
add dx,1
mul dx
mov cx,dx
pop ax
pop bx
pop dx
add cx,ax
ret

genrand:
push dx
push bx
mov ax, word [randseed]
mov dx,7383h
mul dx
mov word [randseed],ax
pop bx
pop dx
ret

printconsole:
mov ah,0eh
loopprint1:
lodsb
test al,al
jz doneprint1
int 10h
jmp loopprint1
doneprint1:
ret

gameOver:
mov ah,0
mov al,3
int 10h
mov si,gamover
call printconsole
xor ah,ah
mov al,byte [score]
mov byte [biosColor],7
call inttostr
mov si,continue
call printconsole
gameOverkeypress:
mov ah,00
int 16h
cmp al,'r'
je resetshit
cmp al,'R'
je resetshit
cmp al,1bh
je doneprog
jmp gameOverkeypress
gamover db 'Game Over! Score: ',0
continue db 0x0D, 0x0A, 'Press r to retry or escape to quit', 0

resetshit:
mov byte [lastmove],4dh
mov word [x1],160
mov word [y1],100
mov word [x2],165
mov word [y2],105
mov byte [score],0
mov byte [obstacleAmount],0
jmp start

addobstacle:
xor ch,ch
mov cl,byte [obstacleAmount]
obstacleLoop:
pusha
call seedrand
mov ax,0
mov bx,197
call getrand
mov dx,cx
call seedrand
push dx
mov ax,1
mov bx,318
call getrand
pop dx
mov word [obstacleY],dx
mov word [obstacleX],cx
mov bp,0
obsloop1:
mov ax,0c0dh
int 10h
inc bp
inc dx
cmp bp,2
jle obsloop1
sub dx,2
dec cx
mov bp,0
obsloop2:
mov ax,0c0dh
int 10h
inc bp
inc cx
cmp bp,2
jle obsloop2
popa
loop obstacleLoop
ret
obstacleAmount db 0