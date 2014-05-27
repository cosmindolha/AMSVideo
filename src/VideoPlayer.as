package 
{
	/**
	 * ...
	 * @author CosminDolha.com
	 */
	
	import flash.net.Responder;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.net.NetStreamAppendBytesAction;

	
		
	public class VideoPlayer extends Sprite 
	{
		private var videoUI:VideoUI;
		
		private var video:Video;
		private var nc:NetConnection;
		private var ns:NetStream;
		private var videoListener:Object;
		private var volumeSt:SoundTransform;
		
		private var vidDuration:int;
		private var vidRatio:Number;
		private var vidW:int;
		private var vidH:int;
		private var progressTimer:Timer;
		
		private var bgVideo:Sprite;
		
		private var _stage:Stage;
		private var pathToVideo:String;
		private var videoPlaying:Boolean;
		private var tags:Array;
		private var totalBytes:ByteArray;
		private var seekPos:Number;
		
		private var dataDispatcher:DataDispatcher;
		private var responder:Responder;
		private var timelineArray:Array;
		private var checkTimelineProgress:Timer;
		private var totalTimelineTime:Number;
		private var currentClipIndex:int;
		private const server:String = "rtmp://localhost/videoeditor";;
		private var recordingDuration:Number;
		private var streamIsPlaying:Boolean;

		
		public function VideoPlayer(disp:DataDispatcher):void 
		{
			
			
			dataDispatcher = disp;
			
			addEventListener(Event.ADDED_TO_STAGE, omAddedToStage);
			
			progressTimer = new Timer(100,1);
			progressTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerProgress);

			
		}
		public function seek(data:Number):void 
		{
			//trace(data)
			if (streamIsPlaying)
			{
				ns.pause();
			}
			ns.seek(Number(vidDuration.toPrecision(2)) * data);
			
		}
		public function pause():void 
		{
			ns.pause();
			videoUI.playBt.visible = true;
			
			videoUI.pauseBt.visible = false;
		}
		public function get videoTime():Number
		{
			return ns.time;
		}
		private function timerProgress(event:TimerEvent):void
		{

			trace(" bytesLoaded=" + ns.bytesLoaded + " bytesTotal=" + ns.bytesTotal);
			videoUI.seekMc.prog.scaleX = ns.bytesLoaded/ns.bytesTotal;
			if (ns.bytesLoaded < ns.bytesTotal)
			{
				progressTimer.start();
			}
		}
		private function omAddedToStage(e:Event):void
		{
			buildUI();
			
			
			
			_stage = this.stage;
		}
		private function everyFrame(e:Event):void
		{
			videoUI.seekMc.playIndicater.curTime.text = getTime(ns.time);
			videoUI.seekMc.progPlay.scaleX = ns.time / vidDuration;
			videoUI.seekMc.playIndicater.x =  (videoUI.seekMc.seekArea.width)*videoUI.seekMc.progPlay.scaleX;
			
		}
		private function netStatusHandlerFMS(event:NetStatusEvent):void{ 
   // trace("event.info.level: " + event.info.level + "\n", "event.info.code: " + event.info.code); 
    switch (event.info.code){ 
        case "NetConnection.Connect.Success": 
            // Call doPlaylist() or doVideo() here. 
            onFMSConnected();
             break; 
        case "NetConnection.Connect.Failed": 
            // Handle this case here. 
            break; 
        case "NetConnection.Connect.Rejected": 
            // Handle this case here. 
            break; 
         case "NetStream.Play.Stop": 
            // Handle this case here. 
            break; 
         case "NetStream.Play.StreamNotFound": 
            // Handle this case here. 
            break; 
         case "NetStream.Publish.BadName": 
             trace("The stream name is already used"); 
            // Handle this case here. 
             break; 
     } 
}
		
		private function onFMSConnected():void
		{
					
			ns = new NetStream(nc);
			
			ns.inBufferSeek = true; 
			
			ns.bufferTime = 0.1; 
			ns.backBufferTime = 0.1; 
			video.attachNetStream(ns);
			

			
			
			videoListener = new Object();
			videoListener.onMetaData = function(md:Object):void { };
			
			ns.client = videoListener;
			
			ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);

			volumeSt = new SoundTransform();
			volumeSt.volume = 0;
			ns.soundTransform = volumeSt;
			
			this.stage.addEventListener(Event.ENTER_FRAME, everyFrame);
			
			setupVideoControlls();
			
			//getVideoList();
			dataDispatcher.log("connected to FMS");
			
		}
		private function createConnection():void
		{
			nc = new NetConnection();
			var ncClient:Object = new Object();
			
			//get info from media server
			
			ncClient.videoSavedToDisk =  function():void {
				
				dataDispatcher.log("video saved to disk");
				
				//play saved video
				
				playVideo("mp4:saved.f4v");
			}
			
			nc.client = ncClient;
			
			nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandlerFMS); 
			
			nc.connect(server);
			dataDispatcher.log("connecting to server "+ server);
			
		}
		public function publishVideo(data:Array):void
		{
			dataDispatcher.log("publising video, saving to disk");
			
			var myResponder:Responder = new Responder(onResult); 
			
			nc.call("saveEditedVideoToDisk", myResponder, data);
			
			function onResult(result:Boolean):void
			{ 
				trace(result);
				
			}
		}
		private function getVideoEidtedStream(data:Array):void
		{
			
			
			
			var myResponder:Responder = new Responder(onVideoEditedStream); 
			
			nc.call("getVideoEidtedPreview", myResponder, data);	
			
		}
		private function getVideoList():void 
		{ 
			nc.call("getFilesSource", new Responder(onVideoListSource)); 
		
		}
		private function onVideoEditedStream(recDuration:Number):void
		{
			dataDispatcher.log("video preview, seconds length: " + recDuration);
			recordingDuration = recDuration;
			if(recDuration != -1){
			
				playVideo("mp4:recStream.f4v");
				
				dataDispatcher.log("preview edits");
			
			}else {
				dataDispatcher.log("preview failed");
			}
		}
		private function onVideoListSource(vidArray:Array):void
		{
			//trace(vidArray[0])
		}
		private function buildUI():void
		{
			bgVideo = new Sprite();
			
			var bgShape:Shape = new Shape();
			
			bgShape.graphics.beginFill(0x000000);
			bgShape.graphics.drawRect(0, 0, 600, 400);
			bgShape.graphics.endFill();
			bgVideo.addChild(bgShape);
			addChild(bgVideo);
			
			video = new Video();			
			addChild(video);
			videoUI = new VideoUI();
			addChild(videoUI);
			
			videoUI.y = 405;
			videoUI.x = 0;
			
			videoUI.seekMc.progPlay.scaleX = 0;
			videoUI.seekMc.prog.scaleX = 0;
			
			videoUI.vol.maskMc.scaleX = 0.5;
			
			
			createConnection();
			
			
		}
		private function setupVideoControlls():void
		{
			videoPlaying = true;
			
			function showPlayPause():void
			{
				videoUI.playBt.visible = videoPlaying;
				videoPlaying =! videoPlaying;
				videoUI.pauseBt.visible = videoPlaying;
			}
			function playClick(e:MouseEvent):void
			{
				showPlayPause();
				ns.resume();
			}
			function pauseClick(e:MouseEvent):void
			{
				ns.pause();
				showPlayPause();
			}
			function prevClick(e:MouseEvent):void
			{
				
			}
			function nextClick(e:MouseEvent):void
			{
			
			}
			videoUI.playBt.addEventListener(MouseEvent.CLICK, playClick);
			videoUI.pauseBt.addEventListener(MouseEvent.CLICK, pauseClick);

			videoUI.prevBt.addEventListener(MouseEvent.CLICK, prevClick);
			videoUI.nextBt.addEventListener(MouseEvent.CLICK, nextClick);
			
			videoUI.vol.area.buttonMode = true;
			videoUI.vol.area.useHandCursor = true;
			
			videoUI.vol.area.addEventListener(MouseEvent.MOUSE_DOWN, volDown);
			videoUI.vol.area.addEventListener(MouseEvent.MOUSE_UP, volUp);

			videoUI.seekMc.seekArea.buttonMode = true;
			videoUI.seekMc.seekArea.useHandCursor = true;
				
			videoUI.seekMc.seekArea.addEventListener(MouseEvent.MOUSE_DOWN, seekClick);
			videoUI.seekMc.seekArea.addEventListener(MouseEvent.MOUSE_UP, seekUp);
			
			videoUI.playBt.visible = false;
			videoUI.pauseBt.visible = false;
 
		}
		private function volDown(e:MouseEvent):void
		{
				_stage.addEventListener(MouseEvent.MOUSE_UP, volUp);
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, volMove);
				
				videoUI.vol.maskMc.width = videoUI.vol.mouseX;
				
				volumeSt.volume = videoUI.vol.maskMc.scaleX;
				ns.soundTransform = volumeSt;
		}
		private function volMove(e:MouseEvent):void
		{
				videoUI.vol.maskMc.width = videoUI.vol.mouseX;
				volumeSt.volume = videoUI.vol.maskMc.scaleX;
				ns.soundTransform = volumeSt;
		}
		private	function volUp(e:MouseEvent):void 
		{
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, volMove);
				_stage.removeEventListener(MouseEvent.MOUSE_UP, volUp);
		}
		private function seekUp(e:MouseEvent):void 
		{
				_stage.removeEventListener(MouseEvent.MOUSE_UP, seekUp);
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, seekMove);
				
				this.stage.addEventListener(Event.ENTER_FRAME, everyFrame);
				
		}
		private	function seekMove(e:MouseEvent):void 
		{
			
				var valPercent:Number = videoUI.seekMc.mouseX/videoUI.seekMc.width;
				//trace(valPercent.toPrecision(2))
				ns.seek(Number(vidDuration.toPrecision(2)) * valPercent);
				
								
				videoUI.seekMc.playIndicater.curTime.text = getTime(ns.time);
				videoUI.seekMc.progPlay.width = videoUI.seekMc.mouseX;
				videoUI.seekMc.playIndicater.x = videoUI.seekMc.mouseX;
				
		}
		private function seekClick(e:MouseEvent):void
		{
				this.stage.removeEventListener(Event.ENTER_FRAME, everyFrame);
		
				
				videoUI.seekMc.playIndicater.curTime.text = getTime(ns.time);
				videoUI.seekMc.progPlay.width = videoUI.seekMc.mouseX;
				videoUI.seekMc.playIndicater.x = videoUI.seekMc.mouseX;
			
			
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, seekMove);
				_stage.addEventListener(MouseEvent.MOUSE_UP, seekUp);
				
				var valPercent:Number = videoUI.seekMc.mouseX / videoUI.seekMc.width;
				
				
				
				
				//trace(Number(vidDuration.toPrecision(2))*valPercent)
				//wont work on generated data
				ns.seek(Number(vidDuration.toPrecision(2)) * valPercent);
				
				
		}
		private function netStatusHandler(event:NetStatusEvent):void 
		{
			dataDispatcher.log("netStatusHandler = " + event.info.code);
			switch (event.info.code) 
			{
			case "NetConnection.Connect.Success" :
			//progressTimer.start();
			// trace("NetConnection.Connect.Success");
			
			break;
			case "NetStream.Play.StreamNotFound" :
			  videoUI.info.text = "Stream not found: ";
			break;
			case "NetStream.Play.Stop" :
				streamIsPlaying = false;
			break;			
			case "NetStream.Play.Start" :
				streamIsPlaying = true;
				scaleCenterVideo();
			break;			
			
			case "NetStream.Video.DimensionChange" :
				scaleCenterVideo();
			break;

			}
		}
		private function getTime(sec:int):String 
		{
			var p1:String;
			var p2:String;
			var rez:String;
			var s:int = sec/60;
			var rest:int=Math.round(sec)- s * 60;
			if (s <= 9) {
				p1 = "0" + s.toString();
			} else {
				p1 = s.toString();
			}
			if (rest <= 9) {
				p2 = "0" + rest;
			} else {
				p2 = rest.toString();
			}
			rez = p1 + ":" + p2;
			return rez;
		}
		public function getStreamLength(str:String):void
		{
			
			var length:Number = 0;
			
			responder = new Responder(onResult); 
			nc.call("getStreamLength", responder, str );
			
			function onResult(result:Number):void
			{ 
				length = result;
				dataDispatcher.currentVideoDuration(length);
				
				trace("getting length ", result);
			}
			
		}
		public function playTimeline(data:Array):void
		{
			timelineArray = new Array();
			timelineArray = data;
			
			//set current clip index to 0, the start of the timeline
			
			currentClipIndex = 0;
			
			
			//check how big is the timeline
			
			totalTimelineTime = 0;
			
			for (var i:int = 0; i < timelineArray.length; i++)
			{
				var obj:Object = new Object();
				obj = timelineArray[i];
				var clipLength:Number = obj.end - obj.start;
				
				totalTimelineTime += clipLength;
			}
			
			vidDuration = totalTimelineTime;
			
			checkTimelineProgress = new Timer(10, 1);
			
			checkTimelineProgress.addEventListener(TimerEvent.TIMER, onCheckTimelineProgress);
			
			checkTimelineProgress.start();
			
			getVideoEidtedStream(data);
		}
		
		private function onCheckTimelineProgress(e:TimerEvent):void
		{
			var currentClipEndTime:Number = timelineArray[currentClipIndex].end;
			
			
			
			checkTimelineProgress.start();
			
		}
		
		public function playVideo(videoURL:String):void
		{
			videoUI.playBt.visible = false;
			videoUI.pauseBt.visible = true;
			
			if (streamIsPlaying == false)
			{
				ns.resume();
			}
			ns.close();
			videoUI.durTime.text = getTime(Math.round(recordingDuration));
			ns.play(videoURL), 0, -1;
			
			
			
		}
		private function scaleCenterVideo():void
		{
			vidW = video.videoWidth;
			vidH = video.videoHeight;
			
			var vr:Number = vidW/vidH;
			var cr:Number = bgVideo.width/bgVideo.height;
			if (vr > cr) 
			{

				video.width = bgVideo.width;

				var ratioW:Number = video.width/vidW;

				video.height = vidH*ratioW;

			} else if (vr < cr) 
			{

				video.height = bgVideo.height;

				var ratioH:Number = video.height / vidH;

				video.width = vidW * ratioH;


			}
			//trace(vr, cr)
			
				
				video.x = (bgVideo.width/2)-(video.width/2);
				video.y = (bgVideo.height/2)-(video.height/2);

		}


	}

}