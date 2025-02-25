
using Test, VarBCFiles


@testset "Only version 6" begin
   # Check that we only allow version 6 files
   @test_throws AssertionError("version == \"VARBC_cycle.version006\"") read("data/VARBC.cycle_v5",VarBC)
end 

v1 = read("data/VARBC.cycle1",VarBC)
v2 = read("data/VARBC.cycle2",VarBC)

# Check that we write back file exactly as we read them
@testset "write" begin
     file, = mktemp()
     write(file,v2)
     @test read(file) == read("data/VARBC.cycle2") # this reads files as Array{UInt8,1}
     rm(file)
end


@testset "filter!" begin
    v = read("MEPSprod/VARBC.cycle",VarBC)
    @test length(filter!(p-> p.second.class=="sfcobs",v)) == 95
end

@testset "merge!" begin
    v1 = read("data/VARBC.cycle1_merge",VarBC)
    v2 = read("data/VARBC.cycle2_merge",VarBC)
    v3 = read("data/VARBC.cycle_merge2into1",VarBC)
    merge!(v1,v2)
    @test v3.records == v1.records             
end


@testset "Equality" begin 
    @test v1 != v2
end 

@testset "Conversions" begin
    # Check that rmdi2nan works 
    key="D0MZ8zJj 16199110       1     6"
    @test isnan(v2.records[key].param0[1])
end
