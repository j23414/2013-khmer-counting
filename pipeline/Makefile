KHMER=/usr/local/src/khmer

# khmer paper pipeline
# raw data:
#	iowa_prairie_0920.fa.1
#	iowa_prairie_0920.fa.2
#	iowa_prairie_0920.fa.3
#	iowa_prairie_0920.fa.4
#	iowa_prairie_0920.fa.5
#	MH0001.trimmed.fa
#	ecoli_ref.fastq

all: benchmark  check_fp_rate check_error trimming assembly 

copydata:
	rm -fr ../data/
	mkdir ../data/
	cp *.time* ls.log fp_assessment.out ecoli_ref.fastq.pos*.abund1 \
	*hist *.endcount  *.f*.out norm*.out ../data/


clean:
	rm -fr `cat clean-list.txt`


	
####### STEP1: benchmark of different tools
benchmark: khmer jellyfish tallymer dsk kanalyze kmc_two_steps turtle BFCount ls.log

ls.log: 
	ls -l >ls.log
	
kmerlist2.fa:
	cut -c 1-22 iowa_prairie_0920.fa.1 > kmerlist2.fa

kmerlist2: kmerlist2.fa
	grep -v ^'>' kmerlist2.fa > kmerlist2


# khmer benchmark
BLOOM_HIST = bloom_1_1_22.hist bloom_2_1_22.hist bloom_3_1_22.hist bloom_4_1_22.hist bloom_5_1_22.hist \
	bloom_1_5_22.hist bloom_2_5_22.hist bloom_3_5_22.hist bloom_4_5_22.hist bloom_5_5_22.hist \
	bloom_1_20_22.hist bloom_2_20_22.hist bloom_3_20_22.hist bloom_4_20_22.hist bloom_5_20_22.hist

BLOOM_COUNT = bloom_1_1_22.count.time bloom_2_1_22.count.time bloom_3_1_22.count.time bloom_4_1_22.count.time \
	bloom_5_1_22.count.time


khmer: $(BLOOM_HIST) $(BLOOM_COUNT)

# error rate = 0.01
bloom_1_1_22.hist bloom_1_1_22.kh: HASH =  --threads 8 -k 22 -N 6 -x 89648744
bloom_2_1_22.hist bloom_2_1_22.kh:: HASH =  --threads 8 -k 22 -N 6 -x 169392606
bloom_3_1_22.hist bloom_3_1_22.kh:: HASH =  --threads 8 -k 22 -N 6 -x 230987668
bloom_4_1_22.hist bloom_4_1_22.kh:: HASH =  --threads 8 -k 22 -N 6 -x 282853349
bloom_5_1_22.hist bloom_5_1_22.kh:: HASH =  --threads 8 -k 22 -N 6 -x 338907573

# error rate = 0.05
bloom_1_5_22.hist: HASH =  --threads 8 -k 22 -N 4 -x 87476779
bloom_2_5_22.hist: HASH =  --threads 8 -k 22 -N 4 -x 165288646
bloom_3_5_22.hist: HASH =  --threads 8 -k 22 -N 4 -x 225391413
bloom_4_5_22.hist: HASH =  --threads 8 -k 22 -N 4 -x 276000519
bloom_5_5_22.hist: HASH =  --threads 8 -k 22 -N 4 -x 330696689

# error rate = 0.20

bloom_1_20_22.hist: HASH =  --threads 8 -k 22 -N 2 -x 93992675
bloom_2_20_22.hist: HASH =  --threads 8 -k 22 -N 2 -x 177600526
bloom_3_20_22.hist: HASH =  --threads 8 -k 22 -N 2 -x 242180177
bloom_4_20_22.hist: HASH =  --threads 8 -k 22 -N 2 -x 296559010
bloom_5_20_22.hist: HASH =  --threads 8 -k 22 -N 2 -x 355329342



bloom_%_1_22.hist: iowa_prairie_0920.fa.%
	-echo 3 > /proc/sys/vm/drop_caches
	time -o $@.time ${KHMER}/scripts/abundance-dist-single.py -s $(HASH) $^ $@


bloom_%_5_22.hist: iowa_prairie_0920.fa.%
	-echo 3 > /proc/sys/vm/drop_caches
	time -o $@.time ${KHMER}/scripts/abundance-dist-single.py -s $(HASH) $^ $@


bloom_%_20_22.hist: iowa_prairie_0920.fa.%
	-echo 3 > /proc/sys/vm/drop_caches
	time -o $@.time ${KHMER}/scripts/abundance-dist-single.py -s $(HASH) $^ $@


bloom_%_1_22.kh: iowa_prairie_0920.fa.%
	-echo 3 > /proc/sys/vm/drop_caches
	time -o $@.time ${KHMER}/scripts/load-into-counting.py  $(HASH) $@ $<

%.count.time: %.kh kmerlist2
	-echo 3 > /proc/sys/vm/drop_caches
	time -o $@ python khmer-count-kmers.py $^





