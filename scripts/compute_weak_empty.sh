#!/bin/bash

maplesat=$1
openwbo=$2
bench=$3
instance=$4
num_iters=1000


out_dir=/home/ezulkosk/backdoors_benchmarks/${bench}/weak_e_files/
mkdir $out_dir

name=`basename $instance .cnf`
rm ${out_dir}/${name}.weak_empty
for seed in `seq 1 $num_iters`
do
    ${maplesat}  ${instance} ${out_dir}/${name}.${seed}.model  -no-pre -rnd-seed=$seed -rnd-init -rnd-freq=1 -rnd-pol
    python3 /home/ezulkosk/fmeasy/src/hitting_set_generator.py $input ${out_dir}/${name}.${seed}.model > ${out_dir}/${name}.${seed}.wcnf
    ${openwbo} ${out_dir}/${name}.${seed}.wcnf > ${out_dir}/${name}.${seed}.result
    cat ${name}.${seed}.result | grep "^v" | sed 's/v //g' | tr ' ' '\n' | grep -c "-" >> ${out_dir}/${name}.weak_empty
    rm ${out_dir}/${name}.${seed}.wcnf ${out_dir}/${name}.${seed}.result ${out_dir}/${name}.${seed}.model 
    
done

cat ${out_dir}/${name}.*.weak_empty | sort -rn | head -n 1 > ${out_dir}/${name}.best_weak_empty


