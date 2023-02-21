# @copyright Rug Pull Games
# @see Rug Pull Games: https://rug-pull.games/
# @see RPG 404: https://rpg404.com/
# @author endaye.eth, Fried Egg Fendi

extends Node

var cloud_used = {}
var score = 0.0
var factor = 1.0

var game_state = K.GameState.INIT

var bgm_audio = true
var sfx_audio = true

### default


func _ready():
	_reset()


# private


func _reset():
	cloud_used.clear()
	score = 0