# jellyfish benchmark
jellyfish: jelly_1_22.hist jelly_2_22.hist jelly_3_22.hist jelly_4_22.hist jelly_5_22.hist\
    jelly_1_31.hist jelly_2_31.hist jelly_3_31.hist jelly_4_31.hist jelly_5_31.hist \
    jelly_1_22.count.time jelly_2_22.count.time jelly_3_22.count.time \
    jelly_4_22.count.time jelly_5_22.count.time 
    
	# Jellyfish benchmark k=22 and k=31


jelly_1_22.count.time: jelly_1_22.hist kmerlist2
	-echo 3 > /proc/sys/vm/drop_caches
	time -o jelly_1_22.count.time bash jelly-search.sh jelly_1_22_0 kmerlist2

jelly_2_22.count.time: jelly_2_22.hist kmerlist2
	-echo 3 > /proc/sys/vm/drop_caches
	time -o jelly_2_22.count.time bash jelly-search.sh jelly_2_22_0 kmerlist2

jelly_3_22.count.time: jelly_3_22.hist kmerlist2
	-echo 3 > /proc/sys/vm/drop_caches
	time -o jelly_3_22.count.time bash jelly-search.sh jelly_3_22_0 kmerlist2

jelly_4_22.count.time: jelly_4_22.hist kmerlist2
	-echo 3 > /proc/sys/vm/drop_caches
	time -o jelly_4_22.count.time bash jelly-search.sh jelly_4_22_0 kmerlist2

jelly_5_22.count.time: jelly_5_22.hist kmerlist2
	-echo 3 > /proc/sys/vm/drop_caches
	time -o jelly_5_22.count.time bash jelly-search.sh jelly_5_22_0 kmerlist2
	
jelly_1_22.hist:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o jelly_1_22.time1 jellyfish count -m 22 -c 2 -C -s 70147260 -t 8 -o jelly_1_22 iowa_prairie_0920.fa.1
	-echo 3 > /proc/sys/vm/drop_caches
	time -o jelly_1_22.time2 jellyfish histo -t 8 -o jelly_1_22.hist ./jelly_1_22_0

jelly_2_22.hist:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o jelly_2_22.time1 jellyfish count -m 22 -c 2 -C -s 132544268 -t 8 -o jelly_2_22 iowa_prairie_0920.fa.2
	-echo 3 > /proc/sys/vm/drop_caches
	time -o jelly_2_22.time2 jellyfish histo -t 8 -o jelly_2_22.hist ./jelly_2_22_0

jelly_3_22.hist:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o jelly_3_22.time1 jellyfish count -m 22 -c 2 -C -s 180740423 -t 8 -o jelly_3_22 iowa_prairie_0920.fa.3
	-echo 3 > /proc/sys/vm/drop_caches
	time -o jelly_3_22.time2 jellyfish histo -t 8 -o jelly_3_22.hist ./jelly_3_22_0

jelly_4_22.hist:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o jelly_4_22.time1 jellyfish count -m 22 -c 2 -C -s 221323652 -t 8 -o jelly_4_22 iowa_prairie_0920.fa.4
	-echo 3 > /proc/sys/vm/drop_caches
	time -o jelly_4_22.time2 jellyfish histo -t 8 -o jelly_4_22.hist ./jelly_4_22_0

jelly_5_22.hist:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o jelly_5_22.time1 jellyfish count -m 22 -c 2 -C -s 265184279 -t 8 -o jelly_5_22 iowa_prairie_0920.fa.5
	-echo 3 > /proc/sys/vm/drop_caches
	time -o jelly_5_22.time2 jellyfish histo -t 8 -o jelly_5_22.hist ./jelly_5_22_0


jelly_1_31.hist:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o jelly_1_31.time1 jellyfish count -m 31 -c 2 -C -s 70147260 -t 8 -o jelly_1_31 iowa_prairie_0920.fa.1
	-echo 3 > /proc/sys/vm/drop_caches
	time -o jelly_1_31.time2 jellyfish histo -t 8 -o jelly_1_31.hist ./jelly_1_31_0

jelly_2_31.hist:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o jelly_2_31.time1 jellyfish count -m 31 -c 2 -C -s 132544268 -t 8 -o jelly_2_31 iowa_prairie_0920.fa.2
	-echo 3 > /proc/sys/vm/drop_caches
	time -o jelly_2_31.time2 jellyfish histo -t 8 -o jelly_2_31.hist ./jelly_2_31_0

jelly_3_31.hist:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o jelly_3_31.time1 jellyfish count -m 31 -c 2 -C -s 180740423 -t 8 -o jelly_3_31 iowa_prairie_0920.fa.3
	-echo 3 > /proc/sys/vm/drop_caches
	time -o jelly_3_31.time2 jellyfish histo -t 8 -o jelly_3_31.hist ./jelly_3_31_0

