# @copyright Rug Pull Games
# @see Rug Pull Games: https://rug-pull.games/
# @see RPG 404: https://rpg404.com/
# @author endaye.eth, Fried Egg Fendi

extends Control

# nodes
onready var Version: Label = $BtnGodot/Version
onready var BtnShareEffect: AnimatedSprite = $BtnShare/BtnEffect

### default


func _ready():
	_bind_events()
	self.visible = false


func _process(_dt):
	if G.game_state == K.GameState.END:
		_check_input()


### private


func _bind_events():
	var error_code = Events.connect("game_ready", self, "_hide_gui")
	assert(error_code == OK, error_code)
	error_code = Events.connect("game_end", self, "_show_gui")
	assert(error_code == OK, error_code)


func _show_gui():
	self.visible = true
	BtnShareEffect.playing = true


func _hide_gui():
	self.visible = false
	BtnShareEffect.playing = false


func _check_input():
	if Input.is_action_just_pressed("ui_accept"):
		_restart_game()


func _restart_game():
	Events.emit_signal("game_ready")


func _on_BtnRestart_pressed():
	_restart_game()

func _on_BtnCopyright_pressed():
	var error_code = OS.shell_open("https://rpg404.com/")
	assert(error_code == OK, error_code)
