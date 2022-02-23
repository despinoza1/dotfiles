" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

set nu
set mouse=a
set clipboard+=unnamedplus

call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'joshdick/onedark.vim'

call plug#end()

colorscheme onedark

if !exists('g:vscode')
  " Use tab for trigger completion with characters ahead and navigate.
  " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " Use <c-space> to trigger completion.
  inoremap <silent><expr> <c-space> coc#refresh()

  " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
  " Coc only does snippet and additional edit on confirm.
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

  " Use `[c` and `]c` to navigate diagnostics
  nmap <silent> [c <Plug>(coc-diagnostic-prev)
  nmap <silent> ]c <Plug>(coc-diagnostic-next)

  " Remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " Use K to show documentation in preview window
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Remap for rename current word
  nmap <leader>rn <Plug>(coc-rename)

  " Remap for format selected region
  xmap <leader>f  <Plug>(coc-format-selected)
  nmap <leader>f  <Plug>(coc-format-selected)

  augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup end

  " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
  xmap <leader>a  <Plug>(coc-codeaction-selected)
  nmap <leader>a  <Plug>(coc-codeaction-selected)

  " Remap for do codeAction of current line
  nmap <leader>ac  <Plug>(coc-codeaction)
  " Fix autofix problem of current line
  nmap <leader>qf  <Plug>(coc-fix-current)

  " Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
  nmap <silent> <TAB> <Plug>(coc-range-select)
  xmap <silent> <TAB> <Plug>(coc-range-select)
  xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

  " Use `:Format` to format current buffer
  command! -nargs=0 Format :call CocAction('format')

  " Use `:Fold` to fold current buffer
  command! -nargs=? Fold :call     CocAction('fold', <f-args>)

  " use `:OR` for organize import of current buffer
  command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

  " Add status line support, for integration with other plugin, checkout `:h coc-status`
  set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

  " Using CocList
  " Show all diagnostics
  nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
  " Manage extensions
  nnoremap <silent> <space>x :<C-u>CocList extensions<cr>
  " Show commands
  nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
  " Find symbol of current document
  nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
  " Search workspace symbols
  nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
  " Do default action for next item.
  nnoremap <silent> <space>j  :<C-u>CocNext<CR>
  " Do default action for previous item.
  nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
  " Resume latest coc list
  nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

  " Used to expand decorations in worksheets
  nmap <Leader>ws <Plug>(coc-metals-expand-decoration)

  " Toggle panel with Tree Views
  nnoremap <silent> <space>t :<C-u>CocCommand metals.tvp<CR>
  " Toggle Tree View 'metalsPackages'
  nnoremap <silent> <space>tp :<C-u>CocCommand metals.tvp metalsPackages<CR>
  " Toggle Tree View 'metalsCompile'
  nnoremap <silent> <space>tc :<C-u>CocCommand metals.tvp metalsCompile<CR>
  " Toggle Tree View 'metalsBuild'
  nnoremap <silent> <space>tb :<C-u>CocCommand metals.tvp metalsBuild<CR>
  " Reveal current current class (trait or object) in Tree View 'metalsPackages'
  nnoremap <silent> <space>tf :<C-u>CocCommand metals.revealInTreeView metalsPackages<CR>

  "Explorer
  nnoremap <silent> <space>e :<C-u>CocCommand explorer<CR>

  nmap <leader>t <Plug>(coc-terminal-toggle)

  autocmd FileType json syntax match Comment +\/\/.\+$+

  " Better display for messages
  set cmdheight=2