jelly_4_31.hist:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o jelly_4_31.time1 jellyfish count -m 31 -c 2 -C -s 221323652 -t 8 -o jelly_4_31 iowa_prairie_0920.fa.4
	-echo 3 > /proc/sys/vm/drop_caches
	time -o jelly_4_31.time2 jellyfish histo -t 8 -o jelly_4_31.hist ./jelly_4_31_0

jelly_5_31.hist:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o jelly_5_31.time1 jellyfish count -m 31 -c 2 -C -s 265184279 -t 8 -o jelly_5_31 iowa_prairie_0920.fa.5
	-echo 3 > /proc/sys/vm/drop_caches
	time -o jelly_5_31.time2 jellyfish histo -t 8 -o jelly_5_31.hist ./jelly_5_31_0

	# Tallymer benchmark part=1,k =22
tallymer: 1_part1_22.hist 2_part1_22.hist 3_part1_22.hist 4_part1_22.hist 5_part1_22.hist\
    1_part1_22.count.time 2_part1_22.count.time 3_part1_22.count.time \
    4_part1_22.count.time 5_part1_22.count.time

1_part1_22.hist:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o suffix_1_part1.time gt suffixerator -dna -pl -tis -suf -lcp -db iowa_prairie_0920.fa.1 -indexname 1_part1
	-echo 3 > /proc/sys/vm/drop_caches
	time -o mkindex_1_part1_22.time gt tallymer mkindex -mersize 22  -esa 1_part1 >1_part1_22.hist

1_part1.mct: 1_part1_22.hist
	gt tallymer mkindex -mersize 22 -esa 1_part1 -counts -pl 6 -indexname 1_part1 -minocc 1

1_part1_22.count.time: 1_part1.mct kmerlist2.fa
	-echo 3 > /proc/sys/vm/drop_caches
	time -o 1_part1_22.count.time bash tallymer-search.sh 1_part1 kmerlist2.fa

2_part1_22.hist:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o suffix_2_part1.time gt suffixerator -dna -pl -tis -suf -lcp -db iowa_prairie_0920.fa.2 -indexname 2_part1
	-echo 3 > /proc/sys/vm/drop_caches
	time -o mkindex_2_part1_22.time gt tallymer mkindex -mersize 22  -esa 2_part1 >2_part1_22.hist

2_part1.mct: 2_part1_22.hist
	gt tallymer mkindex -mersize 22 -esa 2_part1 -counts -pl 6 -indexname 2_part1 -minocc 1

2_part1_22.count.time: 2_part1.mct kmerlist2.fa
	-echo 3 > /proc/sys/vm/drop_caches
	time -o 2_part1_22.count.time bash tallymer-search.sh 2_part1 kmerlist2.fa

3_part1_22.hist:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o suffix_3_part1.time gt suffixerator -dna -pl -tis -suf -lcp -db iowa_prairie_0920.fa.3 -indexname 3_part1
	-echo 3 > /proc/sys/vm/drop_caches
	time -o mkindex_3_part1_22.time gt tallymer mkindex -mersize 22  -esa 3_part1 >3_part1_22.hist

3_part1.mct: 3_part1_22.hist
	gt tallymer mkindex -mersize 22 -esa 3_part1 -counts -pl 6 -indexname 3_part1 -minocc 1

3_part1_22.count.time: 3_part1.mct kmerlist2.fa
	-echo 3 > /proc/sys/vm/drop_caches
	time -o 3_part1_22.count.time bash tallymer-search.sh 3_part1 kmerlist2.fa

4_part1_22.hist:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o suffix_4_part1.time gt suffixerator -dna -pl -tis -suf -lcp -db iowa_prairie_0920.fa.4 -indexname 4_part1
	-echo 3 > /proc/sys/vm/drop_caches
	time -o mkindex_4_part1_22.time gt tallymer mkindex -mersize 22  -esa 4_part1 >4_part1_22.hist

4_part1.mct: 4_part1_22.hist
	gt tallymer mkindex -mersize 22 -esa 4_part1 -counts -pl 6 -indexname 4_part1 -minocc 1

4_part1_22.count.time: 4_part1.mct kmerlist2.fa
	-echo 3 > /proc/sys/vm/drop_caches
	time -o 4_part1_22.count.time bash tallymer-search.sh 4_part1 kmerlist2.fa

5_part1_22.hist:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o suffix_5_part1.time gt suffixerator -dna -pl -tis -suf -lcp -db iowa_prairie_0920.fa.5 -indexname 5_part1
	-echo 3 > /proc/sys/vm/drop_caches
	time -o mkindex_5_part1_22.time gt tallymer mkindex -mersize 22  -esa 5_part1 >5_part1_22.hist

5_part1.mct: 5_part1_22.hist
	gt tallymer mkindex -mersize 22 -esa 5_part1 -counts -pl 6 -indexname 5_part1 -minocc 1

