local utils = require'config.utils'
local map = vim.keymap.set

-- save
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

--- w!! to save with sudo
map('c', 'w!!', function() utils.sudo_write() end, { silent = true })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

--keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- view :messages
map({'n', 'v'}, '<leader>m', '<cmd>messages<CR>',  { desc = 'Messages' })
map({'n', 'v'}, '<leader>M', '<cmd>mes clear|echo "cleared :messages"<CR>', { desc = 'Clear Messages' })

-- view Noice history
map({'n', 'v'}, '<leader>n', '<cmd>NoiceHistory<CR>',       { desc = 'Notice history' })

-- clear highlight search with <esc>
map( {'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and Clear hlsearch' })

map( 'n',           -- Clear search, diff update and redraw
     '<esc><esc>',  -- taken from runtime/lua/_editor.lua
     '<cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><cr>',
     { desc = 'Redraw / Clear hlsearch / Diff Update' } )

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map('n', 'n', "'Nn'[v:searchforward].'zzzv'", { expr = true, desc = "Next Search Result" })
map('x', 'n', "'Nn'[v:searchforward]",        { expr = true, desc = "Next Search Result" })
map('o', 'n', "'Nn'[v:searchforward]",        { expr = true, desc = "Next Search Result" })
map('n', 'N', "'nN'[v:searchforward].'zzzv'", { expr = true, desc = "Prev Search Result" })
map('x', 'N', "'nN'[v:searchforward]",        { expr = true, desc = "Prev Search Result" })
map('o', 'N', "'nN'[v:searchforward]",        { expr = true, desc = "Prev Search Result" })

-- Change current working dir (:pwd) to curent file's folder
map('n', '<leader>%', function() utils.set_cwd() end, { desc = 'Set cwd to file directory', silent = true })

-- newline without insert mode
map('n', '<leader>o',
    ':<C-u>call append(line("."), repeat([""], v:count1))<CR>',
    { desc = 'New line below', silent = true })
map('n', '<leader>O',
    ':<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>',
    { desc = 'New line above', silent = true })

-- newline with comments
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- Break undo chain on punctuation, parenthesis, quotes, and carriage return
-- so we can use 'u' to undo sections of an edit
for _, c in ipairs({',', '.', '(', '[', '{', '=', '\\', '"', '\'', '<CR>'}) do
   map('i', c, c .. "<C-g>u", { noremap = true })
end

-- redo  
map("n", "<S-u>", "<cmd>redo<cr>", { desc = "Redo last change" })

-- Use operator pending mode to visually select entire buffer, e.g.
--    d<A-a> = delete entire buffer
--    y<A-a> = yank entire buffer
--    v<A-a> = visual select entire buffer
map('o', '<A-a>', ':<C-U>normal! mzggVG<CR>`z')
map('x', '<A-a>', ':<C-U>normal! ggVG<CR>')

-- keep visual selection when (de)indenting
map('v', '<', '<gv', { desc = 'deindent' })
map('v', '>', '>gv', { desc = 'indent' })

-- <leader>v|<leader>s act as <cmd-v>|<cmd-s>
-- <leader>p|P paste from yank register (0)
map({'n', 'v'}, '<leader>rv', '"+p',   { desc = 'Paste from +' } )
map({'n', 'v'}, '<leader>rV', '"+P',   { desc = 'Append from +' } )
map({'n', 'v'}, '<leader>rs', '"*p',   { desc = 'Paste from *' } )
map({'n', 'v'}, '<leader>rS', '"*P',   { desc = 'Append from *' } )
map({'n', 'v'}, '<leader>rp', '"0p',   { desc = 'Paste from 0' } )
map({'n', 'v'}, '<leader>rP', '"0P',   { desc = 'Append from 0' } )

-- copy current file path to the clipboard
-- map({'n', 'v'}, '<leader>y', '<cmd>let @+=@0<CR>', { desc = 'Copy file path' })

