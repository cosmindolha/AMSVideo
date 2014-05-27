package  
{
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import flash.events.Event;
	import events.*;
		
	/**
	 * ...
	 * @author CosminDolha.com
	 */
	public class DataManager 
	{
		private var dataDispatcher:DataDispatcher;
		private var videoLoader:URLLoader;
		
		public function DataManager(disp:DataDispatcher) 
		{
			dataDispatcher = disp;
			
			dataDispatcher.addEventListener(DownloadVideoEvent.START_DOWNLOAD, startDownloading);
			
			
		}
		private function downloaded(event:Event):void 
		{
			var byteArray:ByteArray = videoLoader.data;
			
			dataDispatcher.log("\n Video downloaded");
			
			
		}
		private function startDownloading(e:DownloadVideoEvent):void
		{
			downloadVideo(e.customData);
			
		}
		private function downloadVideo(path:String):void
		{
			
			videoLoader = new URLLoader();
			
			videoLoader.addEventListener(Event.COMPLETE, downloaded);
			videoLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			
			videoLoader.dataFormat = URLLoaderDataFormat.BINARY;
			videoLoader.load(new URLRequest(path));
		}
		private function onProgress(e:ProgressEvent):void
		{
			var percent:Number = (e.bytesLoaded / e.bytesTotal) * 100;
			
			dataDispatcher.log("\n Video downloading " + percent + "%");
		}
	}

}