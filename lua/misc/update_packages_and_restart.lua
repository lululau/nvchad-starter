-- 等价于 Emacs 侧 lx/update-packages-and-restart：
-- 免确认更新全部 lazy.nvim 插件（sync = update + install + clean），
-- 返回报告字符串（更新了哪些插件、旧->新 commit、lockfile 备份位置），
-- 然后延时重启 Neovim，保证 --remote-expr 的调用方先拿到返回值。
--
-- 交互调用：:LxUpdatePackagesAndRestart
-- Agent 命令行调用（等价 emacsclient -e '(lx/update-packages-and-restart)'）：
--   nvim --server <SOCK> --remote-expr 'luaeval("require(_A).run()", "misc.update_packages_and_restart")'
local M = {}

-- 重启延迟（毫秒）：让 RPC 返回值先送达客户端再退出
M.restart_delay = 2000

local function lockfile_path()
  return vim.fn.stdpath("config") .. "/lazy-lock.json"
end

-- {插件名 -> commit}，lazy-lock.json 新旧格式都兼容
function M.read_lock()
  local lines = vim.fn.readfile(lockfile_path())
  if not lines or #lines == 0 then
    return {}
  end
  local ok, data = pcall(vim.json.decode, table.concat(lines, "\n"))
  if not ok or type(data) ~= "table" then
    return {}
  end
  local lock = {}
  for name, info in pairs(data) do
    if type(info) == "table" then
      lock[name] = info.commit or ""
    else
      lock[name] = tostring(info)
    end
  end
  return lock
end

-- 两个 lock 快照的差异 -> 排序后的 "name old->new" 列表
function M.diff_lock(before, after)
  local updated = {}
  for name, commit in pairs(after) do
    local old = before[name]
    if old and old ~= commit and commit ~= "" then
      updated[#updated + 1] = ("%s %s->%s"):format(name, old:sub(1, 7), commit:sub(1, 7))
    end
  end
  table.sort(updated)
  return updated
end

-- 备份更新前的 lockfile；lazy 的回滚机制就是 lockfile + :Lazy restore
function M.backup_lockfile(before_lines)
  local dir = vim.fn.stdpath("state") .. "/lazy-rollback"
  vim.fn.mkdir(dir, "p")
  local path = ("%s/%s.json"):format(dir, os.date("%y-%m-%d_%H.%M.%S"))
  vim.fn.writefile(before_lines, path)
  return path
end

function M.run()
  local ok, manage = pcall(require, "lazy.manage")
  if not ok then
    return "ERROR: lazy.nvim not available: " .. tostring(manage)
  end

  local before_lines = vim.fn.readfile(lockfile_path())
  local before = M.read_lock()

  -- 双保险：wait=true 阻塞到全部任务完成（:Lazy! sync 的无头等价），
  -- 再等 LazySync 事件确保嵌套的 lockfile 写回也已执行
  local finished = false
  local au = vim.api.nvim_create_autocmd("User", {
    pattern = "LazySync",
    once = true,
    callback = function() finished = true end,
  })
  local ok_sync, err = pcall(manage.sync, manage, { wait = true, show = false })
  if not ok_sync then
    vim.api.nvim_del_autocmd(au)
    return "ERROR: Lazy sync failed: " .. tostring(err)
  end
  vim.wait(10000, function() return finished end, 50)
  pcall(vim.api.nvim_del_autocmd, au)

  local updated = M.diff_lock(before, M.read_lock())
  if #updated == 0 then
    return "No plugin updates; all plugins are up to date."
  end

  local backup = M.backup_lockfile(before_lines)
  local report = ("Updated %d plugin(s): %s; old versions saved in lockfile backup: %s "
    .. "(rollback: copy it over lazy-lock.json, then run :Lazy restore); "
    .. "Neovim is restarting to load them.")
    :format(#updated, table.concat(updated, ", "), backup)

  vim.defer_fn(function()
    vim.notify("Plugins updated, restarting Neovim...")
    vim.cmd("silent! wall | restart +qall!")
  end, M.restart_delay)
  return report
end

vim.api.nvim_create_user_command("LxUpdatePackagesAndRestart", function()
  print(M.run())
end, { desc = "Lazy sync (no confirmation), report updates, then restart" })

return M
