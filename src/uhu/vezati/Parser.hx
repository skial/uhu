package uhu.vezati;

import Xml;
import haxe.xml.Parser;
import thx.html.Html;

using Std;
using uhu.Library;
using selecthxml.SelectDom;

/**
 * ...
 * @author Skial Bainn
 */

class Parser {
	
	// private fields
	
	private static var manyActions:Array<String> = ['repeat'];
	private static var elements:Hash< Array<Xml> > = new Hash< Array<Xml> >();
	
	// public fields
	
	public static var prefix:String = 'dtx-';

	public static function parse(html:String) {
		var xml:Xml = Html.toXml(html);
		
		var _v;
		
		// Required - app is the root element to work from
		_v = xml.runtimeSelect( '[${prefix}app]'.format() );
		
		if (_v.length == 1) {
			elements.set('${prefix}app'.format(), _v);
		} else {
			// Could default to body if it exists
			throw 'You need to defind ${prefix}app ONCE in your html file.'.format();
		}
		
		// Actions DONT have values and ARE prefixed
		for (action in manyActions) {
			_v = xml.runtimeSelect( '[$prefix$action]'.format() );
			
			if (_v.length != 0) {
				if (elements.exists(action)) {
					elements.set(action, elements.get(action).concat(_v));
				} else {
					elements.set(action, _v);
				}
			}
		}
		
		for (k in elements.keys()) {
			trace(elements.get(k));
		}
		
		return { };
	}
	
}