# Ennui and Endurance (Panda Magazine Jan. 2017)
@testset "ennui and endurance" begin
    cluster = Collective.best_cluster(corpus, Collective.wordlist(IOBuffer("""
        pule
        ramata
        eta
        mien
        put
        fees
        tiy
        buy
        dale
        oro
        jay
        organa
        pia
        freeing
        car
        pried
        """)))
    @test sort(cluster.words) == ["car", "dale", "eta", "fees", "freeing", "mien", "organa", "pried"]
    @test cluster.feature.description == "has a transaddition with letter 'z'"
end
