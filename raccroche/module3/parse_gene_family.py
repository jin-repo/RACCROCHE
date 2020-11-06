# in_file = open('test.txt', 'r')
in_file = open('GeneFamily_SecondRun.txt', 'r')
out_file = open('cleanedGeneFamilies.txt', 'w')


def get_gene_family_name(block):
    last_line = block[-1]
    cells = last_line.split('\t')
    return cells[1].rstrip()


def replace_gene_family_name(block):
    gf_name = get_gene_family_name(block)
    for line in block:
        if line.startswith('genelist'):
            # out_file.writelines(line)
            continue
        if line.startswith('===========genefamily'):
            # out_file.writelines(line)
            continue
        cells = line.split('\t')
        cells[1] = gf_name
        new_line = '\t'.join(cells)
        out_file.writelines(new_line)


in_block = False
block_lines = []
for line in in_file.readlines():
    if line == 'genelist\n' and not in_block:
        # starting a new block
        block_lines.append(line)
        in_block = True
        continue
    
    if line.startswith('===========genefamily') and in_block:
        # output the block
        block_lines.append(line)
        replace_gene_family_name(block_lines)
        block_lines = []
        in_block = False
        continue

    if in_block:
        block_lines.append(line)

out_file.close()
