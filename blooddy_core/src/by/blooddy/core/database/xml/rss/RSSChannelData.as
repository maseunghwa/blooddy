////////////////////////////////////////////////////////////////////////////////
//
//  © 2007 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.core.database.xml.rss {

	import by.blooddy.core.database.Data;
	import by.blooddy.core.events.database.DataBaseEvent;
	import by.blooddy.core.utils.XMLUtils;

	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 9
	 * @langversion				3.0
	 * 
	 * @keyword					rss, xml, data
	 */
	public class RSSChannelData extends RSSElementData {

		public function RSSChannelData() {
			super();
		}

		private var _language:String;

		public function get language():String {
			return this._language;
		}

		public function set language(value:String):void {
			if ( this._language == value ) return;
			this._language = value;
			super.dispatchEvent( new DataBaseEvent( DataBaseEvent.CHANGE, true ) );
		}

		private var _copyright:String;

		public function get copyright():String {
			return this._copyright;
		}

		public function set copyright(value:String):void {
			if ( this._copyright == value ) return;
			this._copyright = value;
			if ( !this.$lock ) super.dispatchEvent( new DataBaseEvent( DataBaseEvent.CHANGE, true ) );
		}

		private var _managingEditor:String;

		public function get managingEditor():String {
			return this._managingEditor;
		}

		public function set managingEditor(value:String):void {
			if ( this._managingEditor == value ) return;
			this._managingEditor = value;
			if ( !this.$lock ) super.dispatchEvent( new DataBaseEvent( DataBaseEvent.CHANGE, true ) );
		}

		private var _webMaster:String;

		public function get webMaster():String {
			return this._webMaster;
		}

		public function set webMaster(value:String):void {
			if ( this._webMaster == value ) return;
			this._webMaster = value;
			if ( !this.$lock ) super.dispatchEvent( new DataBaseEvent( DataBaseEvent.CHANGE, true ) );
		}

		private var _pubDate:Date;

		public function get pubDate():Date {
			return new Date( this._pubDate.getTime() );
		}

		public function set pubDate(value:Date):void {
			if ( this._pubDate === value || this._pubDate.getTime() == value.getTime() ) return;
			this._pubDate = value;
			if ( !this.$lock ) super.dispatchEvent( new DataBaseEvent( DataBaseEvent.CHANGE, true ) );
		}

		private var _lastBuildDate:Date;

		public function get lastBuildDate():Date {
			return new Date( this._lastBuildDate.getTime() );
		}

		public function set lastBuildDate(value:Date):void {
			if ( this._lastBuildDate === value || this._lastBuildDate.getTime() == value.getTime() ) return;
			this._lastBuildDate = value;
			if ( !this.$lock ) super.dispatchEvent( new DataBaseEvent( DataBaseEvent.CHANGE, true ) );
		}

		private var _category:RSSCategoryData;

		public function get category():RSSCategoryData {
			return this._category;
		}

		public function set category(value:RSSCategoryData):void {
			if ( this._category === value ) return;
			if ( value )	super.addChild( value );
			else			super.removeChild( this._category );
		}

		private var _generator:String;

		public function get generator():String {
			return this._generator;
		}

		public function set generator(value:String):void {
			if ( this._generator == value ) return;
			this._generator = value;
			if ( !this.$lock ) super.dispatchEvent( new DataBaseEvent( DataBaseEvent.CHANGE, true ) );
		}

		private var _docs:String;

		public function get docs():String {
			return this._docs;
		}

		public function set docs(value:String):void {
			if ( this._docs == value ) return;
			this._docs = value;
			if ( !this.$lock ) super.dispatchEvent( new DataBaseEvent( DataBaseEvent.CHANGE, true ) );
		}

		private var _cloud:RSSCloudData;

		public function get cloud():RSSCloudData {
			return this._cloud;
		}

		private var _ttl:uint;

		public function get ttl():uint {
			return this._ttl;
		}

		public function set ttl(value:uint):void {
			if ( this._ttl == value ) return;
			this._ttl = value;
			if ( !this.$lock ) super.dispatchEvent( new DataBaseEvent( DataBaseEvent.CHANGE, true ) );
		}

		private var _image:RSSImageData;

		public function get image():RSSImageData {
			return this._image;
		}

		public function set image(value:RSSImageData):void {
			if ( this._image === value ) return;
			if ( value )	super.addChild( value );
			else			super.removeChild( this._image );
		}

		private var _rating:String;

		public function get rating():String {
			return this._rating;
		}

		public function set rating(value:String):void {
			if ( this._rating == value ) return;
			this._rating = value;
			if ( !this.$lock ) super.dispatchEvent( new DataBaseEvent( DataBaseEvent.CHANGE, true ) );
		}

		private var _textInput:RSSTextInputData;

		public function get textInput():RSSTextInputData {
			return this._textInput;
		}

		public function set textInput(value:RSSTextInputData):void {
			if ( this._textInput === value ) return;
			if ( value )	super.addChild( value );
			else			super.removeChild( this._textInput );
		}

		public function skipHours():* {
			throw new ArgumentError();
		}

		public function skipDays():* {
			throw new ArgumentError();
		}

		public function getItems():Array {
			var num:int = super.numChildren;
			var result:Array = new Array();
			var child:Data;
			while ( num-- ) {
				child = super.getChildAt( num );
				if ( child is RSSItemData ) {
					result.push( child );
				}
			}
			return result;
		}

		public function getItemByTitle(title:String):RSSItemData {
			var num:int = super.numChildren;
			var child:Data;
			while ( num-- ) {
				child = super.getChildAt( num );
				if ( ( child is RSSItemData ) && ( child as RSSItemData ).title == title ) {
					return child as RSSItemData;
				}
			}
			return null;
		}

		public function getItemByGuid(guid:String):RSSItemData {
			var num:int = super.numChildren;
			var child:Data;
			while ( num-- ) {
				child = super.getChildAt( num );
				if ( ( child is RSSItemData ) && ( child as RSSItemData ).guid.name == guid ) {
					return child as RSSItemData;
				}
			}
			return null;
		}

		public override function parseXML(xml:XML):void {
			this.updateXML( xml );
		}

		public function updateXML(xml:XML):void {
			if ( xml.name().toString() != "channel" ) throw new ArgumentError();
			this.$lock++;
			super.parseXML( xml );
			
			this._language =		XMLUtils.parseStringNode( xml.language );
			this._copyright =		XMLUtils.parseStringNode( xml.copyright );
			this._managingEditor =	XMLUtils.parseStringNode( xml.managingEditor );
			this._webMaster =		XMLUtils.parseStringNode( xml.webMaster );
			this._pubDate =			XMLUtils.parseDateNode( xml.pubDate );
			this._lastBuildDate =	XMLUtils.parseDateNode( xml.lastBuildDate );
			this._generator =		XMLUtils.parseStringNode( xml.generator );
			this._docs =			XMLUtils.parseStringNode( xml.docs );
			this._ttl =				XMLUtils.parseUIntNode( xml.ttl );
			this._rating =			XMLUtils.parseStringNode( xml.rating );
			//skipDays
			//skipHours

			var list:XMLList;
			var prop:IRSSElementAsset;

			list = xml.category;
			if ( list.length() > 0 ) {
				if ( !this._category ) super.addChild( new RSSCategoryData() );
				this._category.parseXML( list[0] );
			} else {
				if ( this._category ) super.removeChild( this._category );
			}

			list = xml.cloud;
			if ( list.length() > 0 ) {
				if ( !this._cloud ) super.addChild( new RSSCloudData() );
				this._cloud.parseXML( list[0] );
			} else {
				if ( this._cloud ) super.removeChild( this._cloud );
			}

			list = xml.image;
			if ( list.length() > 0 ) {
				if ( !this._image ) super.addChild( new RSSImageData() );
				this._image.parseXML( list[0] );
			} else {
				if ( this._image ) super.removeChild( this._image );
			}

			list = xml.textInput;
			if ( list.length() > 0 ) {
				if ( this._textInput ) super.addChild( new RSSTextInputData() );
				this._textInput.parseXML( list[0] );
			} else {
				if ( this._textInput ) super.removeChild( this._textInput );
			}
			this.$lock--;

			list = xml.item;
			var guid:String;
			var x:XML, l:XMLList, item:RSSItemData;
			for each ( x in list ) {
				guid = XMLUtils.parseStringNode( x.guid );
				if ( guid ) {
					item = this.getItemByGuid( guid );
					if ( !item ) item = new RSSItemData();
				}
				item.parseXML( x );
				super.addChild( item );
			}

			if ( !this.$lock ) super.dispatchEvent( new DataBaseEvent( DataBaseEvent.CHANGE, true ) ); 
		}

		protected override function addChild_before(child:Data):void {
			super.addChild_before( child );
			var change:Boolean = false;
			this.$lock++;
			if ( child is RSSCategoryData ) {
				if ( this._category ) super.removeChild( this._category );
				this._category = child as RSSCategoryData;
				change = true;
			} else if ( child is RSSCloudData ) {
				if ( this._cloud ) super.removeChild( this._cloud );
				this._cloud = child as RSSCloudData;
				change = true;
			} else if ( child is RSSImageData ) {
				if ( this._image ) super.removeChild( this._image );
				this._image = child as RSSImageData;
				change = true;
			} else if ( child is RSSTextInputData ) {
				if ( this._textInput ) super.removeChild( this._textInput );
				this._textInput = child as RSSTextInputData;
				change = true;
			}
			this.$lock--;
			if ( change && !this.$lock ) super.dispatchEvent( new DataBaseEvent( DataBaseEvent.CHANGE, true ) );
		}

		protected override function removeChild_before(child:Data):void {
			super.removeChild_before( child );
			var change:Boolean = false;
			if ( child is RSSCategoryData ) {
				this._category = null;
				change = true;
			} else if ( child is RSSCloudData ) {
				this._cloud = null;
				change = true;
			} else if ( child is RSSImageData ) {
				this._image = null;
				change = true;
			} else if ( child is RSSTextInputData ) {
				this._textInput = null;
				change = true;
			}
			if ( change && !this.$lock ) super.dispatchEvent( new DataBaseEvent( DataBaseEvent.CHANGE, true ) );
		}

	}

}