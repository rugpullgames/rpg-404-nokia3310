# @copyright Rug Pull Games
# @see Rug Pull Games: https://rug-pull.games/
# @see RPG 404: https://rpg404.com/
# @author endaye.eth, Fried Egg Fendi

extends Sprite

const SHOW_TIME = 0.3

const TMP_RPG404_EMO_FILE = "user://rpg404_emo.png"

var _tt = 0

# node
onready var HTTPRequest: HTTPRequest = $HTTPRequest

### default


func _ready():
	_bind_events()


func _process(dt):
	if G.game_state != K.GameState.RUNNING:
		return

	if self.visible:
		_tt += dt

	if _tt >= SHOW_TIME:
		hide_emo()
		_tt = 0


### public


func show_emo() -> void:
	self.visible = true


func hide_emo() -> void:
	self.visible = false


### private


func _bind_events() -> void:
	var error_code = Events.connect("update_traits", self, "_reset")
	assert(error_code == OK, error_code)
	error_code = Events.connect("game_ready", self, "hide_emo")
	assert(error_code == OK, error_code)
	error_code = Events.connect("game_end", self, "show_emo")
	assert(error_code == OK, error_code)


func _reset() -> void:
	_reset_emo_type()
	hide_emo()


func _reset_emo_type() -> void:
	if (MgrNft.is_rpg404() or MgrNft.is_strxngers()) and MgrNft.NFT_TRAITS.emo:
		_download_emo_texture()
	else:
		push_warning("Wrong NFT emo traits.")


func _download_emo_texture() -> void:
	var image_url = "https://rpg404.com/nft/rpg404/texture/emo/%s.png" % [MgrNft.NFT_TRAITS.emo]
	K.http_download_texture(HTTPRequest, TMP_RPG404_EMO_FILE, image_url)


func _on_HTTPRequest_request_completed(result, response_code, _headers, _body):
	var texture = K.http_request_completed(result, response_code, TMP_RPG404_EMO_FILE)
	if texture:
		self.texture = texture
