package ;

import uhx.macro.NamedArgsSpec;
import uhx.sys.EdeSpec;
import uhx.sys.LiySpec;
import uhx.sys.LodSpec;
//import uhx.macro.PubSubSpec;
#if js
import uhx.macro.WaitSpec;
import uhx.tem.TemSpec;
#end

/*import haxe.Utf8Spec;
import uhx.macro.help.TemArray.TemArray;
import uhx.web.URISpec;*/
//import uhx.fmt.ASCIISpec;
/*import haxe.io.StringInput;
import uhx.oauth.GithubSpec;
import haxe.unit.TestRunner;

//#if !js
import uhu.mu.MustacheSpec;
import uhu.mu.CommentSpec;
import uhu.mu.SectionSpec;
/*import uhu.mu.DelimiterSpec;
import uhu.mu.InterpolationSpec;
import uhu.mu.InvertedSpec;
import uhu.mu.PartialSpec;
import uhu.mu.WalkContextSpec;*/
//#end

//#if js
import uhx.http.Request;
import uhx.http.Response;
import uhx.http.RequestSpec;
//#end

/*#if sys
import sys.net.HostSpec;
import sys.net.SocketSpec;
import uhx.oauth.OAuth10aSpec;
#end

import uhx.crypto.Base64Spec;
import uhx.crypto.HMACSpec;
import uhx.crypto.MD5Spec;*/

import utest.TestHandler;
import utest.Runner;
import utest.ui.Report;

/**
 * ...
 * @author Skial Bainn
 */

#if !disable_macro_tests
//@:build( MacroTests.run() )
#end
class AllTests {
	
	public static function main() {	
		
		var runner = new Runner();
		
		//runner.addCase( new ASCIISpec() );
		
		/*#if !js
		runner.addCase( new Utf8Spec() );
		#end
		
		runner.addCase( new Base64Spec() );
		runner.addCase( new MD5Spec() );
		runner.addCase( new HMACSpec() );
		
		runner.addCase( new URISpec() );
		
		#if sys
		
		//runner.addCase( new OAuth10aSpec() );
		
		//runner.addCase( new HostSpec() );
		//runner.addCase( new SocketSpec() );	// temp disabled - neko cant start echo socket
		
		#end*/
		
		//#if !js
		// Mustache Tests
		//runner.addCase( new MustacheSpec() ); //
		//runner.addCase( new CommentSpec() );
		//runner.addCase( new SectionSpec() ); 
		/*runner.addCase( new DelimiterSpec() ); //
		runner.addCase( new InterpolationSpec() );
		runner.addCase( new InvertedSpec() );
		runner.addCase( new PartialSpec() ); //
		runner.addCase( new WalkContextSpec() ); */
		//#end
		
		// Github OAuth Tests
		//runner.addCase( new GithubSpec() );
		
		#if js
		runner.addCase( new TemSpec() );	//	No useful error given if TemSpec and RequestSpec are compiled together...
		runner.addCase( new WaitSpec() );
		#end
		//runner.addCase( new PubSubSpec() );
		runner.addCase( new RequestSpec() );
		runner.addCase( new NamedArgsSpec() );
		runner.addCase( new LodSpec() );
		runner.addCase( new LiySpec() );
		runner.addCase( new EdeSpec() );
		
		Report.create( runner );
		
		#if !macro
		Console.start();
		#end
		
		runner.run();
		
	}
	
}