# Synthetic data, not from a particular puzzle
@testset "entirely state abbreviations" begin
    f = best_feature(["wahine", "almond", "invade", "mandarin", "inland", "mainland", "ganymede"])
    @test f.description == "can be completely broken down into US state abbreviations"
end

@testset "state abbreviations" begin
    f = best_feature(["wahinex", "yalmond", "invadez", "wmandar", "inpland", "mainzla"])
    @test f.description == "contains 3 US state abbreviations"
end
