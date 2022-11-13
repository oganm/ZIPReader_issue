extends Button


var download_path = 'down/zip.zip'
var download_link = 'https://github.com/oganm/ZIPReader_issue/archive/refs/heads/main.zip'

func _ready():
	pressed.connect(self._on_pressed)


func _on_pressed():
	DirAccess.remove_absolute(download_path)
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._download_completed)
	http_request.request(download_link)
	
	

func _download_completed(result, response_code, headers, body):
	var install_directory = download_path.get_base_dir()
	DirAccess.make_dir_recursive_absolute(install_directory)
	
	var f:FileAccess = FileAccess.open(download_path,FileAccess.WRITE)
	f.store_buffer(body)
	f = null
	
	var reader = ZIPReader.new()
	var err = reader.open(download_path)
	print(err)
	if err != OK:
		push_error('An error occured reading the zip file')
		return err
	else:
		print("I'm good")
