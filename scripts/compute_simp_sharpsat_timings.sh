#!/bin/bash
maple=$1
sharpsat=$2
bench=$3
file=$4

out_dir=~/backdoors_benchmarks/${bench}/simp_sharpsat_test/

mkdir $out_dir


name=`basename $file .cnf`
out_file=${out_dir}/${name}.simp_sharpsat_test
rm -f $out_file
echo $file
for elim in "-elim" "-no-elim"
do
    if [[ $elim == "-elim" ]]
    then
	elim_str="1 "
    else
	elim_str="0 "
    fi
    for asymm in "-asymm" "-no-asymm"
    do
	if [[ $asymm == "-asymm" ]]
	then
	    asymm_str="1 "
	else
	    asymm_str="0 "
	fi
	for rcheck in "-rcheck" "-no-rcheck"
	do
	    if [[ $rcheck == "-rcheck" ]]
	    then
		rcheck_str="1 "
	    else
		rcheck_str="0 "
	    fi
	    for sublim in " " "-sub-lim=0"
	    do
		if [[ $sublim == " " ]]
		then
		    sublim_str="1 "
		else
		    sublim_str="0 "
		fi
		if [[ $elim == "-no-elim" && $asymm == "-no-asymm" && $rcheck == "-no-rcheck" && $sublim == "-sub-lim=0" ]]
		then
		    #echo -no-pre $file
		    # all zeroes is the no simp file
		    cp $file ${out_dir}/${name}.0000.cnf
		else
		    #echo $elim $asymm $rcheck $sublim $file
		    dimacs_file=`echo ${name}. $elim_str $asymm_str $rcheck_str $sublim_str .cnf | tr ' ' '_'`
		    $maple $elim $asymm $rcheck $sublim $file -dimacs=${out_dir}/${dimacs_file}"			
		fi
		res=`echo $res | tr '|' ' '`
		simp_time=`echo $res | awk '{print $3}'`
		total_time=`echo $res | awk '{print $8}'`
		# echo $simp_time
		# echo $total_time
		solving_time=`echo $total_time $simp_time | awk '{print $1-$2}'`
		echo $elim_str $asymm_str $rcheck_str $sublim_str $simp_time $solving_time $total_time
		echo $elim_str $asymm_str $rcheck_str $sublim_str $simp_time $solving_time $total_time >> $out_file
	    done
	done
    done
done

