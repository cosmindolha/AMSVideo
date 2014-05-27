package UI 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author CosminDolha.com
	 */
	public class TimelineClip extends Sprite
	{
		private var shape:Shape;
		private var shapeAlpha:Shape;
		private var _infoObject:Object;
		
		public var _in:Number;
		public var _out:Number;
		public function TimelineClip(obj:Object) 
		{
			_infoObject = obj;
			
			shape = new Shape();
			shape.graphics.lineStyle(1, 0x999999, 1);
			shape.graphics.beginFill(0x333333);
			shape.graphics.drawRect(0, 0, infoObject._width, 200);
			shape.graphics.endFill();
			
			shapeAlpha = new Shape();
			shapeAlpha.graphics.beginFill(0xffffff, 0.1);
			shapeAlpha.graphics.drawRect(0, 0, infoObject._width, 30);
			shapeAlpha.graphics.endFill();
			
			
			var clickable:Sprite = new Sprite();
			
			clickable.addChild(shapeAlpha);
			clickable.buttonMode = true;
			clickable.useHandCursor = true;
			
			addChild(shape);
			addChild(clickable);
			
			clickable.y = -40;
		}
		
		public function get infoObject():Object 
		{
			return _infoObject;
		}

		
	}

}