package uhu.mu;

import haxe.ds.StringMap;
import haxe.io.Eof;
import haxe.io.StringInput;
import uhu.mu.t.TParser;
import uhu.mu.t.TSection;
import uhu.mu.e.ETag;
import uhu.mu.Common;

using Arrays;
using StringTools;

/**
 * ...
 * @author Skial Bainn
 */
 
#if hocco
@:hocco
#end
class Parser {
	
	public var tokens(default, null):Array<ETag>;
	public var sections(default, null):Array<ETag>;
	public var partials(default, null):StringMap<String>;
	public var template(default, null):String;
	public var regex(default, null):EReg;
	public var standalone(default, null):EReg;
	public var otag(default, null):String;
	public var ctag(default, null):String;
	
	private var _template:String;
	
	#if mu_grow
	/**
	 * extend(tag, tokens);
	 */
	public var extend:String->Array<ETag>->Void;
	#end
	
	public function new(otag:String = null, ctag:String = null) {
		tokens = new Array<ETag>();
		sections = new Array<ETag>();
		partials = new StringMap<String>();
		
		this.otag = (otag == null ? Common.OPENING : otag);
		this.ctag = (ctag == null ? Common.CLOSING : ctag);

		if (regex == null) regex = Common.REGEX;
		if (standalone == null) standalone = Common.STANDALONE;
	}
	
	public function parse(template:String):TParser {
		this.template = _template = template;
		
		if (template == null || template == '') {
			throw 'Template is empty.';
		}
		
		while (eos() == false) {
			scan();
		}
		
		return { template:template, tokens:tokens };
	}
	
	public function setTag(otag:String, ctag:String):Void {
		this.otag = (otag == null ? Common.OPENING : otag);
		this.ctag = (ctag == null ? Common.CLOSING : ctag);
		this.regex = Common.createRegex(otag, ctag);
		this.standalone = Common.createStandalone(otag, ctag);
	}
	
	private function eos():Bool {
		if (_template != '') return false;
		return true;
	}
	
	private function scan() {
		var match:Bool = regex.match(_template);
		var matcher:EReg = regex;
		
		if (_template.indexOf(otag) == -1) {
			tokens.push(Static(_template));
			_template = '';
			return;
		}
		
		if (!match) {
			throw 'Encoutered an unclosed tag: "' + _template + '"';
		}
		
		var all:String = matcher.matched(0);
		var pre:String = matcher.matchedLeft();
		var whitespace:String = matcher.matched(1);
		var tag:String = matcher.matched(2).trim();
		var content:String = matcher.matched(3).trim();
		var remainder:String = matcher.matchedRight();
		
		if (['{', '='].indexOf(tag) != -1) {
			if (tag == '{' && matcher.matched(4) != '}') {
				throw 'Triple mustache / unescaped HTML is missing a closing tag.';
			}
		}
		
		var trailingRe = ~/^(?:\r|\\r|\n|\\n)/;
		var leadingRe = ~/(^)?(?:\r|\\r|\n|\\n)/;
		var whitespaceRe = ~/(?:\s{2,}|\t|\\t)$/;
		
		var matchTrailing = trailingRe.match(remainder);
		var matchLeading = leadingRe.match(pre);
		var matchWhitespace = whitespaceRe.match(whitespace);
		
		var carriageRe:EReg = ~/^(?:\r|\\r)/;
		var newlineRe:EReg = ~/^(?:\n|\\n)/;
		
		var isStandalone:Bool = standalone.match(pre + all);
		
		var notInterpolating:Bool = ['', '&', '{'].indexOf(tag) == -1;
		
		#if (debug && madness)
		/* 
		 * madness starts here
		 */
		trace('ALL : ' + all.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		trace('INTER : ' + notInterpolating);
		trace('STANDALONE : ' + isStandalone);
		trace('PRE : ' + pre.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		trace('WHITESPACE : ' + whitespace.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		trace('REMAINDER : ' + remainder.replace(' ', '_s_').replace('\r', '_r_').replace('\n', '_n_').replace('\t', '_t_'));
		
		trace('TRAILING : ' + trailingRe.match(remainder));
		trace('LEADING : ' + leadingRe.match(pre));
		trace('SPACE : ' + whitespaceRe.match(whitespace));
		
		trace('SKIAL! : ' + isStandalone);
		if (isStandalone) {
			trace('EXTRA : ' + (standalone.matched(0).charAt(0) != '{' && standalone.matched(0).charAt(standalone.matched(0).length) != '}'));
		}
		trace(standalone.match(pre + all + remainder));
		trace(pre + all + remainder);
		#end
		
		if (isStandalone && notInterpolating) {
			remainder = carriageRe.replace(remainder, '');
			remainder = newlineRe.replace(remainder, '');
		} 
		else if (pre != '' && whitespace != '' && notInterpolating) {
			whitespace = whitespaceRe.replace(whitespace, '');
		} 
		else if (matchLeading && notInterpolating) {
			if (~/(?:\r|\\r|\n|\\n)$/.match(pre)) {
				remainder = carriageRe.replace(remainder, '');
				remainder = newlineRe.replace(remainder, '');
			} else {
				pre = ~/(^)?(?:\n|\\n)($)?/.replace(pre, '');
				pre = ~/(^)?(?:\r|\\r)($)?/.replace(pre, '');
			}
		}
		
		tokens.push(Static(pre));
		tokens.push(Static(whitespace));
		
		if (whitespace == matcher.matched(1)) {
			whitespace = '';
		}
		
		switch (tag) {
			case '':
				
				tokens.push(Normal(content));
				
			case '&', '{':	//	unescaped HTML
				
				tokens.push(Unescape(content));
				
			case '#', '^':	//	start section
				var block:Array<ETag> = [];
				var closeSection:String = otag + '/' + content + ctag;
				var sectionEreg:EReg = new EReg(closeSection, '');
				var sectionContent:String = '';
				
				if (sectionEreg.match(remainder)) {
					sectionContent = remainder.substr(0, sectionEreg.matchedPos().pos).trim();
				}
				
				tokens.push(Section(
					content, 
					true, 
					block,	//	diff
					sectionContent,
					(tag == '^')
				));
				
				sections.push(
					Section(
						content, 
						true, 
						tokens,	//	diff
						sectionContent,
						(tag == '^')
					)
				);
				
				tokens = block;
			case '/':	//	end section
				
				switch (sections.pop()) {
					default:
						throw 'Problem with last section. Check $all.';
					case Section(_, _, t, _, _):
						tokens = t;
				}
				
			case '>':	//	partial
				
				tokens.push(Partials(content, Common.loadPartial(content, whitespace)));
				
			case '!':	//	comments
				
				tokens.push(Comments(content));
				
			case '=':	//	delimiter
				var tags = content.split(' ');
				
				setTag(tags.first(), tags.last());
				
				tokens.push(Delimiter(content));
			
			#if mu_grow
			case _:
				extend(tag, tokens);
			#end
		}
		
		_template  = remainder;
	}
	
}