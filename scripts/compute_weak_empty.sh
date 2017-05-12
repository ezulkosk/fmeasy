#!/bin/bash

maplesat=$1
openwbo=$2
bench=$3
instance=$4
num_iters=1000


out_dir=/home/ezulkosk/backdoors_benchmarks/${bench}/weak_empty/
mkdir $out_dir

for input in ~/backdoors_benchmarks/${bench}/cnf/*
do
    name=`basename $input .cnf`
    for seed in `seq 1 $num_iters`
    do
	${maplesat}  ${input} ${out_dir}/${name}.${seed}.model  -no-pre -rnd-seed=$seed -rnd-init -rnd-freq=1 -rnd-pol
	python3 /home/ezulkosk/fmeasy/src/compute_hitting_set.py $input ${out_dir}/${name}.${seed}.model > ${out_dir}/${name}.${seed}.wcnf
	${openwbo} ${out_dir}/${name}.${seed}.wcnf > ${out_dir}/${name}.${seed}.result
	#rm ${out_dir}/${name}.${seed}.wcnf
    done
done

for i in ${out_dir}/*.result
do
    name=`basename $i .result`
    echo $name
    cat $i | grep "^v" | sed 's/v //g' | tr ' ' '\n' | grep -c "-" > ${out_dir}/${name}.weak_empty
done

for i in ~/backdoors_benchmarks/${bench}/cnf/*.cnf
do
    name=`basename $i .cnf`
    echo $name
    cat ${out_dir}/${name}.*.weak_empty | sort -rn | head -n 1 > ${out_dir}/${name}.best_weak_empty
done

