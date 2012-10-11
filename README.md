# Uhu #

- [Hocco](#hocco) : Documentation Generator
- [Albert](#albert) : Mustache templates
- [Delko](#delko) : Google Closure Compiler compatible code
- [Kort](#kort) : Minifier / Optimiser for any file type
- [Jumla](#jumla) : Mini macro helper

## Hocco ##

Hocco is [Docco](https://github.com/jashkenas/docco) for Haxe. Docco is a quick-and-dirty, hundred-line-long, literate-programming-style
documentation generator.

### Installation ###

Open your command prompt and enter ```haxelib install Hocco```. That's it.

### Quick Start ###

Start off by marking your classes with ```@:hocco``` metadata. Then in your ```.hxml``` file add ```--macro Hocco.me()``` which will generate
documentation for your project.

You can read a more detailed introduction to Hocco and how to change the default settings per class, 
enum or typedef or for the entire project. [Overview of Hocco](https://github.com/skial/uhu/wiki/Hocco)

## Albert ##

```
status - beta
```

Albert is [Mustache](http://mustache.github.com/), a framework-agnostic way to render logic-free views.

All your logic, decisions, and code is contained in your view. All your markup is contained in your template. 
The template does nothing but reference methods in your view.

This strict separation makes it easier to write clean templates, easier to test your views, and more fun to work on your app's front end.

### Installation ###

At the moment, clone this repo.

### Quick Start ###

```
import Mustache;

class Main {
	
	public function main() {
		var mu = new Mustache();
		
		var template = "Hello {{name}}
		You have just won ${{value}}!
		{{#in_ca}}
		Well, ${{taxed_value}}, after taxes.
		{{/in_ca}}";
		
		var result = mu.render(template, { "name": "Chris", "value": 10000, "taxed_value": 10000 - (10000 * 0.4), "in_ca": true });
		
		trace(result);
	}
	
}
```

Will return -

```
Hello Chris
You have just won $10000!
Well, $6000.0, after taxes.
```

## Delko ##

```
status - alpha
```

### Requirements ###

You will need [Google Closure Compiler](https://developers.google.com/closure/compiler/) in the same output directory use by Haxe.

### Overview ###

Delko is a [custom haxejs generator](http://haxe.org/manual/macros_compiler#custom-js-generator). It outputs annotated 
javascript code to be processed by Google Closure Compiler in advanced mode, that works exactly the same as the javascript generated by haxejs,
in most cases.

### Usage ###

Add the following to your ```.hxml``` file :

```
--macro uhu.js.Delko.use()
```

Once compiled, the following will be created in the output directory :

- /fragments
- closure_compiler_whitespace_only.bat
- closure_compiler_simple_optimizations.bat
- closure_compiler_advanced_optimizations.bat

If your Haxe project is compiled with ```-D debug``` then each of the ```.bat``` files will compile with ```--formatting=pretty_print```.
This allows for easier debugging.

### Example ###

Haxe

```
typedef Iterator<T> = {
	function hasNext() : Bool;
	function next() : T;
}
```

Generated Javascript

```
/** @typedef {{hasNext:function():boolean, next:function():Iterator}} */
var Iterator;
```

### Planned ###

The future plan is to link Delko up with [Kort](#kort).

## Kort ##

```
status - alpha
```

The extendable, all encompassing minifier/optimiser

### Overview ###

Kort uses the following -

* [Google Closure Compiler](https://developers.google.com/closure/compiler/) : to minify Javascript files
* [YUI Compressor](http://developer.yahoo.com/yui/compressor/) : to minify inline Javascript and CSS files
* [HTML Compressor](http://code.google.com/p/htmlcompressor/) : to minify HTML files, which uses previous two as well
* [Turbo-JPGTran](http://libjpeg-turbo.virtualgl.org/) : to optimise JPG files
* [OptiPNG](http://optipng.sourceforge.net/) : to optimise PNG files
* [PNGQuant](http://pngquant.org/) : to further optimise PNG files
* [GIFsicle](http://www.lcdf.org/gifsicle/) : to optimise GIF files

### Quick Start ###

Not recommended - still being worked on. Or just clone this repo.

### Possible Additions ###

* [sfntly](http://code.google.com/p/sfntly/) : to optimise font files
* [webp](https://developers.google.com/speed/webp/) : output to optimised image format

### Command Options ###

```
Kort - The extendable all encompassing minifier/optimiser

Usage : kort [-c] <file>

 -s,  -setup                  Setup the location of the core programs
 -c,  -config                 <file> Pass a user defined configuration file to
                              kort
```
	
### Methods and Variables ###

These can be accessed from your config file -

```
// variables

actions:Hash<TAction>;
types:Array<TFileType>;
paths:Hash<String>;

// methods

get_size(input:File):Int;
set_input(input:File):Void;
set_output(input:File):Void;
set_recursive(value:Bool):Void;
get_ext(input:File):String;
isAnimated(input:File):Bool;
isWindows(?input:File):Bool;
isLinux(?input:File):Bool;
isMac(?input:File):Bool;
```

## Jumla ##

```
status - alpha
```

Jumla is currently a very tiny Haxe Macro helper class. Helps remove switch statements and find the
type of ```ExprDef``` you want.