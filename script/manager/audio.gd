# @copyright Rug Pull Games
# @see Rug Pull Games: https://rug-pull.games/
# @see RPG 404: https://rpg404.com/
# @author endaye.eth, Fried Egg Fendi

extends Control

# resource
const RES_BGM_ON = preload("res://texture/ui/btn_game_bgm_on.png")
const RES_BGM_OFF = preload("res://texture/ui/btn_game_bgm_off.png")
const RES_SFX_ON = preload("res://texture/ui/btn_game_sfx_on.png")
const RES_SFX_OFF = preload("res://texture/ui/btn_game_sfx_off.png")

const URL_BGM_STRXNGERS = "https://rpg404.com/nft/strxngers/audio/bgm/bgm_strxngers_mono.ogg"
const TMP_BGM_FILE = "user://strxnger_bgm.ogg"

# local var
var _res_bgm = "mute.ogg"
export(NodePath) var path_to_bgm
var AudioBgm: AudioStreamPlayer2D

# node
onready var BtnBgm: Button = $BtnBgmAudio
onready var BtnSfx: Button = $BtnSfxAudio
onready var HttpRequest: HTTPRequest = $HTTPRequest

### default


func _ready():
	AudioBgm = get_node(path_to_bgm)
	_bind_events()
	_update_ui()


### private


func _bind_events() -> void:
	var error_code = Events.connect("update_traits", self, "_reset")
	assert(error_code == OK, error_code)


func _reset() -> void:
	_reset_bgm_type()


func _reset_bgm_type() -> void:
	if MgrNft.is_rpg404() and MgrNft.NFT_TRAITS.music:
		if K.DATA_MUSIC.has(MgrNft.NFT_TRAITS.music):
			_res_bgm = K.DATA_MUSIC.get(MgrNft.NFT_TRAITS.music).res_bgm
			AudioBgm.stream = load("res://audio/bgm/" + _res_bgm)
		else:
			push_warning("Not found music id, " + MgrNft.NFT_TRAITS.music)
	elif MgrNft.is_strxngers():
		_download_bgm()
	else:
		push_warning("Wrong NFT cloud traits.")


func _update_ui() -> void:
	BtnBgm.icon = RES_BGM_ON if G.bgm_audio else RES_BGM_OFF
	BtnSfx.icon = RES_SFX_ON if G.sfx_audio else RES_SFX_OFF


func _on_BtnBgmAudio_pressed() -> void:
	G.bgm_audio = !G.bgm_audio
	_update_ui()


func _on_BtnSfxAudio_pressed() -> void:
	G.sfx_audio = !G.sfx_audio
	_update_ui()


func _download_bgm() -> void:
	if OS.get_name() != "HTML5":
		HttpRequest.set_use_threads(true)
	HttpRequest.set_download_file(TMP_BGM_FILE)
	var error_code = HttpRequest.request(URL_BGM_STRXNGERS)
	if error_code != OK:
		push_error("An error occurred in the HTTP request.")


func _on_HTTPRequest_request_completed(result, response_code, _headers, _body):
	if result == OK:
		if response_code == 200:
			var audio_loader = AudioLoader.new()
			AudioBgm.set_stream(audio_loader.loadfile(TMP_BGM_FILE))
			AudioBgm.volume_db = 1
			AudioBgm.pitch_scale = 1
			AudioBgm.play()
		else:
			push_warning("response_code = %s" % response_code)
	else:
		push_warning("result = %s" % result)
