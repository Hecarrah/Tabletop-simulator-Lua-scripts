--[[
Touch the model containing this script with an object to register it as target.
Click the button to return the target in front of this object.
]]

model = getObjectFromGUID("f57ef9"); -- Default model.
defaultLabel = "Unregistered"

distance = -2; -- some tabletop units, negative is forwards relative to text facing.
rotation = {0,180,0}; -- xyz.

labelWidth=750; -- px.
labelHeight=500; -- px.

fontColor={0,0,0}; --RGB.
fontSize=75; -- Font size, duh.

textPosition = {0,0.5,0}; -- position of the text panel.



--LUA below this.
modelStates = {}

function onLoad()
        model = getObjectFromGUID(self.getDescription())
        i = 0;
        if (model ~= nil) and (model.getStates() ~= nil) then
            for _,v in ipairs(model.getStates()) do
                modelStates[i] = v.guid;
                i = i+1;
            end
        end
        self.interactable = true;
        self.createButton({
            label = defaultLabel,
            position=textPosition,
            click_function="moveFigure",
            function_owner=self,
            height=labelHeight, width=labelWidth,
            font_color=fontColor,
            font_size=fontSize,
        })
end

function reloadObject(newGuid)
    self.editButton({index=0, label=model.getName()})
    self.setDescription(newGuid)
    i = 1;
    if (model ~= nil) and (model.getStates() ~= nil) then
        for _,v in ipairs(model.getStates()) do
            modelStates[i] = v.guid;
            i = i+1;
            --print(" " .. v.guid)
        end
        --print("-")
    end
end

function moveFigure()
    model = getObjectFromGUID(self.getDescription())
    if model ~= nil then
        move(model)
    else
        for k,v in ipairs(modelStates) do
            model = getObjectFromGUID(modelStates[k])
            if model ~= nil then
                move(model)
                reloadObject(model.getGUID())
            end
        end
    end
    --print("Specified model is nil (not defined, or doesn't exist)")
end

function move(movedModel)
    ownPos = self.getPosition()
    ownForward = self.getTransformForward()
    newPos = {
        x = ownPos.x + ownForward.x * distance,
        y = ownPos.y + ownForward.y * distance,
        z = ownPos.z + ownForward.z * distance,
    } 
    movedModel.setPosition(newPos)
    movedModel.setRotation(self.getRotation())
    movedModel.rotate(rotation)
    reloadObject(movedModel.getGUID())
end