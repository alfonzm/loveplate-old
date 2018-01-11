G = {
  title = "Love Game",
  width = 240,
  height = 180,
  scale = 3,
  tile_size = 16,
  fullscreen = false,
  debug = false,

  platformer = false, -- used for gravity logic in movableSystem
  gravity = -1500,

  layers = {
    bg         = 100000,
    default    = 200000,
    tiles      = 300000,
    player     = 400000,
    enemy      = 500000,
    bullet     = 600000,
    explosions = 700000,
  }
}

function love.conf(t)
  t.window.title = G.title
  t.window.resizable = false
  t.window.width = G.width * G.scale
  t.window.height = G.height * G.scale
  -- t.window.vsync = false
end