package  
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Timer;
	import UI.TimelineClip;
	import UI.TimelineTicker;
	/**
	 * ...
	 * @author CosminDolha.com
	 */
	public class Timeline extends Sprite
	{
		private var numbersSprite:Sprite;
		
		
		private var timeline:TimelineUI;
		private var timelineTotalSeconds:int;
		private var _width:int;
		private var clipsHolder:Sprite;
		private var clipsSprite:Sprite;
		private var dataTimeline:Array;
		
		public var nfo:TextField;
		
		private var videoPlayer:VideoPlayer;
		private var currentClipInTimelineIndex:int;
		private var clipsArray:Array;
		private var editorCursor:TimelineCursor;
		private var timelineCursorSeekTimer:Timer;
		private var currentTimelineClipIndex:Number;
		private var timelineTimerSeekDelay:Timer;
		private var timelineCursorIsMoving:Boolean;
		private var checkIfMouseIsMoving:Timer;
		private var prevMouseX:Number;
		private var totalTime:Number;
		private var maxTimelineWidth:Number;
		
		public function Timeline(vidPlayer:VideoPlayer) 
		{
			videoPlayer = vidPlayer;
			
			
			clipsHolder = new Sprite();
			clipsSprite = new Sprite();
			
			timelineTotalSeconds = 600;
			
			_width = timelineTotalSeconds * 10;
			
			timeline = new TimelineUI();
			
			nfo = timeline.nfo;
			
			numbersSprite = new Sprite();
			
			
			
			var thickNumber:int = 0;
			var toX:int = 0;
			var num_ticks:int = _width/50;
			
			for (var i : int = 0; i <= num_ticks; i++)
			{
				var tick:TimelineTicker = new TimelineTicker((thickNumber*5).toString());
				
				numbersSprite.addChild(tick);
				tick.x = toX;
				if (i < num_ticks)
				{
				var smallX:int = toX+10;
			
					for (var s:int = 1; s < 5; s++)
					{
						var smallShape:Shape = new Shape();
						smallShape.graphics.beginFill(0x696969);
						smallShape.graphics.drawRect(0, 0, 2, 5);
						smallShape.graphics.endFill();
						numbersSprite.addChild(smallShape);
						smallShape.x = smallX; 
				
						smallX += 10; 
						smallShape.y = 20;
					}
				}
				toX += 50;
				
				thickNumber++;	
    
			}
			
			
			addChild(timeline);
			addChild(numbersSprite);
			addChild(clipsSprite);
			addChild(clipsHolder);
			
			
	
			clipsHolder.y = 40;
			
			timeline.timelineScroller.addEventListener(MouseEvent.MOUSE_DOWN, timelineScrollerOnDown);
			
			
			checkIfMouseIsMoving = new Timer(50, 1);
			
			checkIfMouseIsMoving.addEventListener(TimerEvent.TIMER_COMPLETE, isTimelineCursorMoving);
			
			timelineTimerSeekDelay = new Timer(1000, 1);
			
			timelineTimerSeekDelay.addEventListener(TimerEvent.TIMER_COMPLETE, onDelayTimelineSeek);
		}
		private function seekTimeline():void 
		{
			
			
			
			var perc:Number = clipsHolder.mouseX / maxTimelineWidth;
			
			videoPlayer.seek(perc);
		}
		private function onDelayTimelineSeek(e:TimerEvent):void 
		{
			if (timelineCursorIsMoving)
			{						
				seekTimeline();
			}
			timelineTimerSeekDelay.start();
		}
		public function refreshTimeline(data:Array):void
		{
			
			
			timeline.stage.removeEventListener(Event.ENTER_FRAME, onEveryFrame);
			
			dataTimeline = new Array();
			dataTimeline = data;
			
			while (clipsHolder.numChildren > 0)
			{
				clipsHolder.removeChildAt(0);
				
			}
			var prevClipX:Number = 0;
			var prevClipW:Number = 0;
			
			editorCursor = new TimelineCursor();
			editorCursor.useHandCursor = true;
			editorCursor.button = true;	
			
			totalTime = 0;
			
			clipsArray = new Array();
			
			for (var i:int = 0; i < dataTimeline.length; i++)
			{
				var _width:Number = (dataTimeline[i].end - dataTimeline[i].start) * 10;
				totalTime += dataTimeline[i].end - dataTimeline[i].start;
				var obj:Object = new Object();
				
				obj._width = _width;
				obj.start = dataTimeline[i].start;
				obj.end = dataTimeline[i].end;
				obj.source = dataTimeline[i].source;
				obj.index = i;
				
				var clip:TimelineClip = new TimelineClip(obj);
				
				clipsArray.push(clip);
				
				clip.addEventListener(MouseEvent.CLICK, onClipClick);
				clip.addEventListener(MouseEvent.MOUSE_OVER, onClipOver);
				
				clipsHolder.addChild(clip);
				clip.x = prevClipX + prevClipW;
				
				prevClipW = _width;
				prevClipX = clip.x;
				
			}
			maxTimelineWidth = clipsHolder.width;
			
			
			clipsHolder.addChild(editorCursor);
			editorCursor.y = -40;
			currentClipInTimelineIndex = 0;
			
			
			var delayTimer:Timer = new Timer(100, 1);
			delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, startCursorTracking);
			delayTimer.start();
			function startCursorTracking(e:Event):void
			{
				delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, startCursorTracking);
				timeline.stage.addEventListener(Event.ENTER_FRAME, onEveryFrame);
			}
			
			editorCursor.addEventListener(MouseEvent.MOUSE_DOWN, timelineCursorDown);
			
		
			

		}
		
		private function onClipOver(e:MouseEvent):void
		{
			var obj:Object = e.currentTarget.infoObject;
			
			currentTimelineClipIndex = obj.index;
		}
		private function onClipClick(e:MouseEvent):void
		{
			 
			
			
			editorCursor.x = clipsHolder.mouseX;
			
			timeline.stage.removeEventListener(Event.ENTER_FRAME, onEveryFrame);
			
			//seek current clip
			
	
			seekTimeline();
			
			
			
		}
		
		private function isTimelineCursorMoving(e:TimerEvent):void
		{
			if(prevMouseX != mouseX){
			
			timelineCursorIsMoving = true;
			
			}else {
				timelineCursorIsMoving = false;
			}
			
		}
		private function timelineCursorUp(e:MouseEvent):void
		{

			timelineCursorIsMoving = false;
			
			editorCursor.stopDrag();
			
			timeline.stage.removeEventListener(MouseEvent.MOUSE_UP, timelineCursorUp);

			timelineTimerSeekDelay.stop();
			
			checkIfMouseIsMoving.stop();
			
			seekTimeline();
		}
		private function timelineCursorDown(e:MouseEvent):void
		{
			
	
			
			
			var boundsRect:Rectangle = new Rectangle(0, -40, maxTimelineWidth, 0);
			editorCursor.startDrag(false, boundsRect);
			
			timeline.stage.addEventListener(MouseEvent.MOUSE_UP, timelineCursorUp);
			
			
			
			timelineTimerSeekDelay.start();
			checkIfMouseIsMoving.start();
		}
		private function timelineScrollerOnDown(e:MouseEvent):void
		{
			
			var boundsRect:Rectangle = new Rectangle(0, 282, 796, 0);
			timeline.timelineScroller.startDrag(false, boundsRect);
			
			timeline.stage.addEventListener(MouseEvent.MOUSE_UP, timelineScrollerOnUp);
			timeline.stage.addEventListener(Event.ENTER_FRAME, scrollOnEveryFrame);
			
			
		}	
		
		private function onEveryFrame(e:Event):void
		{
			
			var currentTimeInVideo:Number = videoPlayer.videoTime;
	
			editorCursor.x = (currentTimeInVideo / totalTime)*maxTimelineWidth;
				
			
		}
		private function scrollOnEveryFrame(e:Event):void
		{
			var perc:Number = ((timeline.timelineScroller.x * 100)/796)/100
			
			
			numbersSprite.x = ( -(_width - 1024) * perc);
			
			clipsSprite.x = numbersSprite.x;
			clipsHolder.x = numbersSprite.x;
		}
		private function timelineScrollerOnUp(e:MouseEvent):void
		{
			timeline.stage.removeEventListener(MouseEvent.MOUSE_UP, timelineScrollerOnUp);
			timeline.stage.removeEventListener(Event.ENTER_FRAME, scrollOnEveryFrame);
			timeline.timelineScroller.stopDrag();
		}
		
	}

}