5_part1_22.count.time: 5_part1.mct kmerlist2.fa
	-echo 3 > /proc/sys/vm/drop_caches
	time -o 5_part1_22.count.time bash tallymer-search.sh 5_part1 kmerlist2.fa


dsk: dsk_1_22.time dsk_2_22.time dsk_3_22.time dsk_4_22.time dsk_5_22.time
	# dsk benchmark k=22
dsk_1_22.time:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o dsk_1_22.time dsk iowa_prairie_0920.fa.1 22 -histo

dsk_2_22.time:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o dsk_2_22.time dsk iowa_prairie_0920.fa.2 22 -histo

dsk_3_22.time:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o dsk_3_22.time dsk iowa_prairie_0920.fa.3 22 -histo

dsk_4_22.time:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o dsk_4_22.time dsk iowa_prairie_0920.fa.4 22 -histo

dsk_5_22.time:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o dsk_5_22.time dsk iowa_prairie_0920.fa.5 22 -histo

kanalyze: kanalyze_1.time kanalyze_2.time kanalyze_3.time kanalyze_4.time kanalyze_5.time
kanalyze_1.time:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o kanalyze_1.time /usr/bin/java -jar /usr/local/src/kanalyze/kanalyze.jar count -k 22 -o kanalyze_1.out -f fasta -l 8 iowa_prairie_0920.fa.1

kanalyze_2.time:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o kanalyze_2.time /usr/bin/java -jar /usr/local/src/kanalyze/kanalyze.jar count -k 22 -o kanalyze_2.out -f fasta -l 8 iowa_prairie_0920.fa.2

kanalyze_3.time:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o kanalyze_3.time /usr/bin/java -jar /usr/local/src/kanalyze/kanalyze.jar count -k 22 -o kanalyze_3.out -f fasta -l 8 iowa_prairie_0920.fa.3

kanalyze_4.time:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o kanalyze_4.time /usr/bin/java -jar /usr/local/src/kanalyze/kanalyze.jar count -k 22 -o kanalyze_4.out -f fasta -l 8 iowa_prairie_0920.fa.4

kanalyze_5.time:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o kanalyze_5.time /usr/bin/java -jar /usr/local/src/kanalyze/kanalyze.jar count -k 22 -o kanalyze_5.out -f fasta -l 8 iowa_prairie_0920.fa.5

# kmc benchmark k=22 including two steps
kmc_two_steps: kmc kmc_dump

kmc: kmc_1_22.time kmc_2_22.time kmc_3_22.time kmc_4_22.time kmc_5_22.time

kmc_1_22.time:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o kmc_1_22.time kmc -fa iowa_prairie_0920.fa.1 kmc_1_22.out ./

kmc_2_22.time:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o kmc_2_22.time kmc -fa iowa_prairie_0920.fa.2 kmc_2_22.out ./

kmc_3_22.time:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o kmc_3_22.time kmc -fa iowa_prairie_0920.fa.3 kmc_3_22.out ./

kmc_4_22.time:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o kmc_4_22.time kmc -fa iowa_prairie_0920.fa.4 kmc_4_22.out ./

kmc_5_22.time:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o kmc_5_22.time kmc -fa iowa_prairie_0920.fa.5 kmc_5_22.out ./

kmc_dump: kmc_dump_1_22.time kmc_dump_2_22.time kmc_dump_3_22.time kmc_dump_4_22.time kmc_dump_5_22.time
	# kmc_dump benchmark k=22
kmc_dump_1_22.time:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o kmc_dump_1_22.time kmc_dump kmc_1_22.out kmc_dump_1_22.out

kmc_dump_2_22.time:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o kmc_dump_2_22.time kmc_dump kmc_2_22.out kmc_dump_2_22.out

kmc_dump_3_22.time:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o kmc_dump_3_22.time kmc_dump kmc_3_22.out kmc_dump_3_22.out

kmc_dump_4_22.time:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o kmc_dump_4_22.time kmc_dump kmc_4_22.out kmc_dump_4_22.out

kmc_dump_5_22.time:
	-echo 3 > /proc/sys/vm/drop_caches
	time -o kmc_dump_5_22.time kmc_dump kmc_5_22.out kmc_dump_5_22.out

turtle: turtle_1_22.time turtle_2_22.time turtle_3_22.time turtle_4_22.time turtle_5_22.time
turtle_1_22.time:
	-echo 3 > /proc/sys/vm/drop_caches
#	time -o turtle_1_22.time aTurtle64 -i iowa_prairie_0920.fa.1 -o turtle_1_22.out -k 22 -s 32
	time -o turtle_1_22.time scTurtle32 -i iowa_prairie_0920.fa.1 -o turtle_1_22.out -k 22 -n 4655248 -t 8
turtle_2_22.time:
	-echo 3 > /proc/sys/vm/drop_caches
#	time -o turtle_2_22.time aTurtle64 -i iowa_prairie_0920.fa.2 -o turtle_2_22.out -k 22 -s 32
	time -o turtle_2_22.time scTurtle32 -i iowa_prairie_0920.fa.2 -o turtle_2_22.out -k 22 -n 11379502 -t 8

