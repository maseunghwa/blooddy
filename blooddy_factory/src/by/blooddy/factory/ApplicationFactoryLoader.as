////////////////////////////////////////////////////////////////////////////////
//
//  © 2007 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.factory {

	import flash.accessibility.AccessibilityImplementation;
	import flash.accessibility.AccessibilityProperties;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Shader;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.errors.InvalidSWFError;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.text.TextSnapshot;
	import flash.ui.ContextMenu;
	import flash.utils.getQualifiedClassName;

	//--------------------------------------
	//  Excluded APIs
	//--------------------------------------

	[Exclude(name="accessibilityProperties", kind="property")]
	[Exclude(name="alpha", kind="property")]
	[Exclude(name="blendMode", kind="property")]
	[Exclude(name="blendShader", kind="property")]
	[Exclude(name="cacheAsBitmap", kind="property")]
	[Exclude(name="filters", kind="property")]
	[Exclude(name="height", kind="property")]
	[Exclude(name="mask", kind="property")]
	[Exclude(name="name", kind="property")]
	[Exclude(name="opaqueBackground", kind="property")]
	[Exclude(name="parent", kind="property")]
	[Exclude(name="root", kind="property")]
	[Exclude(name="rotation", kind="property")]
	[Exclude(name="rotationX", kind="property")]
	[Exclude(name="rotationY", kind="property")]
	[Exclude(name="rotationZ", kind="property")]
	[Exclude(name="scale9Grid", kind="property")]
	[Exclude(name="scaleX", kind="property")]
	[Exclude(name="scaleY", kind="property")]
	[Exclude(name="scaleZ", kind="property")]
	[Exclude(name="scrollRect", kind="property")]
	[Exclude(name="stage", kind="property")]
	[Exclude(name="transform", kind="property")]
	[Exclude(name="visible", kind="property")]
	[Exclude(name="width", kind="property")]
	[Exclude(name="x", kind="property")]
	[Exclude(name="y", kind="property")]
	[Exclude(name="z", kind="property")]
	[Exclude(name="accessibilityImplementation", kind="property")]
	[Exclude(name="contextMenu", kind="property")]
	[Exclude(name="doubleClickEnabled", kind="property")]
	[Exclude(name="focusRect", kind="property")]
	[Exclude(name="mouseEnabled", kind="property")]
	[Exclude(name="tabEnabled", kind="property")]
	[Exclude(name="tabIndex", kind="property")]
	[Exclude(name="textSnapshot", kind="property")]
	[Exclude(name="buttonMode", kind="property")]
	[Exclude(name="hitArea", kind="property")]
	[Exclude(name="useHandCursor", kind="property")]
	[Exclude(name="soundTransform", kind="property")]

	[Exclude(name="dispatchEvent", kind="method")]
	[Exclude(name="addChild", kind="method")]
	[Exclude(name="addChildAt", kind="method")]
	[Exclude(name="areInaccessibleObjectsUnderPoint", kind="method")]
	[Exclude(name="contains", kind="method")]
	[Exclude(name="getChildAt", kind="method")]
	[Exclude(name="getChildByName", kind="method")]
	[Exclude(name="getChildIndex", kind="method")]
	[Exclude(name="getObjectsUnderPoint", kind="method")]
	[Exclude(name="removeChild", kind="method")]
	[Exclude(name="removeChildAt", kind="method")]
	[Exclude(name="setChildIndex", kind="method")]
	[Exclude(name="swapChildren", kind="method")]
	[Exclude(name="swapChildrenAt", kind="method")]
	[Exclude(name="startDrag", kind="method")]
	[Exclude(name="stopDrag", kind="method")]

	/**
	 * Грузитель приложения.
	 * 
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 9
	 * @langversion				3.0
	 * 
	 * @keyword					applicationfactoryloader, applicationloader, loader, application, applicationfactory, factory 
	 */
	public class ApplicationFactoryLoader extends Sprite {

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static var inited:Boolean = false;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * Constructor
		 */
		public function ApplicationFactoryLoader(url:String) {
			super();

			if ( inited || !super.stage || super.stage != super.parent  ) {
				throw new ReferenceError( 'The ' + getQualifiedClassName( ( this as Object ).constructor ) + '' );
			}

			super.mouseEnabled = false;
			super.tabEnabled = false;

			inited = true;

			super.addEventListener( Event.REMOVED_FROM_STAGE, this.handler_removedFromStage, false, int.MAX_VALUE );

			this._loader = new LoaderAsset();
			this._loader.contentLoaderInfo.addEventListener( Event.INIT, this.handler_loader_init );
			this._loader.$load( new URLRequest( url ), new LoaderContext( false, ApplicationDomain.currentDomain, SecurityDomain.currentDomain ) );
			super.addChild( this._loader );

		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private var _loader:LoaderAsset;

		/**
		 * @private
		 */
		private var _factory:ApplicationFactory;

		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private function handler_removedFromStage(event:Event):void {
			throw new IllegalOperationError();
		}

		/**
		 * @private
		 */
		private function handler_loader_init(event:Event):void {
			var info:LoaderInfo = event.target as LoaderInfo;
			if ( !( info.content is ApplicationFactory ) ) {
				throw new InvalidSWFError();
			}
			this._factory = info.content as ApplicationFactory;
			this._factory.addEventListener( Event.INIT, this.handler_factory_init );
		}

		/**
		 * @private
		 */
		private function handler_factory_init(event:Event):void {
			this._factory.removeEventListener( Event.INIT, this.handler_factory_init );
			this._factory = null;
			super.removeChild( this._loader );
			this._loader.$lockStage();
			this._loader = null;
			super.removeEventListener( Event.REMOVED_FROM_STAGE, this.handler_removedFromStage );
			super.parent.removeChild( this );
		}

		//--------------------------------------------------------------------------
		//
		//  Overriden properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  DisplayObject
		//----------------------------------

		public override final function set accessibilityProperties(value:AccessibilityProperties):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set alpha(value:Number):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set blendMode(value:String):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set blendShader(value:Shader):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set cacheAsBitmap(value:Boolean):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set filters(value:Array):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set height(value:Number):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set mask(value:DisplayObject):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set name(value:String):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set opaqueBackground(value:Object):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство запрещено")]
		/**
		 * @private
		 */
		public override final function get parent():DisplayObjectContainer {
			return null;
		}

		[Deprecated(message="свойство запрещено")]
		/**
		 * @private
		 */
		public override final function get root():DisplayObject {
			return null;
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set rotation(value:Number):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set rotationX(value:Number):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set rotationY(value:Number):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set rotationZ(value:Number):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set scale9Grid(innerRectangle:Rectangle):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set scaleX(value:Number):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set scaleY(value:Number):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set scaleZ(value:Number):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set scrollRect(value:Rectangle):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство запрещено")]
		/**
		 * @private
		 */
		public override final function get stage():Stage {
			return null;
		}

		[Deprecated(message="свойство запрещено")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function get transform():Transform {
			throw new IllegalOperationError();
		}

		/**
		 * @private
		 */
		public override final function set transform(value:Transform):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set visible(value:Boolean):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set width(value:Number):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set x(value:Number):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set y(value:Number):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set z(value:Number):void {
			throw new IllegalOperationError();
		}

		//----------------------------------
		//  InteractiveObject
		//----------------------------------

		public override final function set accessibilityImplementation(value:AccessibilityImplementation):void {
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set contextMenu(cm:ContextMenu):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set doubleClickEnabled(enabled:Boolean):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set focusRect(focusRect:Object):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set mouseEnabled(enabled:Boolean):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set tabEnabled(enabled:Boolean):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set tabIndex(index:int):void {
			throw new IllegalOperationError();
		}

		//----------------------------------
		//  DisplayObjectContainer
		//----------------------------------

		/**
		 * @private
		 */
		public override final function get textSnapshot():TextSnapshot {
			return null;
		}

		//----------------------------------
		//  Sprite
		//----------------------------------

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set buttonMode(value:Boolean):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set hitArea(value:Sprite):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set useHandCursor(value:Boolean):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="свойство не используется")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function set soundTransform(sndTransform:SoundTransform):void {
			throw new IllegalOperationError();
		} 

		//--------------------------------------------------------------------------
		//
		//  Overriden methods
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  EventDispatcher
		//----------------------------------


		[Deprecated(message="метод запрещён")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function dispatchEvent(event:Event):Boolean {
			throw new IllegalOperationError();
		}

		//----------------------------------
		//  DisplayObjectContainer
		//----------------------------------

		[Deprecated(message="метод запрещён")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function addChild(child:DisplayObject):DisplayObject {
			throw new IllegalOperationError();
		}

		[Deprecated(message="метод запрещён")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function addChildAt(child:DisplayObject, index:int):DisplayObject {
			throw new IllegalOperationError();
		}

		[Deprecated(message="метод запрещён")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function areInaccessibleObjectsUnderPoint(point:Point):Boolean {
			throw new IllegalOperationError();
		}

		[Deprecated(message="метод запрещён")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function contains(child:DisplayObject):Boolean {
			throw new IllegalOperationError();
		}

		[Deprecated(message="метод запрещён")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function getChildAt(index:int):DisplayObject {
			throw new IllegalOperationError();
		}

		[Deprecated(message="метод запрещён")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function getChildByName(name:String):DisplayObject {
			throw new IllegalOperationError();
		}

		[Deprecated(message="метод запрещён")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function getChildIndex(child:DisplayObject):int {
			throw new IllegalOperationError();
		}

		[Deprecated(message="метод запрещён")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function getObjectsUnderPoint(point:Point):Array {
			throw new IllegalOperationError();
		}

		[Deprecated(message="метод запрещён")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function removeChild(child:DisplayObject):DisplayObject {
			throw new IllegalOperationError();
		}

		[Deprecated(message="метод запрещён")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function removeChildAt(index:int):DisplayObject {
			throw new IllegalOperationError();
		}

		[Deprecated(message="метод запрещён")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function setChildIndex(child:DisplayObject, index:int):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="метод запрещён")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function swapChildren(child1:DisplayObject, child2:DisplayObject):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="метод запрещён")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function swapChildrenAt(index1:int, index2:int):void {
			throw new IllegalOperationError();
		}

		//----------------------------------
		//  Sprite
		//----------------------------------

		[Deprecated(message="метод запрещён")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function startDrag(lockCenter:Boolean=false, bounds:Rectangle=null):void {
			throw new IllegalOperationError();
		}

		[Deprecated(message="метод запрещён")]
		/**
		 * @throw	IllegalOperationError
		 */
		public override final function stopDrag():void {
			throw new IllegalOperationError();
		}

	}

}

//==============================================================================
//
//  Inner definitions
//
//==============================================================================

import flash.display.DisplayObject;
import flash.display.Loader;
import flash.errors.IllegalOperationError;
import flash.net.URLRequest;
import flash.system.LoaderContext;
import flash.utils.ByteArray;
import flash.events.Event;
import flash.display.Sprite;

////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: LoaderAsset
//
////////////////////////////////////////////////////////////////////////////////

/**
 * @private
 * Вспомогательный класс.
 * 
 * необходим, что бы при попытки обратится через различные ссылки, типа loaderInfo,
 * свойства были перекрыты
 */
internal final class LoaderAsset extends Loader {

	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------

	/**
	 * @private
	 */
	private static const _JUNK:Sprite = new Sprite();

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 * @private
	 * Constructor
	 */
	public function LoaderAsset() {
		super();
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	[Deprecated(message="свойство запрещено", replacement="$content")]
	/**
	 * @private
	 */
	public override function get content():DisplayObject {
		throw new IllegalOperationError();
	}

	/**
	 * @private
	 */
	internal function get $content():DisplayObject {
		return super.content;
	}

	//--------------------------------------------------------------------------
	//
	//  Internal methods
	//
	//--------------------------------------------------------------------------

	/**
	 * @private
	 */
	internal function $lockStage():void {
		super.addEventListener( Event.ADDED_TO_STAGE, this.handler_addedToStage, false, int.MAX_VALUE, true );
	}

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	[Deprecated(message="метод запрещен", replacement="$load")]
	/**
	 * @private
	 */
	public override function load(request:URLRequest, context:LoaderContext=null):void {
		throw new IllegalOperationError();
	}

	/**
	 * @private
	 */
	internal function $load(request:URLRequest, context:LoaderContext=null):void {
		super.load( request, context );
	}

	[Deprecated(message="метод запрещен", replacement="$loadBytes")]
	/**
	 * @private
	 */
	public override function loadBytes(bytes:ByteArray, context:LoaderContext=null):void {
		throw new IllegalOperationError();
	}

	[Deprecated(message="метод запрещен")]
	/**
	 * @private
	 */
	public override function unload():void {
		throw new IllegalOperationError();
	}

	[Deprecated(message="метод запрещен")]
	/**
	 * @private
	 */
	public override function unloadAndStop(gc:Boolean=true):void {
		throw new IllegalOperationError();
	}

	[Deprecated(message="метод запрещен")]
	/**
	 * @private
	 */
	public override function close():void {
		throw new IllegalOperationError();
	}

	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------

	/**
	 * @private
	 */
	private function handler_addedToStage(event:Event):void {
		_JUNK.addChild( this );
		_JUNK.removeChild( this );
		throw new IllegalOperationError();
	}

}