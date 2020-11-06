# RACCROCHE

[![N|Solid](https://cldup.com/dTxpPi9lDf.thumb.png)](https://nodesource.com/products/nsolid)

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

## Overview

Given the phylogenetic relationships of several extant species, the reconstruction of their ancestral genomes at the gene and chromosome level is made difficult by the cycles of whole genome doubling followed by fractionation in plant lineages. Fractionation scrambles the gene adjacencies that enable existing reconstruction methods. We propose an alternative approach that postpones the selection of gene adjacencies for reconstructing small ancestral segments and instead accumulates a very large number of syntenically validated candidate adjacencies to produce long ancestral contigs through maximum weight matching. Likewise, we do not construct chromosomes by successively piecing together contigs into larger segments, but instead count all contig co-occurrences on the input genomes and cluster these, so that chromosomal assemblies of contigs all emerge naturally ordered at each ancestral node of the phylogeny. These strategies result in substantially more complete reconstructions than existing methods. We deploy a number of quality measures: contig lengths, continuity of contig structure on successive ancestors, coverage of the reconstruction on the input genomes, and rearrangement implications of the chromosomal structures obtained. The reconstructed ancestors can be functionally annotated and are visualized by painting the ancestral projections on the descendant genomes, and by highlighting syntenic ancestor-descendant relationships. Our methods can be applied to genomes drawn from a broad range of clades or orders.

There are four major modules including seven steps in the RACCROCHE pipeline. Scripts in the pipeline are organized according to the modules as depicted in the [diagram of program architechture vs file structure](./documentation/program-vs-file-structure.svg).
  
  ### Module 1
  - Step 1: Pre-process gene families
  - Step 2: List generalized adjacencies
  - Step 3: List candidate adjacencies
  
  ### Module 2
  - Step 4: Construct contigs by maximum weight matching
  
  ### Module 3
  - Step 5: Match synteny blocks between ancestral genome and extant genomes
  - Step 6: Cluster ancestral contigs into ancestral chromosomes
  - Step 7: Painting the extant genomes according to the ancestral chromosomes
  
  More details can be found in the [diagram of module 3 program architechture and file structure](./documentation/Module3-structure.svg).
  
  ### Module 4
  - Step 8: Adapting MCScanX to match ancestral genomes with extant genomes
  - Step 9: Measures of Quality

See the [manual](./manual.md) for how to install and use the pipeline.

In addition to the pipeline, we also provide our project data (under the "project-monocots" directory) on six genomes of monocot orders, confirming the tetraploidization event “tau” in the stem lineage between the alismatids and the lilioids. 

|  |  |
| ------ | ------ |
|Authors | Qiaoji Xu ([QiaojiXu]) |
|  | Lingling Jin ([LinglingJin]) |
|  | Chunfang Zheng |
|  | James H. Leeben-Mack |
|  | David Sankoff |
| Emails | limqiaojixu@gmail.com|
|  | lingling.jin@cs.usask.ca |
| License | [BSD] |

### Citations:   
  - If you use the raccroche pipline for ancestral contigs reconstruction, please cite:   
*RACCROCHE: ancestral flowering plantchromosomes and gene ordersbased on generalized adjacenciesand chromosomal gene co-occurrences* [need to add link]  


   [QiaojiXu]: <https://github.com/Qiaojilim>
   [LinglingJIn]: <https://github.com/jin-repo/RACCROCHE>
   [BSD]: <https://en.wikipedia.org/wiki/BSD_licenses>





