"""
import java.util.*;
import java.io.*;

public class TestGetContigOutput{
 public static void main( String[] args) throws Exception{
	
	 File folder = new File("/mwm/output/dir");
	   for (File afile : folder.listFiles() ) {
		 if ( afile.getName().substring(0,1).equals("W")  ) {
		  int geneNumber = "the number of gene families" ;
		 
		  for(int i = 1; i< geneNumber+1; i++){
		   geneContent = geneContent+"  "+ new Integer(i).toString();
		  }

		    String[] edges = new String[geneNumber];
		  int index = 0;
		
		  String inputFile = "/mwm/output/dir/"+ afile.getName(); 

		  FileReader fr1 = new FileReader(inputFile);
		  BufferedReader br1 = new BufferedReader(fr1);
		  String aline = br1.readLine();
		  while(aline!=null && aline.substring(0,5).equals("total")==false){
			  
		   edges[index] = aline;
		   index++;
		   aline = br1.readLine();
		  }
		  System.out.println("total edges "+ index);
		  System.out.println("---------"+aline);

		  // get genome (first level contigs)

		 
		  GenomeAdj allEdges2 = new GenomeAdj(geneContent);
		        // allEdges2.reorderGeneContent(seed);
		  
		  
		  allEdges2.initialValue(edges);
		  String[] contigs = allEdges2.getGenomeHighEdgeWeight(2);
		
		  String outPutFileName ="/contig/save/dir" + afile.getName();	
		        FileWriter fstream = new FileWriter(outPutFileName,false);
		        BufferedWriter fbw = new BufferedWriter(fstream);
		        for(int i = 0; i< contigs.length; i++){
		            fbw.write("contig "+ i+"\n"+contigs[i]+"\n");
		  }

		        fbw.flush();
		        	
		}
		 
		 
	 
		 
		 
	 }
	 

	 
 }
}
"""
