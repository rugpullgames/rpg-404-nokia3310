# @copyright Rug Pull Games
# @see Rug Pull Games: https://rug-pull.games/
# @see RPG 404: https://rpg404.com/
# @author endaye.eth, Fried Egg Fendi
extends Sprite

const TMP_STRXNGER_BODY_FILE = "user://strxnger_body.png"

onready var HTTPRequest: HTTPRequest = $HTTPRequest

### default


func _ready():
	_bind_events()


### private


func _bind_events() -> void:
	var error_code = Events.connect("update_traits", self, "_reset")
	assert(error_code == OK, error_code)


func _reset() -> void:
	_reset_strxnger_body_type()


func _reset_strxnger_body_type() -> void:
	if MgrNft.is_rpg404():
		visible = false
	elif MgrNft.is_strxngers():
		visible = true
		_download_body_texture()
	else:
		push_warning("Wrong NFT Strxngers body traits.")


func _download_body_texture() -> void:
	var image_url = "https://rpg404.com/nft/strxngers/body/%s.png" % [MgrNft.nft_strxnger_token_id]
	K.http_download_texture(HTTPRequest, TMP_STRXNGER_BODY_FILE, image_url)


func _on_HTTPRequest_request_completed(result, response_code, _headers, _body) -> void:
	var texture = K.http_request_completed(result, response_code, TMP_STRXNGER_BODY_FILE)
	if texture:
		self.texture = texture
