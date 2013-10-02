package ;

import haxe.rtti.Meta;
import de.polygonal.core.fmt.ASCII;

/**
 * ...
 * @author Skial Bainn
 * Haitian Creole for Words
 */
class Mo {

	public function new() {
		
	}
	
	public static function cssify(token:Dynamic):String {
		var meta = Meta.getFields( Type.getEnum( token ) );
		var name = Type.enumConstructor( token );
		
		if (Reflect.hasField(meta, name)) {
			if (Reflect.hasField(Reflect.field(meta, name), 'css')) {
				var info = Reflect.field(Reflect.field(meta, name), 'css');
				name = name.substr(info[0]);
				
				if (info[1] != null) {
					for (param in Type.enumParameters( token ) ) {
						if (Reflect.isEnumValue( param )) {
							name += ' ' + cssify( param );
						}
					}
				}
			}
			
			if (Reflect.hasField(Reflect.field(meta, name), 'split')) {
				var parts = name.split('');
				var i = 0;
				
				name = '';
				
				while ( i < parts.length ) {
					
					if (i != 0 && ASCII.isUpperCaseAlphabetic( parts[i].charCodeAt(0) )) {
						name += ' ';
					}
					
					name += parts[i];
					i++;
					
				}
				
			}
		}
		
		return name.toLowerCase();
	}
	
}