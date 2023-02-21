# @copyright Rug Pull Games
# @see Rug Pull Games: https://rug-pull.games/
# @see RPG 404: https://rpg404.com/
# @author endaye.eth, Fried Egg Fendi
extends AnimatedSprite

const SPEED_FACTOR = 0.3

### default


func _ready():
	_bind_events()


func _process(_dt):
	if G.game_state == K.GameState.RUNNING:
		self.speed_scale = (G.factor - 1) * SPEED_FACTOR + 1


### private


func _bind_events() -> void:
	var error_code = Events.connect("update_traits", self, "_reset")
	assert(error_code == OK, error_code)


func _reset() -> void:
	_reset_strxnger_cloud_type()


func _reset_strxnger_cloud_type() -> void:
	if MgrNft.is_rpg404():
		visible = false
	elif MgrNft.is_strxngers():
		visible = true
	else:
		push_warning("Wrong NFT Strxngers cloud traits.")
