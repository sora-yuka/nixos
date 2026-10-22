{ pkgs, ... }:

{
  programs.vim = {
    enable = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      auto-pairs vim-auto-save
    ];

    settings = {
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      number = true;
      ignorecase = true;
      history = 1000;
    };

    extraConfig = ''
      filetype on
      filetype plugin on
      filetype indent on
      syntax on

      set nobackup
      set showcmd
      set showmatch
      set nowrap
      set scrolloff=10
      set encoding=UTF-8
      set hlsearch
      set incsearch

      set softtabstop=2
  
      set wildmenu
      set wildmode=list:longest
      set wildignore="*.docs,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xslx";

      augroup filetype_settings
        autocmd!
        autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
      augroup END

      set statusline=
      set statusline+=\ %F\ %M\ %Y\ %R
      set statusline+=%=
      set statusline+=\ ascii:\ %b\ row:\ %l\ col:\ %c\ percent:\ %p%%
      set laststatus=2

      highlight EndOfBuffer ctermfg=black guifg=bg

      let g:auto_save = 1
    '';
  };
}
