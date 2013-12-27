import com.haxepunk.Entity;
import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;

class GameScene extends Scene
{
	public function new()
	{
		super();
		
		scoreTxt = new Text("Score: " + score, rightBorder + 10, 100);
	}
	
	override public function begin() 
	{
		// ship, ball and right panel
		add(new Ship(rightBorder / 2 - 20, Main.kScreenHeight - 20));
		add(new Ball(rightBorder / 2, Main.kScreenHeight - 50));
		add(new Entity(rightBorder, 0, Image.createRect(2, HXP.height)));
		addGraphic(new Text("HaxePunk\nBlock Breaker", rightBorder + 10, 30));
		addGraphic(scoreTxt);
		
		for (i in 0...11)
		{
			for (j in 0...6)
			{
				add(new Block(i * 40, 20 + j * 20));
			}
		}
	}
	
	public static function incScore()
	{
		score += 10;
		scoreTxt.text = "Score: " + score;
	}
	
	override public function update() 
	{
		super.update();
	}
	
	public static inline var rightBorder = 440;
	
	private static var score = 0;
	private static var scoreTxt:Text;
}
