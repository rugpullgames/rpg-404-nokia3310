# @copyright Rug Pull Games
# @see Rug Pull Games: https://rug-pull.games/
# @see RPG 404: https://rpg404.com/
# @author endaye.eth, Fried Egg Fendi

extends Label

### default


func _ready():
	_update_score()


func _process(_dt):
	if G.game_state == K.GameState.READY:
		self.text = "0"
	elif G.game_state == K.GameState.RUNNING:
		_update_score()


### private


func _update_score():
	self.text = str(G.score)