turtle_3_22.time:
	-echo 3 > /proc/sys/vm/drop_caches
#	time -o turtle_3_22.time aTurtle64 -i iowa_prairie_0920.fa.3 -o turtle_3_22.out -k 22 -s 32
	time -o turtle_3_22.time scTurtle32 -i iowa_prairie_0920.fa.3 -o turtle_3_22.out -k 22 -n 17095789 -t 8

turtle_4_22.time:
	-echo 3 > /proc/sys/vm/drop_caches
#	time -o turtle_4_22.time aTurtle64 -i iowa_prairie_0920.fa.4 -o turtle_4_22.out -k 22 -s 32
	time -o turtle_4_22.time scTurtle32 -i iowa_prairie_0920.fa.4 -o turtle_4_22.out -k 22 -n 22543362 -t 8

turtle_5_22.time:
	-echo 3 > /proc/sys/vm/drop_caches
#	time -o turtle_5_22.time aTurtle64 -i iowa_prairie_0920.fa.5 -o turtle_5_22.out -k 22 -s 32
	time -o turtle_5_22.time scTurtle32 -i iowa_prairie_0920.fa.5 -o turtle_5_22.out -k 22 -n 29233825 -t 8

# BFCount benchmark
BFCount: BF_count_1.time BF_count_2.time BF_count_3.time BF_count_4.time BF_count_5.time BF_dump_1.time BF_dump_2.time BF_dump_3.time BF_dump_4.time BF_dump_5.time

BF_count_1.time:
	time -o BF_count_1.time BFCounter count -k 22 -n 60000000 -t 8 -c 100000 -o iowa.1 iowa_prairie_0920.fa.1

BF_dump_1.time:
	time -o BF_dump_1.time BFCounter dump -k 22 -i iowa.1 -o iowa.1.txt

BF_count_2.time:
	time -o BF_count_2.time BFCounter count -k 22 -n 120000000 -t 8 -c 100000 -o iowa.2 iowa_prairie_0920.fa.2

BF_dump_2.time:
	time -o BF_dump_2.time BFCounter dump -k 22 -i iowa.2 -o iowa.2.txt

BF_count_3.time:
	time -o BF_count_3.time BFCounter count -k 22 -n 150000000 -t 8 -c 100000 -o iowa.3 iowa_prairie_0920.fa.3

BF_dump_3.time:
	time -o BF_dump_3.time BFCounter dump -k 22 -i iowa.3 -o iowa.3.txt

BF_count_4.time:
	time -o BF_count_4.time BFCounter count -k 22 -n 180000000 -t 8 -c 100000 -o iowa.4 iowa_prairie_0920.fa.4

BF_dump_4.time:
	time -o BF_dump_4.time BFCounter dump -k 22 -i iowa.4 -o iowa.4.txt

BF_count_5.time:
	time -o BF_count_5.time BFCounter count -k 22 -n 220000000 -t 8 -c 100000 -o iowa.5 iowa_prairie_0920.fa.5

BF_dump_5.time:
	time -o BF_dump_5.time BFCounter dump -k 22 -i iowa.5 -o iowa.5.txt

####### STEP2:  Assessment of false positive rate and miscount distribution

check_fp_rate: fp_assessment.out
	#
random_kmers_1M_3c.fa:
	python get_random_kmers_1M_C3.py >random_kmers_1M_3c.fa

	# get random reads with the same number of unique k-mers
	# length of reads = 44  , to be the same as that of MH0001.trimmed.fa
random_reads_1.67M_3c_0.03e.fa:
	python simulate_random_reads.py 1670000 3 0.03 44 random_reads_1.67M_3c_0.03e.fa random_genome_1M.fa

random_reads_2.54M_3c_0.00e.fa:
	python simulate_random_reads.py 2540000 3 0.00 44 random_reads_2.54M_3c_0.00e.fa random_genome_1M.fa

MH0001.trimmed.head176800.fa:
	head -176800 MH0001.trimmed.fa >MH0001.trimmed.head176800.fa

ecoli_ref_head45000.fasta:
	# length of reads  = 100bp
	python get_ecoli_reads.py ecoli_ref.fastq ecoli_ref_head45000.fasta

fp_assessment.out: random_kmers_1M_3c.fa random_reads_1.67M_3c_0.03e.fa random_reads_2.54M_3c_0.00e.fa MH0001.trimmed.head176800.fa ecoli_ref_head45000.fasta
	python fp_assessment.py fp_assessment.out



####### STEP3:  Investigation of sequencing error pattern by k-mer abundance distribution
check_error: ecoli_ref.fastq.pos17.abund1 ecoli_ref.fastq.pos32.abund1
# 
# raw data:ecoli_ref.fastq

ecoli_ref.fastq.ht.k17: ecoli_ref.fastq
	${KHMER}/scripts/load-into-counting.py --ksize 17 --n_hashes 4 --hashsize 1e8 ecoli_ref.fastq.ht.k17 ecoli_ref.fastq


