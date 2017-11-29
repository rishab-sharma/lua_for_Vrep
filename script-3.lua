function updateFloor()
    local c=readInfo()
    local sx=c['sizes'][1]/5
    local sy=c['sizes'][2]/5
    local sizeFact=simGetObjectSizeFactor(model)
    simSetObjectParent(e1,-1,true)
    local child=simGetObjectChild(model,0)
    while child~=-1 do
        simRemoveObject(child)
        child=simGetObjectChild(model,0)
    end
    local xPosInit=(sx-1)*-2.5*sizeFact
    local yPosInit=(sy-1)*-2.5*sizeFact
    local f1,f2
    for x=1,sx,1 do
        for y=1,sy,1 do
            if (x==1)and(y==1) then
                simSetObjectParent(e1,model,true)
                f1=e1
            else
                f1=simCopyPasteObjects({e1},0)[1]
                f2=simCopyPasteObjects({e2},0)[1]
                simSetObjectParent(f1,model,true)
                simSetObjectParent(f2,f1,true)
            end
            local p=simGetObjectPosition(f1,sim_handle_parent)
            p[1]=xPosInit+(x-1)*5*sizeFact
            p[2]=yPosInit+(y-1)*5*sizeFact
            simSetObjectPosition(f1,sim_handle_parent,p)
        end
    end
end

function getDefaultInfoForNonExistingFields(info)
    if not info['version'] then
        info['version']=0
    end
    if not info['sizes'] then
        info['sizes']={1,1}
    end
end

function readInfo()
    local data=simReadCustomDataBlock(model,'XYZ_FLOOR_INFO')
    if data then
        data=simUnpackTable(data)
    else
        data={}
    end
    getDefaultInfoForNonExistingFields(data)
    return data
end

function writeInfo(data)
    if data then
        simWriteCustomDataBlock(model,'XYZ_FLOOR_INFO',simPackTable(data))
    else
        simWriteCustomDataBlock(model,'XYZ_FLOOR_INFO','')
    end
end

function updateUi()
    local c=readInfo()
    local sizeFact=simGetObjectSizeFactor(model)
    simExtCustomUI_setLabelText(ui,1,'X-size (m): '..string.format("%.2f",c['sizes'][1]*sizeFact),true)
    simExtCustomUI_setSliderValue(ui,2,c['sizes'][1]/5,true)
    simExtCustomUI_setLabelText(ui,3,'Y-size (m): '..string.format("%.2f",c['sizes'][2]*sizeFact),true)
    simExtCustomUI_setSliderValue(ui,4,c['sizes'][2]/5,true)
end

function sliderXChange(ui,id,newVal)
    local c=readInfo()
    c['sizes'][1]=newVal*5
    writeInfo(c)
    updateUi()
    updateFloor()
end

function sliderYChange(ui,id,newVal)
    local c=readInfo()
    c['sizes'][2]=newVal*5
    writeInfo(c)
    updateUi()
    updateFloor()
end

function closeEventHandler(h)
    simRemoveScript(sim_handle_self)
end

function showDlg()
    if not ui then
    xml = [[
<ui title="Floor Customizer" closeable="true" onclose="closeEventHandler" resizable="false" activate="false">
    <group layout="form" flat="true">
        <label text="X-size (m): 1" id="1"/>
        <hslider tick-position="above" tick-interval="1" minimum="1" maximum="5" onchange="sliderXChange" id="2"/>
        <label text="Y-size (m): 1" id="3"/>
        <hslider tick-position="above" tick-interval="1" minimum="1" maximum="5" onchange="sliderYChange" id="4"/>
    </group>
    <label text="" style="* {margin-left: 400px;}"/>
</ui>
]]
        ui=simExtCustomUI_create(xml)
        if 2==simGetInt32Parameter(sim_intparam_platform) then
            -- To fix a Qt bug on Linux
            simAuxFunc('activateMainWindow')
        end
        updateUi()
    end
end

function hideDlg()
    if ui then
        simExtCustomUI_destroy(ui)
        ui=nil
    end
end

if (sim_call_type==sim_customizationscriptcall_initialization) then
    model=simGetObjectAssociatedWithScript(sim_handle_self)
    e1=simGetObjectHandle('ResizableFloor_5_25_element')
    e2=simGetObjectHandle('ResizableFloor_5_25_visibleElement')
	simSetScriptAttribute(sim_handle_self,sim_customizationscriptattribute_activeduringsimulation,false)
end

if (sim_call_type==sim_customizationscriptcall_nonsimulation) then
    local s=simGetObjectSelection()
    if s and #s>=1 and s[1]==model then
        showDlg()
    else
        hideDlg()
    end
end

if (sim_call_type==sim_customizationscriptcall_lastbeforesimulation) then
    hideDlg()
end

if (sim_call_type==sim_customizationscriptcall_cleanup) then
    hideDlg()
end
