import sys
from os import listdir
from os.path import join

from os.path import isfile

import itertools

from tabulate import tabulate

FSTR = "{0:.2f}"

def main():
    # given a dir of simp test outs, compute the best simp options according to:
    # avg simp/solving/total time, max simp/solving/total time
    # base_dir = sys.argv[1]
    base_dir = "/home/ezulkosk/backdoors_benchmarks/cdl_feature_models/"

    simp_dir = base_dir + "/simp_test/"
    files = [simp_dir + "/" + f for f in listdir(simp_dir) if isfile(join(simp_dir, f))]
    sum_simp, sum_solving, sum_total = {}, {}, {}
    avg_simp, avg_solving, avg_total = {}, {}, {}
    max_simp, max_solving, max_total = {}, {}, {}
    num_instances = len(files)
    for f in files:
        elim, asymm, rcheck, sublim = "", "", "", ""
        with open(f) as stream:
            for line in stream:
                arr = line.strip().split()
                elim = arr[0]
                asymm = arr[1]
                rcheck = arr[2]
                sublim = arr[3]
                key = (elim, asymm, rcheck, sublim)

                simp_time = float(arr[4])
                solve_time = float(arr[5])
                total_time = float(arr[6])

                sum_simp[key] = sum_simp.get(key, 0) + simp_time
                sum_solving[key] = sum_solving.get(key, 0) + solve_time
                sum_total[key] = sum_total.get(key, 0) + total_time

                if not max_simp.get(key, None):
                    max_simp[key] = 0
                if not max_solving.get(key, None):
                    max_solving[key] = 0
                if not max_total.get(key, None):
                    max_total[key] = 0

                if simp_time > max_simp.get(key, 0):
                    max_simp[key] = simp_time
                if solve_time > max_solving[key]:
                    max_solving[key] = solve_time
                if total_time > max_total[key]:
                    max_total[key] = total_time

    for k,v in sum_simp.items():
        avg_simp[k] = FSTR.format(v / num_instances)
    for k,v in sum_solving.items():
        avg_solving[k] = FSTR.format(v / num_instances)
    for k,v in sum_total.items():
        avg_total[k] = FSTR.format(v / num_instances)

    for k,v in max_simp.items():
        max_simp[k] = FSTR.format(v)
    for k,v in max_solving.items():
        max_solving[k] = FSTR.format(v)
    for k,v in max_total.items():
        max_total[k] = FSTR.format(v)

    rows = []
    header = ["elim", "asymm", "rcheck", "sublim", "Max Simp", "Max Solve", "Max Total", "Avg. Simp", "Avg. Solve", "Avg. Total"]
    for k in itertools.product("01", repeat=4):
        r = [*k, max_simp[k], max_solving[k], max_total[k], avg_simp[k], avg_solving[k], avg_total[k]]
        print(r)
        rows.append(r)
    t = tabulate(rows, headers=header)
    print(t)


if __name__ == '__main__':
    main()