ecoli_ref.fastq.pos17.abund1: ecoli_ref.fastq.ht.k17 ecoli_ref.fastq
	python ${KHMER}/sandbox/hi-lo-abundance-by-position.py ecoli_ref.fastq.ht.k17 ecoli_ref.fastq
	mv ecoli_ref.fastq.pos.abund\=1 ecoli_ref.fastq.pos17.abund1

ecoli_ref.fastq.ht.k32: ecoli_ref.fastq
	${KHMER}/scripts/load-into-counting.py --ksize 32 --n_hashes 4 --hashsize 1e8 ecoli_ref.fastq.ht.k32 ecoli_ref.fastq

ecoli_ref.fastq.pos32.abund1: ecoli_ref.fastq.ht.k32 ecoli_ref.fastq
	python ${KHMER}/sandbox/hi-lo-abundance-by-position.py ecoli_ref.fastq.ht.k32 ecoli_ref.fastq
	mv ecoli_ref.fastq.pos.abund\=1 ecoli_ref.fastq.pos32.abund1




#######  STEP 4: low-memory k-mer trimming

trimming: ecoli_ref.fastq.hist ecoli_ref.fastq.endcount  \
	ecoli_ref.fastq.r1.fq.hist ecoli_ref.fastq.r1.fq.endcount \
	ecoli_ref.fastq.r2.fq.hist ecoli_ref.fastq.r2.fq.endcount \
	ecoli_ref.fastq.r3.fq.hist ecoli_ref.fastq.r3.fq.endcount \
 	ecoli_ref.fastq.r4.fq.hist ecoli_ref.fastq.r4.fq.endcount \
	ecoli_ref.fastq.r5.fq.hist ecoli_ref.fastq.r5.fq.endcount \
 	ecoli_ref.fastq.r6.fq.hist ecoli_ref.fastq.r6.fq.endcount \
	ecoli_ref-trim.fastq.hist ecoli_ref-trim.fastq.endcount \
	ecoli_ref-trim.fastq.r1.fq \
	ecoli_ref.fastq.seqtk-trimmed.fastq.hist ecoli_ref.fastq.seqtk-trimmed.fastq.endcount \
	ecoli_ref.fastq.seqtk-trimmed-q001.fastq.hist ecoli_ref.fastq.seqtk-trimmed-q001.fastq.endcount \
	ecoli_ref.fastq.seqtk-trimmed-b3e5.fastq.hist ecoli_ref.fastq.seqtk-trimmed-b3e5.fastq.endcount \
	ecoli_ref.fastq.seqtk-trimmed.r1.fastq ecoli_ref.fastq.seqtk-trimmed-q001.r1.fastq \
	ecoli_ref.fastq.seqtk-trimmed-b3e5.r1.fastq



HASH_FILTER1 = -x 25818513 -N 1 -k 20 # for optimal hash table to get 0.8 fpr, with minimum 
# memory  
HASH_FILTER2 = -x 25818613 -N 1 -k 20 # to get different primer number
HASH_FILTER3 = -x 25818713 -N 1 -k 20
HASH_FILTER4 = -x 25818813 -N 1 -k 20
HASH_FILTER5 = -x 25818913 -N 1 -k 20
HASH_FILTER6 = -x 25818413 -N 1 -k 20

# do filter abund for each round
# filtered by filter-abund-single.py

ecoli_ref.fastq.r1.fq: ecoli_ref.fastq
	${KHMER}/scripts/filter-abund-single.py $(HASH_FILTER1) $< > $@.out 2>&1
	mv $<.abundfilt $@

ecoli_ref.fastq.r2.fq: ecoli_ref.fastq.r1.fq
	${KHMER}/scripts/filter-abund-single.py $(HASH_FILTER2) $< > $@.out 2>&1
	mv $<.abundfilt $@

ecoli_ref.fastq.r3.fq: ecoli_ref.fastq.r2.fq
	${KHMER}/scripts/filter-abund-single.py $(HASH_FILTER3) $< > $@.out 2>&1
	mv $<.abundfilt $@

ecoli_ref.fastq.r4.fq: ecoli_ref.fastq.r3.fq
	${KHMER}/scripts/filter-abund-single.py $(HASH_FILTER4) $< > $@.out 2>&1
	mv $<.abundfilt $@

ecoli_ref.fastq.r5.fq: ecoli_ref.fastq.r4.fq
	${KHMER}/scripts/filter-abund-single.py $(HASH_FILTER5) $< > $@.out 2>&1
	mv $<.abundfilt $@

ecoli_ref.fastq.r6.fq: ecoli_ref.fastq.r5.fq
	${KHMER}/scripts/filter-abund-single.py $(HASH_FILTER6) $< > $@.out 2>&1
	mv $<.abundfilt $@

