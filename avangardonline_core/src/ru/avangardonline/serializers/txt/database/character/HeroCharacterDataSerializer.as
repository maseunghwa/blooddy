////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2009 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package ru.avangardonline.serializers.txt.database.character {

	import ru.avangardonline.database.character.HeroCharacterData;
	import ru.avangardonline.serializers.ISerializer;

	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					19.08.2009 22:39:30
	 */
	public class HeroCharacterDataSerializer extends CharacterDataSerializer implements ISerializer {

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static const _serializer:HeroCharacterDataSerializer = new HeroCharacterDataSerializer();

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		public static function deserialize(source:String, target:HeroCharacterData=null):HeroCharacterData {
			return _serializer.deserialize( source, target ) as HeroCharacterData;
		}

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * Constructor
		 */
		public function HeroCharacterDataSerializer() {
			super();
		}

		//--------------------------------------------------------------------------
		//
		//  Overriden methods
		//
		//--------------------------------------------------------------------------

		public override function deserialize(source:String, target:*=null):* {
			if ( source.charAt( 0 ) != 'h' ) throw new ArgumentError();
			var data:HeroCharacterData = target as HeroCharacterData;
			var arr:Array = source.substr( 2 ).split( '|', 1 );
			var arr2:Array = arr[ 0 ].split( ',', 2 );
			if ( !data ) {
				data = new HeroCharacterData( parseInt( arr2[ 0 ] ) );
			}
			super.deserialize( source, data );
			data.nick = arr2[1];
			return data;
		}

	}

}