-- Beginning and end of line in `:` command mode
map('c', '<C-s>', '<home>', { desc = 'Start of line' })
map('c', '<C-e>', '<end>' , { desc = 'End of line' })

-- Arrows in command line mode (':') menus
map('c', '<down>', '(wildmenumode() ? "\\<C-n>" : "\\<down>")', { expr = true })
map('c', '<up>',   '(wildmenumode() ? "\\<C-p>" : "\\<up>")',   { expr = true })
for k, v in pairs({ ['<down>'] = '<C-n>', ['<up>'] = '<C-p>' }) do
 map('c', k, function()
   return vim.fn.wildmenumode() and v or k
 end, {expr=true})
end

-- switch to normal mode
map('t', '<M-[>', [[<C-\><C-n>]], {})

-- paste any register into a terminal with Alt-p <register>
map('t', '<A-p>', [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { expr = true })

-- better up/down with visual lines when wrapping
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'",      { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'",      { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'",   { desc = "Up", expr = true, silent = true })

-- navigate tabs
map('n', '<leader><tab><s-tab>', ':tabprevious<CR>',    { desc = 'Previous' })
map('n', '<leader><tab><tab>',   ':tabnext<CR>',        { desc = 'Next' })
map('n', '<leader><tab>f',       ':tabfirst<CR>',       { desc = 'First' })
map('n', '<leader><tab>l',       ':tablast<CR>',        { desc = 'Last' })
map('n', '<Leader><tab>n',       ':tabnew<CR>',         { desc = 'New' })
map('n', '<Leader><tab>c',       ':tabclose<CR>',       { desc = 'Close' })
map('n', '<Leader><tab>o',       ':tabonly<CR>',        { desc = 'Close other tabs' })
map('n', '<Leader><tab>O', ':tabfirst<CR>:tabonly<CR>', { desc = 'First & close others' })

-- fancy tmux-like windowed-buffer zoom
map('n', '<Leader><tab>z', function() utils.tabz() end, { desc = 'Zoom window (tmux-like)' })

