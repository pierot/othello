
/*
	var tlm:TextLineManager = new TextLineManager(_txt);

	tlm.addEventListener(TextLineManager.COMPLETED, allCreateCompleted, false, 0, true);

	addChild(tlm);

	tlm.create();
*/
package be.wellconsidered.text.textliner
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.Event;

	public class TextLineManager extends Sprite
	{
		private var _txtField:TextField;
		private var _arrLines:Array;

		private var _iSpeed:int = 2;
		
		private var _state:String;

		private const CREATING:String = "creating";
		private const KILLING:String = "killing";

		public static const COMPLETED:String = "WriteManagerComplete";

		public function TextLineManager(textfield:TextField, custom_speed:int = 2)
		{
			_txtField = textfield;
			_iSpeed = custom_speed;
		}

		public function create():void
		{
			visible = true;
			mouseEnabled = true;
			
			_txtField.visible = false;

			_state = CREATING;

			buildLines();
			
			for(var i:int = 0; i < _arrLines.length; i++)
			{
				var txtLine:TextLine = _arrLines[i] as TextLine;
				
				txtLine.resetCounterToWrite();
				
				txtLine.complete = false;
				txtLine.addEventListener(Event.ENTER_FRAME, txtLine.writeText, false, 0, true);
				txtLine.addEventListener(TextLine.WRITE_COMPLETE, onCreateLineComplete, false, 0, true);
			}
		}

		public function kill():void
		{
			visible = true;
			mouseEnabled = true;

			_txtField.visible = false;
			
			_state = KILLING;
			
			buildLines();
			
			for(var i:int = 0; i < _arrLines.length; i++)
			{
				var txtLine:TextLine = _arrLines[i] as TextLine;
				
				txtLine.resetCounterToRemove();

				txtLine.complete = false;
				txtLine.addEventListener(Event.ENTER_FRAME, txtLine.removeText, false, 0, true);
				txtLine.addEventListener(TextLine.KILL_COMPLETE, onKillLineComplete, false, 0, true);
			}
		}

		private function initManager(e:Event):void
		{

		}

		private function buildLines():void
		{
			removeLines();
			
			for(var i:int = 0; i < _txtField.numLines; i++)
			{
				var sTextLine:String = _txtField.getLineText(i).split("\r").join("");
				var lineHeight:Number = _txtField.getLineMetrics(i).height;

				var txtLine:TextLine = new TextLine();

				txtLine.defaultTextFormat = _txtField.getTextFormat();
				txtLine.embedFonts = true;
				
				txtLine.autoSize = _txtField.autoSize;

				txtLine.speed = _iSpeed;
				txtLine.tekst = sTextLine;
				txtLine.x = _txtField.x;
				txtLine.y = _txtField.y + lineHeight * i;

				addChild(txtLine);

				_arrLines.push(txtLine);
			}
		}

		private function removeLines():void
		{
			if(_arrLines != null && _arrLines.length > 0)
			{
				for(var i:int = 0; i < _arrLines.length; i++)
				{
					var txtLine:TextLine = _arrLines[i] as TextLine;

					txtLine.removeEventListener(TextLine.WRITE_COMPLETE, onCreateLineComplete);
					txtLine.removeEventListener(TextLine.KILL_COMPLETE, onKillLineComplete);

					removeChild(txtLine);
					
					txtLine = null;
				}
			}

			_arrLines = null;
			_arrLines = new Array();
		}

		private function onCreateLineComplete(e:Event):void
		{
			if(checkAllCompleted())
			{
				visible = false;
				mouseEnabled = false;

				_txtField.visible = true;

				dispatchEvent(new Event(TextLineManager.COMPLETED));
			}
		}

		private function onKillLineComplete(e:Event):void
		{
			if(checkAllCompleted())
			{
				visible = false;
				mouseEnabled = false;

				dispatchEvent(new Event(TextLineManager.COMPLETED));
			}
		}

		private function checkAllCompleted():Boolean
		{
			for(var i:int = 0; i < _arrLines.length; i++)
			{
				var txtLine:TextLine = _arrLines[i] as TextLine;

				if(!txtLine.complete){ return false; }
			}

			return true;
		}
	}
}