else
  " Use `[c` and `]c` to navigate diagnostics
  nmap <silent> [c <Cmd>call VSCodeNotify('editor.action.marker.prevInFiles')<CR>
  nmap <silent> ]c <Cmd>call VSCodeNotify('editor.action.marker.nextInFiles')<CR>

  " Remap keys for gotos
  nmap <silent> gd <Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>
  nmap <silent> gy <Cmd>call VSCodeNotify('editor.action.goToTypeDefinition')<CR>
  "nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>

  " Use K to show documentation in preview window
  nnoremap <silent> K <Cmd>call VSCodeNotify('editor.action.showHover')<CR>

  " Remap for rename current word
  nnoremap <silent> <leader>rn <Cmd>call VSCodeNotify('editor.action.rename')<CR>

  " Remap for format selected region
  xmap <leader>f  <Cmd>call VSCodeNotify('editor.action.formatSelection')<CR>
  nnoremap <silent> <leader>f  <Cmd>call VSCodeNotify('editor.action.formatSelection')<CR>

  " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
  xmap <leader>a  <Plug>(coc-codeaction-selected)
  nmap <leader>a  <Plug>(coc-codeaction-selected)

  " Remap for do codeAction of current line
  nnoremap <leader>ac  <Plug>(coc-codeaction)
  " Fix autofix problem of current line
  nnoremap <leader>qf  <Cmd>call VSCodeNotify('editor.action.quickFix')<CR>

  " Use `:Format` to format current buffer
  command! -nargs=0 Format :call VSCodeNotify('editor.action.formatDocument')<CR>

  " Use `:Fold` to fold current buffer
  command! -nargs=? Fold :call VSCodeNotify('editor.fold', <f-args>)<CR>

  " use `:OR` for organize import of current buffer
  command! -nargs=0 OR   :call CocAction('runCommand', 'editor.action.organizeImport')

  " Using CocList
  " Show all diagnostics
  nnoremap <silent> <space>a <Cmd>call VSCodeNotify('workbench.actions.view.problems')<CR>
  " Manage extensions
  nnoremap <silent> <space>x <Cmd>call VSCodeNotify('workbench.view.extensions')<CR>
  " Show commands
  nnoremap <silent> <space>c  <Cmd>call VSCodeNotify('workbench.action.showCommands')<CR>
  " Find symbol of current document
  nnoremap <silent> <space>o  <Cmd>call VSCodeNotify('outline.focus')<CR> 
  " Search workspace symbols
  nnoremap <silent> <space>s  <Cmd>call VSCodeNotify('workbench.action.showAllSymbols')<CR>
  " Do default action for next item.
  "nnoremap <silent> <space>j  :<C-u>CocNext<CR>
  " Do default action for previous item.
  "nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
  " Resume latest coc list
  "nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

  "Explorer
  nmap <silent> <space>e <Cmd>call VSCodeNotify('workbench.view.explorer')<CR>

  nmap <silent> <leader>t <Cmd>call VSCodeNotify('workbench.action.terminal.toggleTerminal')<CR>
 
  " THEME CHANGER
function! SetCursorLineNrColorInsert(mode)
    " Insert mode: blue
    if a:mode == "i"
        call VSCodeNotify('nvim-theme.insert')

    " Replace mode: red
    elseif a:mode == "r"
        call VSCodeNotify('nvim-theme.replace')
    endif
endfunction


function! SetCursorLineNrColorVisual()
    set updatetime=0
    call VSCodeNotify('nvim-theme.visual')
endfunction

vnoremap <silent> <expr> <SID>SetCursorLineNrColorVisual SetCursorLineNrColorVisual()
nnoremap <silent> <script> v v<SID>SetCursorLineNrColorVisual
nnoremap <silent> <script> V V<SID>SetCursorLineNrColorVisual
nnoremap <silent> <script> <C-v> <C-v><SID>SetCursorLineNrColorVisual

function! SetCursorLineNrColorVisual()
    set updatetime=0
    call VSCodeNotify('nvim-theme.visual')
endfunction

vnoremap <silent> <expr> <SID>SetCursorLineNrColorVisual SetCursorLineNrColorVisual()
nnoremap <silent> <script> v v<SID>SetCursorLineNrColorVisual
nnoremap <silent> <script> V V<SID>SetCursorLineNrColorVisual
nnoremap <silent> <script> <C-v> <C-v><SID>SetCursorLineNrColorVisual


augroup CursorLineNrColorSwap
    autocmd!
    autocmd InsertEnter * call SetCursorLineNrColorInsert(v:insertmode)
    autocmd InsertLeave * call VSCodeNotify('nvim-theme.normal')
    autocmd CursorHold * call VSCodeNotify('nvim-theme.normal')
augroup END

endif

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes
