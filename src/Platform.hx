package;

import openfl.display.Sprite;

/**
 * ...
 * @author Me
 */
class Platform extends Sprite
{
    
	private var platformSpeed:Int;
	
	public function new() 
	{
		super();
		this.graphics.beginFill(0xffffff);
		this.graphics.drawRect(0, 0, 15, 100);
		this.graphics.endFill();
	}
	
	public function setPlatformSpeed(speed:Int)
	{
		platformSpeed = speed;
	}
	
	public function getPlatformSpeed():Int
	{
		return platformSpeed;
	}
	
}