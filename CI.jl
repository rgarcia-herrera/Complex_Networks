"""
Calcula el collective influence de todos los nodos y regresa un arreglo del índice del nodo y su valor de influencia.

`CI(g,n::Int64)` sus argumentos son:  

g - Red no dirigida, objeto del paquete LightGraphs

n - Distancia de la frontera de la bola (leer documentación de [CI](http://www.nature.com/nature/journal/v524/n7563/full/nature14604.html "Artículo")). 
Debe ser mayor que 1 y menor al diámetro de la red.
"""
function CI(g,n::Int64)
    n < diameter(g) || error("n debe ser menor que el diámetro de la red") ### En esta sección restringimos los valores
    n > 1 || error("n debe ser mayor que 1")                               ### que puede tomar "n"
    CI = zeros(nv(g))                         ### Creamos una lista del tamaño del número de nodos
    for v in 1:nv(g)                                          ### Para todos los nodos vamos a realizar lo siguiente:
        vec = neighbors(g,vertices(g)[v])                         ###  Hacemos una lista de los vecinos del nodo
        vec2 = vec                                                ###  Copiamos la misma lista a otra a modificar
        vec = vcat(vertices(g)[v],vec)                            ###  Añadimos el propio nodo a la lista de vecinos
        todos = vec                                               ###  Copiamos la nueva lista a otra a modificar
        distn = Array(Int64,0)                     ### Éste arreglo será el de la frontera de la bola
        for l in 1:(n-1)                           ### Vamos a iterar sobre n que nos define la distancia   
            todos = union(vec,vec2)                        ### En éste arreglo vamos a guardar los vecinos de los vecinos que vayamos generando
            for m in vec2                                  ### Iteramos sobre los vecinos del nodo
                vec2 = union(vec2,neighbors(g,m))          ### Añadimos a la lista los vecinos de los vecinos
            end
            distn = setdiff(vec2,todos)                    ### Al poner la diferencia del conjunto eliminamos los nodos que no se encuentran en la frontera
        end
        δ = zeros(distn)                           ### Hacemos una lista del tamaño de la frontera       
        for m in 1:length(distn)                   ### Iteramos sobre los elementos de la frontera
            δ[m] = (degree(g,distn[m]))-1          ### Hacemos que esta lista contenga los valores del grado-1 de los nodos en la frontera
        end
        σ = sum(δ)                                         ### Sumamos todos los grado-1 de la frontera
        CI[v] = σ * (degree(g,vertices(g)[v])-1)   ### Multiplicamos la suma anterior por el grado-1 del nodo que estamos calculando
    end
    CI = hcat(collect(vertices(g)),CI)             ### Hacemos la lista de cada nodo con relación a su CI
end
