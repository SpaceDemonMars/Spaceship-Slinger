extends Node

#How do we want the score to work?
#num times successfully reached goal without dying?
#should we also multiply it by the timer as a speed bonus?
#we could do totalScore = sum(score = expectedTime/actualTime)
var highScore: int = 0


#Global Settings
var mainMenu: PackedScene = preload("res://Scenes/main_menu.tscn")
var settingsMenu: PackedScene = preload("res://Scenes/settings_menu.tscn")
var settingsOpen: bool = false
#audio
var masterVol: float = 0
var bgmVol: float = 0
var sfxVol: float = 0
#other settings i havent though of yet
