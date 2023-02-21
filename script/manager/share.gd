# Version
# @see Hidden Moss: https://hiddenmoss.com/
# @see Miss. Peacock: https://miss-peacock.com/
# @author Yuancheng Zhang
extends Button

const IMG_PATH = "user://twitter_share.png"
const IMGBB_API = "https://api.imgbb.com/1/upload"
const IMGBB_API_KEY = "7cf64b5f782a1afca533fd0d150c09cd"
const IMGBB_IMG_NAME = "rpg404"

var image = Image.new()
var img
var img_exists = File.new()
var tex = ImageTexture.new()

onready var Http: HTTPRequest = $HTTPRequest


func _ready():
	# Load image
	if img_exists.file_exists(IMG_PATH):
		image.load(IMG_PATH)
		tex.create_from_image(image)


func _send_https():
	# print("_send_https")
	var file = File.new()
	file.open(IMG_PATH, File.READ)
	var file_content = file.get_buffer(file.get_len())

	var use_ssl = true
	var params = [
		"key=%s" % IMGBB_API_KEY,
		"name=%s" % IMGBB_IMG_NAME,
	]

	var body = PoolByteArray()
	body.append_array("\r\n--WebKitFormBoundaryRPG404".to_utf8())
	body.append_array(
		'\r\nContent-Disposition: form-data; name="image"; filename="rpg404.png"\r\n'.to_utf8()
	)
	body.append_array("Content-Type: image/png\r\n".to_utf8())
	body.append_array("Content-Transfer-Encoding: base64\r\n".to_utf8())
	body.append_array("\r\n".to_utf8())
	body.append_array(file_content)
	body.append_array("\r\n".to_utf8())
	body.append_array("--WebKitFormBoundaryRPG404--".to_utf8())
	body.append_array("\r\n".to_utf8())

	# print(body.size())
	var headers = [
		"Content-Type: multipart/form-data; charset=utf-8; boundary=WebKitFormBoundaryRPG404",
		"Content-Length: " + str(body.size()),
	]

	var url = IMGBB_API + "?" + PoolStringArray(params).join("&")
	var error = Http.request_raw(url, headers, use_ssl, HTTPClient.METHOD_POST, body)
	if error != OK:
		print(error)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	# print("hahah")
	# print(result)
	# print(response_code)
	# print(headers)
	# print(body)
	var json = JSON.parse(body.get_string_from_utf8())

	var url = json.result.data.url_viewer
	print(url)
	var shareLink = (
		"https://twitter.com/intent/tweet?"
		+ "text="
		+ ("My record is %s on RPG404.com. \n" % str(G.score)).percent_encode()
		+ "&url="
		+ url.percent_encode()
		+ "&hashtags=rpg404,rpg,indiegame,indiedev,IndieGameDev,pixelart,Mozart,GodotEngine,web3,nft,gamefi"
		+ "&via=rug_pull_games"
	)

	if MgrNft.is_strxngers():
		shareLink = (
			"https://twitter.com/intent/tweet?"
			+ "text="
			+ ("My record is %s on RPG404.com. \n@StrxngersNFT \n" % str(G.score)).percent_encode()
			+ "&url="
			+ url.percent_encode()
			+ "&hashtags=cc0,rpg404,strxngers,indiegame,pixelart,GodotEngine,web3,nft,gamefi"
			+ "&via=rug_pull_games"
		)

	# print(shareLink)

	var error_code = OS.shell_open(shareLink)
	assert(error_code == OK, error_code)


func _on_BtnShare_pressed():
	# Get screenshot from screen
	img = get_viewport().get_texture().get_data()
	img.flip_y()

	# Use twitter card size 800*418
	var width = img.get_width()
	img.crop(width, int(width * 0.5225))

	# Save screenshot as png
	img.save_png(IMG_PATH)

	# Create texture for it
	tex.create_from_image(img)

	if img_exists.file_exists(IMG_PATH):
		_send_https()
