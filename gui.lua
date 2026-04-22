-- Update for gui.lua

-- Existing autoTopBar definition (lines 177-199) remains unchanged:
-- ...
-- Assume the content is unchanged until here

-- Updated button loop to reference the existing autoTopBar:
for i = 1, #buttons do
    local button = buttons[i]
    button.topBar = autoTopBar -- Reference the consolidated autoTopBar
    -- Additional button logic here
end

-- Ensure to remove the duplicated autoTopBar definition starting at line 333.