# also get number of bases processed for other trimming method, using side effect of filter-abund-single.py
TARGET_FQ = ecoli_ref-trim.fastq.r1.fq \
	ecoli_ref.fastq.seqtk-trimmed.r1.fastq \
	ecoli_ref.fastq.seqtk-trimmed-q001.r1.fastq \
	ecoli_ref.fastq.seqtk-trimmed-b3e5.r1.fastq
	
# to get number of bases processed. using filter-abund-single.py just for other trimming method
ecoli_ref-trim.fastq.r1.fq: ecoli_ref-trim.fastq
ecoli_ref.fastq.seqtk-trimmed.r1.fastq: ecoli_ref.fastq.seqtk-trimmed.fastq
ecoli_ref.fastq.seqtk-trimmed-q001.r1.fastq: ecoli_ref.fastq.seqtk-trimmed-q001.fastq
ecoli_ref.fastq.seqtk-trimmed-b3e5.r1.fastq: ecoli_ref.fastq.seqtk-trimmed-b3e5.fastq

$(TARGET_FQ):
	${KHMER}/scripts/filter-abund-single.py $(HASH_FILTER1) $< > $@.out 2>&1
	mv $<.abundfilt $@


# get k-mer abundance distribution to get total number of k-mers
HASH_HIST =  -x 3e8 -N 4 -k 20 #big hash table, for histogram and end unqiue k-mer counting 

%.hist: %
	${KHMER}/scripts/abundance-dist-single.py $(HASH_HIST) $< $@

# count the unique k-mer in 3'end of reads
%.endcount: %
	python count-singleton-kmers-at-end.py $(HASH_HIST) $< | grep ^singletons > $@

# using fastx to quality-filter reads
ecoli_ref-trim.fastq: ecoli_ref.fastq
	fastq_quality_filter -Q33 -q 30 -p 50 -i ecoli_ref.fastq >ecoli_ref-trim.fastq

# using seqtk to trim reads

ecoli_ref.fastq.seqtk-trimmed.fastq: ecoli_ref.fastq
	seqtk trimfq $< > $@

ecoli_ref.fastq.seqtk-trimmed-q001.fastq: ecoli_ref.fastq
	seqtk trimfq -q 0.01 $< > $@

ecoli_ref.fastq.seqtk-trimmed-b3e5.fastq: ecoli_ref.fastq
	seqtk trimfq -b 3 -e 5  $< > $@








#######  STEP 5:diginorm + velvet assembling
# also use Quast to evaluate contigs
#
assembly: Quast get_missing_kmer get_hist

HASH_120M = -x 3e6 -N 4 -k 20
HASH_240M = -x 6e6 -N 4 -k 20
HASH_2400M = -x 60e6 -N 4 -k 20
HASH_60M = -x 1.5e6 -N 4 -k 20
HASH_40M = -x 1e6 -N 4 -k 20
HASH_20M = -x 0.5e6 -N 4 -k 20
HASH_10M = -x 0.25e6 -N 4 -k 20


# diginorm with different size of hash table
# fp rate and retained reads in normXX.out

ecoli_ref.fastq.keep10M.fq: ecoli_ref.fastq
	-${KHMER}/scripts/normalize-by-median.py $(HASH_10M) -C 20 $< > norm10M.out 2>&1
	mv ecoli_ref.fastq.keep $@

ecoli_ref.fastq.keep20M.fq: ecoli_ref.fastq
	-${KHMER}/scripts/normalize-by-median.py $(HASH_20M) -C 20 $< > norm20M.out 2>&1
	mv ecoli_ref.fastq.keep $@

ecoli_ref.fastq.keep40M.fq: ecoli_ref.fastq
	-${KHMER}/scripts/normalize-by-median.py $(HASH_40M) -C 20 $< > norm40M.out 2>&1
	mv ecoli_ref.fastq.keep $@

ecoli_ref.fastq.keep60M.fq: ecoli_ref.fastq
	-${KHMER}/scripts/normalize-by-median.py $(HASH_60M) -C 20 $< > norm60M.out 2>&1
	mv ecoli_ref.fastq.keep $@

ecoli_ref.fastq.keep120M.fq: ecoli_ref.fastq
	-${KHMER}/scripts/normalize-by-median.py $(HASH_120M) -C 20 $< > norm120M.out 2>&1
	mv ecoli_ref.fastq.keep $@

ecoli_ref.fastq.keep240M.fq: ecoli_ref.fastq
	-${KHMER}/scripts/normalize-by-median.py $(HASH_240M) -C 20 $< > norm240M.out 2>&1
	mv ecoli_ref.fastq.keep $@

ecoli_ref.fastq.keep2400M.fq: ecoli_ref.fastq
	-${KHMER}/scripts/normalize-by-median.py $(HASH_2400M) -C 20 $< > norm2400M.out 2>&1
	mv ecoli_ref.fastq.keep $@




