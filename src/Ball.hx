import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;

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
		
		hitBlockSfx = new Sfx("sfx/hit_block.wav");
		hitWallSfx = new Sfx("sfx/hit_walls.wav");
	}
	
	public function checkCollisions()
	{
		if (x < 0 || x + width > GameScene.rightBorder)
		{
			rotation = normalizeAngle(180 - rotation);
			updateAcc();
			hitWallSfx.play();
		}
		
		if (y < 0)
		{
			rotation = normalizeAngle(360 - rotation);
			updateAcc();
			hitWallSfx.play();
		}
		
		var player = collide("player", x, y + speed);
		if (player != null)
		{
			if (!collidingShip)
			{
				collidingShip = true;
				// calculate the difference between the ship's center and the ball's center
				var diff = (x - halfWidth) - (player.x + player.halfWidth);
				
				rotation = normalizeAngle(360 - rotation - diff);
				updateAcc();
				hitWallSfx.play();
				
				speed += 0.1;

			}
		} else
		{
			collidingShip = false;
		}
		
		if (y > HXP.height)
		{
			reset();
		}
	}
	
	override public function moveCollideX(e:Entity):Bool
	{
		scene.remove(e);
		GameScene.incScore();
		hitBlockSfx.play();
		
		rotation = normalizeAngle(180 - rotation);
		updateAcc();
		
		return true;
	}
	
	override public function moveCollideY(e:Entity):Bool
	{
		scene.remove(e);
		GameScene.incScore();
		hitBlockSfx.play();
		
		rotation = normalizeAngle(360 - rotation);
		updateAcc();
		
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
		rotation = 45;
		updateAcc();
		speed = 5;
		collidingShip = false;
	}
	
	public function updateAcc()
	{
		// rotation: angles. cos and sin receive radians
		accX = Math.cos(rotation * Math.PI / 180);
		accY = -Math.sin(rotation * Math.PI / 180);
	}
	
	public inline function normalizeAngle(angle:Float)
	{
		return angle = angle % 360 + ((angle < 0) ? 360 : 0);
	}
	
	public function getSpeed()
	{
		return speed;
	}
	
	private var accX:Float;
	private var accY:Float;
	private var speed:Float;
	private var initPosX:Float;
	private var initPosY:Float;
	private var rotation:Float;
	private var collidingShip:Bool;
	
	private static inline var maxSpeed = 8;
	
	public static var hitBlockSfx:Sfx;
	public static var hitWallSfx:Sfx;
}
