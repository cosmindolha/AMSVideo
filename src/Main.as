package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author CosminDolha.com
	 */
	public class Main extends Sprite 
	{
		private var gui:GUI;
		
		private var dataDispatcher:DataDispatcher;
		private var dataManager:DataManager;
		
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			
			dataDispatcher = new DataDispatcher();
			
			
			
			gui = new GUI(dataDispatcher);
			
			
			
			dataManager = new DataManager(dataDispatcher);
			
			addChild(gui);
		}
		
	}
	
}