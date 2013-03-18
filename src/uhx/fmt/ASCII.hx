package uhx.fmt;
import uhx.core.Klas;

/**
 * ...
 * @author Skial Bainn
 */

class ASCII implements Klas {

	@:alias('NULL')
	@:toString('\\0')
	public static inline var NUL:Int = 0;
	
	@:alias('START_OF_HEADER')
	public static inline var SOH:Int = 1;
	
	@:alias('START_OF_TEXT')
	public static inline var STX:Int = 2;
	
	@:alias('END_OF_TEXT')
	public static inline var ETX:Int = 3;
	
	@:alias('END_OF_TRANSMISSION')
	public static inline var EOT:Int = 4;
	
	@:alias('ENQUIRY')
	public static inline var ENQ:Int = 5;
	
	@:alias('ACKNOWLEDGMENT')
	public static inline var ACK:Int = 6;
	
	@:alias('BELL')
	@:toString('\\a')
	public static inline var BEL:Int = 7;
	
	@:toString('\\b')
	@:alias('BACKSPACE')
	public static inline var BS:Int = 8;
	
	@:toString('\\t')
	@:alias('HORIZONTAL_TAB')
	public static inline var HT:Int = 9;
	
	@:toString('\\n')
	@:alias('LINE_FEED', 'NEW_LINE')
	public static inline var LF:Int = 10;
	
	@:toString('\\v')
	@:alias('VERTICAL_TAB')
	public static inline var VT:Int = 11;
	
	@:toString('\\f')
	@:alias('FORM_FEED')
	public static inline var FF:Int = 12;
	
	@:toString('\\r')
	@:alias('CARRIAGE_RETURN')
	public static inline var CR:Int = 13;
	
	@:alias('SHIFT_OUT')
	public static inline var SO:Int = 14;
	
	@:alias('SHIFT_IN')
	public static inline var SI:Int = 15;
	
	@:alias('DATA_LINK_ESCAPE')
	public static inline var DLE:Int = 16;
	
	@:alias('DEVICE_CONTROL_1')
	public static inline var DC1:Int = 17;
	
	@:alias('DEVICE_CONTROL_2')
	public static inline var DC2:Int = 18;
	
	@:alias('DEVICE_CONTROL_3')
	public static inline var DC3:Int = 19;
	
	@:alias('DEVICE_CONTROL_4')
	public static inline var DC4:Int = 20;
	
	@:alias('NEGATIVE_ACKNOWLEDGEMENT')
	public static inline var NAK:Int = 21;
	
	@:alias('SYNCHRONOUS_IDLE')
	public static inline var SYN:Int = 22;
	
	@:alias('END_OF_TRANSMISSION_BLOCK')
	public static inline var ETB:Int = 23;
	
	@:alias('CANCEL')
	public static inline var CAN:Int = 24;
	
	@:alias('END_OF_MEDIUM')
	public static inline var EM:Int = 25;
	
	@:alias('SUBSTITUTE')
	public static inline var SUB:Int = 26;
	
	@:toString('\\e')
	@:alias('ESCAPE')
	public static inline var ESC:Int = 27;
	
	@:alias('FILE_SEPARATOR')
	public static inline var FS:Int = 28;
	
	@:alias('GROUP_SEPARATOR')
	public static inline var GS:Int = 29;
	
	@:alias('RECORD_SEPARATOR')
	public static inline var RS:Int = 30;
	
	@:alias('UNIT_SEPARATOR')
	public static inline var US:Int = 31;
	
	@:alias('DELETE')
	public static inline var DEL:Int = 127;
	
	@:toString('_')
	public static inline var SPACE:Int = 32;
	
	@:toString('!')
	public static inline var EXCLAMATION:Int = 33;
	
	@:toString('"')
	public static inline var QUOTATION:Int = 34;
	
	@:toString('#')
	@:alias('HASH')
	public static inline var NUMBER:Int = 35;
	
	@:toString('$')
	public static inline var DOLLAR:Int = 36;
	
	@:toString('%')
	public static inline var PERCENT:Int = 37;
	
	@:toString('&')
	public static inline var AMPERSAND:Int = 38;
	
	@:toString("'")
	public static inline var APOSTROPHE:Int = 39;
	
	@:toString('(')
	public static inline var OPEN_PARENTHESE:Int = 40;
	
	@:toString(')')
	public static inline var CLOSE_PARENTHESE:Int = 41;
	
	@:toString('*')
	public static inline var ASTERISK:Int = 42;
	
	@:toString('+')
	public static inline var PLUS:Int = 43;
	
	@:toString(',')
	public static inline var COMMA:Int = 44;
	
	@:toString('-')
	public static inline var HYPHEN:Int = 45;
	
	@:toString('.')
	public static inline var FULL_STOP:Int = 46;
	
	@:toString('/')
	public static inline var SLASH:Int = 47;
	
	@:toInt(0)
	@:toString('0')
	public static inline var ZERO:Int = 48;
	
	@:toInt(1)
	@:toString('1')
	public static inline var ONE:Int = 49;
	
	@:toInt(2)
	@:toString('2')
	public static inline var TWO:Int = 50;
	