-- navigate buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>",     { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>",  { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", utils.bufremove, { desc = "Delete Buffer" })
map("n", "<leader>bD", "<cmd>:bd<cr>",  { desc = "Delete Buffer and Window" })


-- split navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- split navigations from term and insert modes
map({'t', 'i'}, '<C-h>', '<C-\\><C-N><C-w>h')
map({'t', 'i'}, '<C-j>', '<C-\\><C-N><C-w>j')
map({'t', 'i'}, '<C-k>', '<C-\\><C-N><C-w>k')
map({'t', 'i'}, '<C-l>', '<C-\\><C-N><C-w>l')

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==",        { desc = "Move Down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==",        { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv",        { desc = "Move Down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv",        { desc = "Move Up" })

-- split resize with tmux-like directional resizes
map({'n', 't', 'i'}, '<C-up>',    function() utils.relative_resize(false, -2) end, { silent = true })
map({'n', 't', 'i'}, '<C-down>',  function() utils.relative_resize(false,  2) end, { silent = true })
map({'n', 't', 'i'}, '<C-left>',  function() utils.relative_resize(true,  -2) end, { silent = true })
map({'n', 't', 'i'}, '<C-right>', function() utils.relative_resize(true,   2) end, { silent = true })


-- old and unused key bindings

-- not sure what this does
-- overloads for 'd|c' that don't pollute the unnamed registers
-- map('n', '<leader>D',  '"_D',         {})
-- map('n', '<leader>C',  '"_C',         {})
-- map({'n', 'v'}, '<leader>c',  '"_c',  {})

-- any jump over 5 modifies the jumplist
-- so we can use <C-o> <C-i> to jump back and forth
--for _, c in ipairs({'j', 'k'}) do
--  map('n', c, ([[(v:count > 5 ? "m'" . v:count : "") . '%s']]):format(c),
--    { expr = true, silent = true})
--end

-- move along visual lines, not numbered ones
-- without interferring with {count}<down|up>
--for _, m in ipairs({'n', 'v'}) do
--  for _, c in ipairs({ {'<up>','k'}, {'<down>','j'} }) do
--    map(m, c[1], ([[v:count == 0 ? 'g%s' : '%s']]):format(c[2], c[2]),
--        { expr = true, silent = true})
--  end
--end

-- 'c.' for word, 'c>' for WORD
-- 'c.' in visual mode for selection
-- map('n', 'c.', [[:%s/\<<C-r><C-w>\>//g<Left><Left>]], {})
-- map('n', 'c>', [[:%s/\V<C-r><C-a>//g<Left><Left>]], {})
-- map('x', 'c.', [[:<C-u>%s/\V<C-r>=luaeval("require'utils'.get_visual_selection(true)")<CR>//g<Left><Left>]], {})

-- LuaSnip keybindings
--vim.keymap.set({"i"}, "<C-K>", function() require("luasnip").expand() end, {silent = true})
--vim.keymap.set({"i", "s"}, "<C-L>", function() require("luasnip").jump( 1) end, {silent = true})
--vim.keymap.set({"i", "s"}, "<C-J>", function() require("luasnip").jump(-1) end, {silent = true})
--vim.keymap.set({"i", "s"}, "<C-E>", function()
--	if require("luasnip").choice_active() then
--		require("luasnip").change_choice(1)
--	end
--end, {silent = true})

-- fugitive shortcuts for yadm
--local yadm_repo = "$HOME/dots/yadm-repo"

-- auto-complete for our custom fugitive Yadm command
-- https://github.com/tpope/vim-fugitive/issues/1981#issuecomment-1113825991
--vim.cmd(([[
--  function! YadmComplete(A, L, P) abort
--    return fugitive#Complete(a:A, a:L, a:P, {'git_dir': expand("%s")})
--  endfunction
--]]):format(yadm_repo))

--vim.cmd(([[command! -bang -nargs=? -range=-1 -complete=customlist,YadmComplete Yadm exe fugitive#Command(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>, { 'git_dir': expand("%s") })]]):format(yadm_repo))

--local function fugitive_command(nargs, cmd_name, cmd_fugitive, cmd_comp)
--  vim.api.nvim_create_user_command(cmd_name,
--    function(t)
--      local bufnr = vim.api.nvim_get_current_buf()
--      local buf_git_dir = vim.b.git_dir
--      vim.b.git_dir = vim.fn.expand(yadm_repo)
--      vim.cmd(cmd_fugitive .. " " .. t.args)
--      -- after the fugitive window switch we must explicitly
--      -- use the buffer num to restore the original 'git_dir'
--      vim.b[bufnr].git_dir = buf_git_dir
--    end,
--    {
--      nargs = nargs,
--      complete = cmd_comp and string.format("customlist,%s", cmd_comp) or nil,
--    }
--  )
--end

-- fugitive_command("?", "Yadm",        "Git",          "fugitive#Complete")
--fugitive_command("?", "Yit",         "Git",          "YadmComplete")
--fugitive_command("*", "Yread",       "Gread",        "fugitive#ReadComplete")
--fugitive_command("*", "Yedit",       "Gedit",        "fugitive#EditComplete")
--fugitive_command("*", "Ywrite",      "Gwrite",       "fugitive#EditComplete")
--fugitive_command("*", "Ydiffsplit",  "Gdiffsplit",   "fugitive#EditComplete")
--fugitive_command("*", "Yhdiffsplit", "Ghdiffsplit",  "fugitive#EditComplete")
--fugitive_command("*", "Yvdiffsplit", "Gvdiffsplit",  "fugitive#EditComplete")
--fugitive_command(1,   "YMove",       "GMove",        "fugitive#CompleteObject")
--fugitive_command(1,   "YRename",     "GRename",      "fugitive#RenameComplete")
--fugitive_command(0,   "YRemove",     "GRemove")
--fugitive_command(0,   "YUnlink",     "GUnlink")
--fugitive_command(0,   "YDelete",     "GDelete")
