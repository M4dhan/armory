package armory.trait.internal;

#if js

@:expose("armory")
class Bridge {

	public static var App = iron.App;
	public static var Scene = iron.Scene;
	public static var Time = iron.system.Time;
	public static var Object = iron.object.Object;
	public static var Data = iron.data.Data;
}

#end
