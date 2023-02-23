# @copyright Rug Pull Games
# @see Rug Pull Games: https://rug-pull.games/
# @see RPG 404: https://rpg404.com/
# @author endaye.eth, Fried Egg Fendi

extends AnimatedSprite

### default


func _ready():
	_bind_events()


### public


func run() -> void:
	self.play("run")


func jump() -> void:
	self.play("jump")


### private


func _bind_events() -> void:
	var error_code = Events.connect("update_traits", self, "_reset")
	assert(error_code == OK, error_code)


func _reset() -> void:
	_reset_jacket_type()


func _reset_jacket_type() -> void:
	pass
