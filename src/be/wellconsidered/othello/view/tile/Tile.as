package be.wellconsidered.othello.view.tile
{
	import be.wellconsidered.logging.Logger;
	import be.wellconsidered.othello.model.States;
	import be.wellconsidered.othello.model.TileData;
	import be.wellconsidered.othello.model.events.TileDataEvent;
	import be.wellconsidered.othello.view.tile.events.TileEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import gs.TweenFilterLite;

	public class Tile extends Sprite
	{
		private var _model:TileData;
		
		private var _size_edge:int;
		
		public function Tile(size_edge:int)
		{
			super();
			
			_size_edge = size_edge;
			
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			drawTile();
		}
		
		private function drawTile():void
		{
			graphics.clear();
			graphics.lineStyle(1, 0x999999, 1, true);
			
			graphics.beginFill(_model.colour, 1);
			graphics.drawRect(0, 0, _size_edge, _size_edge);
		}
		
		private function onClick(e:MouseEvent):void
		{
			dispatchEvent(new TileEvent(TileEvent.CLICK, false, false));
		}
		
		private function onOver(e:MouseEvent):void
		{
			TweenFilterLite.to(this, .5, { colorMatrixFilter: { brightness: 0.8 } });
		}
		
		private function onOut(e:MouseEvent):void
		{
			TweenFilterLite.to(this, .3, { colorMatrixFilter: {  brightness: 1 } });
		}
		
		private function onLockedChange(e:TileDataEvent):void
		{
			Logger.log("Tile is locked");
			
			removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			removeEventListener(MouseEvent.CLICK, onClick);
			
			buttonMode = false;
			mouseEnabled = false;
		}
		
		private function onSizeChange(e:TileDataEvent):void
		{
			drawTile();
		}
		
		public function ready():void
		{
			if(model.state == States.LEEG || model.state == States.ZET)
			{
				buttonMode = true;
			
				addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
				addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
				addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			}
		}
		
		public function set model(value:TileData):void
		{
			_model = value;
		}
		
		public function get model():TileData
		{
			return _model;
		}
	}
}