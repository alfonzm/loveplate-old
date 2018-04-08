G = {
  title = "Game Title",
  width = 360,
  height = 240,
  scale = 3,
  tile_size = 16,
  fullscreen = true,
  fullscreen = false,
  debug = false,

  platformer = false,
  gravity = -1200,

  layers = {
    bg         = 100,
    default    = 200,
    tiles      = 300,
    player     = 400,
    enemy      = 500,
    particles  = 510,
    explosion  = 600,
    bullet     = 700,
    ui         = 999,
  }
}

Colors = {
  white = {255,255,255,255},
  red = {255,0,0,255},
  green = {0,255,0,255},
}

function love.conf(t)
  t.window.title = G.title
  t.window.resizable = false
  t.window.width = G.width * G.scale
  t.window.height = G.height * G.scale
  -- t.window.vsync = false
end