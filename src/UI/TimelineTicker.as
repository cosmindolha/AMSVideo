package UI 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author CosminDolha.com
	 */
	public class TimelineTicker extends Sprite
	{
		
		public function TimelineTicker(label:String) 
		{
			var textField:TextField = new TextField();
			textField.selectable = false;
			var format:TextFormat = new TextFormat();
			format.font = "Verdana";
            format.color = 0xc9c9c9;
            format.size = 9;
			
			textField.defaultTextFormat = format;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.text = label;
			
			addChild(textField);
			textField.x = -textField.width / 2+1;
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0x434343);
			shape.graphics.drawRect(0, 0, 2, 10);
			shape.graphics.endFill();
			
			addChild(shape);
			
			
			shape.y = 15;
			
	
		}
		
	}

}