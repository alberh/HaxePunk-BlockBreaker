import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;

class Ball extends Entity
{
	public function new(x:Float, y:Float)
	{
		super(x, y);
		initPosX = x;
		initPosY = y;
		
		graphic = Image.createRect(10, 10);
		setHitbox(10, 10);
		
		reset();
		
		type = "ball";
	}
	
	public function checkCollisions()
	{
		if (x < 0 || x + width > GameScene.rightBorder)
		{
			accX *= -1;
		}
		
		if (y < 0)
		{
			accY *= -1;
		}
		
		var player = collide("player", x, y + speed);
		if (player != null)
		{
			accY = -1;
			speed += 0.3;
		}
		
		if (y > HXP.height)
		{
			reset();
		}
	}
	
	override public function moveCollideX(e:Entity):Bool 
	{
		scene.remove(e);
		accX *= -1;
		GameScene.incScore();
		
		return true;
	}
	
	override public function moveCollideY(e:Entity):Bool 
	{
		scene.remove(e);
		accY *= -1;
		GameScene.incScore();
		
		return true;
	}
	
	override public function update():Void 
	{
		checkCollisions();
		speed = Math.min(speed, maxSpeed);
		
		moveBy(accX * speed, accY * speed, "block");
		
		super.update();
	}
	
	public function reset()
	{
		x = initPosX;
		y = initPosY;
		accX = 1;
		accY = -1;
		speed = 2.75;
	}
	
	private var accX:Int;
	private var accY:Int;
	private var speed:Float;
	private var initPosX:Float;
	private var initPosY:Float;
	
	private static inline var maxSpeed = 5;
}
