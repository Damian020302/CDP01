Gonzáles Tamaris Santiago - 423051416
Vázquez Torrijos Damián - 318309877

Para areaTriangulo(a,b,c), originalmente se había definido cómo:
def areaTriangulo(a, b, c) when is_tuple(a) and is_tuple(b) and is_tuple(c) do
    abs((a[0] * (b[1] - c[1]) + b[0] * (c[1] - a[1]) + c[1] * (a[1] - b[1])) / 2)
end

Pero solo registraba 'a', los demás los dejaba vacíos, por lo que se decidió cambiar su estructura
def areaTriangulo(a, b, c) when is_tuple(a) and is_tuple(b) and is_tuple(c) do
    {x1, y1} = a
    {x2, y2} = b
    {x3, y3} = c
    abs((x1 * (y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2)) / 2)
end