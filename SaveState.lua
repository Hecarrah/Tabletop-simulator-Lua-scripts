--[[
Determine which objects are contained in a zone pointed by item description.
On click of a button, return all objects there as they were when the table was loaded last.
]]

saveLabel = "Save State"
loadLabel = "Load State"

labelWidth=750; -- px.
labelHeight=500; -- px.

fontColor={0,0,0}; --RGB.
fontSize=75; -- Font size, duh.

saveLabelPosition = {0,0.5,-0.5}; -- position of the text panel.
loadLabelPosition = {0,0.5, 0.5}; 

-- Lua below, don't edit.
zone = nil;
zoneObjects = nil;
guidMap = {}
positionMap = {}
rotationMap = {}

function onLoad()
    self.interactable = true;
    self.createButton({
        label = saveLabel,
        position= saveLabelPosition,
        click_function="saveState",
        function_owner=self,
        height=labelHeight, width=labelWidth,
        font_color=fontColor,
        font_size=fontSize,
    })
    self.createButton({
        label = loadLabel,
        position= loadLabelPosition,
        click_function="loadState",
        function_owner=self,
        height=labelHeight, width=labelWidth,
        font_color=fontColor,
        font_size=fontSize,
    })

end

function saveState()
    zone = getObjectFromGUID(self.getDescription())
    zoneObjects = zone.getObjects();
    i = 1;
    for _,object in ipairs(zoneObjects) do
        --print(object.guid .. ".. " .. object.getPosition().x ..", ".. object.getPosition().y ..", ".. object.getPosition().z)
        positionMap[i] = object.getPosition()
        rotationMap[i] = object.getRotation()
        guidMap[i] = object.getGUID()
        
        i = i+1;
    end
end

function loadState()
    for k,v in ipairs(positionMap) do
        if getObjectFromGUID(guidMap[k]) ~= nil then
            --print(k .. ".." .. v.x .. ", " .. v.y .. ", " .. v.z)
            object = getObjectFromGUID(guidMap[k])
            object.setPosition(positionMap[k])
            object.setRotation(rotationMap[k])
        end
    end
end