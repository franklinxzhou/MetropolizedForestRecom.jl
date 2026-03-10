function build_get_split_coi_count(coi_field::String)
    f(p, d=collect(1:p.num_dists)) = get_split_coi_count(p, coi_field, d)
    return f
end

function get_split_coi_count(
    partition::MultiLevelPartition,
    coi_field::String, 
    districts::Vector{Int} = collect(1:partition.num_dists)
)
    # making this work for now, but not fast (could improve by taking advantage
    # multiscale structure and of the fact that the district list may be 
    # constrained)

    graph = partition.graph.graphs_by_level[end]
    node_attributes = graph.node_attributes
    levels = partition.graph.levels

    coi_to_dists = Dict{String, Set{Int64}}()
    for ii = 1:graph.num_nodes
        coi = node_attributes[ii][coi_field]
        node = Tuple([node_attributes[ii][l] for l in levels])
        d = get_district(partition, node)
        if haskey(coi_to_dists, coi)
            push!(coi_to_dists[coi], d)
        else
            coi_to_dists[coi] = Set{Int64}(d)
        end
    end
    return length([1 for (coi, dists) in coi_to_dists if length(dists) > 1])
end
