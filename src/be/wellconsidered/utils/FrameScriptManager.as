/**
* FrameScriptManager by Grant Skinner. November 13, 2007
* Visit www.gskinner.com/blog for documentation, updates and more free code.
*
* You may distribute this class freely, provided it is not modified in any way (including
* removing this header or changing the package path).
*
* Please contact info@gskinner.com prior to distributing modified versions of this class.
*/

package be.wellconsidered.utils
{
	import flash.display.MovieClip;

	public class FrameScriptManager
	{
		private var _target:MovieClip;
		private var _labels:Object;

		public function FrameScriptManager(target:MovieClip)
		{
			_target = target;

			updateLabels();
		}

		public function setFrameScript(frame:*, funct:Function):void
		{
			var uiFrameNum:uint = getFrameNumber(frame);

			if (uiFrameNum == 0) { return; }

			_target.addFrameScript(uiFrameNum - 1, funct);
		}

		public function getFrameNumber(frame:*):uint
		{
			var uiFrameNum:uint = uint(frame);

			if (uiFrameNum) { return uiFrameNum; }

			var sLabel:String = String(frame);

			if (sLabel == null) { return 0; }

			uiFrameNum = _labels[sLabel];

			return uiFrameNum;
		}

		private function updateLabels():void
		{
			var arrLabels:Array = _target.currentLabels;

			_labels = new Object();;

			for (var i:uint = 0; i < arrLabels.length; i++)
			{
				_labels[arrLabels[i].name] = arrLabels[i].frame;
			}
		}
	}
}
