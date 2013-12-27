import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class Ship extends Entity
{
	public function new(x:Float, y:Float)
	{
		super(x, y);
		
		graphic = Image.createRect(60, 14, 0x00FF00);
		setHitbox(60, 14);
		
		Input.define("left", [Key.LEFT, Key.A]);
		Input.define("right", [Key.RIGHT, Key.D]);
		
		velocity = 0;
		type = "player";
	}
	
	public function handleInput()
	{
		acceleration = 0;
		
		if (Input.check("left"))
		{
			acceleration = -1;
		}
		
		if (Input.check("right"))
		{
			acceleration = 1;
		}
	}
	
	public function move()
	{
		velocity += acceleration * speed;
		
		// Controlar el máximo
		if (Math.abs(velocity) > maxVelocity)
		{
			velocity = maxVelocity * HXP.sign(velocity);
		}
		
		// Reducción por inercia
		if (velocity < 0)
		{
			velocity = Math.min(velocity + drag, 0);
		}
		else if (velocity > 0)
		{
			velocity = Math.max(velocity - drag, 0);
		}
	}
	
	override public function update()
	{
		handleInput();
		move();
		moveBy(velocity, 0);
		
		if (x > GameScene.rightBorder - width)
		{
			moveTo(GameScene.rightBorder - width, y);
		}
		else if (x < 0)
		{
			moveTo(0, y);
		}
		
		super.update();
	}
	
	private var velocity:Float;
	private var acceleration:Float;
	
	private static inline var maxVelocity:Float = 8;
	private static inline var speed:Float = 1.5;
	private static inline var drag:Float = 0.4;
}
