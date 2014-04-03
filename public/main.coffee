canvas = document.getElementById 'canvas'
context = canvas.getContext '2d'

blockTypes = [ 'none', '#f00', '#0f0', '#00f']

#===============================================================================
#===============================================================================
#===============================================================================
Game =
  canvas:  document.getElementById 'canvas'
  context: @canvas.getContext '2d'

  #game loop stuff
  prevTime: null
  curTime: (new Date).getTime()

  paddleWidth: 120
  paddleHeight: 20
  paddleSpeed: 0.35
  paddleVelocity: 0
  paddleX: @canvas.width/2

  ballExists: true
  ballX: @canvas.width/2
  ballY: @canvas.height/2
  ballSpeed: 0.3
  ballVeloX: 0.4
  ballVeloY: 1
  ballRadius: 10

  paddleBounces: 0
  wallBounces: 0

#===============================================================================
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

#===============================================================================
  refreshBounces: () =>
    document.getElementById("paddleBounces").innerHTML = Game.paddleBounces
    document.getElementById("wallBounces").innerHTML = Game.wallBounces

#===============================================================================
  onClick: (e) =>

#===============================================================================
  onKeyDown: (e) =>
    velo = Game.paddleVelocity

    if e.keyCode == 37 #left arrow
      velo -= 1

    if e.keyCode == 39 #right arrow
      velo += 1

    if velo > 0
      velo = 1
    else if velo < 0
      velo = -1
    else
      velo = 0

    Game.paddleVelocity = velo

#===============================================================================
  onKeyUp: (e) =>
    velo = Game.paddleVelocity

    if e.keyCode == 37 #left arrow
      velo += 1

    if e.keyCode == 39 #right arrow
      velo -= 1

    if velo > 0
      velo = 1
    else if velo < 0
      velo = -1
    else
      velo = 0

    Game.paddleVelocity = velo

#===============================================================================
  update: () =>
    # delta time
    Game.prevTime = Game.curTime
    Game.curTime = (new Date()).getTime()
    deltaTime = Game.curTime - Game.prevTime

    # paddle movement
    Game.paddleX = Game.paddleX + (Game.paddleVelocity * Game.paddleSpeed * deltaTime)

    if Game.paddleX > (Game.canvas.width-Game.paddleWidth)
      Game.paddleX = Game.canvas.width-Game.paddleWidth
    if Game.paddleX < 0
      Game.paddleX = 0

    # ball movement
    if Game.ballExists
      if Game.ballX > Game.canvas.width
        Game.ballX = Game.canvas.width - Game.ballRadius
        Game.ballVeloX = -1 * Game.ballVeloX
        Game.wallBounces++
        Game.refreshBounces()

      if Game.ballX < 0
        Game.ballX = Game.ballRadius
        Game.ballVeloX = -1 * Game.ballVeloX
        Game.wallBounces++
        Game.refreshBounces()

      if Game.ballY > Game.canvas.height
        Game.ballExists = false

      if Game.ballY+Game.ballRadius < 0
        Game.ballY = Game.ballRadius
        Game.ballVeloY = -1 * Game.ballVeloY
        Game.wallBounces++
        Game.refreshBounces()

      # ball bounce from paddle
      if (Game.ballY > Game.canvas.height - (Game.paddleHeight + Game.ballRadius) &&
          Game.ballX > Game.paddleX &&
          Game.ballX < Game.paddleX + Game.paddleWidth)
        Game.ballY = Game.canvas.height - (Game.paddleHeight + Game.ballRadius)
        Game.ballVeloY = -1
        Game.paddleBounces++
        Game.refreshBounces()
        if Game.paddleVelocity != 0
          Game.ballVeloX += (Game.paddleVelocity*0.1)

      Game.ballX = Game.ballX + (Game.ballVeloX * Game.ballSpeed * deltaTime)
      Game.ballY = Game.ballY + (Game.ballVeloY * Game.ballSpeed * deltaTime)

#===============================================================================
  draw: () =>
    Game.canvas.width = Game.canvas.width #weird code to clear the screen, but it works

    Game.context.fillRect Game.paddleX, Game.canvas.height - Game.paddleHeight, Game.paddleWidth, Game.paddleHeight

    if Game.ballExists
      Game.context.beginPath()
      Game.context.arc Game.ballX, Game.ballY, Game.ballRadius, 0, Math.PI*2
      Game.context.stroke()

#===============================================================================
  run: () =>
    @loops = 0

    Game.update()
    Game.draw()

#===============================================================================
#===============================================================================
#===============================================================================

Game.canvas.addEventListener "click", Game.onClick, false
document.addEventListener "keydown", Game.onKeyDown, false
document.addEventListener "keyup", Game.onKeyUp, false
Game._intervalId = setInterval Game.run, 0
