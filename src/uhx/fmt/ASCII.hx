package uhx.fmt;

import uhx.core.Klas;

/**
 * ...
 * @author Skial Bainn
 */


class ASCII implements Klas {

	@:to(s='\\0')
	@:alias('NULL')
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
	
	@:to(s='\\a')
	@:alias('BELL')
	public static inline var BEL:Int = 7;
	
	@:to(s='\\b')
	@:alias('BACKSPACE')
	public static inline var BS:Int = 8;
	
	@:to(s='\\t')
	@:alias('HORIZONTAL_TAB')
	public static inline var HT:Int = 9;
	
	@:to(s='\\n')
	@:alias('LINE_FEED', 'NEW_LINE')
	public static inline var LF:Int = 10;
	
	@:to(s='\\v')
	@:alias('VERTICAL_TAB')
	public static inline var VT:Int = 11;
	
	@:to(s='\\f')
	@:alias('FORM_FEED')
	public static inline var FF:Int = 12;
	
	@:to(s='\\r')
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
	
	@:to(s='\\e')
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
	
	@:to(s='_')
	public static inline var SPACE:Int = 32;
	
	@:to(s='!')
	public static inline var EXCLAMATION:Int = 33;
	
	@:to(s='"')
	public static inline var QUOTATION:Int = 34;
	
	@:to(s='#')
	@:alias('HASH')
	public static inline var NUMBER:Int = 35;
	
	@:to(s='$')
	public static inline var DOLLAR:Int = 36;
	
	@:to(s='%')
	public static inline var PERCENT:Int = 37;
	
	@:to(s='&')
	public static inline var AMPERSAND:Int = 38;
	
	@:to(s="'")
	public static inline var APOSTROPHE:Int = 39;
	
	@:to(s='(')
	public static inline var OPEN_PARENTHESE:Int = 40;
	
	@:to(s=')')
	public static inline var CLOSE_PARENTHESE:Int = 41;
	
	@:to(s='*')
	public static inline var ASTERISK:Int = 42;
	
	@:to(s='+')
	public static inline var PLUS:Int = 43;
	
	@:to(s=',')
	public static inline var COMMA:Int = 44;
	
	@:to(s='-')
	public static inline var HYPHEN:Int = 45;
	
	@:to(s='.')
	public static inline var FULL_STOP:Int = 46;
	
	@:to(s='/')
	public static inline var SLASH:Int = 47;
	
	@:to(s='0')
	public static inline var ZERO:Int = 48;
	
	@:to(s='1')
	public static inline var ONE:Int = 49;
	
	@:to(s='2')
	public static inline var TWO:Int = 50;
	
	@:to(s='3')
	public static inline var THREE:Int = 51;
	
	@:to(s='4')
	public static inline var FOUR:Int = 52;
	
	@:to(s='5')
	public static inline var FIVE:Int = 53;
	
	@:to(s='6')
	public static inline var SIX:Int = 54;
	
	@:to(s='7')
	public static inline var SEVEN:Int = 55;
	
	@:to(s='8')
	public static inline var EIGHT:Int = 56;
	
	@:to(s='9')
	public static inline var NINE:Int = 57;
	
	@:to(s=':')
	public static inline var COLON:Int = 58;
	
	@:to(s=';')
	public static inline var SEMICOLON:Int = 59;
	
	@:to(s='<')
	public static inline var LESS_THAN:Int = 60;
	
	@:to(s='=')
	public static inline var EQUALS:Int = 61;
	
	@:to(s='>')
	public static inline var GREATER_THAN:Int = 62;
	
	@:to(s='?')
	public static inline var QUESTION_MARK:Int = 63;
	
	@:to(s='@')
	public static inline var AT:Int = 64;
	
	@:to(s)
	public static inline var A:Int = 65;
	
	@:to(s)
	public static inline var B:Int = 66;
	
	@:to(s)
	public static inline var C:Int = 67;
	
	@:to(s)
	public static inline var D:Int = 68;
	
