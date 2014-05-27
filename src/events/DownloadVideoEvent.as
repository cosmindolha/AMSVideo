package events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author CosminDolha.com
	 */
	public class DownloadVideoEvent extends Event
	{
		public static const START_DOWNLOAD:String = "startdownload";
		public var customData:String;
		
		public function DownloadVideoEvent(type:String, customData:String, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			this.customData = customData;
			super(type, bubbles, cancelable);
		}
		override public function clone():Event 
		{
			return new DownloadVideoEvent(type, customData, bubbles, cancelable);
		}
		
	}

}