# velvet assembly
velvet.all/contigs.fa: ecoli_ref.fastq
	python ${KHMER}/sandbox/strip-and-split-for-assembly.py $<
	velveth velvet.all 37 -fastq -shortPaired $<.pe -short $<.se
	velvetg velvet.all -exp_cov auto

velvet.10M/contigs.fa: ecoli_ref.fastq.keep10M.fq
	python ${KHMER}/sandbox/strip-and-split-for-assembly.py $<
	velveth velvet.10M 37 -fastq -shortPaired $<.pe -short $<.se
	velvetg velvet.10M -exp_cov auto

velvet.20M/contigs.fa: ecoli_ref.fastq.keep20M.fq
	python ${KHMER}/sandbox/strip-and-split-for-assembly.py $<
	velveth velvet.20M 37 -fastq -shortPaired $<.pe -short $<.se
	velvetg velvet.20M -exp_cov auto

velvet.40M/contigs.fa: ecoli_ref.fastq.keep40M.fq
	python ${KHMER}/sandbox/strip-and-split-for-assembly.py $<
	velveth velvet.40M 37 -fastq -shortPaired $<.pe -short $<.se
	velvetg velvet.40M -exp_cov auto

velvet.60M/contigs.fa: ecoli_ref.fastq.keep60M.fq
	python ${KHMER}/sandbox/strip-and-split-for-assembly.py $<
	velveth velvet.60M 37 -fastq -shortPaired $<.pe -short $<.se
	velvetg velvet.60M -exp_cov auto

velvet.120M/contigs.fa: ecoli_ref.fastq.keep120M.fq
	python ${KHMER}/sandbox/strip-and-split-for-assembly.py $<
	velveth velvet.120M 37 -fastq -shortPaired $<.pe -short $<.se
	velvetg velvet.120M -exp_cov auto

velvet.240M/contigs.fa: ecoli_ref.fastq.keep240M.fq
	python ${KHMER}/sandbox/strip-and-split-for-assembly.py $<
	velveth velvet.240M 37 -fastq -shortPaired $<.pe -short $<.se
	velvetg velvet.240M -exp_cov auto

velvet.2400M/contigs.fa: ecoli_ref.fastq.keep2400M.fq
	python ${KHMER}/sandbox/strip-and-split-for-assembly.py $<
	velveth velvet.2400M 37 -fastq -shortPaired $<.pe -short $<.se
	velvetg velvet.2400M -exp_cov auto

# Quast result files are located in ./data/quast_results/ with .html report
Quast:  e.coli_reference.fa.gz  e.coli_genes.gff  e.coli_operons.gff \
	velvet.10M/contigs.fa \
	velvet.20M/contigs.fa \
	velvet.40M/contigs.fa \
	velvet.60M/contigs.fa \
	velvet.120M/contigs.fa \
	velvet.240M/contigs.fa \
	velvet.2400M/contigs.fa \
	velvet.all/contigs.fa
	python /usr/local/src/quast-2.3/quast.py velvet.10M/contigs.fa velvet.20M/contigs.fa  velvet.40M/contigs.fa velvet.60M/contigs.fa velvet.120M/contigs.fa velvet.240M/contigs.fa velvet.2400M/contigs.fa velvet.all/contigs.fa -R e.coli_reference.fa.gz -G e.coli_genes.gff -O e.coli_operons.gff


# get the missing k-mers
get_missing_kmer: ecoli_ref.fastq.keep10M.fq.kh.e_coli_ref_hist \
	ecoli_ref.fastq.keep20M.fq.kh.e_coli_ref_hist \
	ecoli_ref.fastq.keep40M.fq.kh.e_coli_ref_hist \
	ecoli_ref.fastq.keep60M.fq.kh.e_coli_ref_hist \
	ecoli_ref.fastq.keep120M.fq.kh.e_coli_ref_hist \
	ecoli_ref.fastq.keep240M.fq.kh.e_coli_ref_hist \
	ecoli_ref.fastq.keep2400M.fq.kh.e_coli_ref_hist \
	ecoli_ref.fastq.kh.e_coli_ref_hist


%.kh: %
	python ${KHMER}/scripts/load-into-counting.py -x 4e8 -N 4 -k 20 $@ $<

# get the kmer abundance of ecoli genome in assembled contigs. the number of kmers with
# frequency is the number of missing kmers.
%.e_coli_ref_hist: % e.coli_reference.fa.gz
	${KHMER}/scripts/abundance-dist.py $^ $@


# for number of retained total k-mers
# get the "retained total k-mers" in diginormalized reads data
get_hist: ecoli_ref.fastq.keep10M.fq.hist \
	ecoli_ref.fastq.keep20M.fq.hist \
	ecoli_ref.fastq.keep40M.fq.hist \
	ecoli_ref.fastq.keep60M.fq.hist \
	ecoli_ref.fastq.keep120M.fq.hist \
	ecoli_ref.fastq.keep240M.fq.hist \
	ecoli_ref.fastq.keep2400M.fq.hist \
