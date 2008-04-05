package by.blooddy.gui.utils {

	import by.blooddy.gui.display.IUIControl;
	import by.blooddy.platform.utils.ObjectInfo;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;

	public final class UIControlInfo {

		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		public static function getInfo(dispatcher:IUIControl):UIControlInfo {
			if ( !dispatcher ) return null;
			else return getClassInfo( ( dispatcher as Object ).constructor as Class );
		}

		//--------------------------------------------------------------------------
		//
		//  Private class constants
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static const _HASH:Dictionary = new Dictionary();

		/**
		 * @private
		 */
		private static const UI_CONTROL_LINK:String = getQualifiedClassName(IUIControl);

		//--------------------------------------------------------------------------
		//
		//  Private class methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static function getClassInfo(c:Object):UIControlInfo {
			var info:UIControlInfo = _HASH[c] as UIControlInfo;
			if (!info) {
				var info2:ObjectInfo = ObjectInfo.getInfo( c );
				_HASH[c] = info = new UIControlInfo();
				info.$setInfo( info2 );
			}
			return info;
		}

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 * Constructor.
		 */
		public function UIControlInfo() {
			super();
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private var _info:ObjectInfo;

		private var _styles:XMLList = new XMLList();

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private var _parent:UIControlInfo;

		/**
		 * @private
		 */
		public function get parent():UIControlInfo {
			if ( !this._parent && this._info.parent && this._info.parent.hasInterface( UI_CONTROL_LINK ) ) {
				this._parent = getClassInfo( getDefinitionByName( this._info.parent.name.toString() ) );
			}
			return this._parent;
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		public function hasMember(name:Object, pattern:uint=0):Boolean {
			return this._info.hasMember(name, pattern);
		}

		public function getMember(name:String, pattern:uint=0):ObjectInfo {
			return this._info.getMember(name, pattern);
		}

		[ArrayElementType("platform.utils.ObjectInfo")]
		public function getMembers(type:uint=7, pattern:uint=0):Array {
			return this._info.getMembers(type, pattern);
		}

		public function hasMetadata(name:String, pattern:uint=0):Boolean {
			return this._info.hasMetadata(name, pattern);
		}

		public function getMetadata(name:String, pattern:uint=0):XMLList {
			return this._info.getMetadata(name, pattern);
		}

		public function hasSuperclass(c:Object):Boolean {
			return this._info.hasSuperclass(c);
		}

		public function getSuperclasses():Array {
			return this._info.getSuperclasses();
		}

		public function hasInterface(c:Object):Boolean {
			return this._info.hasInterface(c);
		}

		public function getInterfaces():Array {
			return this._info.getInterfaces();
		}

		public function getStyleList():XMLList {
			return this.$getStyleList( new Object() );
		}

		private function $getStyleList(excludeHash:Object):XMLList {
			var result:XMLList = new XMLList();
			var name:String;
			for each ( var xml:XML in this._styles ) {
				name = xml.arg.(@key=="name").@value;
				if ( !excludeHash[ name ] ) {
					excludeHash[ name ] = true;
					result += xml;
				}
			}
			if ( this.parent ) this.parent.$getStyleList( excludeHash );
			return result;
		}

		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private function $setInfo(info:ObjectInfo):void {
			this._info = info;
			var list:XMLList, xml:XML, arg:XML, name:String;
			list = info.getMetadata("Style", ObjectInfo.META_SELF);
			const hash:Object = new Object();
			for each (xml in list) {
				arg = xml.arg.(@key=="name")[0];
				if ( arg && ( name = arg.@value.toXMLString().toLowerCase() ) && !hash[ name ]) {
					hash[ name ] = true;
					this._styles += xml;
				}
			}
		}

	}

}