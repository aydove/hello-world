import java.io.*;
import java.util.*;
public class Analyze {
	public static List<Pa> ls = new ArrayList<Pa>();
	public static int deal(String s){
		int a=0;
		for(int i=0;i<s.length();i++){
			a+=(change(s.charAt(i))*(Math.pow(16,( s.length()-i-1))));
	    } 
		return a;
	}
	public static int deal(String s1,String s2){
		int a=0;
		if(s1.equals("FF")){
			String temp="";
			for(int i=0;i<s2.length();i++){
				temp=temp+change1(s2.charAt(i));
		    }
			temp=temp.replace('1', '2');
			temp=temp.replace('0', '1');
			temp=temp.replace('2', '0');
			a=(Integer.parseInt(temp, 2)+1)*-1;
		}
		else{
			a=deal(s2);
		}
		return a;
	}
	public static int change(char a){
		String S="0123456789ABCDEF";
		return S.indexOf(a);
	}
	public static String change1(char a){
		String S="0123456789ABCDEF";
		String[] S1={
"0000","0001","0010","0011","0100","0101","0110","0111","1000","1001","1010","1011","1100","1101","1110","1111"};
		return S1[S.indexOf(a)];
	}
	public static void read() throws Exception{
		FileInputStream fis = new FileInputStream("test.txt");
		InputStreamReader isw = new InputStreamReader(fis);
		BufferedReader br = new BufferedReader(isw);
		String s = "";
		while ((s = br.readLine()) != null) {
			s = s.trim();
			if (s.length() == 0){
				continue;
			}
			Pa pkg=new Pa();
		    String[] sa = s.split(" ");
		    pkg.des = deal(sa[1]+sa[2]);
		    pkg.src= deal(sa[10]); 
			pkg.rssi =(double)deal(sa[8],sa[9]); 
			pkg.forw= deal(sa[3]+sa[4]);
			boolean h=false;
			for(int i=0;i<ls.size();i++){
				Pa te=ls.get(i);
				if(pkg.isequal(te)){
					te.rssi=(pkg.rssi+te.rssi*(double)te.count)/(double)(te.count+1);
					te.count++;
					h=true;
					break;
				}
			}
			if(!h){
				ls.add(pkg);
			}
		}
		br.close();
		isw.close();
		fis.close();
	}
	public static void write() throws Exception{
		FileOutputStream fos=new FileOutputStream("data.txt");
		OutputStreamWriter osw=new OutputStreamWriter(fos);
	    BufferedWriter bw=new BufferedWriter(osw);
	    for (int i=0;i<ls.size();i++) {  
	    	Pa te=ls.get(i);
	    	bw.write(te.des+" "+te.src+" "+te.forw+" "+te.rssi+"\r\n");  
        } 
    	bw.flush();
    	bw.close();
    	osw.close();
	    fos.close();
	}
	public static void main(String[] args) throws Exception{
		read();
		write();
	}
}