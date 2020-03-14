##########################################
# Linear Programming Scripts
##########################################
#
# Johann Thiel
# ver 12.18.18
# Functions to solve linear
# programming problems.
#
##########################################

##########################################
# Necessary modules
##########################################
from sage.numerical.backends.generic_backend import get_solver
import sage.numerical.backends.glpk_backend as backend
from tabulate import tabulate
##########################################

##########################################
# Generic linear programming solver that
# produces a sensitivity report
##########################################
# va   = list of variable names
# con  = list of constraint names
# ob   = list of coefficients of objective
#       functions
# M    = matrix of constraint coefficients
# inq  = list of inequality direction
#       1 for '<=', -1 for '>=' and
#       0 for '='.
# bnd  = list of constraint bounds
# mx   = Boolean to determine if the
#       problem is a maximization (True)
#       or minimization (False) problem.
#       Default is set to maximization.
##########################################
def lp(va, con, ob, M, inq, bnd, mx=True):
    # loads the solver
    q = get_solver(solver = 'GLPK')
    # sets solver to min, max otherwise
    if not mx:
        q.set_sense(-1)
    # adds all variables
    for v in va:
        q.add_variable(name=v)
    # adds all constraints
    for i in range(len(M)):
        if inq[i] == 1:
            q.add_linear_constraint(list(zip(range(len(M[0])), M[i])), None, bnd[i], con[i])
        elif inq[i] == -1:
            q.add_linear_constraint(list(zip(range(len(M[0])), M[i])), bnd[i], None, con[i])
        else:
            q.add_linear_constraint(list(zip(range(len(M[0])), M[i])), bnd[i], bnd[i], con[i])
    # sets objective
    q.set_objective(ob)    
    q.solver_parameter(backend.glp_simplex_or_intopt, backend.glp_simplex_only)
    # solves the problem
    q.solve()
    # produces sensitivity report
    q.print_ranges()
##########################################

##########################################
# Generic linear programming solver for
# integer programming problems (produces
# no sensitivity report)
##########################################
# va   = list of variable names
# con  = list of constraint names
# ob   = list of coefficients of objective
#       functions
# M    = matrix of constraint coefficients
# inq  = list of inequality direction
#       1 for '<=', -1 for '>=' and
#       0 for '='.
# bnd  = list of constraint bounds
# mx   = Boolean to determine if the
#       problem is a maximization (True)
#       or minimization (False) problem.
#       Default is set to maximization.
##########################################
def lpInt(va, con, ob, M, inq, bnd, mx=True):
    # loads the solver
    q = get_solver(solver = 'GLPK')
    # sets solver to min, max otherwise
    if not mx:
        q.set_sense(-1)
    # adds all variables
    for v in va:
        q.add_variable(integer=True, name=v)
    # adds all constraints
    for i in range(len(M)):
        if inq[i] == 1:
            q.add_linear_constraint(list(zip(range(len(M[0])), M[i])), None, bnd[i], con[i])
        elif inq[i] == -1:
            q.add_linear_constraint(list(zip(range(len(M[0])), M[i])), bnd[i], None, con[i])
        else:
            q.add_linear_constraint(list(zip(range(len(M[0])), M[i])), bnd[i], bnd[i], con[i])
    # sets objective
    q.set_objective(ob)    
    q.solver_parameter(backend.glp_simplex_then_intopt)
    # solves the problem
    q.solve()
    # The following lines all produce an output report
    if mx:
        st = ' (max) '
    else:
        st = ' (min) '
    sol = [q.get_variable_value(i) for i in range(q.ncols())]
    print 'Optimal'+st+'value: ', q.get_objective_value()
    print ''
    results = [[a,b] for a,b in zip(va,sol)]
    print tabulate(results, headers=['Variable', 'Value'])
    print ''
    slack = [[q.row_name(j), round(max(0,abs(bnd[j]-sum([a*b for a,b in zip(sol,M[j])]))),3)] for j in range(q.nrows())]
    print tabulate(slack, headers=['Constraint', 'Slack'])
##########################################

##########################################
# Generic linear programming solver for
# binary integer programming problems
# (produces no sensitivity report)
##########################################
#
# va   = list of variable names
# con  = list of constraint names
# ob   = list of coefficients of objective
#       functions
# M    = matrix of constraint coefficients
# inq  = list of inequality direction
#       1 for '<=', -1 for '>=' and
#       0 for '='.
# bnd  = list of constraint bounds
# mx   = Boolean to determine if the
#       problem is a maximization (True)
#       or minimization (False) problem.
#       Default is set to maximization.
##########################################
def lpBin(va, con, ob, M, inq, bnd, mx=True):
    # loads the solver
    q = get_solver(solver = 'GLPK')
    # sets solver to min, max otherwise
    if not mx:
        q.set_sense(-1)
    # adds all variables
    for v in va:
        q.add_variable(binary=True, name=v)
    # adds all constraints
    for i in range(len(M)):
        if inq[i] == 1:
            q.add_linear_constraint(list(zip(range(len(M[0])), M[i])), None, bnd[i], con[i])
        elif inq[i] == -1:
            q.add_linear_constraint(list(zip(range(len(M[0])), M[i])), bnd[i], None, con[i])
        else:
            q.add_linear_constraint(list(zip(range(len(M[0])), M[i])), bnd[i], bnd[i], con[i])
    # sets objective
    q.set_objective(ob)    
    q.solver_parameter(backend.glp_simplex_then_intopt)
    # solves the problem
    q.solve()
    # The following lines all produce an output report
    if mx:
        st = ' (max) '
    else:
        st = ' (min) '
    sol = [q.get_variable_value(i) for i in range(q.ncols())]
    print 'Optimal'+st+'value: ', q.get_objective_value()
    print ''
    results = [[a,b] for a,b in zip(va,sol)]
    print tabulate(results, headers=['Variable', 'Value'])
    print ''
    slack = [[q.row_name(j), round(max(0,abs(bnd[j]-sum([a*b for a,b in zip(sol,M[j])]))),3)] for j in range(q.nrows())]
    print tabulate(slack, headers=['Constraint', 'Slack'])
##########################################
