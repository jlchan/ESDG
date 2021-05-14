# domain with a corner
function triangulate_demo_domain(h = .05)    
    pointlist = [0.0 0.0 ; 1.0 0.0 ; 1.0  1.0 ; 0.6 0.6; 0.0 1.0]'
    segmentlist = [1 2 ; 2 3 ; 3 4 ; 4 5 ; 5 1 ]'
    segmentmarkerlist = [1, 2, 3, 4, 5]
    triin = Triangulate.TriangulateIO()
    triin.pointlist = Matrix{Cdouble}(pointlist)
    triin.segmentlist = Matrix{Cint}(segmentlist)
    triin.segmentmarkerlist = Vector{Int32}(segmentmarkerlist)
    triout = triangulate(triin,h^2)
    return triout
end

# domain on xlims x ylims = [xmin,xmas] x [ymin,ymax]
function rectangular_domain(h = .1; xlims = [-1,1],ylims = [-1,1],segment_markers=[1,2,3,4])
    triin=Triangulate.TriangulateIO()
    triin.pointlist=Matrix{Cdouble}([xlims[1] ylims[1];
                                     xlims[2] ylims[1];
                                     xlims[2] ylims[2];
                                     xlims[1] ylims[2];
                                    ]')
    triin.segmentlist=Matrix{Cint}([1 2; 2 3; 3 4; 4 1;]')
    triin.segmentmarkerlist=Vector{Int32}(segment_markers)
    triout = triangulate(triin,h^2)
    return triout
end

square_domain(h=.1) = rectangular_domain(h)

# domain with a square hole on [-1,1]^2 with hole in [-.1,.1]^2
function square_hole_domain(h = .1)
    triin=Triangulate.TriangulateIO()
    triin.pointlist=Matrix{Cdouble}([-1.0 -1.0;
                                    1.0 -1.0;
                                    1.0 1.0;
                                    -1.0 1.0;
                                    -0.1 -0.1;
                                    0.1 -0.1;
                                    0.1 0.1;
                                    -0.1 0.1;
                                    ]')
    triin.segmentlist=Matrix{Cint}([1 2; 2 3; 3 4; 4 1; 5 6; 6 7; 7 8; 8 5; ]')
    triin.segmentmarkerlist=Vector{Int32}([1, 1,1,1, 2,2,2,2])
    triin.holelist=[0.0 0.0]'
    triout = triangulate(triin,h^2)
    return triout
end

# scramjet domain 
function scramjet(h = .1)
    triin=Triangulate.TriangulateIO()
    triin.pointlist=Matrix{Cdouble}([0.0 0.0;
                                     8.0 0.0;
                                     8.0 0.8;    
                                     0.0 2.0;
                                     2.0 0.7;
                                     4.0 0.2; 
                                     7.0 0.6;
                                     6.0 0.7;
                                    ]')
    triin.segmentlist=Matrix{Cint}([1 2; 2 3; 3 4; 4 1; 5 6; 6 7; 7 8; 8 5;]')

    # 1 = wall, 2 = inflow, 3 = outflow 
    triin.segmentmarkerlist=Vector{Int32}([1, 3, 1, 2, 1, 1, 1, 1])

    hole_x = sum(triin.pointlist[1,5:8])/length(triin.pointlist[1,5:8])
    hole_y = sum(triin.pointlist[2,5:8])/length(triin.pointlist[2,5:8])
    triin.holelist=[hole_x hole_y]'

    triout = triangulate(triin,h^2)
    return triout
end

# refinement of a previous mesh given the current mesh size h
function refine(triout, h, href = h/2)
    angle = @sprintf("%.15f",20)
    area  = @sprintf("%.15f",href^2)
    triout2,_ = triangulate("rpa$(area)q$(angle)Q", triout)
    return triout2
end