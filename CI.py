# coding: utf-8
"""Calcula el collective influence de todos los nodos y regresa un
arreglo del índice del nodo y su valor de influencia.

`CI(g,n)` sus argumentos son:  

g - Red no dirigida, objeto del paquete LightGraphs

n - Distancia de la frontera de la bola (leer documentación de
[CI](http://www.nature.com/nature/journal/v524/n7563/full/nature14604.html
"Artículo")). Debe ser mayor que 1 y menor al diámetro de la red.

"""
import networkx as nx
import numpy as np
from pprint import pprint


def CI(g,n):
    # n debe ser menor que el diámetro de la red
    assert n < nx.diameter(g)
    assert n > 1
    CI = np.zeros(len(g.nodes())) ### Creamos una lista del tamaño del número de nodos
    for node in g.nodes():
        D = np.zeros(len(vecinos_de_vecinos(node))) # Hacemos una lista del tamaño de la frontera
        
        for m in vecinos_de_vecinos(node):                   ### Iteramos sobre los elementos de la frontera
            D[m] = nx.degree(g,m)-1          ### Hacemos que esta lista contenga los valores del grado-1 de los nodos en la frontera

#         σ = sum(δ)                                         ### Sumamos todos los grado-1 de la frontera
#         CI[v] = σ * (degree(g,vertices(g)[v])-1)   ### Multiplicamos la suma anterior por el grado-1 del nodo que estamos calculando
#     end
#     CI = hcat(collect(vertices(g)),CI)             ### Hacemos la lista de cada nodo con relación a su CI
# end




def vecinos_de_vecinos(g,nodo,distancia):
    vecinos = set(nx.neighbors(g, nodo) )
    tmp     = set([nodo,])
    
    for l in range(distancia-1):
        vecinos = set.union(tmp, vecinos)
        for n in vecinos:
            for n1 in nx.neighbors(g,n):
                tmp.add(n1)

        if distancia == 2:
            non_border =  set(nx.neighbors(g, nodo))
            non_border.add(nodo)
        else:
            if l == distancia-2-1:
                non_border = tmp.copy()
            
    return tmp - non_border


#g = nx.erdos_renyi_graph(15,.1)
g = nx.Graph()
g.add_edge(1,2)
g.add_edge(1,2)
g.add_edge(1,3)
g.add_edge(2,4)
g.add_edge(2,5)
g.add_edge(3,6)
g.add_edge(3,7)
g.add_edge(4,8)
g.add_edge(8,9)
g.add_edge(9,10)


import pylab as pl
print vecinos_de_vecinos(g,1,2)
#nx.draw(g, with_labels=True)
#pl.show()


