/**************************************
title: CoverFlow knockoff
author: John Dyer (http://johndyer.name)
license: MIT
updated: 12/12/2007
*************************************/

package be.wellconsidered.display.coverflow
{	
    import be.wellconsidered.display.manipulation.Reflection;
    
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.text.*;
    import flash.ui.Keyboard;
    import flash.utils.*;
    
    import gs.TweenLite;
    
    import org.papervision3d.cameras.*;
    import org.papervision3d.core.*;
    import org.papervision3d.core.proto.*;
    import org.papervision3d.events.*;
    import org.papervision3d.materials.*;
    import org.papervision3d.objects.*;
    import org.papervision3d.objects.primitives.*;
    import org.papervision3d.scenes.*;
	
    public class CoverFlow extends EventDispatcher
    {		
		private var _showReflections:Boolean = true;	
	
		private var _arrPlanes:Array = [];
		private var _currentPlaneIndex:Number = 0;
		
		private var _planeAngle:Number = 60;
		private var _planeSeparation:Number = 60;
		private var _planeOffset:Number = 120;
		private var _planeOffsetY:Number = 0;
		private var _selectPlaneZ:Number = -180;	
		
		private var _tweenTime:Number = 0.5;
		
		private var _planeWidth = 200;
		private var _planeHeight = 200;	
		private var _planeNonHiddenHeight:Number;
		
		private var _stage:Stage;		
		private var _camera:Camera3D;
		private var _scene:Scene3D;				
		private var _coverFlowData:Array;
		
		private var _initItemIndex:int = -1;				
		
		private var _currentIndex:Number = 0;
		private var _hoverUp:Boolean = true;
		
		public var needsRender:Boolean = true;
			
		public function CoverFlow(stage:Stage, camera:Camera3D, scene:Scene3D, coverFlowData:Array, showReflections:Boolean = true, planeWidth:Number = 200, planeHeight:Number = 200, initItemIndex:int = -1, planeNonHiddenHeight:Number = -1, hoverUp:Boolean = true)
        {						
            stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);				

			_stage = stage;
			_scene = scene;
			_camera = camera;
			
			_coverFlowData = coverFlowData;
			_showReflections = showReflections;
			
			_planeWidth = planeWidth;
			_planeHeight = planeHeight;		
			
			_initItemIndex = initItemIndex;	
			_hoverUp = hoverUp;
			
			_planeNonHiddenHeight = planeNonHiddenHeight > 0 ? planeNonHiddenHeight : _planeHeight;
			
			_currentIndex = 0;
			
			loadNextPlane();		
        }
		
		function loadNextPlane():void
		{
			var plane:Plane = null;
			var planeMaterial:MovieMaterial = null;
			
			var newWidth:Number = _planeWidth;
			var newHeight:Number = _planeHeight;	
			
			if (_showReflections) 
				new Reflection(_coverFlowData[_currentIndex] as Sprite, 25, 50, _planeNonHiddenHeight);
			
			planeMaterial = new MovieMaterial(_coverFlowData[_currentIndex] as Sprite, true, true); 
			planeMaterial.interactive = true;
			planeMaterial.animated = true;
			
			if (_showReflections) 
				newHeight = newHeight * 2;
			
			plane = new Plane(planeMaterial, newWidth, newHeight, 3, 3);
			
			if (_showReflections) 
				plane.y = -_planeHeight / 2;
				
			plane.z = (_currentIndex + 1 < _coverFlowData.length / 2) ? (_coverFlowData.length / 2 - _currentIndex) * 10 : - (_currentIndex - _coverFlowData.length / 2) * 10;
			plane.extra = {planeIndex : _currentIndex, height: newHeight, planeY: plane.y};
			
			plane.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, planeClicked);
			
			if(_hoverUp)
			{
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, planeOver);
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_OUT, planeOut);
			}
			
			_scene.addChild(plane);
			
			_arrPlanes.push(plane);
			
			if (_currentIndex < _coverFlowData.length - 1) 
			{
				_currentIndex++
			
				loadNextPlane();
			}
			else 
			{
				_camera.lookAt( new DisplayObject3D() );
				
				setTimeout(shiftToItem, 150, Math.floor(_coverFlowData.length / 2));
				
				if(_initItemIndex > -1)
					setTimeout(shiftToItem, 300, _initItemIndex);
				
				setTimeout(setReady, 450);
			}
		}
		
		private function setReady():void
		{
			dispatchEvent(new CoverFlowEvent(CoverFlowEvent.READY, 0));
		}
		
		private function planeOver(ev:InteractiveScene3DEvent)
		{
			var plane:Plane = ev.displayObject3D as Plane;
			
			if(plane.extra.planeIndex != _currentPlaneIndex)
			{
				needsRender = true;
				
				// TweenLite.to(plane, _tweenTime, {y: plane.extra.planeY + _planeOffsetY, overwrite: false});
				
				dispatchEvent(new CoverFlowEvent(CoverFlowEvent.HOVER_OVER, plane.extra.planeIndex));
				
				TweenLite.to(plane, _tweenTime, {z: 50, overwrite: false, onComplete: function(){ needsRender = false; }});
			}
		}
		
		private function planeOut(ev:InteractiveScene3DEvent)
		{
			var plane:Plane = ev.displayObject3D as Plane;
			
			if(plane.extra.planeIndex != _currentPlaneIndex)
			{
				needsRender = true;
				
				// TweenLite.to(plane, _tweenTime, {y: plane.extra.planeY, overwrite: false});
				
				dispatchEvent(new CoverFlowEvent(CoverFlowEvent.HOVER_OUT, plane.extra.planeIndex));
				
				TweenLite.to(plane, _tweenTime, {z: 100, overwrite: false, onComplete: function(){ needsRender = false; }});
			}
		}

		private function planeClicked(ev:InteractiveScene3DEvent) 
		{
			var index:Number = ev.displayObject3D.extra.planeIndex;

			if (!_showReflections || ev.y <= ev.displayObject3D.extra.height) 
			{		
				if (index == _currentPlaneIndex) 
				{			
					dispatchEvent(new CoverFlowEvent(CoverFlowEvent.ITEM_CLICK, index));
				}
				else
				{
					shiftToItem(index);
				}
			}
		}
		
		private function keyDownHandler(ev:KeyboardEvent) 
		{	
			switch (ev.keyCode) 
			{
				case Keyboard.LEFT:
				
					moveLeft();
					
					break;
					
				case Keyboard.RIGHT:
				
					moveRight();
				
					break;

				case Keyboard.UP:
				case Keyboard.PAGE_UP:
				
					shiftToItem(0);

					break;
					
				case Keyboard.DOWN:					
				case Keyboard.PAGE_DOWN:
				
					shiftToItem(_arrPlanes.length - 1);

					break;		
				
				case Keyboard.ENTER:
				
					dispatchEvent(new CoverFlowEvent(CoverFlowEvent.ITEM_CLICK, _currentPlaneIndex));
					
					break;
			}
		}
		
		private function mouseWheelHandler(e:MouseEvent):void
		{		
			if (e.delta < 0) 
				moveRight();
			else 
				moveLeft();
		}		
			
		public function moveLeft()
		{	
			if (_currentPlaneIndex > 0)
				shiftToItem(_currentPlaneIndex - 1);	
		}
			
		public function moveRight() 
		{
			if (_currentPlaneIndex < _arrPlanes.length - 1) 
				shiftToItem(_currentPlaneIndex + 1);
		}
		
		public function shiftToItem(newCenterPlaneIndex:int):void 
		{
			needsRender = true;
			
			if (_currentPlaneIndex == newCenterPlaneIndex) 
				return;

			for (var i:Number = 0; i < _arrPlanes.length; i++) 
			{	
				var plane:Plane = _arrPlanes[i] as Plane;
			
				/*
				if (i >= newCenterPlaneIndex - 1 && i <= newCenterPlaneIndex + 1) 
					plane.material.smooth = true;
				else
					plane.material.smooth = false;
				*/
				
				var difA:Number = (3 - Math.abs(newCenterPlaneIndex - i)) / 10;
				
				if (i == newCenterPlaneIndex) 
				{
					TweenLite.to(plane, _tweenTime, {x: 0, z: _selectPlaneZ, rotationY: 0, onComplete: function() { needsRender = false; }, y: plane.extra.planeY });
				
					TweenLite.to((plane.material as MovieMaterial).movie, _tweenTime, {alpha: 1});
				}
				else if (i < newCenterPlaneIndex) 
				{
					TweenLite.to(plane, _tweenTime, {x: (newCenterPlaneIndex - i + 1) * -_planeSeparation - _planeOffset, z: 100, rotationY: -_planeAngle, y: plane.extra.planeY });
				
					TweenLite.to((plane.material as MovieMaterial).movie, _tweenTime, {alpha: difA});	
				}
				else  
				{
					TweenLite.to(plane, _tweenTime, {x: ((i - newCenterPlaneIndex + 1) * _planeSeparation) + _planeOffset, z: 100, rotationY: _planeAngle, y: plane.extra.planeY });
					
					TweenLite.to((plane.material as MovieMaterial).movie, _tweenTime, {alpha: difA});
				}
			}
			
			_currentPlaneIndex = newCenterPlaneIndex;
			
			dispatchEvent(new CoverFlowEvent(CoverFlowEvent.ITEM_FOCUS, newCenterPlaneIndex));
			
			// STATUS
			if(_currentPlaneIndex == 0)
				dispatchEvent(new CoverFlowEvent(CoverFlowEvent.FLOW_START, _currentPlaneIndex));	
			
			if(_currentPlaneIndex == _arrPlanes.length - 1)
				dispatchEvent(new CoverFlowEvent(CoverFlowEvent.FLOW_END, _currentPlaneIndex));
		}
		
		public function destroy():void
		{
			for(var i:int = 0; i < _arrPlanes.length; i++)
			{
				var plane:Plane = _arrPlanes[i] as Plane;
				
				plane.material.interactive = false;
				plane.material.destroy();
				
				plane.removeEventListener(InteractiveScene3DEvent.OBJECT_CLICK, planeClicked);
				plane.removeEventListener(InteractiveScene3DEvent.OBJECT_OVER, planeOver);
				plane.removeEventListener(InteractiveScene3DEvent.OBJECT_OUT, planeOut);
				
				_scene.removeChild(plane);
			}
			
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
		}
		
		public function set speed(value:Number):void{ _tweenTime = value; }
		public function set overYOffset(value:Number):void { _planeOffsetY = value; }
		public function set hoverUp(value:Boolean):void { _hoverUp = value; }
    }
}