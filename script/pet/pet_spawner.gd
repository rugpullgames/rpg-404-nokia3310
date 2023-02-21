# @copyright Rug Pull Games
# @see Rug Pull Games: https://rug-pull.games/
# @see RPG 404: https://rpg404.com/
# @author endaye.eth, Fried Egg Fendi

extends Node

# resorce
const SCENE_PET = preload("res://scene/pet/pet.tscn")

# const
const SPAWN_TIME_MIN = 3
const SPAWN_TIME_MAX = 8
const SPAWN_TIME_FACTOR = 0.5

# local var
var _tt = 0
var _next_time = _get_next_time(1)
export(NodePath) var path_to_boom_effect
var Boom: AnimatedSprite

### default


func _ready():
	Boom = get_node(path_to_boom_effect)
	var error_code = Events.connect("game_ready", self, "_reset")
	assert(error_code == OK, error_code)


func _process(dt):
	if G.game_state == K.GameState.READY:
		_tt = 0
	elif G.game_state == K.GameState.RUNNING:
		_tt += dt
		if _tt >= _next_time:
			_spawn_pet()
			_tt = 0
			_next_time = _get_next_time()


### public


func play_boom_effect(pos: Vector2):
	Boom.position = pos
	Boom.play_effect()


### private


func _reset():
	_next_time = _get_next_time(1)


func _spawn_pet():
	var pet = SCENE_PET.instance()
	add_child(pet)


func _get_next_time(factor = G.factor):
	return rand_range(SPAWN_TIME_MIN, SPAWN_TIME_MAX) / ((factor - 1) * SPAWN_TIME_FACTOR + 1)
