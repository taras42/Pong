package;

import openfl.display.Sprite;
import openfl.geom.Point;
/**
 * ...
 * @author Me
 */
class Circle extends Sprite
{
	
	private var circlePoint:Point;
	private var circleSpeed:Int;
	
	public function new() 
	{
		super();
		render();
		init();
	}
	
	function init()
	{
		circlePoint = new Point(0, 0);
	}
	
	function render()
	{
		this.graphics.beginFill(0xffffff);
		this.graphics.drawCircle(0, 0, 10);
		this.graphics.endFill();
	}
	
	public function setCircleX(x:Float)
	{
		circlePoint.x = x;
	}
	
	public function setCircleY(y:Float)
	{
		circlePoint.y = y;
	}
	
	public function getCircleX():Float
	{
		return circlePoint.x;
	}
	
	public function getCircleY():Float
	{
		return circlePoint.y;
	}
	
	public function setCircleSpeed(speed:Int)
	{
		circleSpeed = speed;
	}
	
	public function getCircleSpeed():Int
	{
		return circleSpeed;
	}
}