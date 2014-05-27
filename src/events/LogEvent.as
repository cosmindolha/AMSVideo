package events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author CosminDolha.com
	 */
	public class LogEvent extends Event
	{
		public static const ONLOG:String = "onlog";
		public var customData:String;
		
		public function LogEvent(type:String, customData:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			this.customData = customData;
			super(type, bubbles, cancelable);
		}
		override public function clone():Event 
		{
			return new LogEvent(type, customData, bubbles, cancelable);
		}
		
	}

}