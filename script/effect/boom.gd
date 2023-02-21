# @copyright Rug Pull Games
# @see Rug Pull Games: https://rug-pull.games/
# @see RPG 404: https://rpg404.com/
# @author endaye.eth, Fried Egg Fendi

extends AnimatedSprite

const SCREEN_WIDTH = K.SCREEN_WIDTH
const SCREEN_WIDTH_EXT = SCREEN_WIDTH + 300
const SPEED_X = K.SPEED_X

### default


func _ready():
	self.position = Vector2(-100, -100)


func _process(dt):
	if G.game_state != K.GameState.RUNNING:
		return
	_move(dt)


### public


func play_effect():
	self.frame = 0
	self.playing = true


### private


func _move(dt):
	if G.game_state != K.GameState.RUNNING:
		return

	self.position.x -= SPEED_X * G.factor * dt
	self.position.x = fmod(self.position.x + SCREEN_WIDTH_EXT, SCREEN_WIDTH_EXT)
