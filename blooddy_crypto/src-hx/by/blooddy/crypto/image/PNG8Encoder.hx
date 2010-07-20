////////////////////////////////////////////////////////////////////////////////
//
//  © 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.image;

import by.blooddy.crypto.image.palette.IPalette;
import by.blooddy.crypto.image.palette.MedianCutPalette;
import by.blooddy.system.Memory;
import by.blooddy.utils.ByteArrayUtils;
import flash.display.BitmapData;
import flash.Error;
import flash.utils.ByteArray;
import flash.Vector;

/**
 * @author	BlooDHounD
 * @version	1.0
 */
class PNG8Encoder {

	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------

	public static function encode(image:BitmapData, ?palette:IPalette=null, ?filter:UInt=0):ByteArray {
		if ( palette == null ) {
			palette = new MedianCutPalette( image );
		}
		return TMP.encode( image, palette, filter );
	}

}

/**
 * @private
 */
private class TMP {
	
	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------

	public static inline function encode(image:BitmapData, palette:IPalette, filter:UInt):ByteArray {

		var mem:ByteArray = Memory.memory;

		var width:UInt = image.width;
		var height:UInt = image.height;

		var len:UInt = width * height + height;
		var len2:UInt = len + width;

		var bits:UInt;
		// Create output byte array
		var bytes:ByteArray = new ByteArray();
		var chunk:ByteArray = ByteArrayUtils.createByteArray( len2 );

		// PNG signature
		PNGEncoderHelper.writeSignature( bytes );

		// IHDR
		PNGEncoderHelper.writeIHDR( bytes, chunk, width, height, 0x08, 0x03 );

		// PLTE
		// tRNS
		if ( image.transparent ) {
			writeColors( bytes, chunk, palette, true );
		} else {
			writeColors( bytes, chunk, palette, false );
		}

		// IDAT
		// IDAT
		if ( len2 < 1024 ) chunk.length = 1024;
		else chunk.length = len2;
		Memory.memory = chunk;
		if ( image.transparent ) {
			if ( len < 4 + 4 * 256 ) Memory.fill( len, min( 4 + 4 * 256, len2 ), 0x00 ); // мы случайно могли наследить
			writeIDATContent( image, palette, filter, len, true );
		} else {
			if ( len < 4 + 3 * 256 ) Memory.fill( len, min( 4 + 3 * 256, len2 ), 0x00 ); // мы случайно могли наследить
			writeIDATContent( image, palette, filter, len, false );
		}
		Memory.memory = mem;
		chunk.length = len;
		chunk.compress();
		chunk.position = 4;
		chunk.writeBytes( chunk );
		chunk.position = 0;
		chunk.writeUnsignedInt( 0x49444154 );
		PNGEncoderHelper.writeChunk( bytes, chunk );

		// tEXt
		PNGEncoderHelper.writeTEXT( bytes, chunk, 'Software', 'by.blooddy.crypto.image.PNG8Encoder' );

		// IEND
		PNGEncoderHelper.writeIEND( bytes, chunk );

		Memory.memory = mem;

		chunk.clear();

		bytes.position = 0;

		return bytes;
	}

	//--------------------------------------------------------------------------
	//
	//  Private class methods
	//
	//--------------------------------------------------------------------------

	/**
	 * @private
	 */
	private static inline function min(v1:UInt, v2:UInt):UInt {
		return ( v1 < v2 ? v1 : v2 );
	}

