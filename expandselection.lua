local mod = {}

logger = hs.logger.new('expander', 'debug')
inspect = hs.inspect.inspect
ax = hs.axuielement

function mod.expandSelection()
    local system = ax.systemWideElement()
    local element = system:attributeValue("AXFocusedUIElement")

    if not element then
        logger.i("No focused UI element")
        return
    end

    local application = ax.applicationElementForPID(element:pid())
    application:setAttributeValue('AXManualAccessibility', true)

    local role = element:attributeValue("AXRole")

    if not (role == "AXTextField" or role == "AXTextArea") then
        logger.i("not in a text box, role: " .. role)
        return
    end

    local value = element:attributeValue("AXValue")
    local textLength = element:attributeValue("AXNumberOfCharacters")
    local selection = element:attributeValue("AXSelectedTextRange")

    logger.i(inspect({
        selection = selection,
        value = value,
        textLength = textLength
    }))

    local out = expandSelectionRange(selection.location, selection.length, value)
    local nextLocation = out[1]
    local nextLength = out[2]

    logger.i(inspect({
        nextLocation = nextLocation,
        nextLength = nextLength
    }))

    element:setAttributeValue("AXSelectedTextRange", {
        location = nextLocation,
        length = nextLength
    })
end

mod.paster = nil;

function mod.applicationWatcher(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        hs.console.printStyledtext("activated: " .. appName)
        if (appName == "Code") then
            mod.paster:disable()
        else
            mod.paster:enable()
        end
    end
end

function mod.registerDefaultBindings(mods, key, excludedApps)
    mods = mods or {"cmd", "shift"}
    key = key or "SPACE"
    excludedApps = excludedApps or {"Code"}

    mod.paster = hs.hotkey.new(mods, key, function()
        mod.expandSelection()
    end)

    local appWatcher = hs.application.watcher.new(mod.applicationWatcher)
    appWatcher:start()
end

return mod
