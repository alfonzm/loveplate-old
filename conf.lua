G = {
  title = "Love Game",
  width = 240,
  height = 180,
  scale = 4,
  tile_size = 16,
  fullscreen = false,
}

function love.conf(t)
  t.window.title = G.title
  t.window.resizable = false
  t.window.width = G.width * G.scale
  t.window.height = G.height * G.scale
  -- t.window.vsync = false
end