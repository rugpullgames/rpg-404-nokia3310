# @copyright Rug Pull Games
# @see Rug Pull Games: https://rug-pull.games/
# @see RPG 404: https://rpg404.com/
# @author endaye.eth, Fried Egg Fendi

extends Sprite

const TMP_RPG404_JACKET_FILE = "user://rpg404_jacket.png"

onready var HTTPRequest: HTTPRequest = $HTTPRequest

### default


func _ready():
	_bind_events()


### private


func _bind_events() -> void:
	var error_code = Events.connect("update_traits", self, "_reset")
	assert(error_code == OK, error_code)


func _reset() -> void:
	_reset_jacket_type()


func _reset_jacket_type() -> void:
	if MgrNft.is_rpg404() and MgrNft.NFT_TRAITS.jacket:
		_download_jacket_texture()
		visible = true
	elif MgrNft.is_strxngers():
		visible = false
	else:
		push_warning("Wrong NFT jacket traits.")


func _download_jacket_texture() -> void:
	var image_url = (
		"https://rpg404.com/nft/rpg404/texture/jacket/%s.png"
		% [MgrNft.NFT_TRAITS.jacket]
	)
	K.http_download_texture(HTTPRequest, TMP_RPG404_JACKET_FILE, image_url)


func _on_HTTPRequest_request_completed(result, response_code, _headers, _body):
	var texture = K.http_request_completed(result, response_code, TMP_RPG404_JACKET_FILE)
	if texture:
		self.texture = texture
