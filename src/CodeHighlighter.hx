
private typedef CodeHighlighterLanguage = {
	var names : Array<String>;
	var rules : Array<Rule>;
}

private enum Rule {
    Flat( type : String, pattern : EReg);
    Nested( language : String, start : Rule, end : Rule );
}

private enum Match {
    Done;
    Matched;
    NotMatched;
}

/**
*/
@:hocco
class CodeHighlighter {
	
	// Common patterns
	static var patterns = {
        ignorable: ~/^[ \t\r\n]+/,
        tripleString: ~/^(["]{3}(["]{0,2}[^\\"]|\\.)*["]{3})/,
        doubleString: ~/^(["]([^\\"]|\\.)*["])/,
        singleString: ~/^([']([^'\\]|['][']|\\.)*['])/,
        number: ~/^(0x[0-9a-fA-F]+|([0-9]+([.][0-9]+)?([eE][+-]?[0-9]+)?)[a-zA-Z]?)/,
        dollarIdentifier: ~/^([$][a-zA-Z0-9_]*)/,
        identifier: ~/^([a-zA-Z_][a-zA-Z0-9_]*)/,
        upperIdentifier: ~/^([A-Z][a-zA-Z0-9_]*)/,
        lowerIdentifier: ~/^([a-z_][a-zA-Z0-9_]*)/,
        docCommentBegin: ~/^\/\*\*/,
        docCommentEnd: ~/^\*\//,
        blockComment: ~/^([\/][*]([^*]|[*][^\/])*[*][\/])/,
        lineComment: ~/^([\/][\/][^\r\n]*(\r\n|\r|\n)?)/,
        entity: ~/^([&][^;]+[;])/,
    };
    
	// Common rules
	static var common = {
        ignorable:
            Flat("", patterns.ignorable),
        docComment: 
            Nested("doc-comment", 
                Flat("comment", patterns.docCommentBegin), 
                Flat("comment", patterns.docCommentEnd)
            ),
        blockComment:
            Flat("comment", patterns.blockComment),
        lineComment:
            Flat("comment", patterns.lineComment),
        dashComment:
            Flat("comment", ~/^([-][-][^\n]*)/),
        dashBlockComment:
            Flat("comment", ~/^([{][-]([^-]|[-][^}])*[-][}])/),
        hashComment:
            Flat("comment", ~/^([#][^\n\r]*)/),
        number:
            Flat("number", patterns.number),
        tripleString:
            Flat("string", patterns.tripleString),
        doubleString:
            Flat("string", patterns.doubleString),
        singleString:
            Flat("string", patterns.singleString),
        functionName:
            Flat("", ~/^([a-zA-Z_][a-zA-Z0-9_]*\s*[(])/),
        regex:
			Flat( "string", ~/^~\/([^\\\/]|\\.)*\/[a-zA-Z]*/ )
    };
    
    public static var HAXE : CodeHighlighterLanguage = {
       	names: ["hx","haxe"],
        rules: [
            common.ignorable,
            Flat( "keyword", ~/^(public|private|package|import|enum|class|interface|typedef|implements|extends|if|else|switch|case|default|for|in|do|while|continue|break|dynamic|untyped|cast|static|inline|extern|override|var|function|new|return|trace|try|catch|throw|this|null|true|false|super|typeof|undefined)\b/),
			Flat( "keyword", ~/^(#((if|elseif)(\s+[a-zA-Z_]+)?|(else|end)))\b/),
            Flat( "type", patterns.upperIdentifier),
            common.functionName,
            Flat( "variable", patterns.lowerIdentifier ),
            common.docComment, common.blockComment, common.lineComment,
            common.number, common.doubleString, common.singleString,
            common.regex,
			Flat( "operator", ~/^(!|~|-*|\\++)/), // unop
			Flat( "operator", new EReg('^((>>{1,3}|<<{1,2}|-|\\|{1,2}|\\^|&+|!|\\+{1}|\\*)(={0,2})|%|\\.{3}|/|=)', '')), // binop
        ]
    };
    
	public static var CSS : CodeHighlighterLanguage = {
		names: ["css"],
		rules: [
			common.ignorable,
			Flat("variable", ~/^([a-zA-Z-]+[:])/),
			Flat("number", ~/^([#][0-9a-fA-F]{6}|[0-9]+[a-zA-Z%]*)/),
			Flat("type", ~/^([#.:]?[a-zA-Z>-][a-zA-Z0-9>-]*)/),
			Flat("keyword", ~/^(url|rgb|rect|inherit)\b/),
			Flat("comment", ~/^(<!--|-->)/),
			common.blockComment
		]
	};
	
	public static var JS : CodeHighlighterLanguage = {
		names: [ "js","javascript"],
		rules: [
			common.ignorable,
			Flat("keyword", ~/^(abstract|boolean|break|byte|case|catch|char|class|const|continue|debugger|default|delete|do|double)\b/),
			Flat("keyword", ~/^(else|enum|export|extends|false|final|finally|float|for|function|goto|if|implements|import|in)\b/),
			Flat("keyword", ~/^(instanceof|int|interface|long|native|new|null|package|private|protected|public|return|short|static|super)\b/),
			Flat("keyword", ~/^(switch|synchronized|this|throw|throws|transient|true|try|typeof|var|void|volatile|while|with)\b/),
			Flat("type", patterns.entity),
			common.functionName,
			Flat("variable", ~/^[a-zA-Z_$][a-zA-Z0-9_]*/),
			Flat("comment", ~/^(<!--|-->)/),
			common.docComment, common.blockComment, common.lineComment,
			common.number, common.doubleString, common.singleString
		]
	};
	
	public static var XHTML = {
        names: ["html","xhtml","xml"],
        rules: [
            common.ignorable,
            Flat("comment", ~/^(<[!]--([^-]|[-][^-]|[-][-][^>])*-->)/),
            Flat("variable", ~/^(<[!]\[CDATA\[([^\]]|\][^\]]|\]\][^>])*\]\]>)/i),
            Flat("keyword", ~/^(<[%]([^%]|[%][^>])*[%]>)/),
            Nested("css", 
                Nested("xml-attributes", 
                    Flat("keyword", ~/^<\s*style\b/i), 
                    Flat("keyword", ~/^>/)
                ),
                Flat("keyword", ~/^<\s*\/\s*style\s*>/i)
            ),
            Nested("javascript", 
                Nested("xml-attributes", 
                    Flat("keyword", ~/^<\s*script\b/i), 
                    Flat("keyword", ~/^>/)
                ),
                Flat("keyword", ~/^<\s*\/\s*script\s*>/i)
            ),
            Nested("php", 
                Flat("keyword", ~/^<[?](php[0-9]*)?/i), 
                Flat("keyword", ~/^[?]>/)
            ),
            Nested("xml-attributes", 
                Flat("keyword", ~/^<\s*[a-zA-Z0-9_.-]+/), 
                Flat("keyword", ~/^>/)
            ),
            Flat("keyword", ~/^(<\s*\/\s*[a-zA-Z0-9_.-]+)\s*(>)/),
            Flat("variable", patterns.entity),
            Flat("", ~/^[^<&]+/)
        ]
    };
    
    public static var PERL = {
        names: ["perl"],
        rules: [
            common.ignorable,
            Flat("string", ~/^(m|q|qq|qw|qx)\/([^\\\/]|\\.)*\/[a-zA-Z]*/),
            Flat("string", ~/^(y|tr|s)\/([^\\\/]|\\.)*\/([^\\\/]|\\.)*\/[a-zA-Z]*/),
            Flat("string", ~/^\/(([^\s\/\\]|\\.)([^\\\/]|\\.)*)?\/[a-zA-Z]*/),
            Flat("keyword", ~/^(abs|accept|alarm|Answer|Ask|atan2|bind|binmode|bless|caller|chdir|chmod|chomp|Choose|chop|chown|chr|chroot|close|closedir|connect|continue|cos|crypt|dbmclose|dbmopen|defined|delete|die|Directory|do|DoAppleScript|dump)\b/),
            Flat("keyword", ~/^(each|else|elsif|endgrent|endhostent|endnetent|endprotoent|endpwent|eof|eval|exec|exists|exit|exp|FAccess|fcntl|fileno|find|flock|for|foreach|fork|format|formline)\b/),
            Flat("keyword", ~/^(getc|GetFileInfo|getgrent|getgrgid|getgrnam|gethostbyaddr|gethostbyname|gethostent|getlogin|getnetbyaddr|getnetbyname|getnetent|getpeername|getpgrp|getppid|getpriority|getprotobyname|getprotobynumber|getprotoent|getpwent|getpwnam|getpwuid|getservbyaddr|getservbyname|getservbyport|getservent|getsockname|getsockopt|glob|gmtime|goto|grep)\b/),
            Flat("keyword", ~/^(hex|hostname|if|import|index|int|ioctl|join|keys|kill|last|lc|lcfirst|length|link|listen|LoadExternals|local|localtime|log|lstat|MakeFSSpec|MakePath|map|mkdir|msgctl|msgget|msgrcv|msgsnd|my|next|no|oct|open|opendir|ord)\b/),
            Flat("keyword", ~/^(pack|package|Pick|pipe|pop|pos|print|printf|push|pwd|Quit|quotemeta|rand|read|readdir|readlink|recv|redo|ref|rename|Reply|require|reset|return|reverse|rewinddir|rindex|rmdir)\b/),
            Flat("keyword", ~/^(scalar|seek|seekdir|select|semctl|semget|semop|send|SetFileInfo|setgrent|sethostent|setnetent|setpgrp|setpriority|setprotoent|setpwent|setservent|setsockopt|shift|shmctl|shmget|shmread|shmwrite|shutdown|sin|sleep|socket|socketpair|sort|splice|split|sprintf|sqrt|srand|stat|stty|study|sub|substr|symlink|syscall|sysopen|sysread|system|syswrite)\b/),
            Flat("keyword", ~/^(tell|telldir|tie|tied|time|times|truncate|uc|ucfirst|umask|undef|unless|unlink|until|unpack|unshift|untie|use|utime|values|vec|Volumes|wait|waitpid|wantarray|warn|while|write)\b/),
            common.functionName,
			//Flat("variable", ~/^(\@|\$|)[a-zA-Z_][a-zA-Z0-9_]*/),
			Flat("variable", ~/^(@|\$|)[a-zA-Z_][a-zA-Z0-9_]*/),
            common.hashComment,
            common.number, common.doubleString, common.singleString,
        ],
    };
    
    public static var RUBY = {
        names: ["ruby"],
        rules: [
            common.ignorable,
            Flat("", ~/^::/),
            Flat("string", ~/^\/(([^\s\/\\]|\\.)([^\\\/]|\\.)*)?\/[a-zA-Z]*/),
            Flat("keyword", ~/^(alias|and|BEGIN|begin|break|case|class|def|defined|do|else|elsif|END|end|ensure|false|for|if|in|module|next|nil|not|or|redo|rescue|retry|return|self|super|then|true|undef|unless|until|when|while|yield)\b/),
            Flat("keyword", ~/^(require|include|raise|public|protected|private|)\b/),
            Flat("string", ~/^:[a-zA-Z_][a-zA-Z0-9_]*/),
            Flat("type", patterns.upperIdentifier),
            common.functionName,
			//Flat("variable", ~/^(\@|\$|)[a-zA-Z_][a-zA-Z0-9_]*/),
			Flat("variable", ~/^(@|\$|)[a-zA-Z_][a-zA-Z0-9_]*/),
            common.hashComment,
            common.number, common.doubleString, common.singleString,
        ],
    };
    
    public static var CPP = {
        names: ["c++", "cpp", "c"],
        rules: [
            common.ignorable,
            Flat("keyword", ~/^(asm|auto|bool|break|case|catch|class|const|const_cast|continue|default|delete|do|double|dynamic_cast|else|enum|explicit|export|extern|false|float|for|friend|goto|if|inline|int|long|mutable|namespace|new|operator|private|protected|public|register|reinterpret_cast|return|short|signed|sizeof|static|static_cast|struct|switch|template|this|throw|true|try|typedef|typeid|typename|union|unsigned|using|virtual|void|volatile|wchar_t|while)\b/),
            common.functionName,
            Flat("variable", patterns.identifier),
            Flat("type", ~/^#[a-zA-Z0-9_]+([^\r\n\\]|\\(\r\n|\r|\n|.))*/),
            common.docComment, common.blockComment, common.lineComment,
            common.number, common.doubleString, common.singleString,
        ],
    };
    
    public static var CSHARP = {
        names: ["c#", "csharp", "c-sharp", "cs"],
        rules: [
            common.ignorable,
            Flat("keyword", ~/^(abstract|event|new|struct|as|explicit|null|switch|base|extern|object|this|bool|false|operator|throw|break|finally|out|true|byte|fixed|override|try|case|float|params|typeof|catch|for|private|uint|char|foreach|protected|ulong|checked|goto|public|unchecked|class|if|readonly|unsafe|const|implicit|ref|ushort|continue|in|return|using|decimal|int|sbyte|virtual|default|interface|sealed|volatile|delegate|internal|short|void|do|is|sizeof|while|double|lock|stackalloc|else|long|static|enum|namespace|string)\b/),
            common.functionName,
            Flat("variable", patterns.identifier),
            common.docComment, common.blockComment, common.lineComment,
            common.number, common.doubleString, common.singleString,
        ],
    };
    
    public static var JAVA = {
        names: ["java"],
        rules: [
            common.ignorable,
            Flat("keyword", ~/^(abstract|assert|break|case|catch|class|continue|default|do|else|enum|extends|final|finally|for|if|implements|import|instanceof|interface|native|new|package|private|protected|public|return|static|strictfp|super|switch|synchronized|this|throw|throws|transient|try|volatile|while|true|false|null)\b/),
            Flat("type", ~/^(boolean|byte|char|double|float|int|long|short|void)/),
            Flat("type", patterns.upperIdentifier),
            common.functionName,
            Flat("variable", patterns.lowerIdentifier),
            common.docComment, common.blockComment, common.lineComment,
            common.number, common.doubleString, common.singleString,
        ],
    };
    
    public static var SCALA = {
        names: ["scala"],
        rules: [
            common.ignorable,
            Flat("keyword", ~/^(true|false|this|super|forSome|type|val|var|with|if|else|while|try|catch|finally|yield|do|for|throw|return|match|new|implicit|lazy|case|override|abstract|final|sealed|private|protected|public|package|import|def|class|object|trait|extends|null)\b/),
            Flat("type", ~/^(boolean|byte|char|double|float|int|long|short|void)/),
            Flat("type", patterns.upperIdentifier),
            common.functionName,
            Nested("xml-attributes", 
                Flat("keyword", ~/^<\/?[a-zA-Z0-9]+/), 
                Flat("keyword", ~/^>/)
            ),
            Flat("variable", patterns.lowerIdentifier),
            common.docComment, common.blockComment, common.lineComment,
            common.number, common.doubleString, common.tripleString, common.singleString,
        ],
    };
    
    public static var PYTHON = {
		names: ["py","python"],
        rules: [
            common.ignorable,
            Flat("keyword", ~/^(and|del|from|not|while|as|elif|global|or|with|assert|else|if|pass|yield|break|except|import|print|class|exec|in|raise|continue|finally|is|return|def|for|lambda|try|[:])\b/),
            Flat("keyword", ~/^(__[A-Za-z0-9_]+)/),
            common.number, common.tripleString, common.doubleString, common.singleString,
            Flat("string", ~/^((r|u|ur|R|U|UR|Ur|uR)?["]{3}(["]{0,2}[^"])*["]{3})/),
            Flat("string", ~/^((r|u|ur|R|U|UR|Ur|uR)?["][^"]*["])/),
            Flat("string", ~/^((r|u|ur|R|U|UR|Ur|uR)?['][^']*['])/),
            Flat("variable", patterns.lowerIdentifier),
            Flat("type", patterns.upperIdentifier),
            common.hashComment,
        ],
    };
    
	public static var HASKELL ={
        names: ["haskell"],
        rules: [
            common.ignorable,
            Flat("keyword", ~/^(as|of|case|class|data|default|deriving|do|forall|hiding|if|then|else|import|infix|infixl|infixr|instance|let|in|module|newtype|qualified|type|where)/),
            Flat("type", patterns.upperIdentifier),
            Flat("variable", ~/^([a-z][a-zA-Z0-9']*)/),
            common.dashComment, common.dashBlockComment,
            common.number, common.doubleString
        ]
    };
	
	public static var languages:Array<CodeHighlighterLanguage> = [
		HAXE, CSS, JS, XHTML, PERL, RUBY, CPP, CSHARP, JAVA, SCALA, PYTHON, HASKELL
	];
	
	#if (js||!air)
	/*public static function highlightAll( ?addLineNumbers : Bool ) {
		var pattern = ~/^code\s*(.*)$/;
        var elements = [];
        var pres = js.Lib.document.getElementsByTagName( 'pre' );
        for( i in 0...pres.length ) {
            if( pattern.match( pres[i].className) ) {
                elements.push( { element: pres[i], language: pattern.matched(1) } );
            }
        }
        var iterate = null;
        iterate = function() {
            var element = elements.pop();
            if(element == null) {
                if(addLineNumbers) {
                    var es = js.Lib.document.getElementsByName('code-line-numbers');
                    for(i in 0...es.length) {
                        // Disables text selection (in FF and IE at least)
                        var e: Dynamic = es[i];
                        e.onselectstart = function() {
                            return false;
                        };
                        e.unselectable = "on";
                        e.style.MozUserSelect = "none";
                        e.style.cursor = "default";
                    }
                }
                return;
            }
            var result = highlight(
                StringTools.htmlUnescape(element.element.innerHTML), 
                element.language,
                addLineNumbers);
            // IE workaround for innerHTML/pre browser bug
            result = "<pre style=\"margin:0;padding:0;\">" + 
                result + 
                "</pre>";
            if(element.language != null && element.language.length != 0)
                element.element.innerHTML = result;
            haxe.Timer.delay( iterate, 1 );
        }
        haxe.Timer.delay( iterate, 1 );
	}*/
	#end
	
    public static function highlight( code : String, languageName : String, ?addLineNumbers : Bool ) : String {
        return ( if(addLineNumbers) lineNumbers(code) else "") +
            "<pre class=\"code-code\">"+
				highlightUntil( Flat("",~/^$/), code, languageName ).html+
            "</pre>";
    }
    
	static function highlightUntil( stopRule : Rule, code : String, languageName : String ) : { html: String, rest: String } {
        var language = null;
        for ( l in languages ) {
            for ( n in l.names ) {
                if( n.toLowerCase() == languageName.toLowerCase()) language = l;
            }
        }
        if( language == null )
        	return { html: code, rest: "" };
			
        var rules = if(stopRule == null) {
            stopRule = Flat("", ~/^/);
            language.rules.concat([stopRule]);
        } else {
            [stopRule].concat(language.rules);
        }
        var html = new StringBuf();
        // Try a rule - mutates state on success!
        var tryRule = null;
        tryRule = function(rule) {
            switch(rule) {
                case Flat(type, pattern):
                    if(!pattern.match(code)) return NotMatched;
                    var s = pattern.matched(0);
                    if(s.length == 0 && rule != stopRule) return NotMatched;
                    html.add(markup(s, type));
                    code = code.substr(s.length);
                case Nested(language, start, stop):
                    var match = tryRule(start);
                    switch(match) {
                        case Matched:
                            var h = highlightUntil(stop, code, language);
                            html.add(h.html);
                            code = h.rest;
                        default:
                            return match;
                    }
            }
            if(rule == stopRule) return Done;
            return Matched;
        };
        // Keep trying until the stopRule matches.
        while(true) {
            var next = false;
            for(rule in rules) {
                switch(tryRule(rule)) {
                    case Done:
                        return { html: html.toString(), rest: code };
                    case Matched:
                        next = true;
                    case NotMatched:
                }
                if(next) break;
            }
            if(!next) {
                html.add(StringTools.htmlEscape(code.substr(0, 1)));
                code = code.substr(1);
            }
        }
        // This statement is unreachable, but makes the compiler happy.
        return null;
    }
    
    // Highlights one token (or list of tokens)
    private static function markup(code: String, type: String) {
        if(type.length == 0) return StringTools.htmlEscape(code);
        return "<span class=\"code-" + type + "\">" +
            StringTools.htmlEscape(code) +
            "</span>";
    }
    
    // Generate line numbers
	static function lineNumbers( code : String ) : String {
        var ns = code.split("\n");
        var rs = code.split("\r");
        var lines = if(ns.length > rs.length) ns else rs;
        var count = lines.length;
        var last = lines.pop();
        if( last != null && (last.length == 0 || last == "\n" || last == "\r" ) ) {
            count -= 1;
        }
        var html = new StringBuf();
        html.add("<div class=\"code-line-numbers\" name=\"code-line-numbers\">");
        for( i in 0...count ) {
            if( i != 0 ) html.add( "\n" );
            html.add( i+1 );
        }
        html.add( "</div>" );
        return html.toString();
    }
        
}