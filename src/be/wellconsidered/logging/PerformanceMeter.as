/**
* @author 	Pieter Michels
*/

package be.wellconsidered.logging 
{
	import be.wellconsidered.logging.Logger;
	
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.display.Graphics;
	import flash.system.System;
	import flash.text.TextFormat;
	import flash.display.Stage;
	
	public class PerformanceMeter extends Sprite
	{
		private var _fps:TextField;
		private var _mem:TextField;
		
		private var _fps_timer:Timer;
		private var _fps_counter:uint = 0;
		private var _fps_interval:int;
		
		public function PerformanceMeter(param_int:int = 1000)
		{
			// Logger.log("Performance Meter inited");
			
			initFields();
			initEventListeners();
			
			_fps_interval = param_int;
			
			_fps_timer = new Timer(_fps_interval);
			_fps_timer.addEventListener(TimerEvent.TIMER, updateMeters);
			_fps_timer.start();
		}
		
		private function initEventListeners():void
		{
			addEventListener(Event.ADDED_TO_STAGE, initMeter);
			addEventListener(Event.ENTER_FRAME, updateFields);
		}
		
		private function initMeter(e:Event):void
		{
			graphics.beginFill(0xcccccc, .7);
			graphics.drawRect(5, 5, 105, 13);
			graphics.endFill();			
		}
		
		private function initFields():void
		{
			var meter_tf:TextFormat = new TextFormat("Arial", 10, 0x000000);
			
			_fps = new TextField();
			_fps.defaultTextFormat = meter_tf;
			_mem = new TextField();
			_mem.defaultTextFormat = meter_tf;
			
			_fps.x = 10; _fps.y = 3;
			_mem.x = 50; _mem.y = 3;
			
			addChild(_mem);
			addChild(_fps);
		}
		
		private function updateFields(e:Event):void
		{
			_fps_counter += 1 * 1000 / _fps_interval;
		}
		
		private function updateMeters(e:TimerEvent):void
		{	
			_fps.text = Math.round(_fps_counter) + " fps";
			_mem.text = Math.round(System.totalMemory / 1024) + " Kb";
			
			_fps_counter = 0;
		}
	}
}
