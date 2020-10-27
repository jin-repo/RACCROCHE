
import java.util.*;
import java.io.*;

public class TestGetContigOutput{
 public static void main( String[] args) throws Exception{
	 //File dirPath = "/Users/qiaojixu/Desktop/Genomes_Project/TreeNode/MWMOutput";
	 File folder = new File("/Users/qiaojixu/Desktop/w6Genomes_Project/TreeNode/MWMOutput");
	 //File[] listOfFiles = folder.listFiles();
	 //for (int j = 0; j < listOfFiles.length; j++) {
	   for (File afile : folder.listFiles() ) {
		 if ( afile.getName().substring(0,1).equals("W")  ) {
	        //System.out.println(afile.getName());
		   
		  // else {System.out.println(afile.getName());}
	   
	  
		  int geneNumber = 10279;//13695;//18193 ;// 13936;22581; 13695
		  String geneContent = "";
		  for(int i = 1; i< geneNumber+1; i++){
		   geneContent = geneContent+"  "+ new Integer(i).toString();
		  }

		    String[] edges = new String[geneNumber];
		  int index = 0;
		  
		  //String inputFile = "/Users/qiaojixu/Desktop/18Genomes_Project/TreeNode/MWMOutput/W5TreeNode5_50_9.txt";
		  ///Users/qiaojixu/Desktop/6Genomes_Project/NewTreeNode/MWMOutput/W7TreeNode5_50_15.txt
		  String inputFile = "/Users/qiaojixu/Desktop/w6Genomes_Project/TreeNode/MWMOutput/"+ afile.getName(); //listOfFiles[j].getName() need to be changed


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
		  
		  //System.out.println(allEdges2.rootGeneContent);
		  
		  allEdges2.initialValue(edges);
		  String[] contigs = allEdges2.getGenomeHighEdgeWeight(2);
		  //String outPutFileName = "/Users/qiaojixu/Desktop/18Genomes_Project/TreeNode/Contig/ContigW5TreeNode5_50_9";
		  String outPutFileName ="/Users/qiaojixu/Desktop/w6Genomes_Project/TreeNode/Contig/Contig" + afile.getName();
		  		
		        //for(int i = 0; i< allGenomeIndex.length; i++30
		        //    outPutFileName = outPutFileName+"_"+new Integer(allGenomeIndex[i]).toString();
		        //}
		        //outPutFileName = outPutFileName+".txt";
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
                                                                                                                     