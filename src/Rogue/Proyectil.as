package Rogue
{
	import flash.display.Shape;

	public class Proyectil extends Entidad
	{
		protected var direccion:int = 0;
		protected var metaX:int = 0;
		protected var metaY:int = 0;
		
		protected var areaExplosion:Shape = new Shape();
		protected var explotando:Boolean = false;		
		
		protected var invisible:Boolean = false;
		
		public function Proyectil()
		{
		}
		
		public function getDireccion():int
		{
			return direccion;
		}
		
		public function getMetaX() : int
		{
			return metaX;
		}
		
		public function getMetaY() : int
		{
			return metaY;
		}
		
		public function explotar() : void
		{
			
		}
		
		public function iniciarExplosion() : void
		{
			
		}
		
		public function setPosicion() : void
		{
			
		}
		
		public function getAreaExplosion() : Shape
		{
			return areaExplosion;
		}
		
		public function getExplotando() : Boolean
		{
			return explotando;
		}
		
		public function selfRemove() : void
		{
			if(parent.contains(this))
			{
				this.parent.removeChild(this);
			}
		}
		
		public function volverInvisible() : void
		{
			invisible = true;
			imagen.alpha = 0;
		}
		
		public function getInvisible() : Boolean
		{
			return invisible;
		}
	}
}