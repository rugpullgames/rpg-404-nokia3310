# @copyright Rug Pull Games
# @see Rug Pull Games: https://rug-pull.games/
# @see RPG 404: https://rpg404.com/
# @author endaye.eth, Fried Egg Fendi

extends StaticBody2D

onready var SprBaseFloor: Sprite = $SprBaseFloor

### default


func _ready():
	_bind_events()


### private


func _bind_events() -> void:
	var error_code = Events.connect("update_traits", self, "_reset")
	assert(error_code == OK, error_code)


func _reset() -> void:
	_reset_base_floor()


func _reset_base_floor() -> void:
	if MgrNft.is_rpg404():
		SprBaseFloor.visible = true
	elif MgrNft.is_strxngers():
		SprBaseFloor.visible = false
	else:
		SprBaseFloor.visible = true
