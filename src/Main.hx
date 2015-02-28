package ;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import openfl.events.KeyboardEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

enum GameState {
		Paused;
		Playing;
}

enum Player {
	Human;
	AI;
}

class Main extends Sprite 
{
	
	private var platform1:Platform;
	private var platform2:Platform;
	private var circle:Circle;
	
	private var scorePlayer:Int;
	private var scoreAI:Int;
	
	private var scoreField:TextField;
	private var messageField:TextField;
	
	private var currentGameState:GameState;
	
	private var arrowKeyUp:Bool;
	private var arrowKeyDown:Bool;
	private var wKeyUp:Bool;
	private var sKeyDown:Bool;
	
	private var platformSpeed:Int;
	private var ballSpeed:Int;

	var inited:Bool;
	

	/* ENTRY POINT */
	
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
	}
	
	function init() 
	{
		if (inited) return;
		inited = true;
		
		platform1 = initPlatform(5, 200, 7);
		platform2 = initPlatform(480, 200, 7);

		circle = initCircle(250, 250, 7);
		
		scorePlayer = 0;
		scoreAI = 0;
		
		arrowKeyUp = false;
		arrowKeyDown = false;
		
		initScoreTextField();
		initStateMessageTextField();
		
		setGameState(Paused);
		initEvents();
		
		render();
	}
	
	function initPlatform(x:Int, y:Int, speed:Int):Platform
	{
		var platform:Platform = new Platform();
		platform.x = x;
		platform.y = y;
		
		platform.setPlatformSpeed(speed);
		
		return platform;
	}
	
	function initCircle(x:Int, y:Int, speed:Int):Circle
	{
		var circle:Circle = new Circle();
		circle.x = x;
		circle.y = y;
		
		circle.setCircleSpeed(speed);
		
		return circle;
	}
	
	function initEvents()
	{
		stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		
		this.addEventListener(Event.ENTER_FRAME, everyFrame);
	}
	
	function render()
	{
		this.addChild(platform1);
		this.addChild(platform2);
		this.addChild(circle);
		
	}
	
	function initScoreTextField()
	{
		var scoreFormat:TextFormat = new TextFormat("Verdana", 24, 0xbbbbbb, true);
		scoreFormat.align = TextFormatAlign.CENTER;

		scoreField = new TextField();
		addChild(scoreField);
		scoreField.width = 500;
		scoreField.y = 30;
		scoreField.defaultTextFormat = scoreFormat;
		scoreField.selectable = false;
	}
	
	function initStateMessageTextField()
	{
		var messageFormat:TextFormat = new TextFormat("Verdana", 18, 0xbbbbbb, true);
		messageFormat.align = TextFormatAlign.CENTER;

		messageField = new TextField();
		addChild(messageField);
		messageField.width = 500;
		messageField.y = 450;
		messageField.defaultTextFormat = messageFormat;
		messageField.selectable = false;
		messageField.text = "Press SPACE to start\nUse ARROW KEYS to move your platform";
	}
	
	private function everyFrame(event:Event):Void {
		if (currentGameState == Playing) {
			var firstPlatfromSpeed:Int = platform1.getPlatformSpeed();
			var secondPlatfromSpeed:Int = platform2.getPlatformSpeed();
			
			if (arrowKeyUp) {
				platform1.y -= firstPlatfromSpeed;
			}
			if (arrowKeyDown) {
				platform1.y += firstPlatfromSpeed;
			}
			
			if (wKeyUp) {
				platform2.y -= secondPlatfromSpeed;
			}
			if (sKeyDown) {
				platform2.y += secondPlatfromSpeed;
			}
			
			if (platform1.y < 5) platform1.y = 5;
			if (platform1.y > 395) platform1.y = 395;
			
			circle.x += circle.getCircleX();
		    circle.y += circle.getCircleY();
			
		    if (circle.y < 5 || circle.y > 495) circle.setCircleY(circle.getCircleY() * (-1));
			
		    if (circle.x < 5) winGame(AI);
		    if (circle.x > 495) winGame(Human);
			
			if (circle.getCircleX() < 0 && circle.x < 30 && circle.y >= platform1.y && circle.y <= platform1.y + 100) {
				bounceBall();
				circle.x = 30;
			}
			
			if (circle.getCircleX() > 0 && circle.x > 470 && circle.y >= platform2.y && circle.y <= platform2.y + 100) {
				bounceBall();
				circle.x = 470;
			}
			
			if (platform2.y < 5) platform2.y = 5;
				if (platform2.y > 395) platform2.y = 395;
			}
	}
	
	private function winGame(player:Player):Void {
		if (player == Human) {
			scorePlayer++;
		} else {
			scoreAI++;
		}
		setGameState(Paused);
	}
	
	private function updateScore():Void {
		scoreField.text = scorePlayer + ":" + scoreAI;
	}
	
	private function keyDown(event:KeyboardEvent):Void {
		if (currentGameState == Paused && event.keyCode == 32) {
			setGameState(Playing);
		} else if(event.keyCode == 38){
			arrowKeyUp = true;
		} else if(event.keyCode == 40){
			arrowKeyDown = true;
		} else if (event.keyCode == 87) { // W
			wKeyUp = true;
		} else if (event.keyCode == 83) { // S
			sKeyDown = true;
		}
	}
	
	private function keyUp(event:KeyboardEvent):Void {
		if (event.keyCode == 38) { // Up
			arrowKeyUp = false;
		}else if (event.keyCode == 40) { // Down
			arrowKeyDown = false;
		}else if(event.keyCode == 87) { // W
			wKeyUp = false;
		}else if (event.keyCode == 83) { // S
			sKeyDown = false;
		}
	}
	
	private function setGameState(state:GameState):Void {
		currentGameState = state;
		updateScore();
		if (state == Paused) {
			messageField.alpha = 1;
		}else {
			messageField.alpha = 0;
			platform1.y = 200;
			platform2.y = 200;
			circle.x = 250;
		    circle.y = 250;
		    var direction:Int = (Math.random() > .5)?(1):( -1);
			var randomAngle:Float = (Math.random() * Math.PI / 2) - (Math.PI / 4);
			circle.setCircleX(direction * Math.cos(randomAngle) * circle.getCircleSpeed());
			circle.setCircleY(Math.sin(randomAngle) * circle.getCircleSpeed());
		}
	}
	
	private function bounceBall():Void {
		var direction:Int = (circle.getCircleX() > 0)?( -1):(1);
		var randomAngle:Float = (Math.random() * Math.PI / 2) - (Math.PI / 4);
		circle.setCircleX(direction * Math.cos(randomAngle) * circle.getCircleSpeed());
		circle.setCircleY(Math.sin(randomAngle) * circle.getCircleSpeed());
	}

	/* SETUP */

	public function new() 
	{
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
		//
	}
}