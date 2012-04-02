package be.wellconsidered.othello.model
{
	import be.wellconsidered.othello.model.events.TileDataEvent;
	
	import flash.events.EventDispatcher;
	
	public class TileData extends EventDispatcher
	{
		private var _iRij:int;
		private var _iKol:int;
		private var _nColour:Number = 0xaaaaaa;
		
		private var _iCurrentState:int = States.LEEG;
		
		public function TileData(rij:int, kol:int)
		{
			_iRij = rij;
			_iKol = kol;
		}
		
		public function get rij():int
		{
			return _iRij;
		}
		
		public function get kol():int
		{
			return _iKol;
		}
	
		public function get colour():Number
		{
			return _nColour;
		}
		
		public function set rij(value:int):void
		{
			_iRij = value;
		}
		
		public function set kol(value:int):void
		{
			_iKol = value;
		}
		
		public function set state(value:int):void
		{
			_iCurrentState = value;
			
			switch(_iCurrentState)
			{
				case States.LEEG:		_nColour = 0xaaaaaa;		break;
				case States.RAND:		_nColour = 0xffc1b5;		break;
				case States.WIT:		_nColour = 0xffffff;		break;
				case States.ZET:		_nColour = 0x65ff65;		break;
				case States.ZWART:	_nColour = 0x000000;		break;
			}
		}
		
		public function get state():int
		{
			return _iCurrentState;
		}
		
		public override function toString():String
		{
			return "Tile op " + rij + " - " + kol + " (" + state + ")";
		}
	}
}