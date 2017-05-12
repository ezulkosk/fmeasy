import sys

from sat_reader import SatInstance


def main():
    cnf_file = sys.argv[1]
    model_file = sys.argv[2]
    with open(model_file) as model:
        model.readline()
        m = model.readline().split()
        m = [int(i) for i in m]
        # print(m)
        m = m[:-1]
    s = SatInstance(cnf_file)
    s.read_cnf()
    final_clauses = []
    for clause in s.get_clauses():
        out_clause = []
        for l in clause:
            if l in m:
                out_clause.append(abs(l))
        assert out_clause
        out_clause = tuple(out_clause)
        final_clauses.append(out_clause)

    # for clause in final_clauses:
    #     print(clause)

    top = 2 * len(m)
    print("p wcnf " + str(len(m)) + " " + str(len(m) + len(final_clauses)) + " " + str(top))
    for i in m:
        print("1 -" + str(abs(i)) + " 0")
    for clause in final_clauses:
        print(str(top) + " " + " ".join(str(l) for l in clause) + " 0")


if __name__ == '__main__':
    main()