	@:to(s)
	public static inline var E:Int = 69;
	
	@:to(s)
	public static inline var F:Int = 70;
	
	@:to(s)
	public static inline var G:Int = 71;
	
	@:to(s)
	public static inline var H:Int = 72;
	
	@:to(s)
	public static inline var I:Int = 73;
	
	@:to(s)
	public static inline var J:Int = 74;
	
	@:to(s)
	public static inline var K:Int = 75;
	
	@:to(s)
	public static inline var L:Int = 76;
	
	@:to(s)
	public static inline var M:Int = 77;
	
	@:to(s)
	public static inline var N:Int = 78;
	
	@:to(s)
	public static inline var O:Int = 79;
	
	@:to(s)
	public static inline var P:Int = 80;
	
	@:to(s)
	public static inline var Q:Int = 81;
	
	@:to(s)
	public static inline var R:Int = 82;
	
	@:to(s)
	public static inline var S:Int = 83;
	
	@:to(s)
	public static inline var T:Int = 84;
	
	@:to(s)
	public static inline var U:Int = 85;
	
	@:to(s)
	public static inline var V:Int = 86;
	
	@:to(s)
	public static inline var W:Int = 87;
	
	@:to(s)
	public static inline var X:Int = 88;
	
	@:to(s)
	public static inline var Y:Int = 89;
	
	@:to(s)
	public static inline var Z:Int = 90;
	
	@:to(s='[')
	public static inline var OPEN_SQUARE_BRACKET:Int = 91;
	
	@:to(s='\\')
	public static inline var BACKSLASH:Int = 92;
	
	@:to(s=']')
	public static inline var CLOSE_SQUARE_BRACKET:Int = 93;
	
	@:to(s='^')
	public static inline var CARET:Int = 94;
	
	@:to(s='_')
	public static inline var UNDERSCORE:Int = 95;
	
	@:to(s='`')
	public static inline var ACCENT:Int = 96;
	
	@:to(s)
	public static inline var a:Int = 97;
	
	@:to(s)
	public static inline var b:Int = 98;
	
	@:to(s)
	public static inline var c:Int = 99;
	
	@:to(s)
	public static inline var d:Int = 100;
	
	@:to(s)
	public static inline var e:Int = 101;
	
	@:to(s)
	public static inline var f:Int = 102;
	
	@:to(s)
	public static inline var g:Int = 103;
	
	@:to(s)
	public static inline var h:Int = 104;
	
	@:to(s)
	public static inline var i:Int = 105;
	
	@:to(s)
	public static inline var j:Int = 106;
	
	@:to(s)
	public static inline var k:Int = 107;
	
	@:to(s)
	public static inline var l:Int = 108;
	
	@:to(s)
	public static inline var m:Int = 109;
	
	@:to(s)
	public static inline var n:Int = 110;
	
	@:to(s)
	public static inline var o:Int = 111;
	
	@:to(s)
	public static inline var p:Int = 112;
	
	@:to(s)
	public static inline var q:Int = 113;
	
	@:to(s)
	public static inline var r:Int = 114;
	
	@:to(s)
	public static inline var s:Int = 115;
	
	@:to(s)
	public static inline var t:Int = 116;
	
	@:to(s)
	public static inline var u:Int = 117;
	
	@:to(s)
	public static inline var v:Int = 118;
	
	@:to(s)
	public static inline var w:Int = 119;
	
	@:to(s)
	public static inline var x:Int = 120;
	
	@:to(s)
	public static inline var y:Int = 121;
	
	@:to(s)
	public static inline var z:Int = 122;
	
	@:to(s='{')
	public static inline var OPEN_CURLY_BRACKET:Int = 123;
	
	@:to(s='|')
	public static inline var VERTICAL_BAR:Int = 124;
	
	@:to(s='}')
	public static inline var CLOSE_CURLY_BRACKET:Int = 125;
	
	@:to(s='~')
	public static inline var TILDE:Int = 126;
	
}