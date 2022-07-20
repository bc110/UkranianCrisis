extends Node

var network = NetworkedMultiplayerENet.new()
var port = 1909
var max_players = 100

var points_dict = {"White": 50, "Yellow": 75, "Orange": 100}

var ukrane = null
var russia = null

func _ready():
	StartServer()
	print(points_dict["White"])

func StartServer():
	network.create_server(port,max_players)
	get_tree().set_network_peer(network)
	print("Server started")
	
	network.connect("peer_connected",self,"_Peer_Connected")
	network.connect("peer_disconnected",self,"_Peer_Disconnected")

func _Peer_Connected(player_id):
	print("User "+str(player_id)+" Connected")
	
	var data
	
	if ukrane == null:
		data = {"Nation":"UA","PlayerPrestege":16,"EnemyPrestege":32}
		ukrane = player_id
		rpc_id(player_id,"SetStart",data)
	
	elif russia == null:
		data = {"Nation":"RU","PlayerPrestege":32,"EnemyPrestege":16}
		russia = player_id
		rpc_id(player_id,"SetStart",data)

func _Peer_Disconnected(player_id):
	print("User "+str(player_id)+" Disconnected")
	if player_id == ukrane:
		ukrane = null
	elif player_id == russia:
		russia = null

remote func SendData(move_data,requester):
	var player_id = get_tree().get_rpc_sender_id()
	"""
	rpc_id(player_id,"ReturnData",requester)
	print("dataRecived")
	print(move_data["MoveType"])
	if(move_data["MoveType"]=="SelectOrder"):
		print(move_data["Order"])
	"""
	if player_id == ukrane:
		rpc_id(russia,"ReturnData",move_data,requester)
	elif player_id == russia:
		rpc_id(ukrane,"ReturnData",move_data,requester)
