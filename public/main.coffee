canvas = document.getElementById 'canvas'
context = canvas.getContext '2d'

blockStates = [ true, true, true, true, true, true, true, true ]
blockColors = [ '#f00', '#0f0', '#00f', '#ccc', '#fcc', '#cfc', '#ccf', '#000' ]

Game =
  canvas:  document.getElementById 'canvas'
  context: @canvas.getContext '2d'
  fps: 60
  stopped: false

  #game loop stuff
  loops: 0
  skipTicks: 1000 / @fps
  maxFrameSkip: 10
  nextGameTick: (new Date).getTime()

  paddleX: (640-80)/2

  getCursorPosition: (e) =>
    if e.pageX != undefined && e.pageY != undefined
    	x = e.pageX
    	y = e.pageY
    else
    	x = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft
    	y = e.clientY + document.body.scrollTop + document.documentElement.scrollTop

    x -= Game.canvas.offsetLeft;
    y -= Game.canvas.offsetTop;

    point =
      x: x
      y: y

    return point

  onClick: (e) =>

  onKeyDown: (e) =>
    if(e.keyCode == 13)
      Game.context.fillRect 0, 0, 640, 480

  onKeyUp: (e) =>


  update: () =>


  draw: () =>
    i = 0
    #Game.canvas.width = Game.canvas.width

    while i < 8
      if blockStates[i]
        Game.context.fillStyle = blockColors[i]
        Game.context.fillRect i*80, 0, 80, 80

      i++

  run: () =>
    @loops = 0

    Game.update()
    Game.draw()

Game.canvas.addEventListener "click", Game.onClick, false
document.addEventListener "keydown", Game.onKeyDown, false
document.addEventListener "keyup", Game.onKeyUp, false
Game._intervalId = setInterval Game.run, 0
