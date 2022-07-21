# 34+10 porcí
# 2 porce bez masa vedle
using JSON

# počet ĺidí a konstanta žravosti, kterou se vynásobí veškeré suroviny
coef = 1.3
n = 44*coef


jid = JSON.parsefile("jidelnicek.json")
ing = Any[]

# objekty "kolik" se rozdělí podle "ks" a "kg" a naskládají do ingrediencí ing
function j(den ::Int64,jidlo ::String)
    q = split(jid[string(den)][string(jidlo)]["kolik"],"+")
    s = Array{Any}(undef,length(q))
    # if length(jid[string(den)][string(jidlo)][string(co)])>1
    for i in 1:length(q)    
        if occursin(" kg ", q[i])
            spl = split.(q[i],"kg")
            unit = "kg"
        elseif occursin(" ks ", q[i])
            spl = split.(q[i],"ks")
            unit = "ks"
        elseif occursin(" porce ", q[i])
            spl = split.(q[i],"porce")
            unit = "porce"
        else
            print("\n -------problém ve dni "+den)
        end
        s[i] = [lstrip(rstrip(spl[2])),parse(Float64,spl[1]),unit]
    end

    return s
end

# 22:31;1:2
for den=22:29, jidlo=["sv1","obed","sv2","vecere"]
    global ing
    append!(ing,j(den,jidlo))
end

# seřazení, sečtení ingrediencí a vynásobení počtem lidí
sort!(ing)
list = Any[]


function getsum(i ::Int64, co ::String, ingredientList ::Any)
    sum = ing[i][2]
    k = 1
    while k<= length(ingredientList)
        if co == ingredientList[i+k][1]
            sum += ing[i+k][2]
        else
            return sum,i+k-1
        end
        k += 1
    end
end

len = length(ing)
i=1
while i < len
    global i, len
    co = string(ing[i][1])
    kolik, iMax = getsum(i,co,ing)

    push!(list,[co,kolik*n,ing[i][3]])
    i = 1+iMax
end

quant = Array{Float64}(undef, length(list))
for i in 1:length(list)
    quant[i] = list[i][2]
end

for element in list
    co = element[1]
    kolik = round(element[2],digits=1)
    jednotka = element[3]
    print(co," ", kolik, " ", jednotka, "\n")
end
