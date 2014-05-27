package UI 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author CosminDolha.com
	 */
	public class SButton extends Sprite
	{
		
		private var _button:myButton;
		public function SButton(label:String, x:int, y:int, handler:Function = null) 
		{
			_button = new myButton();
			_button.label.selectable = false;
			_button.label.mouseEnabled = false;
			_button.useHandCursor = true;
			_button.buttonMode = true;
			
			_button.bg_over.visible = false;
			
			_button.label.text = label;
			
			_button.x = x;
			_button.y = y;
			
			
			_button.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			_button.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			if (handler != null) _button.addEventListener(MouseEvent.CLICK, handler);
			addChild(_button);
		}
		private function onOut(e:MouseEvent):void
		{
			_button.bg_over.visible = false;
			_button.bg_normal.visible = true;
			
		}		
		private function onOver(e:MouseEvent):void
		{
			_button.bg_over.visible = true;
			_button.bg_normal.visible = false;
			
		}
		public function set label(str:String):void
		{
			_button.label.text = str;
		}
	}

}