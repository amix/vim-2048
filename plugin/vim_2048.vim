" 2048 in your Vim
" ================
"
" Install:
"
"   First install term2048 ( https://github.com/bfontaine/term2048 ):
"
"       $ pip install term2048
"
" Usage:
"
"   From command mode simply call to play:
"
"       :Play2048
"
" Requires a Vim that's compiled with Python support.
"
" By amix:
"   https://github.com/amix
"
" MIT License
"

if exists("g:loaded_2048")
  finish
endif
let g:loaded_2048 = 1


" --- Init
function! s:Init2048()
python << EOF
import vim
import re
import math
from term2048 import game
from term2048.board import Board
TERM_GAME = game.Game()

def getCellStr(x, y):
    self = TERM_GAME

    c = TERM_GAME.board.getCell(x, y)

    az = {}
    for i in range(1, int(math.log(self.board.goal(), 2))):
        az[2 ** i] = chr(i + 96)

    if c == 0:
        return '  .'
    elif c == 1024:
        s = ' 1k'
    elif c == 2048:
        s = ' 2k'
    else:
        s = '%3d' % c

    return s

setattr(TERM_GAME, 'getCellStr', getCellStr)
EOF
endfunction


" --- Print board
function! s:PrintBoard()
setlocal noro
setlocal modifiable
python << EOF
TERM_GAME.saveBestScore()
lines = TERM_GAME.__str__(margins={'left': 5, 'top': 5, 'bottom': 5})
lines = lines.split('\n')
cb = vim.current.buffer
del cb[:]
cb.append(lines)
EOF
setlocal ro
setlocal nomodifiable
endfunction


" --- Move left
function! s:MoveLeft() 
python << EOF
TERM_GAME.incScore(TERM_GAME.board.move(Board.LEFT))
EOF
call s:PrintBoard()
endfunction


" --- Move right
function! s:MoveRight() 
python << EOF
TERM_GAME.incScore(TERM_GAME.board.move(Board.RIGHT))
EOF
call s:PrintBoard()
endfunction


" --- Move up
function! s:MoveUp() 
python << EOF
TERM_GAME.incScore(TERM_GAME.board.move(Board.UP))
EOF
call s:PrintBoard()
endfunction


" --- Move down
function! s:MoveDown() 
python << EOF
TERM_GAME.incScore(TERM_GAME.board.move(Board.DOWN))
EOF
call s:PrintBoard()
endfunction

function! s:Colors() 
    hi ColNumber2		guifg=DarkGreen ctermfg=DarkGreen
    hi ColNumber4		guifg=DarkBlue ctermfg=DarkBlue
    hi ColNumber8		guifg=DarkCyan ctermfg=DarkCyan
    hi ColNumber16		guifg=DarkRed ctermfg=DarkRed
    hi ColNumber32		guifg=DarkMagenta ctermfg=DarkMagenta
    hi ColNumber64		guifg=Red ctermfg=Red
    hi ColNumber128		guifg=Blue ctermfg=Blue
    hi ColNumber256		guifg=Magenta ctermfg=Magenta
    hi ColNumber512		guifg=White ctermfg=White
    hi ColNumber1024	guifg=Green ctermfg=Green
    hi ColNumber2048	guifg=Yellow ctermfg=Yellow

    syn match Number2 /\<2\>/
    hi link Number2 ColNumber2

    syn match Number4 /\<4\>/
    hi link Number4 ColNumber4

    syn match Number8 /\<8\>/
    hi link Number8 ColNumber8

    syn match Number16 /\<16\>/
    hi link Number16 ColNumber16

    syn match Number32 /\<32\>/
    hi link Number32 ColNumber32

    syn match Number64 /\<64\>/
    hi link Number64 ColNumber64

    syn match Number128 /\<128\>/
    hi link Number128 ColNumber128

    syn match Number256 /\<256\>/
    hi link Number256 ColNumber256

    syn match Number512 /\<512\>/
    hi link Number512 ColNumber512

    syn match Number1024 /\<1024\>/
    hi link Number1024 ColNumber1024

    syn match Number2048 /\<2048\>/
    hi link Number2048 ColNumber2048
endfunction


function! s:Play(...)
    execute ":enew"
    setlocal buftype=nofile
    call s:Colors()
    call s:Init2048()
    call s:PrintBoard()

    nnoremap <buffer> <left> :call <SID>MoveLeft()<cr>
    nnoremap <buffer> h :call <SID>MoveLeft()<cr>

    nnoremap <buffer> <right> :call <SID>MoveRight()<cr>
    nnoremap <buffer> l :call <SID>MoveRight()<cr>

    nnoremap <buffer> <up> :call <SID>MoveUp()<cr>
    nnoremap <buffer> k :call <SID>MoveUp()<cr>

    nnoremap <buffer> <down> :call <SID>MoveDown()<cr>
    nnoremap <buffer> j :call <SID>MoveDown()<cr>
endfunction

command! -nargs=? Play2048 call s:Play(<args>)
