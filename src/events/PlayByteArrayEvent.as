package events 
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author CosminDolha.com
	 */
	public class PlayByteArrayEvent extends Event 
	{
		
		public static const PLAY_BYTES:String = "playbytes";
		public var customData:ByteArray;
		
		public function PlayByteArrayEvent(type:String, customData:ByteArray, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			this.customData = customData;
			super(type, bubbles, cancelable);
		}
		override public function clone():Event 
		{
			return new PlayByteArrayEvent(type, customData, bubbles, cancelable);
		}
		
	}

}