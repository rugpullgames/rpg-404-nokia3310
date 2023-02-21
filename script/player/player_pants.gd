# @copyright Rug Pull Games
# @see Rug Pull Games: https://rug-pull.games/
# @see RPG 404: https://rpg404.com/
# @author endaye.eth, Fried Egg Fendi

extends AnimatedSprite

const ANIM_NAME = "default"
const SPEED_FACTOR = 0.3

const TMP_RPG404_PANTS_FILES = ["user://rpg404_pants_1.png", "user://rpg404_pants_2.png"]

var image_urls: PoolStringArray
var frame_idx = 0

# node
onready var HTTPRequest: HTTPRequest = $HTTPRequest

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
	_reset_pants_type()


func _reset_pants_type() -> void:
	if MgrNft.is_rpg404() and MgrNft.NFT_TRAITS.pants:
		self.frames.clear(ANIM_NAME)
		frame_idx = 0
		image_urls = [
			"https://rpg404.com/nft/rpg404/texture/pants/%s_1.png" % [MgrNft.NFT_TRAITS.pants],
			"https://rpg404.com/nft/rpg404/texture/pants/%s_2.png" % [MgrNft.NFT_TRAITS.pants]
		]
		_download_pants_texture()
		visible = true
	elif MgrNft.is_strxngers():
		visible = false
	else:
		push_warning("Wrong NFT pants traits.")


func _download_pants_texture() -> void:
	K.http_download_texture(HTTPRequest, TMP_RPG404_PANTS_FILES[frame_idx], image_urls[frame_idx])


func _on_HTTPRequest_request_completed(result, response_code, _headers, _body):
	var texture = K.http_request_completed(result, response_code, TMP_RPG404_PANTS_FILES[frame_idx])
	if texture:
		self.frames.add_frame(ANIM_NAME, texture, frame_idx)
		frame_idx += 1
		if frame_idx < TMP_RPG404_PANTS_FILES.size():
			_download_pants_texture()
