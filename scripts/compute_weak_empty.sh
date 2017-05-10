#!/bin/bash


bench=$1
num_iters=1000

mkdir fm_out
mkdir fm_out/${bench}

for input in ~/backdoors_benchmarks/${bench}/cnf/*
do
    name=`basename $input .cnf`
    for seed in `seq 1 $num_iters`
    do
	./maplesat  ${input} model -hitting-set-out=fm_out/${bench}/${name}.${seed}.wcnf -no-pre -rnd-seed=$seed -rnd-init -rnd-freq=1 -rnd-pol 
	./open-wbo fm_out/${name}.${seed}.wcnf > fm_out/${benchm}/${name}.${seed}.result
	rm fm_out/${name}.${seed}.wcnf
    done
done

for i in fm_out/${bench}/*.result
do
    name=`basename $i .result`
    echo $name
    cat $i | grep "^v" | sed 's/v //g' | tr ' ' '\n' | grep -c "-" > fm_out/${bench}/${name}.weak_empty
done

for i in ~/backdoors_benchmarks/${bench}/cnf/*.cnf
do
    name=`basename $i .cnf`
    echo $name
    cat fm_out/${bench}/${name}.*.weak_empty | sort -rn | head -n 1 > fm_out/${bench}/${name}.best_weak_empty
done

