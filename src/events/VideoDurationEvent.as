package events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author CosminDolha.com
	 */
	public class VideoDurationEvent extends Event
	{
		
		public static var VIDEO_DURATION:String = "videoduration";
		public var customData:Number;
		
		public function VideoDurationEvent(type:String, customData:Number, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			this.customData = customData;
			super(type, bubbles, cancelable);
		}
		override public function clone():Event 
		{
			return new VideoDurationEvent(type, customData, bubbles, cancelable);
		}
		
	}

}