	@:toInt(3)
	@:toString('3')
	public static inline var THREE:Int = 51;
	
	@:toInt(4)
	@:toString('4')
	public static inline var FOUR:Int = 52;
	
	@:toInt(5)
	@:toString('5')
	public static inline var FIVE:Int = 53;
	
	@:toInt(6)
	@:toString('6')
	public static inline var SIX:Int = 54;
	
	@:toInt(7)
	@:toString('7')
	public static inline var SEVEN:Int = 55;
	
	@:toInt(8)
	@:toString('8')
	public static inline var EIGHT:Int = 56;
	
	@:toInt(9)
	@:toString('9')
	public static inline var NINE:Int = 57;
	
	@:toString(':')
	public static inline var COLON:Int = 58;
	
	@:toString(';')
	public static inline var SEMICOLON:Int = 59;
	
	@:toString('<')
	public static inline var LESS_THAN:Int = 60;
	
	@:toString('=')
	public static inline var EQUALS:Int = 61;
	
	@:toString('>')
	public static inline var GREATER_THAN:Int = 62;
	
	@:toString('?')
	public static inline var QUESTION_MARK:Int = 63;
	
	@:toString('@')
	public static inline var AT:Int = 64;
	
	@:toString
	public static inline var A:Int = 65;
	
	@:toString
	public static inline var B:Int = 66;
	
	@:toString
	public static inline var C:Int = 67;
	
	@:toString
	public static inline var D:Int = 68;
	
	@:toString
	public static inline var E:Int = 69;
	
	@:toString
	public static inline var F:Int = 70;
	
	@:toString
	public static inline var G:Int = 71;
	
	@:toString
	public static inline var H:Int = 72;
	
	@:toString
	public static inline var I:Int = 73;
	
	@:toString
	public static inline var J:Int = 74;
	
	@:toString
	public static inline var K:Int = 75;
	
	@:toString
	public static inline var L:Int = 76;
	
	@:toString
	public static inline var M:Int = 77;
	
	@:toString
	public static inline var N:Int = 78;
	
	@:toString
	public static inline var O:Int = 79;
	
	@:toString
	public static inline var P:Int = 80;
	
	@:toString
	public static inline var Q:Int = 81;
	
	@:toString
	public static inline var R:Int = 82;
	
	@:toString
	public static inline var S:Int = 83;
	
	@:toString
	public static inline var T:Int = 84;
	
	@:toString
	public static inline var U:Int = 85;
	
	@:toString
	public static inline var V:Int = 86;
	
	@:toString
	public static inline var W:Int = 87;
	
	@:toString
	public static inline var X:Int = 88;
	
	@:toString
	public static inline var Y:Int = 89;
	
	@:toString
	public static inline var Z:Int = 90;
	
	@:toString('[')
	public static inline var OPEN_SQUARE_BRACKET:Int = 91;
	
	@:toString('\\')
	public static inline var BACKSLASH:Int = 92;
	
	@:toString(']')
	public static inline var CLOSE_SQUARE_BRACKET:Int = 93;
	
	@:toString('^')
	public static inline var CARET:Int = 94;
	
	@:toString('_')
	public static inline var UNDERSCORE:Int = 95;
	
	@:toString('`')
	public static inline var ACCENT:Int = 96;
	
	@:toString
	public static inline var a:Int = 97;
	
	@:toString
	public static inline var b:Int = 98;
	
	@:toString
	public static inline var c:Int = 99;
	
	@:toString
	public static inline var d:Int = 100;
	
	@:toString
	public static inline var e:Int = 101;
	
	@:toString
	public static inline var f:Int = 102;
	
	@:toString
	public static inline var g:Int = 103;
	
	@:toString
	public static inline var h:Int = 104;
	
	@:toString
	public static inline var i:Int = 105;
	
	@:toString
	public static inline var j:Int = 106;
	
	@:toString
	public static inline var k:Int = 107;
	
	@:toString
	public static inline var l:Int = 108;
	
	@:toString
	public static inline var m:Int = 109;
	
	@:toString
	public static inline var n:Int = 110;
	
	@:toString
	public static inline var o:Int = 111;
	
	@:toString
	public static inline var p:Int = 112;
	
	@:toString
	public static inline var q:Int = 113;
	
	@:toString
	public static inline var r:Int = 114;
	
	@:toString
	public static inline var s:Int = 115;
	
	@:toString
	public static inline var t:Int = 116;
	
	@:toString
	public static inline var u:Int = 117;
	
	@:toString
	public static inline var v:Int = 118;
	
	@:toString
	public static inline var w:Int = 119;
	
	@:toString
	public static inline var x:Int = 120;
	
	@:toString
	public static inline var y:Int = 121;
	
	@:toString
	public static inline var z:Int = 122;
	
	@:toString('{')
	public static inline var OPEN_CURLY_BRACKET:Int = 123;
	
	@:toString('|')
	public static inline var VERTICAL_BAR:Int = 124;
	
	@:toString('}')
	public static inline var CLOSE_CURLY_BRACKET:Int = 125;
	
	@:toString('~')
	public static inline var TILDE:Int = 126;
	
}