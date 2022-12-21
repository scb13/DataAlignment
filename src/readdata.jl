

function readdata(path)
    cd("C:\\Users\\scb47\\Documents\\MATLAB\\Aristotle")
    cd(path)

    #using CSV, DataFrames
    #if already saved then just load
    if length(filter(x->occursin("jld2",x), readdir())) >=1
        @load "trialdata.jld2" trialdata
        return trialdata
    else
        tdp = CSV.read("trialdataP.csv", DataFrame)

        #get column names
        nms = names(tdp);
        nn = 1
        newnms = Array{AbstractString}(undef,size(nms))
        for ii in nms
            nm = string(ii)
            ndx = findlast(isequal('_'),nm)
            if ndx==nothing
                newnms[nn] = nm
            else
                newnms[nn] = nm[1:ndx-1]
            end
            nn+=1
        end
        uniqnms = unique(newnms)

        #place entries from csv into new table
        s=0
        temphold=Array{Any}(undef,size(tdp,1),size(uniqnms,1))
        for row=1:size(tdp,1), unm in uniqnms
            s+=1
            ndx=findall(x->x==unm, newnms)
            temphold[row,findfirst(isequal(unm), uniqnms)]=vec(convert(Array,tdp[row,ndx]))
        end
        trialdata = DataFrame()
        conditions = Vector{AbstractString}(undef,0)
        nms = Vector{AbstractString}(undef,0)
        coherence = Vector{Real}(undef,0)
        contrast = Vector{Real}(undef,0)
        tdir = Vector{Real}(undef,0)
        tspeed = Vector{Real}(undef,0)
        start = Vector{Real}(undef,0)
        stop = Vector{Real}(undef,0)
        useable = Vector{Real}(undef,0)
        for ii in 1:length(temphold[:,1])
            push!(conditions, temphold[ii,1][1])
            push!(nms, temphold[ii,2][1])
            push!(coherence, temphold[ii,3][1])
            push!(contrast, temphold[ii,4][1])
            push!(tdir, temphold[ii,5][1])
            push!(tspeed, temphold[ii,6][1])
            push!(start, temphold[ii,7][1])
            push!(stop, temphold[ii,8][1])
            push!(useable, temphold[ii,16][1])
        end
        trialdata.conditions = conditions
        trialdata.names = nms
        trialdata.coherence = coherence
        trialdata.contrast = contrast
        trialdata.tarDir = tdir
        trialdata.tarSp = tspeed
        trialdata.startTime = start
        trialdata.stopTime = stop
        trialdata.Hpos = temphold[:,9]
        trialdata.Vpos = temphold[:,10]
        trialdata.Hvel = temphold[:,11]
        trialdata.Vvel = temphold[:,12]
        trialdata.calcSp = temphold[:,13]
        trialdata.sacSta = temphold[:,14]
        trialdata.sacSto = temphold[:,15]
        trialdata.useable = useable
        trialdata.blink = temphold[:,17];

        #if event times put events and spikes in too
        u = length(18:size(uniqnms,1))
        if u>0
            trialdata.evnts = temphold[:,findfirst(isequal("evnts"), uniqnms)]
            u-=1
        end
        if convert(Int64,(u/2))==1
            #if only one unit no underscores
            trialdata[:,Symbol("spiketimes")] = temphold[:, findfirst(isequal("spiketimes"), uniqnms)]
            trialdata[:,Symbol("spikewaves")] = temphold[:, findfirst(isequal("spikewaves"), uniqnms)]
        else
            for ii in 1:convert(Int64,(u/2))
                trialdata[:,Symbol("spiketimes_$ii")] = temphold[:, findfirst(isequal("spiketimes_$ii"), uniqnms)]
                trialdata[:,Symbol("spikewaves_$ii")] = temphold[:, findfirst(isequal("spikewaves_$ii"), uniqnms)]
            end
        end
        @save "trialdata.jld2" trialdata
        return trialdata
    end
end
