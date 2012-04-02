package be.wellconsidered.text.textliner
{
	import flash.text.TextField;
	import flash.events.Event;

	public class TextLine extends TextField
	{
		private var _sText:String = "";
		private var _iCounter:int = 0;
		private var _iSpeed:int = 1;
		private var _bComplete:Boolean = false;

		public static const WRITE_COMPLETE:String = "WriteComplete";
		public static const KILL_COMPLETE:String = "KillComplete";

		public function TextLine()
		{
			super();

			addEventListener(TextLine.WRITE_COMPLETE, markComplete, false, 0, true);
			addEventListener(TextLine.KILL_COMPLETE, markComplete, false, 0, true);
		}

		private function markComplete(e:Event):void
		{
			complete = true;
		}
		
		public function resetCounterToWrite():void
		{
			_iCounter = 0;
		}

		public function writeText(e:Event):void
		{
			appendText(_sText.substr(_iCounter, _iSpeed));
			
			_iCounter += _iSpeed;

			if(_iCounter > length)
			{
				text = _sText;
				
				removeEventListener(Event.ENTER_FRAME, writeText);
				
				dispatchEvent(new Event(TextLine.WRITE_COMPLETE));
			}
		}

		public function resetCounterToRemove():void
		{
			_iCounter = _sText.length;
		}

		public function removeText(e:Event):void
		{
			text = _sText.substr(0, _iCounter);

			_iCounter -= _iSpeed;

			if(_iCounter + _iSpeed <= 0)
			{
				htmlText = "";		
				
				removeEventListener(Event.ENTER_FRAME, removeText);

				dispatchEvent(new Event(TextLine.KILL_COMPLETE));
			}
		}

		public function set tekst(value:String):void
		{
			_sText = value;
		}

		public function get tekst():String
		{
			return _sText;
		}

		public function set speed(value:int):void
		{
			_iSpeed = value;
		}

		public function get speed():int
		{
			return _iSpeed;
		}

		public function set complete(value:Boolean):void
		{
			_bComplete = value;
		}

		public function get complete():Boolean
		{
			return _bComplete;
		}
	}
}
