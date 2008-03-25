﻿package by.blooddy.gui.display {

	import by.blooddy.gui.utils.UIControlInfo;
	import by.blooddy.platform.display.ResourceManagerOwnerSprite;
	import by.blooddy.platform.events.isIntrinsicEvent;
	import by.blooddy.platform.utils.ObjectInfo;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.events.MouseEvent;

//	[Deprecated(message="string_describing_deprecation", replacement="string_specifying_replacement", since="version_of_replacement")]
//
//	The [Event], [Effect] and [Style] metadata tags also support deprecation. These tags support the following options for syntax:
//	[Event(... , deprecatedMessage="string_describing_deprecation", deprecatedReplacement="string_specifying_replacement", deprecatedSince="version_of_replacement")]

	//--------------------------------------
	//  Excluded APIs
	//--------------------------------------

	[Exclude(name="graphics", kind="property")]

	[Exclude(name="startDrag", kind="method")]
	[Exclude(name="stopDrag", kind="method")]

	//--------------------------------------
	//  Other metadata
	//--------------------------------------

//	[AccessibilityClass(implementation="by.blooddy.gui.accessibility.UIControlAccessibility")]
//	[IconFile("MyButton.png")]
	[AbstractControl]

	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 9
	 * @langversion				3.0
	 * 
	 * @keyword					uicontrol, uicomponent, control, component, ui
	 */
	public class UIControl extends ResourceManagerOwnerSprite implements IUIControl {

		public function UIControl() {
			super();

			this._info = UIControlInfo.getInfo( this );

			// класс абстрактный
			if ( this._info.hasMetadata("AbstractControl", ObjectInfo.META_SELF) ) {
				throw new ArgumentError();
			}

			super.addEventListener(Event.ADDED_TO_STAGE, this.handler_addedToStage, false, int.MAX_VALUE);
			super.addEventListener(Event.REMOVED_FROM_STAGE, this.handler_removedFromStage, false, int.MAX_VALUE);
		}

		private var _info:UIControlInfo;

	    //--------------------------------------
	    //  mouse declaration
	    //--------------------------------------

		private var _mouseChildren:Boolean = true;

		public override function get mouseChildren():Boolean {
			return this._mouseChildren;
		}

		public override function set mouseChildren(enable:Boolean):void {
			if ( enable == this._mouseChildren ) return;
			this._mouseChildren = enable;
			this.mouseChildren_update();
		}

		private function mouseChildren_update():void {
			super.mouseChildren = this._mouseChildren;
		}

	    //--------------------------------------
	    //  graphics declaration
	    //--------------------------------------

		[Deprecated(message="свойство не используется")]
		/**
		 * @default	null
		 */
		public override function get graphics():Graphics {
			return null;
		}

		protected function get $graphics():Graphics {
			return super.graphics;
		}

		CONFIG::debug {

			/**
			 * @private
			 */
			private var _showPreview:Boolean = false;

			public function get showPreview():Boolean {
				return this._showPreview;
			}

			/**
			 * @private
			 */
			public function set showPreview(value:Boolean):void {
				if ( this._showPreview == value ) return;
				this._showPreview = value;
				if ( this._showPreview ) {
					this.redrawPreview();
				} else {
					super.graphics.clear();
				}
			}

			/**
			 * @private
			 */
			private function redrawPreview():void {
				var bounds:Rectangle = this.getControlBounds( this );
				with ( super.graphics ) {
					clear();
					lineStyle(1, 0xFFFFFF, 1, true, LineScaleMode.NONE);
					beginFill(0xFFFFFF, 0.3);
					drawRect( bounds.x, bounds.y, bounds.width, bounds.height );
					endFill();
				}
			}

		}

	    //--------------------------------------
	    //  center
	    //--------------------------------------	

		/**
		 * @private
		 */
		private var _center:Point = new Point();

		[Bindable("centerChanged")]
		public function get center():Point {
			return this._center;
		}

		/**
		 * @private
		 */
		public function set center(p:Point):void {
			var changed:Boolean = false;
			if ( p.x != this._center.x && !isNaN(p.x) ) {
				this._center.x = p.x;
				changed = true;
			}
			if ( p.y != this._center.y && !isNaN(p.y) ) {
				this._center.y = p.y;
				changed = true;
			}
			if (changed) {
				CONFIG::debug {
					if (this._showPreview) this.redrawPreview();
				}
				super.dispatchEvent( new Event("centerChanged") );
			}
		}

	    //--------------------------------------
	    //  position declaration
	    //--------------------------------------	
	
		/**
		 * @private
		 */
		private var _x:Number = 0;

		[Bindable("move")]
		[Inspectable(category="Position")]
		/**
		 */
		public override function get x():Number {
			return this._x;
		}

		/**
		 * @private
		 */
		public override function set x(value:Number):void {
		if (this._x == value && !isNaN(x)) return;
			this.move(value, this._y);
		}

		protected final function get $x():Number {
			return super.x;
		}

		/**
		 * @private
		 */
		private var _y:Number = 0;

		[Bindable("move")]
		[Inspectable(category="Position")]
		/**
		 */
		public override function get y():Number {
			return this._y;
		}

		/**
		 * @private
		 */
		public override function set y(value:Number):void {
			if (this._y == value && !isNaN(y)) return;
			this.move(this._x, value);
		}

		protected final function get $y():Number {
			return super.y;
		}

		public function move(x:Number, y:Number):void {
			var changed:Boolean = false;
			if ( this._x != x && !isNaN(x) ) {
				this._x = x;
				super.x = Math.round( this._x );
				changed = true;
			}
			if ( this._y != y && !isNaN(y) ) {
				this._y = y;
				super.y = Math.round( this._y );
				changed = true;
			}
			if (changed) {
				super.dispatchEvent( new Event("move") );
			}
		}

	    //--------------------------------------
	    //  size declaration
	    //--------------------------------------	
	
		/**
		 * @private
		 */
		private var _startWidth:Number = 0;

		/**
		 * @private
		 */
		private var _width:Number = 0;

		[Bindable("resize")]
		[Inspectable(category="Size")]
		/**
		 */
		public override function get width():Number {
			return this._width;
		}

		/**
		 * @private
		 */
		public override function set width(value:Number):void {
			if (this._width == value) return;
			this.setSize(value, this._height);
		}

		protected function get $width():Number {
			return super.width;
		}

		/**
		 * @private
		 */
		private var _startHeight:Number = 0;

		/**
		 * @private
		 */
		private var _height:Number;

		[Bindable("resize")]
		[Inspectable(category="Size")]
		/**
		 */
		public override function get height():Number {
			return this._height;
		}

		/**
		 * @private
		 */
		public override function set height(value:Number):void {
			if (this._height == value) return;
			this.setSize(this._width, value);
		}

		protected function get $height():Number {
			return super.height;
		}

		/**
		 * @private
		 */
		private var _scaleX:Number = 1;

		[Bindable("resize")]
		[Inspectable(category="Size", defaultValue="1.0")]
		/**
		 */
		public override function get scaleX():Number {
			return this._scaleX;
		}

		/**
		 * @private
		 */
		public override function set scaleX(value:Number):void {
			if (this._scaleX == value) return;
			this.setSize(this._width, value);
		}

		/**
		 * @private
		 */
		private var _scaleY:Number = 1;

		[Bindable("resize")]
		[Inspectable(category="Size", defaultValue="1.0")]
		/**
		 */
		public override function get scaleY():Number {
			return this._scaleY;
		}

		/**
		 * @private
		 */
		public override function set scaleY(value:Number):void {
			if (this._scaleY == value) return;
			this.height = this._startHeight * value;
		}

		/**
		 */
		public function setSize(width:Number, height:Number):void {
			var changed:Boolean = false;
			var oldWidth:Number = this._width;
			if (oldWidth != width && !isNaN(width)) {
				this._width = width;
				changed = true;
			}
			var oldHeight:Number = this._width;
			if (oldHeight != height && !isNaN(height)) {
				this._height = height;
				changed = true;
			}
			width = Math.round( this._width );
			height = Math.round( this._height );
			if (changed) {
				CONFIG::debug {
					if (this._showPreview) this.redrawPreview();
				}
				super.dispatchEvent( new Event(Event.RESIZE) );
			}
		}

		public override function getBounds(targetCoordinateSpace:DisplayObject):Rectangle {
			return this.getControlBounds( targetCoordinateSpace );
		}

		protected final function $getBounds(targetCoordinateSpace:DisplayObject):Rectangle {
			return super.getBounds( targetCoordinateSpace );
		}

		public override function getRect(targetCoordinateSpace:DisplayObject):Rectangle {
			return this.getControlBounds( targetCoordinateSpace );
		}

		protected final function $getRect(targetCoordinateSpace:DisplayObject):Rectangle {
			return super.getRect( targetCoordinateSpace );
		}

		/**
		 * @private
		 */
		private function getControlBounds(targetCoordinateSpace:DisplayObject):Rectangle {
			var p:Point = new Point();
			var result:Rectangle = new Rectangle();
			result.left = -this._center.x;
			result.top = -this._center.y;
			result.width = this._width;
			result.height = this._height;
			if ( targetCoordinateSpace !== this ) {
				result.topLeft = targetCoordinateSpace.globalToLocal( super.localToGlobal( result.topLeft ) );
				result.bottomRight = targetCoordinateSpace.globalToLocal( super.localToGlobal( result.bottomRight ) );
			}
			return result;
		}

		public override function set scale9Grid(innerRectangle:Rectangle):void {
			super.scale9Grid = innerRectangle;
			setScale9Grid( this, innerRectangle );
		}

		/**
		 * @private
		 */
		private static function setScale9Grid(container:DisplayObjectContainer, innerRectangle:Rectangle):void {
			var l:uint = container.numChildren;
			var child:DisplayObject;
			var childRectangle:Rectangle = new Rectangle();
			while (l--) {
				child = container.getChildAt( l );
				// прямоугольник
				childRectangle
				childRectangle.topLeft = child.globalToLocal( container.localToGlobal( innerRectangle.topLeft ) );
				childRectangle.bottomRight = child.globalToLocal( container.localToGlobal( innerRectangle.bottomRight ) );
				// сэтим
				child.scale9Grid = childRectangle;
				if ( !( child is IUIControl ) && ( child is DisplayObjectContainer ) ) {
					setScale9Grid( ( child as DisplayObjectContainer ), childRectangle );
				}
			}
		}

	    //--------------------------------------
	    //  drag declaration
	    //--------------------------------------	

		[Deprecated(message="метод не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override function startDrag(lockCenter:Boolean=false, bounds:Rectangle=null):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="метод не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override function stopDrag():void {
			throw new IllegalOperationError();
		}

	    //--------------------------------------
	    //  livepreview declaration
	    //--------------------------------------	

		public function get isLivePreview():Boolean {
			var C:Class;
			if ( super.parent ) {
				// flash
				C = getDefinitionByName("fl.livepreview::LivePreviewParent") as Class;
				if ( C && super.parent is C ) return true;
				// flex
				C = getDefinitionByName("mx.core::UIComponentGlobals") as Class;
				if ( C && "designMode" in C && C.designMode ) return true;
			}
			return false;
		}

	    //--------------------------------------
	    //  events declaration
	    //--------------------------------------	

		public override function dispatchEvent(event:Event):Boolean {
			if ( isIntrinsicEvent( this, event ) ) return true; // throw new IllegalOperationError();
			else return super.dispatchEvent( event );
		}

		protected final function $dispatchEvent(event:Event):Boolean {
			return super.dispatchEvent( event );
		}

	    //--------------------------------------
	    //  toString declaration
	    //--------------------------------------	

		public override function toString():String {
			var parent:DisplayObject = this;
			var result:Array = new Array();
			do {
				if (parent.name) result.unshift( parent.name );
				else result.unshift( ( parent as Object ).toLocaleString() );
			} while ( parent = parent.parent );
			return result.join(".");
		}

	    //--------------------------------------
	    //  stage events declaration
	    //--------------------------------------	

		/**
		 * @private
		 */
		private function handler_addedToStage(event:Event):void {
		}

		/**
		 * @private
		 */
		private function handler_removedFromStage(event:Event):void {
		}

	}

}