"""
import java.util.*;
import java.io.*;
public class GenomeAdj{
	String rootGeneContent;
	String[] nodeString;
	int[][] edges;
	String[] rootGene;
	
	public GenomeAdj(String rootContent){
		rootGeneContent = rootContent;
	}
	public void reorderGeneContent(int seed){
		Random r = new Random(seed);
		String[] tmp = splitBS(rootGeneContent);
		for(int i = 0; i< tmp.length; i++){
			for(int j = 0; j< tmp.length; j++){
				if(i!=j){
					int s = r.nextInt(2);
					if(s==0){
						String atmp = tmp[i];
						tmp[i] = tmp[j];
						tmp[j] = atmp;
					}
				}
			}
		}
		rootGeneContent="";
		for(int i = 0; i< tmp.length; i++){
			rootGeneContent = rootGeneContent+"  "+tmp[i];
		}
	}
	public void initialValue2(){
		rootGene = splitBS(rootGeneContent);
	}
	
	public void initialValue(String[] selectedEdges){
		int[] en = new int[700]; // can be changed
		
		rootGene = splitBS(rootGeneContent);
		nodeString = new String[2*rootGene.length];
	
		for(int i = 0; i< rootGene.length; i++){
			nodeString[2*i] = rootGene[i]+"t";
			nodeString[2*i+1] = rootGene[i]+"h";
		}
		
	
		edges = new int[nodeString.length][nodeString.length];
		for(int i = 0; i< selectedEdges.length; i++){
			if(selectedEdges[i]!=null){
			String[] nodes = splitBS(selectedEdges[i]);
			int n1 = new Integer(nodes[0]).intValue();
			int n2 = new Integer(nodes[1]).intValue();
			int w = new Integer(nodes[2]).intValue();
			
			edges[n1][n2] = w;
			edges[n2][n1] = w;
				en[w]++;
			}
		}
		for(int i = 0; i< en.length; i++){
			if(en[i]!=0){System.out.println(en[i]+ "\tedges with weight\t"+i);
			}
		}
	}
	
		
	public int getGeneNextNode(int s){
        if((s/2)*2 == s){return (s+1);}
        return (s-1);
    }
	
	
	public String[] getGenomeHighEdgeWeight(int lowest){
		int re = 0;
		for(int i = 0; i< edges.length; i++){
			for(int j = 0; j< edges.length; j++){
				if(edges[i][j]< lowest){
					if(edges[i][j]>0){/*System.out.println(i+" ,"+j);*/re++;}
					edges[i][j] = 0;
					
				}
			}
		}
		System.out.println("removed edge "+ re);
		int chrNumber = 0;
		String[] tmp = new String[600000];
		
		int[] freeNode = new int[edges.length];
		boolean moreFreeNode = checkFreeNode(freeNode);
		int circularChr = 0;
		while(moreFreeNode== true){
			int firstNode = FindANodeNotInEdge(0, freeNode);
			while(firstNode!=-1){
				freeNode[firstNode] = 1;
				tmp[chrNumber] = "";
				String s = nodeString[firstNode];
				//System.out.println("====="+s);
				
				if(s.substring(s.length()-1, s.length()).equals("h")){
					tmp[chrNumber] = tmp[chrNumber]+ "  -"+s.substring(0,s.length()-1);
				}else{
					tmp[chrNumber] = tmp[chrNumber]+ "  "+ s.substring(0,s.length()-1);
				}
				int si = getGeneNextNode(firstNode);
				freeNode[si] = 1;
				while(true){
					if(NotAEdgeNode(si,edges)){ break;}
					else{
						int ngenei = findEdgeNode(si, edges);
						freeNode[ngenei]=1;
						String ngene = nodeString[ngenei];
						if(ngene.substring(ngene.length()-1,ngene.length()).equals("h")){
							tmp[chrNumber] = tmp[chrNumber] + "  -" +ngene.substring(0,ngene.length()-1);
						}else{
							tmp[chrNumber] = tmp[chrNumber] + "  " +ngene.substring(0,ngene.length()-1);
						}
						si = getGeneNextNode(ngenei);
						freeNode[si]=1;
					}
				}
				firstNode = FindANodeNotInEdge(firstNode+1, freeNode);
				chrNumber++;
			}
			moreFreeNode = checkFreeNode(freeNode);
			
			if(moreFreeNode == true){
				int[] lowestEdge = getTheLowestedge(freeNode);
				System.out.println("cut edge ("+lowestEdge[0]+ ","+lowestEdge[1]+" ) with weight "+ edges[lowestEdge[0]][lowestEdge[1]]);
				circularChr++;
				edges[lowestEdge[0]][lowestEdge[1]] = 0;
				edges[lowestEdge[1]][lowestEdge[0]] = 0;
				
				//break an edge with smallest weight
			}
		}
		String[] result = new String[chrNumber];
		for(int i = 0; i< result.length; i++){
			result[i] = tmp[i];
		}
		
		for(int i = 0; i< result.length-1; i++){
			for(int j = i+1; j< result.length; j++){
				String[] genes1 = splitBS(result[i]);
				String[] genes2 = splitBS(result[j]);
				if(genes1.length<genes2.length){
					String atmp = result[i];
					result[i]= result[j];
					result[j]= atmp;
				}
			}
		}
		
	/*	for(int i = 0; i< result.length; i++){
			System.out.println("chr "+ i);
			System.out.println(result[i]);
		}*/
		
	//	System.out.println("totalChr\t"+result.length+"\tcircularChr\t"+circularChr);
		
		int[] chrLen = new int[80000];
		for(int i = 0; i< result.length; i++){
			String[] gs = splitBS(result[i]);
			chrLen[gs.length]++;
		}
		for(int i = 0; i< chrLen.length; i++){
			if(chrLen[i]!=0){
				System.out.println(chrLen[i]+"\tchr with\t"+i+"\tgenes");
			}
		}
		
		
		System.out.println("totalChr\t"+result.length+"\tnumberOfChrWithOneGEne\t"+chrLen[1]);
		
		return result;
	}
	
	
	public String[] getGenome(){
		int chrNumber = 0;
		String[] tmp = new String[30000];
		
		int[] freeNode = new int[edges.length];
		boolean moreFreeNode = checkFreeNode(freeNode);
		int circularChr = 0;
		while(moreFreeNode== true){
			int firstNode = FindANodeNotInEdge(0, freeNode);
			while(firstNode!=-1){
				freeNode[firstNode] = 1;
				tmp[chrNumber] = "";
				String s = nodeString[firstNode];
				//System.out.println("====="+s);
			
				if(s.substring(s.length()-1, s.length()).equals("h")){
					tmp[chrNumber] = tmp[chrNumber]+ "  -"+s.substring(0,s.length()-1);
				}else{
					tmp[chrNumber] = tmp[chrNumber]+ "  "+ s.substring(0,s.length()-1);
				}
				int si = getGeneNextNode(firstNode);
				freeNode[si] = 1;
				while(true){
					if(NotAEdgeNode(si,edges)){ break;}
					else{
						int ngenei = findEdgeNode(si, edges);
						freeNode[ngenei]=1;
						String ngene = nodeString[ngenei];
						if(ngene.substring(ngene.length()-1,ngene.length()).equals("h")){
							tmp[chrNumber] = tmp[chrNumber] + "  -" +ngene.substring(0,ngene.length()-1);
						}else{
							tmp[chrNumber] = tmp[chrNumber] + "  " +ngene.substring(0,ngene.length()-1);
						}
						si = getGeneNextNode(ngenei);
						freeNode[si]=1;
					}
				}
				firstNode = FindANodeNotInEdge(firstNode+1, freeNode);
				chrNumber++;
			}
			moreFreeNode = checkFreeNode(freeNode);
			
			if(moreFreeNode == true){
				int[] lowestEdge = getTheLowestedge(freeNode);
				System.out.println("cut edge ("+lowestEdge[0]+ ","+lowestEdge[1]+" ) with weight "+ edges[lowestEdge[0]][lowestEdge[1]]);
				circularChr++;
				edges[lowestEdge[0]][lowestEdge[1]] = 0;
				edges[lowestEdge[1]][lowestEdge[0]] = 0;
				
				//break an edge with smallest weight
			}
		}
		
		String[] result = new String[chrNumber];
		for(int i = 0; i< result.length; i++){
			result[i] = tmp[i];
		}
		
		for(int i = 0; i< result.length-1; i++){
			for(int j = i+1; j< result.length; j++){
				String[] genes1 = splitBS(result[i]);
				String[] genes2 = splitBS(result[j]);
				if(genes1.length<genes2.length){
					String atmp = result[i];
					result[i]= result[j];
					result[j]= atmp;
				}
			}
		}
		
		for(int i = 0; i< result.length; i++){
			System.out.println("chr "+ i);
			System.out.println(result[i]);
		}
		
		System.out.println("totalChr\t"+result.length+"\tcircularChr\t"+circularChr);
		
		int[] chrLen = new int[50000];
		for(int i = 0; i< result.length; i++){
			String[] gs = splitBS(result[i]);
			chrLen[gs.length]++;
		}
		for(int i = 0; i< chrLen.length; i++){
			if(chrLen[i]!=0){
				System.out.println(chrLen[i]+"\tchr with\t"+i+"\tgenes");
			}
		}
		
		
		return result;
	}
	
	public boolean checkFreeNode(int[] fn){
		for(int i = 0;i< fn.length; i++){
			if(fn[i]==0){
				return true;
			}
		}
		return false;
	}
	
	public int[] getTheLowestedge(int[] fn){
		int lowestValue = 1000;
		int li = -1;
		int lj = -1;
		int[] result = new int[2]; 
		for(int i = 0; i< edges.length; i++){
			for(int j = 0; j< edges.length; j++){
				if(fn[i]==0 && fn[j]== 0){
					if(edges[i][j]>0 && edges[i][j]< lowestValue){
						lowestValue = edges[i][j];
						li=i;
						lj=j;
					}
				}
			}
		}
		result[0] = li; result[1] = lj;
		return result;
	}
		
			
			
	
	
	public boolean NotAEdgeNode(int si, int[][] es){
		for(int i = 0; i< es.length; i++){
			if(es[si][i]!=0){
				return false;
			}
		}
		return true;
	}
	
	public int findEdgeNode(int si, int[][] es){
		for(int i = 0; i< es.length; i++){
			if(es[si][i]>0){
				return i;
			}
		}
		return -1;
	}
		
	
	public int FindANodeNotInEdge(int startIndex, int[] fn){
		if(startIndex>edges.length-1){
			return -1;
		}
		for(int i = startIndex; i< edges.length; i++){
			if(fn[i] ==0){
			boolean find = true;
			for(int j = 0; j< edges.length; j++){
				if(edges[i][j]!=0){
					find = false;
				}
			}
			if(find==true){
				return i;
			}
			}}
		return -1;
	}
	
	public int findPosition(String agene){
		for(int i = 0; i< rootGene.length; i++){
			if(agene.equals(rootGene[i])){
				return i;
			}
		}
		return -1;
	}
	
	public void sameGeneContent(String[] agenome){
		int[] geneCopy = new int[rootGene.length];
		int geneNumber = 0;
		for(int i = 0; i< agenome.length; i++){
			String[] genes = splitBS(agenome[i]);
			geneNumber= geneNumber+ genes.length;
			for(int j = 0; j< genes.length; j++){
				String agene = genes[j];
				if(agene.substring(0,1).equals("-")){
					agene = agene.substring(1);
				}
				int p = findPosition(agene);
				if(p!=-1){
					geneCopy[p]++;
				}else{
					System.out.println("not in gene content "+ agene);
				}
			}
		}
		System.out.println("geneNumber in root content "+ rootGene.length);
			System.out.println("geneNumber in reconstructed root "+ geneNumber);
		
		for(int i = 0; i< geneCopy.length; i++){
			if(geneCopy[i]!=1){System.out.println(rootGene[i] + "  has "+geneCopy[i] + "copies");}
		}
		
		
			
	}
	
	public String[] splitBS(String s){
        String[] tmp = s.trim().split(" ");
        int index = 0;
        for(int i = 0; i < tmp.length; i++){
            if(tmp[i].trim().equals("") ==false){
                index++;
            }
        }
        String[] result = new String[index];
        index = 0;
        for(int j = 0; j <tmp.length; j++){
            if(tmp[j].trim().equals("") == false){
                result[index] = tmp[j].trim();
                index++;
            }
        }
        return result;
    }
	

					
		
	
}
"""
