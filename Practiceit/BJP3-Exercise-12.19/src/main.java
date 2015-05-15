
public class main {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		countBinary(2);
	}

	public static void countBinary(int n)
	{
		countBinary(n,"");
	}
	
	public static void countBinary(int n, String path)
	{
		if (path.length() == n)
		{
			System.out.println(path);
			return;
		}
		countBinary(n, path+"0");
		countBinary(n, path+"1");
	}
}
// n = 1 ; path = ""
// n = 1 ; path = "0"
// n = 1 ; path = "1" ; print; return
// n = 2 ; path = ""
// n = 2 ; path = "0"
// n = 2 ; path = "00"; print; return
// n = 2 ; path = "01"; print; return
// n = 2 ; path = "1" 
// n = 2 ; path = "11"; print; return
