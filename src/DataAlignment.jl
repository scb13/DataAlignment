module DataAlignment

# take in behavior csv and neurons and align by time into tables

monkdate = Array{Any}(undef, 0)
ftype = Array{Any}(undef, 0)
etype = Array{Any}(undef, 0)
tdata = Array{Any}(undef, 0)

expsX = ["Ar190606","Ar190607","Ar190610","Ar190611","Ar190612","Ar190613","Ar190617","Ar190627","Ar190628","Ar190702","Ar190703"];
expsI = ["0623","0624","0625","0626","0627","0630","0702","0703","0706","0707","0708",
    "0709","0710","0711","0713","0718","0721","0723","0724","0725","0727","0728","0729",
    "0730","0801","0803_2","0804","0805","0811","0812_2","0813","0814","0815",
    "0819","0828","0901"];
expsS = ["0103","0106","0107","0108","0109","0110","0113","0117","0121_2","0123","0124",
    "0904","0907","0909_2","0910","0914","0916","0918","0919","0921",
    "0922","0924_2","0925","0930","1009_3","1013_2",
    "1021","1022","1102","1106","1125_2","1126_2","1127",
    "1201","1205"];
expsDio = ["0517","0518","0519","0523","0524","0525","0526","0527","0528","0529",
    "0530","0531","0601","0602","0603","0604","0606","0607","0608","0609",
    "0612_2","0613","0614","0615","0616","0617","0618","0619","0621","0622",
    "0623","0624","0626","0627","0628","0630","0701","0709","0711","0712"
];

for ee in expsX
    trialdata = readdata("$(ee)dt")
    push!(monkdate, ee)
    push!(ftype, "plx")
    push!(etype, "dt")
    push!(tdata, trialdata)
    trialdata = readdata(ee)
    push!(monkdate, ee)
    push!(ftype, "plx")
    push!(etype, "st")
    push!(tdata, trialdata)
end

for ee in expsI
    trialdata = readbevdata("Ar20$(ee)dt")
    addPL2!(trialdata, "PVneuron$(ee).jld2", "MTar20$(ee).pl2")
    push!(monkdate, "Ar20$(ee)")
    push!(ftype, "pl2")
    push!(etype, "dt")
    push!(tdata, trialdata)
    trialdata = readbevdata("Ar20$(ee)rf")
    addPL2!(trialdata, "PVneuron$(ee).jld2", "MTar20$(ee).pl2")
    push!(monkdate, "Ar20$(ee)")
    push!(ftype, "pl2")
    push!(etype, "rf")
    push!(tdata, trialdata)
    trialdata = readbevdata("Ar20$(ee)st")
    addPL2!(trialdata, "PVneuron$(ee).jld2", "MTar20$(ee).pl2")
    push!(monkdate, "Ar20$(ee)")
    push!(ftype, "pl2")
    push!(etype, "st")
    push!(tdata, trialdata)
    trialdata1 = readbevdata("Ar20$(ee)st")
    trialdata2 = readbevdata("Ar20$(ee)")
    trialdata = vcat(trialdata1, trialdata2)
    addPL2!(trialdata, "PVneuron$(ee).jld2", "MTar20$(ee).pl2")
    push!(monkdate, "Ar20$(ee)")
    push!(ftype, "pl2")
    push!(etype, "st")
    push!(tdata, trialdata)
end

for ee in expsS
    #println(ee)
    trialdata = readbevdata("Ar20$(ee)dt")
    addPL2!(trialdata, "PVneuron$(ee).jld2", "MTar20$(ee).pl2")
    push!(monkdate, "Ar20$(ee)")
    push!(ftype, "pl2")
    push!(etype, "dt")
    push!(tdata, trialdata)
    trialdata = readbevdata("Ar20$(ee)rf")
    addPL2!(trialdata, "PVneuron$(ee).jld2", "MTar20$(ee).pl2")
    push!(monkdate, "Ar20$(ee)")
    push!(ftype, "pl2")
    push!(etype, "rf")
    push!(tdata, trialdata)
    trialdata = readbevdata("Ar20$(ee)st")
    addPL2!(trialdata, "PVneuron$(ee).jld2", "MTar20$(ee).pl2")
    push!(monkdate, "Ar20$(ee)")
    push!(ftype, "pl2")
    push!(etype, "st")
    push!(tdata, trialdata)
    trialdata = readbevdata("Ar20$(ee)")
    addPL2!(trialdata, "PVneuron$(ee).jld2", "MTar20$(ee).pl2")
    push!(monkdate, "Ar20$(ee)")
    push!(ftype, "pl2")
    push!(etype, "spulse")
    push!(tdata, trialdata)
end

for ee in expsDio
    trialdata = readbevdata("Di22$(ee)dt")
    addPL2!(trialdata, "PVneurons$(ee).jld2", "MTdi22$(ee).pl2","Y:\\Diogenes\\MTunits")
    push!(monkdate, "Di22$(ee)")
    push!(ftype, "pl2")
    push!(etype, "dt")
    push!(tdata, trialdata)
    trialdata = readbevdata("Di22$(ee)rf")
    addPL2!(trialdata, "PVneurons$(ee).jld2", "MTdi22$(ee).pl2","Y:\\Diogenes\\MTunits")
    push!(monkdate, "Di22$(ee)")
    push!(ftype, "pl2")
    push!(etype, "rf")
    push!(tdata, trialdata)
    trialdata = readbevdata("Di22$(ee)st")
    addPL2!(trialdata, "PVneurons$(ee).jld2", "MTdi22$(ee).pl2","Y:\\Diogenes\\MTunits")
    push!(monkdate, "Di22$(ee)")
    push!(ftype, "pl2")
    push!(etype, "st")
    push!(tdata, trialdata)
    println(ee)###
    trialdata = readbevdata("Di22$(ee)")
    addPL2!(trialdata, "PVneurons$(ee).jld2", "MTdi22$(ee).pl2","Y:\\Diogenes\\MTunits")
    push!(monkdate, "Di22$(ee)")
    push!(ftype, "pl2")
    push!(etype, "spulse")
    push!(tdata, trialdata)
end

#save based on etype to save on load in time
cd("C:\\Users\\...")
ndx = etype .== "dt"
dttdata = tdata[ndx]
dtmonkdate = monkdate[ndx]
dtftype = ftype[ndx]
@save "MTdata_dt.jld2" dtmonkdate dtftype dttdata

ndx = etype .== "rf"
rftdata = tdata[ndx]
rfmonkdate = monkdate[ndx]
rfftype = ftype[ndx]
@save "MTdata_rf.jld2" rfmonkdate rfftype rftdata

ndx = etype .== "st"
sttdata = tdata[ndx]
stmonkdate = monkdate[ndx]
stftype = ftype[ndx]
@save "MTdata_st.jld2" stmonkdate stftype sttdata

ndx = etype .== "spulse"
sptdata = tdata[ndx]
spmonkdate = monkdate[ndx]
spftype = ftype[ndx]
@save "MTdata_spulse.jld2" spmonkdate spftype sptdata

end
