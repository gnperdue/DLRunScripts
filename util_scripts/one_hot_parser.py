import sys
import numpy as np
import matplotlib.pyplot as plt

filen = sys.argv[1]
outn = filen.split('/')[-1]
outn = outn.split('.')[0] + '.pdf'

# read in file formatting like:
# [0 1 0 0 0]
# [0 0 1 0 0]
# [0 1 0 0 0]
raw = open(filen, 'r').readlines()
# turn into list of python lists
oh = [eval(','.join(elem.strip().split(' '))) for elem in raw]
um = np.argmax(oh, axis=1)

mm = np.max(um)
plt.figure(figsize=(6, 6))
n, bins, _ = plt.hist(um, bins=range(mm+2))
print(n)
print(bins)
plt.savefig(outn, bbox_inches='tight')
