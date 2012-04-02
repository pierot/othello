package be.wellconsidered.othello.events
{
	import flash.events.Event;

	public class OthelloEvent extends Event
	{
		public static var PLAYER_SWITCH:String = "PlayerSwitch";
		public static var END_GAME:String = "EndGame";
		
		private var _data:*;
		
		public function OthelloEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:*=null)
		{
			super(type, bubbles, cancelable);
			
			_data = data;
		}
		
		public function get data():*
		{
			return _data;
		}
	}
}