	/**
	 * @private
	 */
	private static inline function writeColors(bytes:ByteArray, chunk:ByteArray, palette:IPalette, transparent:Bool):Void {
		chunk.length = 1024 + 4;
		Memory.memory = chunk;

		var colors:Vector<UInt> = palette.getColors();
		var l:UInt = colors.length;

		var i:UInt = 4;
		var j:UInt = 4 + 3 * 256;
		var k:UInt = 0;
		var c:UInt;
		do {
			c = colors[ k ];
			if ( transparent ) { // a
				Memory.setByte( j++, c >> 24 );
			}
			// rgb
			Memory.setByte( i++, c >> 16 );
			Memory.setByte( i++, c >>  8 );
			Memory.setByte( i++, c       );
		} while ( ++k < l );
		Memory.memory = null;
		// PLTE
		chunk.position = 0;
		chunk.writeUnsignedInt( 0x504C5445 );
		chunk.length = 4 + 3 * l;
		PNGEncoderHelper.writeChunk( bytes, chunk );
		// tRNS
		if ( transparent ) {
			chunk.length = 1024 + 4;
			chunk.position = 0;
			chunk.writeUnsignedInt( 0x74524E53 );
			chunk.writeBytes( chunk, 4 + 3 * 256, l );
			chunk.length = l + 4;
			PNGEncoderHelper.writeChunk( bytes, chunk );
		}
	}
	
	/**
	 * @private
	 */
	private static inline function writeIDATContent(image:BitmapData, palette:IPalette, filter:UInt, offset:UInt, transparent:Bool):Void {
		var width:UInt = image.width;
		var height:UInt = image.height;

		var x:UInt, y:UInt = 0;
		var c:UInt, c0:UInt, c1:UInt, c2:UInt;
		var i:UInt = 0, j:UInt;

		switch ( filter ) {

			case PNGEncoderHelper.NONE:
				do {
					Memory.setByte( i++, PNGEncoderHelper.NONE );
					x = 0;
					do {
						Memory.setByte(
							i++,
							palette.getIndexByColor(
								transparent ? image.getPixel32( x, y ) : image.getPixel( x, y )
							)
						);
					} while ( ++x < width );
				} while ( ++y < height );


			case PNGEncoderHelper.SUB:
				do {
					Memory.setByte( i++, PNGEncoderHelper.SUB );
					c0 = 0;
					x = 0;
					do {

						c = palette.getIndexByColor(
							transparent ? image.getPixel32( x, y ) : image.getPixel( x, y )
						);
						Memory.setByte( i++, c - c0 );
						c0 = c;

					} while ( ++x < width );
				} while ( ++y < height );


			case PNGEncoderHelper.UP:
				do {
					j = offset;
					Memory.setByte( i++, PNGEncoderHelper.UP );
					x = 0;
					do {
						c = palette.getIndexByColor(
							transparent ? image.getPixel32( x, y ) : image.getPixel( x, y )
						);
						Memory.setByte( i++, c - Memory.getByte( j ) );
						Memory.setByte( j++, c );
					} while ( ++x < width );
				} while ( ++y < height );

			
			case PNGEncoderHelper.AVERAGE:
				do {
					j = offset;
					Memory.setByte( i++, PNGEncoderHelper.AVERAGE );
					c0 = 0;
					x = 0;
					do {

						c = palette.getIndexByColor(
							transparent ? image.getPixel32( x, y ) : image.getPixel( x, y )
						);

						Memory.setByte( i++, c - ( ( c0 + Memory.getByte( j ) ) >>> 1 ) );
						c0 = c;

						Memory.setByte( j++, c );
						
					} while ( ++x < width );
				} while ( ++y < height );


			case PNGEncoderHelper.PAETH:
				do {

					j = offset;
					Memory.setByte( i++, PNGEncoderHelper.PAETH );
					c0 = 0;
					c2 = 0;
					x = 0;
					do {

						c = palette.getIndexByColor(
							transparent ? image.getPixel32( x, y ) : image.getPixel( x, y )
						);

						c1 = Memory.getByte( j );
						Memory.setByte( i++, c - PNGEncoderHelper.paethPredictor( c0, c1, c2 ) );
						c0 = c;
						c2 = c1;

						Memory.setByte( j++, c );

					} while ( ++x < width );
				} while ( ++y < height );


			default:
				Error.throwError( ArgumentError, 2008, 'filter' );

		}
	}

}