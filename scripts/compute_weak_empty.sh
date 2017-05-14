#!/bin/bash

maplesat=$1
openwbo=$2
#bench=$3
fmeasy_dir=$3
out_dir=$4
instance=$5
num_iters=$6


#out_dir=/home/ezulkosk/backdoors_benchmarks/${bench}/weak_e_files/
mkdir $out_dir

name=`basename $instance .cnf`
rm ${out_dir}/${name}.weak_empty
for seed in `seq 1 $num_iters`
do
    ${maplesat}  ${instance} ${out_dir}/${name}.${seed}.model  -no-pre -rnd-seed=$seed -rnd-init -rnd-freq=1 -rnd-pol
    python3 ${fmeasy_dir}/src/hitting_set_generator.py $instance ${out_dir}/${name}.${seed}.model > ${out_dir}/${name}.${seed}.wcnf
    ${openwbo} ${out_dir}/${name}.${seed}.wcnf > ${out_dir}/${name}.${seed}.result
    cat ${out_dir}/${name}.${seed}.result | grep "^v" | sed 's/v //g' | tr ' ' '\n' | grep -c "-" >> ${out_dir}/${name}.weak_empty
    rm ${out_dir}/${name}.${seed}.wcnf ${out_dir}/${name}.${seed}.result ${out_dir}/${name}.${seed}.model 
    
done




