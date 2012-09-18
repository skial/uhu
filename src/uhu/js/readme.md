# Uhu JavaScript #

Here you can find experimental macros to help minify javascript files, with help from [tinkerbell](https://github.com/back2dos/tinkerbell/wiki), seriously.

## Mini.hx

Mini.hx takes all vars in all methods, and moves them to the method parameter line.

```
public function move(x:Int, y:Int):Void {
	var _a:String;
	var _b:String;
	var _c:String;
	// code
}
```

gets compiled to -

```
public function move(x,y,_a,_b,_c) {
	// code
}
```

#### Usage

Using Mini is very easy -

```
import uhu.js.Mini;

class Main implements Mini {
	// code
}
```

## Uhu.hx

Uhu.hx is a custom javascript generator. It does its best to match normal/improve the output of haxejs, but adds [Google Closure Compiler Annotations](https://developers.google.com/closure/compiler/docs/js-for-compiler) to as much as it can.

Uhu.hx is also planned to support documentation typed in the .hx source files to be output to the respective javascript methods/variables, so the generated javascript can be shared, shipping, packaged to anyone. 

Think of something like jQuery written in Haxe, which then can be output to clean, well formatted, well annotated javascript, which _should_ be highly compressable/minifable etc.

#### Usage

Just add the following to your .hxml file -

```
--macro uhu.js.Uhu.use()
```