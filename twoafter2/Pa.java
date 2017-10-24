public class Pa {
	public int src;
	public int des;
	public double rssi;
	public int forw;
	public int count;
	Pa(){
		src=0;
		des=0;
		rssi=0;
		forw=-1;
		count=0;
	}
	public boolean isequal(Pa a){
		if(a.src==src&&a.des==des&&a.forw==forw){
			return true;
		}
		else{
			return false;
		}
	}
}