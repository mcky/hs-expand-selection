package = "hs-expand-selection"
version = "0.1.0-1"
source = {
   url = "..." -- Your project's source URL (e.g., Git repository)
}
description = {
   summary = "A hammerspoon Spoon to bla bla",
   -- detailed = [[
      -- A more detailed description of your project.
   -- ]],
   homepage = "...", -- Optional: Your project's homepage
   license = "MIT" -- Choose appropriate license
}
dependencies = {
   "lua >= 5.1",
   "busted >= 2.1.1",
   
}
build = {
   type = "builtin",
   modules = {
      -- List your project's modules here
      -- ["yourproject"] = "src/yourproject.lua",
      -- ["yourproject.submodule"] = "src/submodule.lua"
   }
}
