package  
{
	import events.*;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author CosminDolha.com
	 */
	public class DataDispatcher extends EventDispatcher
	{
		private var logEvent:LogEvent;
		private var downloadVideoEvent:DownloadVideoEvent;
		private var playBytesEvent:PlayByteArrayEvent;
		private var videoDurationEvent:VideoDurationEvent;
		
		
		
		public function currentVideoDuration(data:Number):void
		{
			videoDurationEvent = new VideoDurationEvent(VideoDurationEvent.VIDEO_DURATION, data);
			
			dispatchEvent(videoDurationEvent);
		}
		public function downloadVideo(data:String):void
		{
			downloadVideoEvent = new DownloadVideoEvent(DownloadVideoEvent.START_DOWNLOAD, data);
			
			dispatchEvent(downloadVideoEvent);
		}
		public function log(data:String):void
		{
			logEvent = new LogEvent(LogEvent.ONLOG, data);
			
			dispatchEvent(logEvent);
			
		}		
		public function playBytes(data:ByteArray):void
		{
			playBytesEvent = new PlayByteArrayEvent(PlayByteArrayEvent.PLAY_BYTES, data);
			
			dispatchEvent(playBytesEvent);
			
		}
		
	}

}