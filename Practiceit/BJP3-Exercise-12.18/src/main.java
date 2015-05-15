public class main {

	public static void main(String[] args) {
		waysToClimb(3);
		waysToClimb(4);
		waysToClimb(6);
		waysToClimb(2);
		waysToClimb(1);
		waysToClimb(0);
	}
	public static void waysToClimb(int in)
	{
	    if (in > 0)
	    {
	    	waysToClimbR("", in, 0);
	    }
	}
	public static void waysToClimbR(String path, int target, int origin)
	{
		String delimiter =  (origin == 0)? "[" : ", ";
		if (origin == target)
		{
			System.out.println(path + "]");
			return;
		}
		if (origin + 1 <= target)
			waysToClimbR(path + delimiter +"1", target, origin + 1);
		if (origin + 2 <= target)
			waysToClimbR(path + delimiter +"2", target, origin + 2);
	}
}
