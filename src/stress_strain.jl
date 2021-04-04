module stress_strain

using Plots
plotly()

include("data.jl")

diameter = 1.283/100 # m
area = pi * (diameter/2)^2 # m^2
length = 5.08 / 100 # m

stress(force) = force / area
strain(deformation) = deformation / length

strain_values = []
stress_values = []
for (force, deformation) in data
    push!(strain_values, strain(deformation))
    push!(stress_values, stress(force))
end

E = (stress_values[3]-stress_values[2])/(strain_values[3]-strain_values[2])

p = plot(
    strain_values, stress_values,
    title = "Axial Stress-Strain", 
    xlabel="Axial Strain, ɛ",
    ylabel="Axial Stress, σ (Pa)",
    lims=(0, Inf),
    legend = false)
scatter!(strain_values, stress_values)
plot!(filter(x -> x >= .002, collect(0:3) ./ 500), x -> E*(x-.002))
annotate!([(.03, 5e8, Plots.text("E: $(round(E, sigdigits=3)) Pa", 10, :left))])
annotate!([(.03, 4e8, Plots.text("A: $(round(area, sigdigits=3)) m^2", 10, :left))])
annotate!([(.03, 3e8, Plots.text("σ (pro): $(round(stress_values[6], sigdigits=3)) Pa", 10, :left))])
annotate!([(.03, 2e8, Plots.text("σ (yield): $(round(stress_values[9], sigdigits=3)) Pa", 10, :left))])
annotate!([(.03, 1e8, Plots.text("σ (ult): $(round(last(stress_values), sigdigits=3)) Pa", 10, :left))])

display(p)

end # module
