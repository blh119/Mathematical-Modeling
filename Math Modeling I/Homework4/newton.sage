##########################################
# Newton's Method Scripts
##########################################
#
# Johann Thiel
# ver 11.25.17
# Functions to implement Newton's
# method.
#
##########################################

##########################################
# Generic Newton's method for one
# 1-variable functions
##########################################
# g = function
# x0 = initial value
# n  = number of iterations
##########################################
def newton(g,x0,n):
    x = var('x')
    f(x) = g(x)
    N = x0
    for i in range(n):
        N = N - f(N)/f.diff(x)(N)
    return N
##########################################

##########################################
# Generic Newton's method for two
# 2-variable functions
##########################################
# F,G = functions
# x0 = initial x-value
# y0 = initial y-value
# n  = number of iterations
##########################################
def newton2(F,G,x0,y0,n):
    x = var('x')
    y = var('y')
    f(x,y) = F(x,y)
    g(x,y) = G(x,y)
    N = vector([x0,y0])
    for i in range(n):
        A = jacobian((f,g),(x,y))(N[0],N[1])
        N = N - A^(-1)*vector([f(N[0],N[1]),g(N[0],N[1])])
    return N
##########################################