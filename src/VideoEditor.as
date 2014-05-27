package  
{
	import com.zoharbabin.bytearray.flv.FlvWizard;
	




	import flash.net.FileReference;
	import flash.net.NetConnection;
	import flash.net.NetStream;


	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author CosminDolha.com
	 */
	public class VideoEditor 
	{
		private var dataDispatcher:DataDispatcher;
		private var flvwiz:FlvWizard;
		
		
		
		
		public function VideoEditor(disp:DataDispatcher) 
		{
		
			dataDispatcher = disp;
			
			flvwiz = new FlvWizard ();

		}
		public function randomSlice(videoBytes:ByteArray):void
		{
			var streams:Vector.<ByteArray> = new Vector.<ByteArray>();
			dataDispatcher.log("\n start slicing 50 times, randomly");
			for (var i:int = 0; i < 50;i++ )
			{
				var from:Number =  rnd(1000, 50000);
				var to:Number =  rnd(from, 60000);
				
				var slicedByteArray:ByteArray = flvwiz.slice(videoBytes, from, to);
				
				streams.push(slicedByteArray);
			}
			dataDispatcher.log("\n end slicing, starting to combine streams");
			var mergedBytes:ByteArray = flvwiz.concatStreams(streams);
			dataDispatcher.log("\n streams merged, play new byte array stream");
			dataDispatcher.playBytes(mergedBytes);
			
		}
				//returns a random number 
		private function rnd(min:Number, max:Number):Number
		{
			var randomNum:Number = Math.floor(Math.random()*(max-min+1))+min;
			return randomNum;
		}

	}

}