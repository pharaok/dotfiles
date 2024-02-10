from sympy import Function, simplify, solve, symbols
from sympy.parsing.latex import parse_latex
from sympy.printing.latex import latex


def sympy_solve_latex(latex_eq, var):
    x, y, z = symbols("x y z")
    f, g, h = symbols("f g h", cls=Function)

    expr = ""
    try:
        expr = parse_latex(latex_eq)
    except:
        return "ERR"
    solutions = solve(expr, var)

    if not solutions:
        return r"\O"
    return latex(solutions[0])
