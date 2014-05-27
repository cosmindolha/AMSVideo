package  
{
	import flash.display.Sprite;
	import flash.display.SWFVersion;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import UI.SButton;
	import events.*;
	import flash.system.Capabilities;

			
	/**
	 * ...
	 * @author CosminDolha.com
	 */
	public class GUI extends Sprite
	{
		private var videoPlayer:VideoPlayer;
		private var timeline:Timeline;
		private var loadVideoButton:SButton;
		
		private var dataDispatcher:DataDispatcher;
		private var randomize:SButton;
		
		private var videoEditor:VideoEditor;
		private var videoBytes:ByteArray;
		private var timelineDataArray:Array;
		

		
		public function GUI(disp:DataDispatcher) 
		{
			
	
			
			dataDispatcher = disp;
			
			
			
			dataDispatcher.addEventListener(LogEvent.ONLOG, logMessage);
			
			
			
			videoPlayer = new VideoPlayer(dataDispatcher);
			//videoPlayer.addEventListener(Event.ADDED_TO_STAGE, onVideoAddedToStage);
			
			addChild(videoPlayer);
			
			loadVideoButton = new SButton("Gen Rnd clips", 620, 10, playVideo);
			
			var createOutputButton:SButton = new SButton("Play Gen Video", 750, 10, playGenVideo);
			
			var publishVideoButton:SButton = new SButton("Publish Video", 880, 10, publishVideo);
			
			
			addChild(publishVideoButton);
			addChild(createOutputButton);
			addChild(loadVideoButton);

			
			timeline = new Timeline(videoPlayer);
			addChild(timeline);
			timeline.y = 450;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			//videoEditor = new VideoEditor(dataDispatcher);
			
		}
		private function onAdded(e:Event):void 
		{
			var delayTimer:Timer = new Timer(10, 1);
			delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, done);
			
			function done(e:TimerEvent):void
			{
				dataDispatcher.log("Compiled flash player version " + String(loaderInfo.swfVersion));
			}
			delayTimer.start();
		}
		private function publishVideo(e:MouseEvent):void 
		{
			videoPlayer.publishVideo(timelineDataArray);
			
		}
		private function playGenVideo(e:MouseEvent):void 
		{
			videoPlayer.playVideo("mp4:saved2.f4v");
		}
		private function logMessage(e:LogEvent):void 
		{
			timeline.nfo.appendText("\n"+e.customData);
			timeline.nfo.scrollV = timeline.nfo.maxScrollV;
			
		}

		private function playVideo(e:MouseEvent):void 
		{

			createEditedList();
		}
		

		private function createEditedList():void
		{
			timelineDataArray = new Array();
			
			
			
			for (var i:int = 0; i < 15; i++)
			{
			//var s1:int = rnd(10, 603);
			var s1:int = rnd(1, 120);
			var s2:int = rnd(s1, s1 + 5);
			
			var clipObject:Object = new Object();
			clipObject.start = s1;
			clipObject.end = s2;
			clipObject.source = "mp4:"+rnd(1, 3)+".mp4";	
			
			
			timelineDataArray.push(clipObject);
			
			}
			
			timeline.refreshTimeline(timelineDataArray);
			videoPlayer.playTimeline(timelineDataArray);
		}

		
		//returns a random number 
		private function rnd(min:Number, max:Number):Number
		{
			var randomNum:Number = Math.floor(Math.random()*(max-min+1))+min;
			return randomNum;
		}
	}

}