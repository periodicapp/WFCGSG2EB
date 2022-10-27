class graphNode:
    def __init__(self,name):
        self.vertexName = name
        self.neighbors = []
    
    def buildEdge(self,vertex):
        self.neighbors.append(vertex)

def ConstructGraph(vertices,edges):
    
    obj={}
    for v in vertices:
        obj[v] = graphNode(v)
        
    for e in edges:
        u = obj[e[0]]
        v = obj[e[1]]
        u.buildEdge(v)
        v.buildEdge(u)
    
    return obj

def dfs(node,visited):
    if node.vertexName in visited:
        return
    visited.append(node.vertexName)
    for n in node.neighbors:
        dfs(n,visited)

def main():
    vertices = range(3)
    edges = [[0,1],[1,2],[2,0]]
    visited = []
    graph =  ConstructGraph(vertices,edges)
    source = input('Enter the source node::')
    destination = input('Enter the destination node::')
    dfs(graph[source],visited)
    if destination in visited:
        print "Source {0} and destination {1} are connected".format(source,destination)
    else:
        print "Source {0} and destination {1} are not connected".format(source,destination)

if __name__ == '__main__':main()
