# Uhu #

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

## _BETA_ Albert { ##

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

## _ALPHA_ Uhu{JS} ##

**_WARNING_** Uhu{JS} was written just before Haxe 2.10 released, so it needs updating, alot.

Uhu{JS} is a custom haxejs generator. It outputs annotated javascript code to be processed by Google Closure Compiler, in advanced mode, producing
highly compressed, highly efficient javascript, that works exactly the same as the highly efficient javascript generated haxejs.

## _ALPHA_ Kort ##

The extendable, all encompassing minifier/optimiser

### Overview ###

Kort uses the following -

* Google Closure Compiler : to minify Javascript files
* YUI Compressor : to minify inline Javascript and CSS files
* HTML Compressor : to minify HTML files, which uses previous two as well
* Turbo-JPGTran : to optimise JPG files
* OptiPNG : to optimise PNG files
* PNGQuant : to further optimise PNG files
* GIFsicle : to optimise GIF files

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