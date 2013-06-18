package example.hxparse;

import haxe.io.StringInput;
import example.hxparse.Mu;

/**
 * ...
 * @author Skial Bainn
 */
class Main {

	public static function main() {
		var parser = new MuParser( new StringInput('  12 {{! 34 }}\n') );
		var parser = new MuParser( new StringInput('<h1>{{ header }}</h1>
{{#list}}
<ul>
{{#item}}{{# current }}<li><strong>{{name}}</strong></li>
{{/ current }}{{#link}}<li><a href="{{url}}">{{name}}</a></li>
{{/link}}{{/item}}</ul>{{/list}}{{#empty}}<p>The list is empty.</p>{{/empty}}') );
	}
	
}